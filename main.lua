-- 支持ELGG修改器，作者：VellMod / Stylish Upgrade
-- Modern Sidebar UI using Changning E02PROMaterial3 Library

-- 1. Load Cloud Library (ELGG specific)
-- Note: loadYunLuaGroup is a core ELGG function for loading cloud-based UI modules.
loadYunLuaGroup("5C3C4E3813681C4C204C35346F1B4C2F7EFF612D2B22176DCA84CB8CFE5F350E1D4733067DCC9F")

-- 2. UI Configuration Globals
悬浮窗图标 = 'https://files.catbox.moe/mbkj32.png'
标题 = 'VellMod Material 3'
分页 = {
    '实用功能',
    '娱乐功能',
    '设置',
}

-- Theme Colors for components
local PURPLE_ACCENT = "#D0BCFF"

-- 3. Initialization Mapper
function init()
    stab = 分页
    ttitle = 标题
    xfcpic = 悬浮窗图标
end
init()

-- 4. Feature Implementation
-- Each table in uistart corresponds to an index in the '分页' table.
uistart({
    { -- 实用功能 (Practical Features)
        changning.text("Main Hacks", PURPLE_ACCENT, "16sp", true),
        changning.line("Movement"),
        changning.switch(
            "每日任务",
            function() gg.toast("Daily Tasks: ON") end,
            function() gg.toast("Daily Tasks: OFF") end,
            "Automate daily routine"
        ),
        changning.button(
            "原地光翼",
            function() gg.toast("Teleporting to wings...") end,
            PURPLE_ACCENT
        ),
        changning.box({
            "Teleport Tools",
            changning.check({
                { "Auto Run", function() end, function() end },
                { "Safe Mode", function() end, function() end },
            })
        }),
    },
    { -- 娱乐功能 (Fun Features)
        changning.line("Visuals & Fun"),
        changning.switch(
            "离线模式",
            function() gg.toast("Offline Mode: ON") end,
            function() gg.toast("Offline Mode: OFF") end,
            "Play without server connection"
        ),
        changning.switch2(
            "无限能量",
            function() gg.toast("Infinite Energy: ON") end,
            function() gg.toast("Infinite Energy: OFF") end
        ),
        changning.radio({
            { "Normal Speed", function() gg.setSpeed(1.0) end },
            { "Fast Speed (2x)", function() gg.setSpeed(2.0) end },
            { "Sonic Speed (5x)", function() gg.setSpeed(5.0) end },
        }),
    },
    { -- 设置 (Settings)
        changning.text("About VellMod", PURPLE_ACCENT, "14sp"),
        changning.text("Version: 2.1.0 (E02PRO)"),
        changning.text("Author: VellMod"),
        changning.line("Exit"),
        changning.button(
            "Close Script",
            function()
                gg.toast("Closing...")
                Lock.unUi()
                os.exit()
            end,
            "#FF5252"
        ),
    },
})

-- 5. Launch UI using ELGG's Lock.Ui
-- 'invoke' is the entry point defined by the loaded cloud library.
Lock.Ui(invoke, nil, function(err)
    print("ELGG UI Error: " .. err)
end)

-- Keep the script thread alive
while true do
    gg.sleep(5000)
end
