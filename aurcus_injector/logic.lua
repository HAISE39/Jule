local logic = {}

-- Modul Logic: Implementasi fitur hack Aurcus Online
-- Menggunakan API kitty untuk manipulasi memori

local kitty = require("kitty")

function logic.runRefreshSkill(enabled, callback)
  if not enabled then
    callback("Mod Nonaktif")
    return
  end

  thread(function()
    call(function() callback("Scanning Skill (Kitty)...") end)

    -- Target Pattern: 3;81;20 (Dword)
    local count = kitty.search("3;81;20")

    if count > 0 then
      -- Modifikasi nilai 3 menjadi 25 pada offset 0
      kitty.write("25", 0)
      call(function() callback("Skill Patched! (" .. count .. " found)") end)
    else
      call(function() callback("Pola tidak ditemukan!") end)
    end
  end)
end

return logic
