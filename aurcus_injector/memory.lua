local memory = {}

import "java.io.RandomAccessFile"
import "java.lang.Float"
import "java.lang.String"

-- Helper to convert value to little-endian bytes
function memory.pack(val, type)
  local i = 0
  if type == "Float" then
    i = Float.floatToRawIntBits(Float.valueOf(tonumber(val)))
  else
    i = math.tointeger(val) or 0
  end
  return string.char(i & 0xFF, (i >> 8) & 0xFF, (i >> 16) & 0xFF, (i >> 24) & 0xFF)
end

-- Helper to convert bytes to value
function memory.unpack(bytes, type)
  local i = bytes:byte(1) | (bytes:byte(2) << 8) | (bytes:byte(3) << 16) | (bytes:byte(4) << 24)
  if type == "Float" then
    return Float.intBitsToFloat(i)
  end
  return i
end

function memory.getJavaHeapRange()
  local f = io.open("/proc/self/maps", "r")
  if not f then return nil end
  for line in f:lines() do
    if line:find("%[anon:dalvik%-main space%]") then
      local start, stop = line:match("(%x+)%-(%x+)")
      if start and stop then
        f:close()
        return tonumber(start, 16), tonumber(stop, 16)
      end
    end
  end
  f:close()
  return nil
end

-- Search for a pattern (Dword or Float)
function memory.search(val, type)
  local start, stop = memory.getJavaHeapRange()
  if not start then return {} end

  -- Handle group pattern like "3;30;1"
  local pattern = ""
  for part in tostring(val):gmatch("[^;]+") do
    pattern = pattern .. memory.pack(part, type)
  end

  local results = {}
  local raf = RandomAccessFile("/proc/self/mem", "r")
  local chunkSize = 1024 * 256 -- 256KB
  local overlap = #pattern - 1

  for current = start, stop - #pattern, chunkSize - overlap do
    local size = math.min(chunkSize, stop - current)
    if size < #pattern then break end

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
    if #results > 5000 then break end
  end
  raf.close()
  return results
end

-- Efficiently refine a list of results
function memory.refine(results, val, offset, type)
  local new_results = {}
  local pattern = memory.pack(val, type)
  local raf = RandomAccessFile("/proc/self/mem", "r")

  for _, addr in ipairs(results) do
    raf.seek(addr + offset)
    local buffer = luajava.createArray("byte", {4})
    raf.readFully(buffer)
    local content = tostring(String(buffer, "ISO-8859-1"))
    if content == pattern then
      table.insert(new_results, addr)
    end
  end

  raf.close()
  return new_results
end

-- Efficiently write to a list of results
function memory.writeBatch(results, val, offset, type)
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
end

return memory
