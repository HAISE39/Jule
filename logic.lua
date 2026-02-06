-- logic.lua - Mod Feature Logic
local memory = require("memory")

local logic = {}

-- Speed Hack feature
function logic.toggleSpeed(state)
    if state then
        memory.setGameSpeed(2.5)
        gg.toast("Speed Hack: 2.5x")
    else
        memory.setGameSpeed(1.0)
        gg.toast("Speed Hack: Normal")
    end
end

-- Example Function 1
function logic.feature1()
    gg.alert("Feature 1 Activated")
end

return logic
