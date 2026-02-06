-- memory.lua - Game Specific Memory Operations
local kitty = require("kitty")

local memory = {}

-- Example: Modify game speed
function memory.setGameSpeed(speed)
    -- This is a generic example using GG's built-in speed hack
    gg.setSpeed(speed)
end

-- Example: Patching a specific feature (Placeholder)
function memory.applyHack(pattern, offset, value, type)
    local results = kitty.search(pattern, type)
    if results then
        for i, res in ipairs(results) do
            kitty.patch(res.address + offset, value, type)
        end
        return true
    end
    return false
end

return memory
