-- memory.lua
-- Memory Manipulation Library for AndLua+
-- Targets [anon:dalvik-main space]

require "import"
import "java.io.RandomAccessFile"
import "java.lang.String"

local memory = {}

-- Get the exact address range for [anon:dalvik-main space]
function memory.getJavaHeapRange()
  local f = io.open("/proc/self/maps", "r")
  if not f then return nil end
  local start_addr, end_addr
  for line in f:lines() do
    -- Specifically target 'dalvik-main space' as per GG behavior
    if line:find("dalvik%-main space") then
      local s, e = line:match("(%x+)%-(%x+)")
      if s then
        start_addr = tonumber(s, 16)
        end_addr = tonumber(e, 16)
        break
      end
    end
  end
  f:close()
  return start_addr, end_addr
end

-- Fast memory search using RandomAccessFile and String conversion
function memory.search(pattern, start_addr, end_addr)
  local raf = nil
  local success, err = pcall(function()
    raf = RandomAccessFile("/proc/self/mem", "r")
  end)
  if not success or not raf then return nil end

  local chunk_size = 1024 * 512 -- 512KB chunks
  local pattern_len = #pattern
  local current = start_addr

  while current < end_addr do
    local read_len = math.min(chunk_size + pattern_len, end_addr - current)
    if read_len <= 0 then break end

    raf.seek(current)
    local bytes = jarray(read_len, "byte")
    raf.readFully(bytes)

    -- ISO-8859-1 keeps bytes as-is for binary searching
    local data = String(bytes, "ISO-8859-1").toString()
    local pos = data:find(pattern, 1, true)

    if pos then
      raf.close()
      return current + pos - 1
    end

    current = current + chunk_size
  end

  raf.close()
  return nil
end

-- Write a 4-byte DWORD to memory (Little Endian)
function memory.writeDword(address, value)
  local raf = nil
  local success, err = pcall(function()
    raf = RandomAccessFile("/proc/self/mem", "rw")
  end)
  if not success or not raf then return false end

  raf.seek(address)
  local b = jarray(4, "byte")
  b[0] = (value & 0xFF)
  b[1] = ((value >> 8) & 0xFF)
  b[2] = ((value >> 16) & 0xFF)
  b[3] = ((value >> 24) & 0xFF)

  raf.write(b)
  raf.close()
  return true
end

return memory
