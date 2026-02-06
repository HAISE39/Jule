local logic = {}

local memory = require("memory")

function logic.runRefreshSkill(enabled, callback)
  if not enabled then
    callback("Mod Disabled")
    return
  end

  thread(function()
    call(function() callback("Scanning Skill...") end)

    -- Pattern: 3;81;20
    local count = memory.search("3;81;20")

    if count > 0 then
      -- Patch 3 -> 25 at offset 0
      memory.write("25", 0)
      call(function() callback("Skill Patched (" .. count .. ")") end)
    else
      call(function() callback("Pattern Not Found") end)
    end
  end)
end

return logic
