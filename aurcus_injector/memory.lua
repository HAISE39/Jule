local memory = {}

import "java.io.RandomAccessFile"
import "java.lang.Float"
import "java.lang.String"

-- Convert value to 4-byte little-endian string
function memory.pack(val, type)
  local i = 0
  -- Strip suffix if present (e.g., "20:9" -> "20")
  local cleanVal = tostring(val):match("([^:]+)") or "0"

  if type == "Float" then
    i = Float.floatToRawIntBits(Float.valueOf(tonumber(cleanVal) or 0.0))
  else
    i = math.tointeger(tonumber(cleanVal) or 0) or 0
  end
  return string.char(i & 0xFF, (i >> 8) & 0xFF, (i >> 16) & 0xFF, (i >> 24) & 0xFF)
end

-- Convert 4-byte string to value
function memory.unpack(bytes, type)
  if not bytes or #bytes < 4 then return 0 end
  local i = bytes:byte(1) | (bytes:byte(2) << 8) | (bytes:byte(3) << 16) | (bytes:byte(4) << 24)
  if type == "Float" then
    return Float.intBitsToFloat(i)
  end
  return i
end

-- Get relevant memory ranges for scanning
function memory.getRelevantRanges()
  local ranges = {}
  local f = io.open("/proc/self/maps", "r")
  if not f then return ranges end

  for line in f:lines() do
    -- Focus on rw segments that are likely Java Heap / Dalvik / Ashmem / Anonymous
    if line:find("rw") then
      if line:find("dalvik") or line:find("/dev/ashmem") or (not line:find("/") and not line:find("%[")) then
        local start, stop = line:match("(%x+)%-(%x+)")
        if start and stop then
          table.insert(ranges, {tonumber(start, 16), tonumber(stop, 16)})
        end
      end
    end
  end
  f:close()
  return ranges
end

-- Search for a pattern across multiple ranges
function memory.search(val, type)
  local ranges = memory.getRelevantRanges()
  if #ranges == 0 then return {} end

  local pattern = ""
  for part in tostring(val):gmatch("[^;]+") do
    pattern = pattern .. memory.pack(part, type)
  end

  local results = {}
  local raf = RandomAccessFile("/proc/self/mem", "r")
  local chunkSize = 1024 * 256 -- 256KB
  local overlap = #pattern - 1

  for _, range in ipairs(ranges) do
    local start, stop = range[1], range[2]

    for current = start, stop - #pattern, chunkSize - overlap do
      local size = math.min(chunkSize, stop - current)
      if size < #pattern then break end

      -- Add pcall to handle potential read errors on protected segments
      local success, err = pcall(function()
        raf.seek(current)
        local buffer = luajava.createArray("byte", {size})
        raf.readFully(buffer)
        local content = tostring(String(buffer, "ISO-8859-1"))

        local pos = 1
        while true do
          pos = content:find(pattern, pos, true)
          if not pos then break end
          table.insert(results, current + pos - 1)
          pos = pos + 1
          if #results > 5000 then break end
        end
      end)

      if #results > 5000 then break end
    end
    if #results > 5000 then break end
  end
  raf.close()
  return results
end

-- Read single value
function memory.read(addr, type)
  local success, val = pcall(function()
    local raf = RandomAccessFile("/proc/self/mem", "r")
    raf.seek(addr)
    local buffer = luajava.createArray("byte", {4})
    raf.readFully(buffer)
    raf.close()
    local bytes = tostring(String(buffer, "ISO-8859-1"))
    return memory.unpack(bytes, type)
  end)
  return success and val or 0
end

-- Write to multiple addresses
function memory.writeBatch(results, val, offset, type)
  if not results or #results == 0 then return end

  local success, err = pcall(function()
    local raf = RandomAccessFile("/proc/self/mem", "rw")
    local data = memory.pack(val, type)
    local b = luajava.createArray("byte", {4})
    for i=1, 4 do
      local byte = data:byte(i)
      if byte > 127 then byte = byte - 256 end
      b[i-1] = byte
    end

    for _, addr in ipairs(results) do
      raf.seek(addr + offset)
      raf.write(b)
    end
    raf.close()
  end)
end

return memory
