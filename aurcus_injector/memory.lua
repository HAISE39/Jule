local memory = {}

import "java.io.RandomAccessFile"
import "java.lang.Float"
import "java.lang.String"

local results = {}
local current_range = {start = 0, stop = 0}

-- Helper: Convert value to 4-byte string
local function valueToBytes(val, type)
  local i = 0
  if type == "Dword" then
    i = math.tointeger(val) or 0
  elseif type == "Float" then
    local f = tonumber(val) or 0.0
    -- Use java.lang.Float to get bits
    i = Float.floatToRawIntBits(Float.valueOf(f))
  end
  -- Pack as 4-byte little-endian string
  return string.char(i & 0xFF, (i >> 8) & 0xFF, (i >> 16) & 0xFF, (i >> 24) & 0xFF)
end

-- Helper: Convert pattern (e.g. "3;30;1") to bytes
local function patternToBytes(text, type)
  local bytes = ""
  for part in text:gmatch("[^;]+") do
    bytes = bytes .. valueToBytes(part, type)
  end
  return bytes
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

function memory.clear()
  results = {}
end

function memory.getResultsCount()
  return #results
end

function memory.search(text, type)
  memory.clear()
  local start, stop = memory.getJavaHeapRange()
  if not start then return false end
  current_range.start = start
  current_range.stop = stop

  local pattern = patternToBytes(text, type)
  local raf = RandomAccessFile("/proc/self/mem", "r")
  -- Use smaller chunks to avoid memory issues and table.unpack limits
  -- But since we use String(buffer), we can use larger chunks.
  local chunkSize = 128 * 1024 -- 128KB
  local overlap = #pattern - 1

  for current = start, stop - #pattern, chunkSize - overlap do
    local size = math.min(chunkSize, stop - current)
    if size < #pattern then break end

    raf.seek(current)
    local buffer = luajava.createArray("byte", {size})
    raf.readFully(buffer)
    -- Convert byte array to Lua string via Java String
    local content = tostring(String(buffer, "ISO-8859-1"))

    local pos = 1
    while true do
      pos = content:find(pattern, pos, true)
      if not pos then break end
      table.insert(results, current + pos - 1)
      if #results >= 10000 then break end -- Limit results
      pos = pos + 1
    end
    if #results >= 10000 then break end
  end
  raf.close()
  return #results > 0
end

function memory.offset(text, offset, type)
  if #results == 0 then return false end
  local pattern = patternToBytes(text, type)
  local new_results = {}
  local raf = RandomAccessFile("/proc/self/mem", "r")

  for _, addr in ipairs(results) do
    local target = addr + offset
    if target >= current_range.start and target <= current_range.stop - #pattern then
      raf.seek(target)
      local buffer = luajava.createArray("byte", {#pattern})
      raf.readFully(buffer)
      local content = tostring(String(buffer, "ISO-8859-1"))
      if content == pattern then
        table.insert(new_results, addr)
      end
    end
  end

  raf.close()
  results = new_results
  return #results > 0
end

function memory.write(text, offset, type)
  if #results == 0 then return false end
  local data = patternToBytes(text, type)
  local raf = RandomAccessFile("/proc/self/mem", "rw")

  for _, addr in ipairs(results) do
    local target = addr + offset
    if target >= current_range.start and target <= current_range.stop - #data then
      raf.seek(target)
      local b = luajava.createArray("byte", {#data})
      for i=1, #data do
        local val = data:byte(i)
        if val > 127 then val = val - 256 end
        b[i-1] = val
      end
      raf.write(b)
    end
  end
  raf.close()
  return true
end

return memory
