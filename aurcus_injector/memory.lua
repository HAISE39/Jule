-- memory.lua
-- Memory Manipulation Library for AndLua+
-- Pustaka Manipulasi Memori untuk AndLua+

local memory = {}

-- Function to get Dalvik Main memory range
function memory.getDalvikMain()
  local maps = io.open("/proc/self/maps", "r")
  if not maps then return nil end

  local start_addr, end_addr
  for line in maps:lines() do
    -- Search for [anon:dalvik-main] which is the Java Heap
    if line:find("%[anon:dalvik%-main%]") then
      start_addr, end_addr = line:match("(%x+)%-(%x+)")
      break
    end
  end
  maps:close()

  if start_addr and end_addr then
    return tonumber(start_addr, 16), tonumber(end_addr, 16)
  end
  return nil
end

-- Function to search for a pattern with a gap (wildcard)
-- prefix: bytes before the gap
-- suffix: bytes after the gap
-- gap_len: length of the wildcard gap in bytes
function memory.searchPattern(prefix, suffix, gap_len, start_addr, end_addr)
  local raf = io.open("/proc/self/mem", "rb")
  if not raf then return nil end

  local chunk_size = 1024 * 1024 -- 1MB chunks
  local prefix_len = #prefix
  local total_len = prefix_len + gap_len + #suffix

  local current = start_addr
  while current < end_addr do
    local success = raf:seek("set", current)
    if not success then break end

    local data = raf:read(chunk_size + total_len)
    if not data then break end

    local pos = 1
    while true do
      pos = data:find(prefix, pos, true)
      if not pos then break end

      -- Check if suffix matches after the gap
      local suffix_start = pos + prefix_len + gap_len
      if data:sub(suffix_start, suffix_start + #suffix - 1) == suffix then
        raf:close()
        return current + pos - 1
      end
      pos = pos + 1
    end

    current = current + chunk_size
    if current >= end_addr then break end
  end

  raf:close()
  return nil
end

-- Function to write Dword (4 bytes) to memory
function memory.writeDword(address, value)
  -- Use r+b to allow writing at an offset without truncation
  local raf = io.open("/proc/self/mem", "r+b")
  if not raf then return false end

  local success = raf:seek("set", address)
  if not success then
    raf:close()
    return false
  end

  -- Pack as 4 bytes little endian (Compatible with all Lua versions)
  local b = string.char(
    value % 256,
    math.floor(value / 256) % 256,
    math.floor(value / 65536) % 256,
    math.floor(value / 16777216) % 256
  )

  raf:write(b)
  raf:flush()
  raf:close()
  return true
end

return memory
