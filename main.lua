-- 支持ELGG修改器，作者：VellMod / Stylish Upgrade
-- Modern Stylish Purple Mod Menu UI for ELGG

gg.toast("Starting script...")

local 悬浮窗图标外链 = "https://files.catbox.moe/mbkj32.png"
local 资源文件夹 = "/sdcard/.vlx/"

-- Theme Colors (Strings for Color.parseColor)
local PURPLE_BG = "#FF1A0033"
local PURPLE_CARD = "#FF2D0054"
local PURPLE_ACCENT = "#FFD0BCFF"
local PURPLE_STROKE = "#FF6A1B9A"
local TEXT_PRIMARY = "#FFFFFFFF"
local TEXT_SECONDARY = "#FFCAC4D0"

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
local hide_path = 资源文件夹 .. "隐藏.png"
local enlarge_path = 资源文件夹 .. "放大.png"
local shrink_path = 资源文件夹 .. "缩小.png"

-- Download Assets if missing
if not file.new(icon_file).exists() then
    gg.toast("Downloading assets...")
    pcall(function()
        file.download(悬浮窗图标外链, icon_file)
        file.download("https://www.xiaoman.top/assets/users/VellMod/exit.png", exit_path)
        file.download("https://www.xiaoman.top/assets/users/VellMod/hide.png", hide_path)
        file.download("https://www.xiaoman.top/assets/users/VellMod/enlarge.png", enlarge_path)
        file.download("https://www.xiaoman.top/assets/users/VellMod/shrink.png", shrink_path)
    end)
end

-- Menus Structure
menus = {
	{ "MOVEMENT", "Hacks for player speed and jumping.",
		{
			{ "s", "Speed Hack (2.0x)", "Toggle 2x speed boost",
                open = function() gg.setSpeed(2.0) gg.toast("Speed Boost: ON") end,
                close = function() gg.setSpeed(1.0) gg.toast("Speed Boost: OFF") end
            },
			{ "t", "Super Jump", "Enhanced jump height (Mock)", function() gg.alert("Jump Hack Applied") end },
		}
	},
	{ "VISUALS", "Hacks for game visibility and Chams.",
		{
			{ "s", "Chams (Rainbow)", "Colored player models",
                open = function() gg.toast("Chams: ON") end,
                close = function() gg.toast("Chams: OFF") end
            },
			{ "t", "Brightness", "Remove game fog", function() gg.toast("Brightness Hack Enabled") end },
		}
	},
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

xfc_large = false
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

function miaobian(d, r, t, y)
	local InsideColor = Color.parseColor(t)
	local drawable = GradientDrawable()
	drawable.setShape(GradientDrawable.RECTANGLE)
	drawable.setColor(InsideColor)
	drawable.setCornerRadii({ r, r, r, r, r, r, r, r });
	drawable.setStroke(d, Color.parseColor(y))
	return drawable
end

function costimg(id, src, func, pad)
	local sw = {
		ImageView,
		layout_height = -1,
		layout_width = -1,
		layout_weight = "4.1",
		src = src,
		padding = pad,
		onClick = function() pcall(func) end,
		id = id,
	}
	return sw
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

function getShepeBackground(color, radiu)
	local drawable = luajava.new(GradientDrawable)
	drawable.setShape(GradientDrawable.RECTANGLE)
	drawable.setColor(Color.parseColor(color))
	drawable.setCornerRadii({ radiu, radiu, radiu, radiu, radiu, radiu, radiu, radiu })
	return drawable
end

function natext(text, lay)
	local sw = {
		TextView,
		text = text,
		gravity = "center",
		layout_width = "90dp",
		layout_height = -1,
		padding = "5dp",
		ellipsize = "marquee",
		selected = true,
		singleLine = true,
		textSize = "13sp",
		textColor = Color.parseColor(PURPLE_ACCENT),
		onClick = function()
			cpage.setVisibility(View.GONE)
			lay.setVisibility(View.VISIBLE)
			cpage = lay
		end
	}
	return sw
end

function pline()
	return {
		View,
		layout_width = -1,
		layout_height = "1dp",
		background = getShepeBackground(PURPLE_STROKE, 10),
		layout_alignParentBottom = "true",
	}
end

function VellMod_switch(ojbk, parent)
	local sw = loadlayout({
		Switch,
		text = ojbk[2],
		textColor = Color.parseColor(TEXT_PRIMARY),
		padding = "8dp",
		layout_width = -1,
		layout_height = "45dp",
	})
	sw.ThumbDrawable.setColorFilter(PorterDuffColorFilter(Color.parseColor(PURPLE_ACCENT), PorterDuff.Mode.SRC_ATOP))
	sw.TrackDrawable.setColorFilter(PorterDuffColorFilter(Color.parseColor(PURPLE_STROKE), PorterDuff.Mode.SRC_ATOP))
	sw.onClick = function()
		local mode = sw.checked and "open" or "close"
		threadStart({
			run = function()
				pcall(ojbk[mode])
			end
		})
	end
	parent.addView(sw)
	parent.addView(loadlayout({
		View,
		layout_width = -1,
		layout_height = "1dp",
		background = getShepeBackground(PURPLE_STROKE, 10)
	}))
end

function VellMod_text(ojbk, parent)
	local btn = loadlayout({
		RelativeLayout,
		layout_height = "45dp",
		layout_width = -1,
		onClick = function()
			threadStart({
				run = function()
					pcall(ojbk[4])
				end
			})
		end,
		{
			TextView,
			layout_alignParentTop = "true",
			layout_marginBottom = "20dp",
			layout_height = "24dp",
			layout_width = -1,
			text = ojbk[2],
			textSize = "14sp",
			textColor = Color.parseColor(TEXT_PRIMARY),
		},
		{
			TextView,
			layout_height = "16dp",
			layout_width = -1,
			layout_alignParentTop = "true",
			layout_marginTop = "19dp",
			textSize = "11sp",
			text = ojbk[3],
			textColor = Color.parseColor(TEXT_SECONDARY),
		},
		pline(),
	})
	parent.addView(btn)
end

xfc_table = {
	LinearLayout,
	layout_height = "fill",
	layout_width = "fill",
	id = "touch",
	{
		RelativeLayout,
		layout_height = "340dp",
		layout_width = "280dp",
		background = getShepeBackground(PURPLE_BG, 40),
		id = "ooo",
		{
			LinearLayout,
			layout_height = -1,
			orientation = "vertical",
			layout_margin = "10dp",
			layout_width = -1,
			{
				LinearLayout,
				layout_height = "45dp",
				orientation = "horizontal",
				layout_width = -1,
				gravity = "center",
				{
					ImageView,
					layout_width = -1,
					layout_height = -1,
					layout_weight = "4.1",
					id = "logo",
					src = icon_file,
				},
				{
					TextView,
					textColor = Color.parseColor(PURPLE_ACCENT),
					text = "VellMod",
					gravity = "center",
					textSize = "16sp",
					layout_height = -1,
					layout_width = -1,
					layout_weight = "3.2",
				},
				costimg("xfc_dx", enlarge_path, function()
					if xfc_large == false then
						lllayoutParams = ooo.getLayoutParams()
						ooo1_jilu = lllayoutParams.width
						ooo2_jilu = lllayoutParams.height
						lllayoutParams.width = ooo1
						lllayoutParams.height = ooo2
						ooo.setLayoutParams(lllayoutParams)
						xfc_large = true
						xfc_dx.setImageDrawable(Drawable.createFromPath(shrink_path))
					elseif xfc_large == true then
						lllayoutParams = ooo.getLayoutParams()
						lllayoutParams.width = ooo1_jilu
						lllayoutParams.height = ooo2_jilu
						ooo.setLayoutParams(lllayoutParams)
						xfc_dx.setImageDrawable(Drawable.createFromPath(enlarge_path))
						xfc_large = false
					end
				end, "10dp"),
				costimg("xfc_yc", hide_path, function()
					window.removeView(xfc)
					window.addView(xfq, mainLayoutParams)
				end, "5dp"),
				costimg("xfc_exit", exit_path, function()
					window.removeView(xfc)
					luajava.exit()
					os.exit()
				end, "5dp"),
			},
			{
				LinearLayout,
				layout_height = "38dp",
				layout_width = -1,
				orientation = "vertical",
				{
					LinearLayout,
					layout_height = "35dp",
					layout_width = -1,
					{
						TextView,
						text = "💜",
						gravity = "center",
						layout_width = "25dp",
						textSize = "14sp",
						layout_height = -1,
						id = "page_delete",
						onClick = function()
							local coumt = view_list.getChildCount()
							if coumt > 1 then
								view_list.removeViewAt(coumt - 1)
							else
								gg.toast("At root menu")
							end
						end,
					},
					{
						HorizontalScrollView,
						layout_height = -1,
						layout_width = -1,
						horizontalScrollBarEnabled = false,
						{
							LinearLayout,
							layout_height = -1,
							orientation = "horizontal",
							layout_width = -1,
							id = "view_list",
						},
					},
				},
			},
			{
				ScrollView,
				layout_width = -1,
				layout_height = -1,
				VerticalScrollBarEnabled = false,
				{
					RelativeLayout,
					layout_height = -1,
					layout_width = -1,
					layout_margin = "3dp",
					id = "funclayout",
					{
						LinearLayout,
						layout_height = -1,
						orientation = "vertical",
						layout_width = -1,
						id = "main_list"
					},
				},
			},
		},
		{
			View,
			layout_width = "25dp",
			layout_height = "25dp",
			layout_alignParentRight = "true",
			layout_alignParentBottom = "true",
			id = "td",
		},
	},
}

function LoadUi()
    gg.toast("Initializing UI...")
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
    xfq.setBackground(getShepeBackground(PURPLE_BG, 30))

	moveTouch(suspended_ball, xfq, mainLayoutParams)
	function suspended_ball.onClick()
		window.removeView(xfq)
		window.addView(xfc, mainLayoutParams)
	end

	xfc = loadlayout(xfc_table)
	view_list.addView(loadlayout(natext("DASHBOARD", main_list)))
	laytab = { main_list }
	cpage = laytab[1]
	moveTouch(touch, xfc, mainLayoutParams)
	view_list.getChildAt(0).getPaint().setFakeBoldText(true)

	for i = 1, #menus do
		local btn = loadlayout({
			RelativeLayout,
			layout_height = "45dp",
			layout_width = -1,
            background = getShepeBackground(PURPLE_CARD, 15),
            layout_margin = "2dp",
			onClick = function()
				cpage.setVisibility(View.GONE)
				laytab[i + 1].setVisibility(View.VISIBLE)
				cpage = laytab[i + 1]
				local sw = loadlayout(natext(menus[i][1], laytab[i + 1]))
				sw.getPaint().setFakeBoldText(true)
				view_list.addView(sw)
			end,
			{
				TextView,
				layout_alignParentTop = "true",
				layout_marginBottom = "20dp",
				layout_height = "24dp",
				layout_width = -1,
                layout_marginLeft = "10dp",
				text = menus[i][1],
				textSize = "15sp",
				textColor = Color.parseColor(TEXT_PRIMARY),
			},
			{
				TextView,
				layout_height = "16dp",
				layout_width = -1,
				layout_alignParentBottom = "true",
				layout_marginBottom = "4dp",
                layout_marginLeft = "10dp",
				textSize = "11sp",
				text = menus[i][2],
				textColor = Color.parseColor(TEXT_SECONDARY),
			},
			pline(),
		})
		local lyt = loadlayout({
			LinearLayout,
			layout_height = -1,
			orientation = "vertical",
			Visibility = 8,
			layout_width = -1
		})
		table.insert(laytab, lyt)
		main_list.addView(btn)
		funclayout.addView(lyt)
	end

	for i = 1, #menus do
		for k = 1, #menus[i][3] do
			local mtab = menus[i][3][k]
			if mtab[1] == "t" then
				VellMod_text(mtab, laytab[i + 1])
			elseif mtab[1] == "s" then
				VellMod_switch(mtab, laytab[i + 1])
			end
		end
	end

	function td.OnTouchListener(v, event)
		if event.getAction() == MotionEvent.ACTION_DOWN then
			params = ooo.getLayoutParams()
			firstX = event.getRawX()
			firstY = event.getRawY()
			wmX = params.width
			wmY = params.height
			max = dp2px(350)
			min = dp2px(50)
		elseif event.getAction() == MotionEvent.ACTION_MOVE then
			local width = wmX + (event.getRawX() - firstX)
			local height = wmY + (event.getRawY() - firstY)
			if width < max and width > min then
				params.width = width
				ooo.setBackground(miaobian(5, 40, PURPLE_BG, PURPLE_ACCENT))
			elseif width > max then
				ooo.setBackground(miaobian(5, 40, PURPLE_BG, "#FFFF0000"))
				params.width = max
			elseif width < min then
				ooo.setBackground(miaobian(5, 40, PURPLE_BG, "#FFFF0000"))
				params.width = min
			end
			if height < max and height > min then
				params.height = height
			elseif height > max then
				params.height = max
			elseif height < min then
				params.height = min
			end
			ooo.setLayoutParams(params)
		elseif event.getAction() == MotionEvent.ACTION_UP then
			ooo.setBackground(getShepeBackground(PURPLE_BG, 40))
		end
		return true
	end

	window.addView(xfq, mainLayoutParams)
    gg.toast("Menu Ready! Click the icon to open.")
end

-- Use Lock.Ui safely
if Lock and Lock.Ui then
    Lock.Ui(LoadUi, nil, function(err)
        print("ELGG UI Error: " .. err)
        luajava.exit()
    end)
else
    -- Fallback attempt
    pcall(LoadUi)
end

-- Keep alive loop (Prevents instant exit if Lock.Ui is not blocking)
while true do
    gg.sleep(5000)
end
