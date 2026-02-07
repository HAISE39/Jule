-- 支持ELGG修改器，作者：VellMod / Stylish Upgrade
-- Modern Material UI for ELGG using Changning Library

-- 1. Essential Initialization Function (MUST BE DEFINED BEFORE LOADING LIBRARY)
function init()
    stab = 分页
    ttitle = 标题
    xfcpic = 悬浮窗图标
end

-- 2. Load Cloud UI Library
loadYunLuaGroup("5C3C4E3813681C4C204C35346F1B4C2F7EFF612D2B22176DCA84CB8CFE5F350E1D4733067DCC9F")

-- 3. Mod Logic Functions
function refresh_skill()
    gg.clearResults()
    gg.searchNumber("3;81;20", gg.TYPE_DWORD)
    local results = gg.getResults(100)
    for i, v in ipairs(results) do
        if v.value == "3" then
            v.value = "25"
            v.freeze = true
        end
    end
    gg.addListItems(results)
    gg.toast("Refresh Skill: Applied")
end

function open_bag()
    gg.clearResults()
    gg.searchNumber("h FF FF FF FF 02 00 00 00 FF FF FF FF 00 00 00 00 00 00 00 00", gg.TYPE_BYTE)
    local results = gg.getResults(1)
    if #results > 0 then
        local address = results[1].address + 4
        gg.setValues({{address = address, flags = gg.TYPE_DWORD, value = 12}})
        gg.toast("Open Bag: Applied")
    else
        gg.toast("Pattern not found")
    end
end

-- 4. UI Configuration
悬浮窗图标 = 'https://files.catbox.moe/mbkj32.png'
标题 = 'VellMod Material 3'
分页 = {
    '公告',
    '常用功能',
    '设置',
}

-- 5. Trigger Initialization
init()

-- 6. Define UI Content
uistart({
    { -- 公告 (Notice)
        changning.text('Selamat Datang di VellMod','#D0BCFF','16sp',true),
        changning.line('Update Log'),
        changning.text('v2.2.0: Migrated to Changning Material UI'),
        changning.text('Bug fixes and performance improvements.'),
    },
    { -- 常用功能 (Common Features)
        changning.text('Game Modifications', '#D0BCFF', '14sp'),
        changning.button('Refresh Skill', function() refresh_skill() end),
        changning.button('Open Bag (Premium)', function() open_bag() end),
        changning.line('Misc'),
        changning.switch(
            "Speed Hack (2x)",
            function() gg.setSpeed(2.0) end,
            function() gg.setSpeed(1.0) end,
            "Boost player movement speed"
        ),
    },
    { -- 设置 (Settings)
        changning.text('Modder: VellMod'),
        changning.text('Platform: ELGG'),
        changning.line('Exit'),
        changning.button('Close Script', function()
            gg.toast("Exiting...")
            Lock.unUi()
            os.exit()
        end, '#FF5252'),
    },
})

-- 7. Launch UI
Lock.Ui(invoke, nil, function(err)
    print("ELGG Error: " .. err)
end)

-- Keep Alive
while true do
    gg.sleep(5000)
end
