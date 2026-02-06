-- main.lua - ELGG Mod Menu Bootstrap
-- Author: VellMod / Adapted for Modular Structure

local logic = require("logic")
local ui = require("ui")

-- 1. Configuration & Resources
local 资源文件夹 = "/sdcard/.vlx/"
local icon_file = 资源文件夹 .. "图标.png"
local exit_path = 资源文件夹 .. "退出.png"

local check_file = file.new(资源文件夹)
if not check_file.isDirectory() then
    check_file.delete()
    check_file.mkdir()
end

-- 2. Resource Management
if not file.new(icon_file).exists() then
    gg.toast("Downloading resources...")
    file.download("https://files.catbox.moe/mbkj32.png", icon_file)
    file.download("https://www.xiaoman.top/assets/users/VellMod/exit.png", exit_path)
end

-- 3. Menu Definition (Linked to logic.lua)
local menus = {
    { "Movement Hacks", "Speed and movement related hacks",
        {
            { "s", "Speed Hack", "Toggle 2.5x Speed",
                open = function() logic.toggleSpeed(true) end,
                close = function() logic.toggleSpeed(false) end
            },
        }
    },
    { "Miscellaneous", "Other useful features",
        {
            { "t", "Test Alert", "Shows a simple alert", function() logic.feature1() end },
        }
    },
}

-- 4. Initialization
local function start()
    ui.init(menus, {
        icon = icon_file,
        exit = exit_path
    })
end

-- Use ELGG's UI safe wrapper if available
if Lock and Lock.Ui then
    Lock.Ui(start, nil, function(err)
        print("ELGG UI Error: " .. err)
        luajava.exit()
    end)
else
    -- Fallback for standard environments
    start()
end

-- Keep script running
while true do
    gg.sleep(1000)
end
