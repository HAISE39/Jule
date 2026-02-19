local memory = {}

import "java.io.RandomAccessFile"
import "java.lang.Float"
import "java.lang.String"

-- Results cache
local Res = {}

-- Helper: Pack Dword
local function packDword(val)
  local i = math.tointeger(tonumber(val)) or 0
  return string.char(i & 0xFF, (i >> 8) & 0xFF, (i >> 16) & 0xFF, (i >> 24) & 0xFF)
end

-- Helper: Pack Pattern (3;81;20)
local function packPattern(val)
  local p = ""
  for part in tostring(val):gmatch("[^;]+") do
    p = p .. packDword(part)
  end
  return p
end

-- Get Java Heap (dalvik-main) Range
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

-- Clear Results (mimic C++ ClearResults)
function memory.clear()
  Res = {}
end

-- Memory Search (mimic C++ MemorySearch)
function memory.search(val)
  memory.clear()
  local start, stop = memory.getJavaHeapRange()
  if not start then return 0 end

  local pattern = packPattern(val)
  local raf = RandomAccessFile("/proc/self/mem", "r")
  local chunkSize = 1024 * 256
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
      table.insert(Res, current + pos - 1)
      pos = pos + 1
      if #Res > 10000 then break end
    end
    if #Res > 10000 then break end
  end
  raf.close()
  return #Res
end

-- Memory Write (mimic C++ MemoryWrite)
function memory.write(val, offset)
  if #Res == 0 then return false end
  local data = packDword(val)
  local raf = RandomAccessFile("/proc/self/mem", "rw")

  -- Convert to byte array for write
  local b = luajava.createArray("byte", {4})
  for i=1, 4 do
    local byte = data:byte(i)
    if byte > 127 then byte = byte - 256 end
    b[i-1] = byte
  end

  for _, addr in ipairs(Res) do
    raf.seek(addr + offset)
    raf.write(b)
  end
  raf.close()
  return true
end

-- Get Result Count
function memory.getCount()
  return #Res
end

return memory
