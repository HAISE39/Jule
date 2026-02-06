-- 支持ELGG修改器，作者：VellMod / Stylish Upgrade
-- Modern Sidebar UI for ELGG based on DKTool style

gg.toast("Starting script...")

local 悬浮窗图标外链 = "https://files.catbox.moe/mbkj32.png"
local 资源文件夹 = "/sdcard/.vlx/"

-- Theme Colors (Modern Dark with Purple Accents)
local COLOR_BG = "#FF0A0A0A"
local COLOR_SIDEBAR = "#FF141414"
local COLOR_CARD = "#FF1E1E1E"
local COLOR_ACCENT = "#FFBB86FC"
local COLOR_TEXT_PRIMARY = "#FFFFFFFF"
local COLOR_TEXT_SECONDARY = "#FFB0B0B0"
local COLOR_BORDER = "#40FFFFFF"

-- Resource Initialization
pcall(function()
    local check_file = file.new(资源文件夹)
    if not check_file.isDirectory() then
        check_file.delete()
        check_file.mkdir()
    end
end)

local icon_file = 资源文件夹 .. "图标.png"
local exit_path = 资源文件夹 .. "退出.png"

-- Download Assets if missing
if not file.new(icon_file).exists() then
    gg.toast("Downloading assets...")
    pcall(function()
        file.download(悬浮窗图标外链, icon_file)
        file.download("https://www.xiaoman.top/assets/users/VellMod/exit.png", exit_path)
    end)
end

-- Menus Structure
menus = {
	{ "实用功能", "Practical features for gameplay.",
		{
			{ "s", "每日任务", "Daily tasks automation",
                open = function() gg.toast("Daily Tasks: ON") end,
                close = function() gg.toast("Daily Tasks: OFF") end
            },
			{ "t", "原地光翼", "Teleport to light wings", function() gg.toast("Teleporting...") end },
		}
	},
	{ "娱乐功能", "Fun and visual modifications.",
		{
			{ "s", "离线模式", "Play without connection",
                open = function() gg.toast("Offline Mode: ON") end,
                close = function() gg.toast("Offline Mode: OFF") end
            },
			{ "t", "无限能量", "Infinite energy usage", function() gg.toast("Energy locked") end },
		}
	},
    { "列表菜单", "List of extra options.", {} },
    { "附加功能", "Additional utility tools.", {} },
    { "弹琴菜单", "Music and instruments.", {} },
    { "设置菜单", "Configuration and settings.", {} },
}

-- Native Imports
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "java.util.*"
import "java.lang.*"
import "android.*"
import "android.ext.*"
import "android.graphics.*"
import "android.graphics.drawable.*"

context = activity
window = context.getSystemService("window")

-- Handle potential method vs property for device dimensions
local devW = device.getWidth
local devH = device.getHeight
if type(devW) == "function" then devW = devW() end
if type(devH) == "function" then devH = devH() end
ooo1 = tonumber(devW) or 1080
ooo2 = tonumber(devH) or 1920

function getLayoutParams(flag)
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

function moveTouch(id, lay, params)
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

function getShepeBackground(color, radiu, strokeWidth, strokeColor)
	local drawable = luajava.new(GradientDrawable)
	drawable.setShape(GradientDrawable.RECTANGLE)
	drawable.setColor(Color.parseColor(color))
	drawable.setCornerRadii({ radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu })
    if strokeWidth and strokeColor then
        drawable.setStroke(strokeWidth, Color.parseColor(strokeColor))
    end
	return drawable
end

function dp2px(dpValue)
	local scale = activity.getResources().getDisplayMetrics().scaledDensity
	return dpValue * scale + 0.5
end

function threadStart(runnable)
	local newRun = luajava.createProxy("java.lang.Runnable", runnable)
	local subThread = luajava.newInstance("java.lang.Thread", newRun)
	subThread:start()
	return subThread
end

function VellMod_switch(ojbk, parent)
	local sw = loadlayout({
		LinearLayout,
        orientation = "horizontal",
        layout_width = -1,
        layout_height = "50dp",
        gravity = "center_vertical",
        padding = "10dp",
        {
            TextView,
            text = ojbk[2],
            textColor = Color.parseColor(COLOR_TEXT_PRIMARY),
            layout_weight = 1,
            textSize = "14sp",
        },
        {
            Switch,
            id = "sw_btn",
        }
	})
	sw_btn.ThumbDrawable.setColorFilter(PorterDuffColorFilter(Color.parseColor(COLOR_ACCENT), PorterDuff.Mode.SRC_ATOP))
	sw_btn.TrackDrawable.setColorFilter(PorterDuffColorFilter(Color.parseColor(COLOR_TEXT_SECONDARY), PorterDuff.Mode.SRC_ATOP))
	sw_btn.onClick = function()
		local mode = sw_btn.checked and "open" or "close"
		threadStart({
			run = function()
				pcall(ojbk[mode])
			end
		})
	end
	parent.addView(sw)
end

function VellMod_text(ojbk, parent)
	local btn = loadlayout({
		Button,
		layout_height = "45dp",
		layout_width = -1,
        layout_margin = "5dp",
        background = getShepeBackground(COLOR_CARD, 10),
        text = ojbk[2],
        textColor = Color.parseColor(COLOR_TEXT_PRIMARY),
        textAllCaps = false,
		onClick = function()
			threadStart({
				run = function()
					pcall(ojbk[4])
				end
			})
		end,
	})
	parent.addView(btn)
end

xfc_table = {
	LinearLayout,
	layout_height = "fill",
	layout_width = "fill",
	id = "touch",
	{
		LinearLayout,
        orientation = "horizontal",
		layout_height = "350dp",
		layout_width = "450dp",
		background = getShepeBackground(COLOR_BG, 30),
		id = "ooo",
        -- Sidebar
        {
            LinearLayout,
            orientation = "vertical",
            layout_width = "120dp",
            layout_height = -1,
            background = getShepeBackground(COLOR_SIDEBAR, 30),
            padding = "10dp",
            {
                LinearLayout,
                layout_width = -1,
                layout_height = "60dp",
                gravity = "center",
                {
                    ImageView,
                    layout_width = "40dp",
                    layout_height = "40dp",
                    src = icon_file,
                },
                {
                    TextView,
                    text = "DKTool\nSkyTool",
                    textColor = Color.parseColor(COLOR_TEXT_PRIMARY),
                    textSize = "10sp",
                    layout_marginLeft = "5dp",
                }
            },
            {
                ScrollView,
                layout_width = -1,
                layout_height = -1,
                VerticalScrollBarEnabled = false,
                {
                    LinearLayout,
                    orientation = "vertical",
                    layout_width = -1,
                    id = "sidebar_list",
                }
            }
        },
        -- Main Content Area
        {
            LinearLayout,
            orientation = "vertical",
            layout_width = -1,
            layout_height = -1,
            {
                RelativeLayout,
                layout_width = -1,
                layout_height = "50dp",
                padding = "10dp",
                {
                    TextView,
                    id = "content_title",
                    text = "Welcome",
                    textColor = Color.parseColor(COLOR_TEXT_PRIMARY),
                    textSize = "16sp",
                    layout_centerVertical = true,
                },
                {
                    ImageView,
                    layout_width = "25dp",
                    layout_height = "25dp",
                    layout_alignParentRight = true,
                    layout_centerVertical = true,
                    src = exit_path,
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
                VerticalScrollBarEnabled = false,
                {
                    LinearLayout,
                    orientation = "vertical",
                    layout_width = -1,
                    id = "content_list",
                    padding = "10dp",
                }
            }
        }
	},
}

function LoadUi()
    gg.toast("Initializing Sidebar UI...")
	local LayoutParams = WindowManager.LayoutParams
	mainLayoutParams = getLayoutParams(LayoutParams.FLAG_NOT_FOCUSABLE)

	xfq = loadlayout({
		LinearLayout,
		layout_width = "60dp",
		layout_height = "60dp",
		{
			ImageView,
			layout_width = "60dp",
			src = icon_file,
			id = "suspended_ball",
			layout_height = "60dp",
            padding = "10dp",
		},
	})
    xfq.setBackground(getShepeBackground(COLOR_ACCENT, 30))

	moveTouch(suspended_ball, xfq, mainLayoutParams)
	function suspended_ball.onClick()
		window.removeView(xfq)
		window.addView(xfc, mainLayoutParams)
	end

	xfc = loadlayout(xfc_table)
	moveTouch(touch, xfc, mainLayoutParams)

    local content_views = {}

    for i, menu in ipairs(menus) do
        local menu_name = menu[1]
        local menu_features = menu[3]

        -- Sidebar Item
        local sidebar_item = loadlayout({
            LinearLayout,
            layout_width = -1,
            layout_height = "45dp",
            layout_marginBottom = "5dp",
            gravity = "center_vertical",
            padding = "8dp",
            id = "item_container",
            {
                TextView,
                text = menu_name,
                textColor = Color.parseColor(COLOR_TEXT_SECONDARY),
                textSize = "12sp",
            }
        })
        sidebar_item.setBackground(getShepeBackground(COLOR_SIDEBAR, 10))

        -- Content View for this menu
        local menu_content = loadlayout({
            LinearLayout,
            orientation = "vertical",
            layout_width = -1,
            visibility = View.GONE,
        })
        content_list.addView(menu_content)
        content_views[i] = menu_content

        for _, feature in ipairs(menu_features) do
            if feature[1] == "s" then
                VellMod_switch(feature, menu_content)
            elseif feature[1] == "t" then
                VellMod_text(feature, menu_content)
            end
        end

        sidebar_item.onClick = function()
            for j, v in ipairs(content_views) do
                v.setVisibility(View.GONE)
                sidebar_list.getChildAt(j-1).setBackground(getShepeBackground(COLOR_SIDEBAR, 10))
                sidebar_list.getChildAt(j-1).getChildAt(0).setTextColor(Color.parseColor(COLOR_TEXT_SECONDARY))
            end
            menu_content.setVisibility(View.VISIBLE)
            sidebar_item.setBackground(getShepeBackground(COLOR_CARD, 10, 2, COLOR_ACCENT))
            sidebar_item.getChildAt(0).setTextColor(Color.parseColor(COLOR_TEXT_PRIMARY))
            content_title.setText(menu_name)
        end

        sidebar_list.addView(sidebar_item)

        -- Default to first menu
        if i == 1 then
            menu_content.setVisibility(View.VISIBLE)
            sidebar_item.setBackground(getShepeBackground(COLOR_CARD, 10, 2, COLOR_ACCENT))
            sidebar_item.getChildAt(0).setTextColor(Color.parseColor(COLOR_TEXT_PRIMARY))
            content_title.setText(menu_name)
        end
    end

	window.addView(xfq, mainLayoutParams)
    gg.toast("Sidebar Menu Ready!")
end

-- Use Lock.Ui safely
if Lock and Lock.Ui then
    Lock.Ui(LoadUi, nil, function(err)
        print("ELGG UI Error: " .. err)
        luajava.exit()
    end)
else
    pcall(LoadUi)
end

while true do
    gg.sleep(5000)
end
