local kitty = {}

-- --- KittyMemory Modul untuk AndLua+ ---
-- Menyediakan API profesional untuk modifikasi memori (Write/Patch)
-- Target khusus: [anon:dalvik-main space] (Java Heap)

local memory = require("memory")

-- Mencari pola DWORD (misal: "3;81;20") di Java Heap
function kitty.search(pattern)
  return memory.search(pattern)
end

-- Menulis nilai ke semua hasil pencarian terakhir dengan offset tertentu
-- type: "Dword" atau "Float" (Default: "Dword")
function kitty.write(value, offset, type)
  return memory.write(value, offset or 0)
end

-- Patch memori menggunakan string HEX (misal: "19 00 00 00")
-- Sangat berguna untuk bypass yang lebih kompleks
function kitty.patch(address, hex)
  -- Bersihkan spasi dari hex
  hex = hex:gsub("%s+", "")
  local data = ""
  for i = 1, #hex, 2 do
    local b = tonumber(hex:sub(i, i+1), 16)
    data = data .. string.char(b)
  end

  import "java.io.RandomAccessFile"
  local success, err = pcall(function()
    local raf = RandomAccessFile("/proc/self/mem", "rw")
    raf.seek(address)
    local b = luajava.createArray("byte", {#data})
    for i=1, #data do
      local byte = data:byte(i)
      if byte > 127 then byte = byte - 256 end
      b[i-1] = byte
    end
    raf.write(b)
    raf.close()
  end)
  return success
end

-- Mendapatkan jumlah hasil pencarian terakhir
function kitty.count()
  return memory.getCount()
end

return kitty
