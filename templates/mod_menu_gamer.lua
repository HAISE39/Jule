-- Ultimate Modern Gamer Mod Menu for ELGG
-- Author: Jules (Assistant)
-- Theme: Modern Stylish Purple (Premium)
-- Features: Draggable Menu, Remote Icons, Glowing UI

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.drawable.*"
import "android.graphics.*"

-- Theme Configuration
local theme = {
    bg = "#FF0A0A0A",
    card = "#FF1A1A1A",
    accent = "#FFBB86FC",
    accent_glow = "#80BB86FC",
    accent_light = "#FFD0BCFF",
    text = "#FFFFFFFF",
    text_dim = "#FFAAAAAA",
    sidebar = "#FF121212"
}

-- Remote Icon URLs (Replace with your own if needed)
local icons = {
    logo = "https://img.icons8.com/color/96/cyber-security.png",
    home = "https://img.icons8.com/fluency/48/home.png",
    mods = "https://img.icons8.com/fluency/48/lightning-bolt.png",
    settings = "https://img.icons8.com/fluency/48/settings.png"
}

-- Utility Functions
function threadStart(runnable)
    local newRun = luajava.createProxy("java.lang.Runnable", runnable)
    local subThread = luajava.newInstance("java.lang.Thread", newRun)
    subThread:start()
    return subThread
end

function getShape(color, radius, stroke_width, stroke_color)
    local drawable = GradientDrawable()
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(Color.parseColor(color))
    drawable.setCornerRadii({ radius, radius, radius, radius, radius, radius, radius, radius })
    if stroke_width and stroke_color then
        drawable.setStroke(stroke_width, Color.parseColor(stroke_color))
    end
    return drawable
end

-- Floating Window Manager
local window = activity.getSystemService(Context.WINDOW_SERVICE)

function getParams()
    local params = WindowManager.LayoutParams()
    if Build.VERSION.SDK_INT >= 26 then
        params.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        params.type = WindowManager.LayoutParams.TYPE_PHONE
    end
    params.format = PixelFormat.RGBA_8888
    params.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    params.gravity = Gravity.LEFT | Gravity.TOP
    params.width = WindowManager.LayoutParams.WRAP_CONTENT
    params.height = WindowManager.LayoutParams.WRAP_CONTENT
    return params
end

local iconParams = getParams()
iconParams.x = 100
iconParams.y = 100

local menuParams = getParams()
menuParams.x = 200
menuParams.y = 200

-- Layout Definitions
function CreateMenu()
    local ids = {}
    local menu_layout = {
        LinearLayout,
        layout_width = "300dp",
        layout_height = "380dp",
        orientation = "horizontal",
        background = getShape(theme.bg, 40, 3, theme.accent),
        id = "main_container",
        {
            -- Sidebar
            LinearLayout,
            layout_width = "75dp",
            layout_height = "fill",
            orientation = "vertical",
            gravity = "center_horizontal",
            background = getShape(theme.sidebar, 40, 0),
            paddingTop = "30dp",
            {
                ImageView,
                layout_width = "40dp",
                layout_height = "40dp",
                layout_marginBottom = "40dp",
                id = "menu_logo",
            },
            {
                ImageView,
                layout_width = "32dp",
                layout_height = "32dp",
                layout_margin = "18dp",
                id = "side_home",
                onClick = function() SwitchTab("Home") end
            },
            {
                ImageView,
                layout_width = "32dp",
                layout_height = "32dp",
                layout_margin = "18dp",
                id = "side_mods",
                onClick = function() SwitchTab("Mods") end
            },
            {
                ImageView,
                layout_width = "32dp",
                layout_height = "32dp",
                layout_margin = "18dp",
                id = "side_settings",
                onClick = function() SwitchTab("Settings") end
            },
        },
        {
            -- Main Area
            LinearLayout,
            layout_width = "fill",
            layout_height = "fill",
            orientation = "vertical",
            {
                -- Draggable Header
                LinearLayout,
                layout_width = "fill",
                layout_height = "50dp",
                gravity = "center_vertical",
                paddingLeft = "15dp",
                id = "header",
                {
                    TextView,
                    text = "VELLIXAO MODS",
                    textColor = Color.parseColor(theme.accent),
                    textSize = "14sp",
                    -- Removed textStyle to ensure maximum compatibility across ELGG versions
                }
            },
            {
                -- Content area
                LinearLayout,
                layout_width = "fill",
                layout_height = "fill",
                orientation = "vertical",
                padding = "10dp",
                {
                    TextView,
                    id = "tab_title",
                    text = "Home",
                    textColor = Color.parseColor(theme.text),
                    textSize = "20sp",
                    layout_marginBottom = "10dp",
                },
                {
                    ScrollView,
                    layout_width = "fill",
                    layout_height = "fill",
                    {
                        LinearLayout,
                        id = "content_list",
                        orientation = "vertical",
                        layout_width = "fill",
                    }
                }
            }
        }
    }

    local main_view = loadlayout(menu_layout, ids)

    -- Draggable Menu Logic
    local sX, sY, iX, iY
    ids.header.onTouch = function(v, event)
        local action = event.getAction()
        if action == MotionEvent.ACTION_DOWN then
            sX = event.getRawX()
            sY = event.getRawY()
            iX = menuParams.x
            iY = menuParams.y
            return true
        elseif action == MotionEvent.ACTION_MOVE then
            menuParams.x = iX + (event.getRawX() - sX)
            menuParams.y = iY + (event.getRawY() - sY)
            window.updateViewLayout(main_view, menuParams)
            return true
        end
        return false
    end

    -- Tab Content Logic
    function RefreshContent(tab)
        ids.content_list.removeAllViews()
        if tab == "Home" then
            addComponent(ids.content_list, "Status", "System Injector: ACTIVE", "#FF4CAF50")
            addComponent(ids.content_list, "User", "Gamer Mode Enabled", theme.accent_light)
        elseif tab == "Mods" then
            addSwitch(ids.content_list, "Gode Mode", "Protect against all damage", function(s) print("God: "..tostring(s)) end)
            addSwitch(ids.content_list, "Wallhack", "See enemies through walls", function(s) print("Wall: "..tostring(s)) end)
            addSwitch(ids.content_list, "No Recoil", "Laser precision shots", function(s) print("Recoil: "..tostring(s)) end)
        elseif tab == "Settings" then
            addButton(ids.content_list, "Minimize Menu", function()
                window.removeView(main_view)
                window.addView(icon_view, iconParams)
            end)
            addButton(ids.content_list, "Exit Script", function() os.exit() end)
        end
    end

    function SwitchTab(name)
        ids.tab_title.setText(name)
        RefreshContent(name)
    end

    -- Load Remote Icons
    threadStart({
        run = function()
            local b_logo = loadbitmap(icons.logo)
            local b_home = loadbitmap(icons.home)
            local b_mods = loadbitmap(icons.mods)
            local b_set = loadbitmap(icons.settings)
            activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
                run = function()
                    ids.menu_logo.setImageBitmap(b_logo)
                    ids.side_home.setImageBitmap(b_home)
                    ids.side_mods.setImageBitmap(b_mods)
                    ids.side_settings.setImageBitmap(b_set)
                end
            }))
        end
    })

    SwitchTab("Home")
    return main_view
end

-- UI Components
function addComponent(parent, title, value, val_color)
    local item = loadlayout({
        LinearLayout,
        layout_width = "fill",
        layout_height = "wrap_content",
        orientation = "vertical",
        padding = "12dp",
        layout_margin = "6dp",
        background = getShape(theme.card, 20, 2, "#40FFFFFF"),
        {
            TextView,
            text = title,
            textColor = Color.parseColor(theme.text_dim),
            textSize = "12sp",
        },
        {
            TextView,
            text = value,
            textColor = Color.parseColor(val_color or theme.text),
            textSize = "15sp",
        }
    })
    parent.addView(item)
end

function addSwitch(parent, title, desc, callback)
    local is_on = false
    local ids = {}
    local item = loadlayout({
        LinearLayout,
        layout_width = "fill",
        layout_height = "wrap_content",
        orientation = "horizontal",
        gravity = "center_vertical",
        padding = "12dp",
        layout_margin = "6dp",
        background = getShape(theme.card, 20, 2, "#40FFFFFF"),
        {
            LinearLayout,
            orientation = "vertical",
            layout_weight = 1,
            {
                TextView,
                text = title,
                textColor = Color.parseColor(theme.text),
                textSize = "14sp",
            },
            {
                TextView,
                text = desc,
                textColor = Color.parseColor(theme.text_dim),
                textSize = "10sp",
            }
        },
        {
            CardView,
            layout_width = "44dp",
            layout_height = "22dp",
            radius = "11",
            id = "t_bg",
            CardBackgroundColor = Color.parseColor("#FF333333"),
            {
                View,
                layout_width = "18dp",
                layout_height = "18dp",
                layout_margin = "2dp",
                id = "t_thumb",
                background = getShape("#FFFFFFFF", 9),
            }
        }
    }, ids)

    item.onClick = function()
        is_on = not is_on
        if is_on then
            ids.t_bg.setCardBackgroundColor(Color.parseColor(theme.accent))
            callback(true)
        else
            ids.t_bg.setCardBackgroundColor(Color.parseColor("#FF333333"))
            callback(false)
        end
    end
    parent.addView(item)
end

function addButton(parent, label, callback)
    local item = loadlayout({
        TextView,
        layout_width = "fill",
        layout_height = "45dp",
        layout_margin = "8dp",
        text = label,
        gravity = "center",
        textColor = Color.parseColor(theme.bg),
        textSize = "14sp",
        background = getShape(theme.accent, 22.5),
        onClick = callback
    })
    parent.addView(item)
end

-- Floating Icon Initialization
local icon_ids = {}
icon_view = loadlayout({
    CardView,
    layout_width = "60dp",
    layout_height = "60dp",
    radius = "30",
    CardBackgroundColor = Color.parseColor(theme.accent),
    Elevation = "15dp",
    {
        ImageView,
        layout_width = "40dp",
        layout_height = "40dp",
        layout_gravity = "center",
        id = "float_img",
    }
}, icon_ids)

-- Load Floating Logo
threadStart({
    run = function()
        local bit = loadbitmap(icons.logo)
        activity.runOnUiThread(luajava.createProxy("java.lang.Runnable", {
            run = function() icon_ids.float_img.setImageBitmap(bit) end
        }))
    end
})

-- Icon Drag Logic
local startX, startY, initialX, initialY
icon_view.onTouch = function(v, event)
    local action = event.getAction()
    if action == MotionEvent.ACTION_DOWN then
        startX = event.getRawX()
        startY = event.getRawY()
        initialX = iconParams.x
        initialY = iconParams.y
        return true
    elseif action == MotionEvent.ACTION_MOVE then
        iconParams.x = initialX + (event.getRawX() - startX)
        iconParams.y = initialY + (event.getRawY() - startY)
        window.updateViewLayout(icon_view, iconParams)
        return true
    elseif action == MotionEvent.ACTION_UP then
        if math.abs(event.getRawX() - startX) < 10 and math.abs(event.getRawY() - startY) < 10 then
            window.removeView(icon_view)
            window.addView(CreateMenu(), menuParams)
        end
        return true
    end
    return false
end

-- Execution Entry
Lock.Ui(function()
    window.addView(icon_view, iconParams)
end)
