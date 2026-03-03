--[[
  VellTools GameGuardian Remote Value Loader
  Created for the user request.
--]]

-- API Configuration
local API_URL = "http://your-website-url.com/api/values"
local API_KEY = "vtools-secret-key" -- Should match the one in Next.js

function fetchData()
    local headers = {
        ["x-api-key"] = API_KEY
    }
    local response = gg.makeRequest(API_URL, headers)
    if not response or response.content == "" then
        gg.alert("Failed to connect to the website or the API is offline.")
        return nil
    end

    return response.content
end

-- Improved JSON parser for the specific array structure that handles whitespace and newlines
function parseData(jsonStr)
    local items = {}

    -- This pattern is more robust against whitespace and handles key-value pairs individually
    -- We'll extract each object {} and then find name/value inside it
    for object in jsonStr:gmatch("{[^{}]+}") do
        local name = object:match('"name"%s*:%s*"([^"]+)"')
        local value = object:match('"value"%s*:%s*"([^"]+)"')

        if name and value then
            table.insert(items, {name = name, value = value})
        end
    end

    return items
end

function main()
    gg.toast("Loading configurations from website...")
    local jsonStr = fetchData()
    if not jsonStr then return end

    local items = parseData(jsonStr)
    if #items == 0 then
        gg.alert("No items found on the website.")
        return
    end

    -- Extract names for the menu
    local names = {}
    for i, item in ipairs(items) do
        names[i] = item.name
    end

    local choice = gg.choice(names, nil, "Select a value to execute from VellTools")
    if choice == nil then return end

    local selectedItem = items[choice]
    executeValue(selectedItem.name, selectedItem.value)
end

function executeValue(name, value)
    gg.toast("Executing: " .. name .. " (Value: " .. value .. ")")

    -- GameGuardian Execution logic (Example: Search and Edit)
    -- In this example, we assume the value is what the user wants to search/edit
    gg.clearResults()
    gg.searchNumber(value, gg.TYPE_DWORD)
    local count = gg.getResultCount()

    if count == 0 then
        gg.alert("No results found for value: " .. value)
    else
        gg.alert("Found " .. count .. " results for " .. name .. ". Ready to modify?")
        -- Optional: gg.editAll("999999", gg.TYPE_DWORD)
    end
end

-- Start Script
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        main()
    end
    gg.sleep(100)
end
