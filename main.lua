-- 支持ELGG修改器，作者：VellMod / Stylish Upgrade
-- Modern Stylish Purple Mod Menu UI for ELGG

local 悬浮窗图标外链 = "https://files.catbox.moe/mbkj32.png"
local 资源文件夹 = "/sdcard/.vlx_purple/"

-- Color Palette
local c_bg = 0xFF1A0033        -- Deep Purple Background
local c_card = 0xFF2D0054      -- Lighter Purple Card
local c_accent = 0xFFD0BCFF    -- Lavender Accent
local c_stroke = 0xFF6A1B9A    -- Rich Purple Stroke
local c_text_p = 0xFFFFFFFF    -- White Text
local c_text_s = 0xFFCAC4D0    -- Secondary Lavender Text

local check_file = file.new(资源文件夹)
if not check_file.isDirectory() then
	check_file.delete()
	check_file.mkdir()
end

-- Resources
local icon_file = 资源文件夹 .. "icon.png"
local exit_path = 资源文件夹 .. "exit.png"
local hide_path = 资源文件夹 .. "hide.png"
local enlarge_path = 资源文件夹 .. "enlarge.png"
local shrink_path = 资源文件夹 .. "shrink.png"

if not file.new(icon_file).exists() then
	file.download(悬浮窗图标外链, icon_file)
	file.download("https://www.xiaoman.top/assets/users/VellMod/exit.png", exit_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/hide.png", hide_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/enlarge.png", enlarge_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/shrink.png", shrink_path)
end

-- Stylish Menus
menus = {
	{ "MOVEMENT", "Hacks related to player movement.",
		{
			{ "s", "Speed Hack (2.0x)", "Fast movement speed",
                open = function() gg.setSpeed(2.0) gg.toast("Speed Boost: ON") end,
                close = function() gg.setSpeed(1.0) gg.toast("Speed Boost: OFF") end
            },
			{ "s", "Jump Hack (High)", "Increased jump height",
                open = function() gg.toast("Jump Hack Enabled") end,
                close = function() gg.toast("Jump Hack Disabled") end
            },
		}
	},
	{ "VISUALS", "Enhance game visuals and ESP.",
		{
			{ "t", "Full Bright", "Remove shadows and fog", function() gg.alert("Visual Hack Applied") end },
			{ "s", "Chams (Rainbow)", "Colored player models",
                open = function() gg.toast("Chams: Rainbow") end,
                close = function() gg.toast("Chams: OFF") end
            },
		}
	},
    { "SETTINGS", "Menu and script configurations.",
		{
			{ "t", "Reset All", "Restore default game state", function() gg.setSpeed(1.0) gg.toast("Restored Defaults") end },
		}
	},
}

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
ooo1 = tonumber(device.getWidth)
ooo2 = tonumber(device.getHeight)

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
		ColorFilter = c_accent,
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
	drawable = luajava.new(GradientDrawable)
	drawable.setShape(GradientDrawable.RECTANGLE)
	drawable.setColor(color)
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
		textColor = c_text_s,
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
		background = getShepeBackground(c_stroke, 10),
		layout_alignParentBottom = "true",
	}
end

function VellMod_switch(ojbk, parent)
	local sw = loadlayout({
		Switch,
		text = ojbk[2],
		textColor = c_text_p,
		padding = "8dp",
		layout_width = -1,
		layout_height = "45dp",
	})
	sw.ThumbDrawable.setColorFilter(PorterDuffColorFilter(c_accent, PorterDuff.Mode.SRC_ATOP))
	sw.TrackDrawable.setColorFilter(PorterDuffColorFilter(c_stroke, PorterDuff.Mode.SRC_ATOP))
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
		background = getShepeBackground(c_stroke, 10),
        layout_marginLeft = "10dp",
        layout_marginRight = "10dp"
	}))
end

function VellMod_text(ojbk, parent)
	local btn = loadlayout({
		RelativeLayout,
		layout_height = "45dp",
		layout_width = -1,
        layout_margin = "2dp",
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
            layout_marginLeft = "8dp",
			text = ojbk[2],
			textSize = "14sp",
			textColor = c_text_p,
		},
		{
			TextView,
			layout_height = "16dp",
			layout_width = -1,
			layout_alignParentTop = "true",
			layout_marginTop = "19dp",
            layout_marginLeft = "8dp",
			textSize = "11sp",
			text = ojbk[3],
			textColor = c_text_s,
		},
		pline(),
	})
	parent.addView(btn)
end

xfc = {
	LinearLayout,
	layout_height = "fill",
	layout_width = "fill",
	id = "touch",
	{
		RelativeLayout,
		layout_height = "340dp",
		layout_width = "280dp",
		background = getShepeBackground(c_bg, 40),
		id = "ooo",
		{
			LinearLayout,
			layout_height = -1,
			orientation = "vertical",
			layout_margin = "12dp",
			layout_width = -1,
			{
				LinearLayout, -- Top Bar
				layout_height = "45dp",
				orientation = "horizontal",
				layout_width = -1,
				gravity = "center",
                background = getShepeBackground(c_card, 20),
                layout_marginBottom = "10dp",
				{
					ImageView,
					layout_width = -1,
					layout_height = -1,
					layout_weight = "4.5",
					id = "logo",
					src = icon_file,
				},
				{
					TextView,
					textColor = c_accent,
					text = "VELLIX AO",
					gravity = "center",
					textSize = "16sp",
                    textStyle = "bold",
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
				LinearLayout, -- Navigation
				layout_height = "40dp",
				layout_width = -1,
				orientation = "vertical",
				{
					LinearLayout,
					layout_height = "38dp",
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
								gg.toast("Back to Main Menu")
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
					layout_margin = "4dp",
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
            padding = "8dp",
            background = getShepeBackground(c_bg, 30),
		},
	})
	moveTouch(suspended_ball, xfq, mainLayoutParams)
	function suspended_ball.onClick()
		window.removeView(xfq)
		window.addView(xfc, mainLayoutParams)
	end

	xfc = loadlayout(xfc)
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
            layout_margin = "2dp",
            background = getShepeBackground(c_card, 15),
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
                layout_marginLeft = "12dp",
				text = menus[i][1],
				textSize = "15sp",
                textStyle = "bold",
				textColor = c_text_p,
			},
			{
				TextView,
				layout_height = "16dp",
				layout_width = -1,
				layout_alignParentBottom = "true",
				layout_marginBottom = "4dp",
                layout_marginLeft = "12dp",
				textSize = "11sp",
				text = menus[i][2],
				textColor = c_text_s,
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
			max = dp2px(400)
			min = dp2px(100)
		elseif event.getAction() == MotionEvent.ACTION_MOVE then
			local width = wmX + (event.getRawX() - firstX)
			local height = wmY + (event.getRawY() - firstY)
			if width < max and width > min then
				params.width = width
				ooo.setBackground(miaobian(5, 40, "#FF1A0033", "#FFD0BCFF"))
			elseif width > max then
				ooo.setBackground(miaobian(5, 40, "#FF1A0033", "#FFFF0000"))
				params.width = max
			elseif width < min then
				ooo.setBackground(miaobian(5, 40, "#FF1A0033", "#FFFF0000"))
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
			ooo.setBackground(getShepeBackground(c_bg, 40))
		end
		return true
	end

	window.addView(xfq, mainLayoutParams)
end

Lock.Ui(LoadUi, nil, function(err)
	print(err)
	luajava.exit()
end)

os.exit()
