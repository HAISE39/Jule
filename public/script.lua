-- Configuration
local API_URL = "https://your-website.vercel.app/api/verify" -- Replace with your actual URL
local SAVE_FILE = gg.getFileDir() .. "/.token_verified"

function verifyToken(token)
    local response = gg.makeRequest(API_URL, {
        ["Content-Type"] = "application/json"
    }, jsonEncode({token = token}))

    if not response or not response.content then
        gg.alert("Failed to connect to verification server.")
        return false
    end

    local data = jsonDecode(response.content)
    if data and data.success then
        return true
    else
        gg.alert("Verification failed: " .. (data and data.message or "Unknown error"))
        return false
    end
end

-- Simple JSON helpers (since standard GG might not have a full JSON lib)
function jsonEncode(t)
    local s = "{"
    for k, v in pairs(t) do
        s = s .. string.format("%q:%q,", k, v)
    end
    return s:sub(1, -2) .. "}"
end

function jsonDecode(s)
    local t = {}
    -- Improved pattern matching for success and message
    t.success = s:match('"success"%s*:%s*(true)') == "true"
    if not t.success then
        t.success = false
    end
    t.message = s:match('"message"%s*:%s*"(.-)"')
    return t
end

function saveVerifiedToken(token)
    local f = io.open(SAVE_FILE, "w")
    if f then
        f:write(token)
        f:close()
    end
end

function getSavedToken()
    local f = io.open(SAVE_FILE, "r")
    if f then
        local token = f:read("*a")
        f:close()
        return token
    end
    return nil
end

function main()
    local savedToken = getSavedToken()

    if savedToken then
        -- Optional: Re-verify with server every time, or just trust the saved token
        -- For this requirement "cukup 1x saja", we trust the saved token
        gg.toast("Welcome back! Token verified.")
        startScript()
        return
    end

    while true do
        local prompt = gg.prompt({
            "Input Token Script:",
            "Keluar"
        }, {
            "",
            false
        }, {
            "text",
            "checkbox"
        })

        if not prompt then os.exit() end -- User cancelled prompt

        if prompt[2] then -- Keluar checked
            os.exit()
        end

        local token = prompt[1]
        if token == "" then
            gg.alert("Please enter a token!")
        else
            if verifyToken(token) then
                saveVerifiedToken(token)
                gg.alert("Token Verified Successfully!")
                startScript()
                break
            end
        end
    end
end

function startScript()
    gg.alert("Script started successfully!")
    -- Your actual script logic goes here
    while true do
        if gg.isVisible(true) then
            gg.setVisible(false)
            local choice = gg.choice({"Menu 1", "Menu 2", "Exit"}, nil, "Main Menu")
            if choice == 1 then
                gg.toast("Menu 1 selected")
            elseif choice == 2 then
                gg.toast("Menu 2 selected")
            elseif choice == 3 then
                os.exit()
            end
        end
        gg.sleep(100)
    end
end

main()
