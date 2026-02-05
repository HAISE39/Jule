-- memory.lua
-- Final Production Memory Library for Aurcus Online
-- Kode Jadi (No Placeholders)

require "import"
import "java.io.RandomAccessFile"
import "java.lang.String"

local memory = {}

-- Get Dalvik Main (Java Heap) range from maps
function memory.getDalvikMain()
  local f = io.open("/proc/self/maps", "r")
  if not f then return nil end
  local start_addr, end_addr
  for line in f:lines() do
    if line:find("dalvik%-main") then
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

-- High performance memory search
function memory.search(pattern, start_addr, end_addr)
  local raf = RandomAccessFile("/proc/self/mem", "r")
  local chunk_size = 1024 * 512 -- 512KB
  local pattern_len = #pattern

  local current = start_addr
  while current < end_addr do
    local read_size = math.min(chunk_size + pattern_len, end_addr - current)
    if read_size <= 0 then break end

    raf.seek(current)
    local bytes = jarray(read_size, "byte")
    raf.readFully(bytes)

    -- Convert to string for fast Lua searching
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

-- Write 4-byte Dword to memory
function memory.writeDword(address, value)
  local raf = RandomAccessFile("/proc/self/mem", "rw")
  raf.seek(address)

  -- Little Endian 4-byte write
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
