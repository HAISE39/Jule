-- Modern Gamer Style Mod Menu for ELGG
-- Author: Jules (Assistant)
-- Theme: Modern Stylish Purple
-- Note: Replace icon sources in ImageView with your local assets or URLs.

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
    accent_light = "#FFD0BCFF",
    text = "#FFFFFFFF",
    text_dim = "#FFAAAAAA",
    sidebar = "#FF121212"
}

-- Utility Functions
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
local wmParams = WindowManager.LayoutParams()

if Build.VERSION.SDK_INT >= 26 then
    wmParams.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
else
    wmParams.type = WindowManager.LayoutParams.TYPE_PHONE
end

wmParams.format = PixelFormat.RGBA_8888
wmParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
wmParams.gravity = Gravity.LEFT | Gravity.TOP
wmParams.width = WindowManager.LayoutParams.WRAP_CONTENT
wmParams.height = WindowManager.LayoutParams.WRAP_CONTENT

-- Layout Definitions
function CreateMenu()
    local ids = {}
    -- Main Container
    local menu_layout = {
        LinearLayout,
        layout_width = "280dp",
        layout_height = "350dp",
        orientation = "horizontal",
        background = getShape(theme.bg, 30, 2, theme.accent),
        id = "main_window",
        {
            -- Sidebar
            LinearLayout,
            layout_width = "70dp",
            layout_height = "fill",
            orientation = "vertical",
            gravity = "center_horizontal",
            background = getShape(theme.sidebar, 30, 0),
            paddingTop = "20dp",
            {
                TextView,
                text = "V",
                textColor = Color.parseColor(theme.accent),
                textSize = "24sp",
                layout_marginBottom = "30dp",
            },
            {
                TextView, -- Placeholder for icon
                text = "🏠",
                layout_margin = "15dp",
                id = "tab_home",
                onClick = function() SwitchTab("Home") end
            },
            {
                TextView, -- Placeholder for icon
                text = "⚡",
                layout_margin = "15dp",
                id = "tab_mods",
                onClick = function() SwitchTab("Mods") end
            },
            {
                TextView, -- Placeholder for icon
                text = "⚙️",
                layout_margin = "15dp",
                id = "tab_settings",
                onClick = function() SwitchTab("Settings") end
            },
        },
        {
            -- Content Area
            LinearLayout,
            layout_width = "fill",
            layout_height = "fill",
            orientation = "vertical",
            padding = "15dp",
            {
                TextView,
                id = "tab_title",
                text = "Home",
                textColor = Color.parseColor(theme.text),
                textSize = "18sp",
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

    local main_view = loadlayout(menu_layout, ids)

    -- Helper to clear and add components
    function RefreshContent(tab)
        ids.content_list.removeAllViews()
        if tab == "Home" then
            addComponent(ids.content_list, "Welcome, Gamer!", "Status: Injection Ready", "Info")
        elseif tab == "Mods" then
            addSwitch(ids.content_list, "Infinite Health", function(state) print("HP: "..tostring(state)) end)
            addSwitch(ids.content_list, "One Hit Kill", function(state) print("OHK: "..tostring(state)) end)
            addSwitch(ids.content_list, "Speed Hack", function(state) print("Speed: "..tostring(state)) end)
        elseif tab == "Settings" then
            addButton(ids.content_list, "Minimize Menu", function()
                window.removeView(main_view)
                window.addView(icon_view, iconParams)
            end)
            addButton(ids.content_list, "Unload Cheat", function() os.exit() end)
        end
    end

    function SwitchTab(name)
        ids.tab_title.setText(name)
        RefreshContent(name)
    end

    SwitchTab("Home")
    return main_view
end

-- Component Factories
function addComponent(parent, title, desc, type)
    local item = loadlayout({
        LinearLayout,
        layout_width = "fill",
        layout_height = "wrap_content",
        orientation = "vertical",
        padding = "10dp",
        layout_margin = "5dp",
        background = getShape(theme.card, 15),
        {
            TextView,
            text = title,
            textColor = Color.parseColor(theme.accent_light),
            textSize = "14sp",
        },
        {
            TextView,
            text = desc,
            textColor = Color.parseColor(theme.text_dim),
            textSize = "10sp",
        }
    })
    parent.addView(item)
end

function addSwitch(parent, title, callback)
    local is_on = false
    local ids = {}
    local item = loadlayout({
        LinearLayout,
        layout_width = "fill",
        layout_height = "wrap_content",
        gravity = "center_vertical",
        padding = "10dp",
        layout_margin = "5dp",
        background = getShape(theme.card, 15),
        {
            TextView,
            text = title,
            textColor = Color.parseColor(theme.text),
            layout_weight = 1,
        },
        {
            CardView,
            layout_width = "40dp",
            layout_height = "20dp",
            radius = "10",
            id = "toggle_bg",
            CardBackgroundColor = Color.parseColor("#FF333333"),
            {
                View,
                layout_width = "16dp",
                layout_height = "16dp",
                layout_margin = "2dp",
                id = "toggle_thumb",
                background = getShape("#FFFFFFFF", 8),
            }
        }
    }, ids)

    item.onClick = function()
        is_on = not is_on
        if is_on then
            ids.toggle_bg.setCardBackgroundColor(Color.parseColor(theme.accent))
            -- thumb animation could go here
            callback(true)
        else
            ids.toggle_bg.setCardBackgroundColor(Color.parseColor("#FF333333"))
            callback(false)
        end
    end
    parent.addView(item)
end

function addButton(parent, label, callback)
    local item = loadlayout({
        TextView,
        layout_width = "fill",
        layout_height = "40dp",
        layout_margin = "5dp",
        text = label,
        gravity = "center",
        textColor = Color.parseColor(theme.bg),
        background = getShape(theme.accent, 20),
        onClick = callback
    })
    parent.addView(item)
end

-- Floating Icon
local icon_layout = {
    CardView,
    layout_width = "50dp",
    layout_height = "50dp",
    radius = "25",
    CardBackgroundColor = Color.parseColor(theme.accent),
    Elevation = "10dp",
    {
        TextView,
        text = "V",
        textColor = Color.parseColor(theme.bg),
        textSize = "20sp",
        gravity = "center",
    }
}

icon_view = loadlayout(icon_layout)
iconParams = WindowManager.LayoutParams()
iconParams.type = wmParams.type
iconParams.format = wmParams.format
iconParams.flags = wmParams.flags
iconParams.gravity = wmParams.gravity
iconParams.width = WindowManager.LayoutParams.WRAP_CONTENT
iconParams.height = WindowManager.LayoutParams.WRAP_CONTENT
iconParams.x = 100
iconParams.y = 100

-- Drag Logic
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
            window.addView(CreateMenu(), wmParams)
        end
        return true
    end
    return false
end

-- Start
Lock.Ui(function()
    window.addView(icon_view, iconParams)
end)
