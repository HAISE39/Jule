-- ui.lua - Native Android UI for ELGG
-- Adapted from user example by VellMod

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.graphics.*"
import "android.graphics.drawable.*"

local ui = {}

-- State variables
local xfc_large = false
local ooo1 = tonumber(device.getWidth)
local ooo2 = tonumber(device.getHeight)
local window = activity.getSystemService("window")

-- Helper: Layout Params
function ui.getLayoutParams(flag)
    local LayoutParams = WindowManager.LayoutParams
    local layoutParams = luajava.new(LayoutParams)
    if Build.VERSION.SDK_INT >= 26 then
        layoutParams.type = LayoutParams.TYPE_APPLICATION_OVERLAY
    else
        layoutParams.type = LayoutParams.TYPE_PHONE
    end
    layoutParams.format = PixelFormat.RGBA_8888
    layoutParams.flags = flag
    layoutParams.gravity = Gravity.CENTER
    layoutParams.width = LayoutParams.WRAP_CONTENT
    layoutParams.height = LayoutParams.WRAP_CONTENT
    return layoutParams
end

-- Helper: Background Drawable
function ui.getShepeBackground(color, radiu)
    local drawable = luajava.new(GradientDrawable)
    drawable.setShape(GradientDrawable.RECTANGLE)
    drawable.setColor(color)
    drawable.setCornerRadii({ radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu })
    return drawable
end

-- Helper: Move Touch
function ui.moveTouch(id, lay, params)
    function id.onTouch(v, event)
        local Action = event.getAction()
        if Action == MotionEvent.ACTION_DOWN then
            RawX = event.getRawX()
            RawY = event.getRawY()
            x = params.x
            y = params.y
        elseif Action == MotionEvent.ACTION_MOVE then
            params.x = tonumber(x) + (event.getRawX() - RawX)
            params.y = tonumber(y) + (event.getRawY() - RawY)
            window.updateViewLayout(lay, params)
        end
    end
end

-- UI Construction Helpers (extracted from example)
local function dp2px(dpValue)
    local scale = activity.getResources().getDisplayMetrics().scaledDensity
    return dpValue * scale + 0.5
end

local function threadStart(runnable)
    local newRun = luajava.createProxy("java.lang.Runnable", runnable)
    local subThread = luajava.newInstance("java.lang.Thread", newRun)
    subThread:start()
    return subThread
end

local function natext(text, lay, cpage_setter)
    return {
        TextView,
        text = text,
        gravity = "center",
        layout_width = "80dp",
        layout_height = -1,
        padding = "5dp",
        ellipsize = "marquee",
        selected = true,
        singleLine = true,
        textSize = "13sp",
        textColor = 0xFFCAC4D0,
        onClick = function(v)
            cpage_setter(lay)
        end
    }
end

function ui.init(menus, resources)
    local LayoutParams = WindowManager.LayoutParams
    local mainLayoutParams = ui.getLayoutParams(LayoutParams.FLAG_NOT_FOCUSABLE)
    local xfc -- Declare early to fix scope in listeners

    -- Floating Ball Layout
    local xfq_ids = {}
    local xfq = loadlayout({
        LinearLayout,
        layout_width = "50dp",
        layout_height = "50dp",
        {
            ImageView,
            layout_width = "50dp",
            src = resources.icon,
            id = "suspended_ball",
            layout_height = "50dp",
        },
    }, xfq_ids)

    -- Main Menu Layout (Simplified for the module)
    local xfc_ids = {}
    local xfc_layout = {
        LinearLayout,
        layout_height = "fill",
        layout_width = "fill",
        id = "touch",
        {
            RelativeLayout,
            layout_height = "320dp",
            layout_width = "260dp",
            background = ui.getShepeBackground(0xFF405688, 30),
            id = "ooo",
            {
                LinearLayout,
                layout_height = -1,
                orientation = "vertical",
                layout_margin = "10dp",
                layout_width = -1,
                {
                    LinearLayout, -- Top bar
                    layout_height = "40dp",
                    orientation = "horizontal",
                    layout_width = -1,
                    gravity = "center",
                    {
                        ImageView,
                        layout_width = -1,
                        layout_height = -1,
                        layout_weight = "4.1",
                        src = resources.icon,
                    },
                    {
                        TextView,
                        textColor = 0xFFD0BCFF,
                        text = "VellMod",
                        gravity = "center",
                        textSize = "14sp",
                        layout_height = -1,
                        layout_width = -1,
                        layout_weight = "3.35",
                    },
                    -- Add exit button
                    {
                        ImageView,
                        layout_height = -1,
                        layout_width = -1,
                        layout_weight = "4.1",
                        src = resources.exit,
                        padding = "4dp",
                        onClick = function()
                            window.removeView(xfc)
                            luajava.exit()
                            os.exit()
                        end
                    }
                },
                {
                    ScrollView,
                    layout_width = -1,
                    layout_height = -1,
                    {
                        RelativeLayout,
                        id = "funclayout",
                        layout_width = -1,
                        layout_height = -1,
                        {
                            LinearLayout,
                            id = "main_list",
                            orientation = "vertical",
                            layout_width = -1,
                        }
                    }
                }
            }
        }
    }

    xfc = loadlayout(xfc_layout, xfc_ids)
    local main_list = xfc_ids.main_list
    local touch = xfc_ids.touch
    local funclayout = xfc_ids.funclayout

    local laytab = { main_list }
    local cpage = main_list

    local function set_cpage(lay)
        cpage.setVisibility(View.GONE)
        lay.setVisibility(View.VISIBLE)
        cpage = lay
    end

    -- Populate Menu
    for i = 1, #menus do
        local menu = menus[i]

        -- Sub-page for this menu
        local lyt = loadlayout({
            LinearLayout,
            layout_height = -1,
            orientation = "vertical",
            visibility = View.GONE,
            layout_width = -1
        })
        table.insert(laytab, lyt)
        funclayout.addView(lyt)

        -- Button in Main Menu to open sub-page
        local btn = loadlayout({
            TextView,
            text = menu[1],
            textColor = 0xFFF6EDFF,
            textSize = "16sp",
            padding = "10dp",
            layout_width = -1,
            onClick = function()
                set_cpage(lyt)
            end
        })
        main_list.addView(btn)

        -- Add items to the sub-page
        for _, item in ipairs(menu[3]) do
            if item[1] == "s" then
                local sw = loadlayout({
                    Switch,
                    text = item[2],
                    textColor = 0xFFCAC4D0,
                    layout_width = -1,
                    padding = "5dp",
                })
                sw.onClick = function()
                    local mode = sw.checked and "open" or "close"
                    threadStart({run = function() pcall(item[mode]) end})
                end
                lyt.addView(sw)
            elseif item[1] == "t" then
                local tbtn = loadlayout({
                    Button,
                    text = item[2],
                    layout_width = -1,
                    onClick = function()
                        threadStart({run = function() pcall(item[4]) end})
                    end
                })
                lyt.addView(tbtn)
            end
        end

        -- Back button in sub-page
        local back_btn = loadlayout({
            Button,
            text = "< Back",
            layout_width = -1,
            onClick = function()
                set_cpage(main_list)
            end
        })
        lyt.addView(back_btn)
    end

    ui.moveTouch(xfq_ids.suspended_ball, xfq, mainLayoutParams)
    xfq_ids.suspended_ball.onClick = function()
        window.removeView(xfq)
        window.addView(xfc, mainLayoutParams)
    end

    ui.moveTouch(touch, xfc, mainLayoutParams)

    window.addView(xfq, mainLayoutParams)
end

return ui
