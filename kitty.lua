-- kitty.lua - Memory Utility Wrapper for ELGG
-- Provides high-level memory modification functions

local kitty = {}

-- Patch memory address with a specific value and type
function kitty.patch(address, value, type)
    local edits = {
        { address = address, flags = type, value = value }
    }
    local success = gg.setValues(edits)
    if success then
        -- Optionally freeze the value
        gg.addListItems(edits)
    end
    return success
end

-- Search for a pattern and return results
function kitty.search(pattern, type)
    gg.clearResults()
    gg.searchNumber(pattern, type)
    local count = gg.getResultCount()
    if count > 0 then
        return gg.getResults(count)
    end
    return nil
end

return kitty
