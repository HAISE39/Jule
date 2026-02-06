-- 支持ELGG修改器，作者：VellMod，ELGG下载：https://www.xiaoman.top
-- Simple Mod Menu for ELGG using Native Android UI

local 悬浮窗图标外链 = "https://files.catbox.moe/mbkj32.png"

local 资源文件夹 = "/sdcard/.vlx/"

local check_file = file.new(资源文件夹)
if not check_file.isDirectory() then
	check_file.delete()
	check_file.mkdir()
end

-- 资源文件路径
local icon_file = 资源文件夹 .. "图标.png"
local exit_path = 资源文件夹 .. "退出.png"
local hide_path = 资源文件夹 .. "隐藏.png"
local enlarge_path = 资源文件夹 .. "放大.png"
local shrink_path = 资源文件夹 .. "缩小.png"

if not file.new(icon_file).exists() then
	file.download(悬浮窗图标外链, icon_file)
	file.download("https://www.xiaoman.top/assets/users/VellMod/exit.png", exit_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/hide.png", hide_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/enlarge.png", enlarge_path)
	file.download("https://www.xiaoman.top/assets/users/VellMod/shrink.png", shrink_path)
end

-- Define Menu Items (Following user's structure)
menus = {
	{ "Main Features", "Core mod functions for the game.",
		{
			{ "s", "Speed Hack (2.0x)", "Toggle game speed between 1x and 2x",
                open = function() gg.setSpeed(2.0) gg.toast("Speed: 2.0x") end,
                close = function() gg.setSpeed(1.0) gg.toast("Speed: 1.0x") end
            },
			{ "t", "Wallhack (Mock)", "Example of a function call hack", function() gg.alert("Wallhack Activated (Mock)") end },
		}
	},
	{ "Visuals", "Change how the game looks.",
		{
			{ "s", "Chams (Mock)", "Toggle player colors",
                open = function() gg.toast("Chams Enabled") end,
                close = function() gg.toast("Chams Disabled") end
            },
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
import "android.view.animation.Animation"
import "android.view.animation.RotateAnimation"
import "android.animation.ObjectAnimator"
import "android.view.animation.ScaleAnimation"
import "android.view.animation.*"
import "android.view.animation.DecelerateInterpolator"
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
		ColorFilter = 0xFFD0BCFF,
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
		layout_width = "80dp",
		layout_height = -1,
		padding = "5dp",
		ellipsize = "marquee",
		selected = true,
		singleLine = true,
		textSize = "13sp",
		textColor = 0xFFCAC4D0,
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
		background = getShepeBackground(0xFFCAC4D0, 10),
		layout_alignParentBottom = "true",
	}
end

function VellMod_switch(ojbk, parent)
	local sw = loadlayout({
		Switch,
		text = ojbk[2],
		textColor = 0xFFF6EDFF,
		padding = "5dp",
		layout_width = -1,
		layout_height = "40dp",
	})
	sw.ThumbDrawable.setColorFilter(PorterDuffColorFilter(0xFFD0BCFF, PorterDuff.Mode.SRC_ATOP))
	sw.TrackDrawable.setColorFilter(PorterDuffColorFilter(0xFFD0BCFF, PorterDuff.Mode.SRC_ATOP))
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
		background = getShepeBackground(0xFFCAC4D0, 10)
	}))
end

function VellMod_text(ojbk, parent)
	local btn = loadlayout({
		RelativeLayout,
		layout_height = "40dp",
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
			textColor = 0xFFF6EDFF,
		},
		{
			TextView,
			layout_height = "16dp",
			layout_width = -1,
			layout_alignParentTop = "true",
			layout_marginTop = "19dp",
			textSize = "11sp",
			text = ojbk[3],
			textColor = 0xFFCAC4D0,
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
		layout_height = "320dp",
		layout_width = "260dp",
		background = getShepeBackground(0xFF405688, 30),
		id = "ooo",
		{
			LinearLayout,
			layout_height = -1,
			orientation = "vertical",
			layout_margin = "10dp",
			layout_width = -1,
			{
				LinearLayout,
				layout_height = "40dp",
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
					textColor = 0xFFD0BCFF,
					text = "VellMod",
					gravity = "center",
					textSize = "14sp",
					layout_height = -1,
					layout_width = -1,
					layout_weight = "3.35",
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
				end, "9dp"),
				costimg("xfc_yc", hide_path, function()
					window.removeView(xfc)
					window.addView(xfq, mainLayoutParams)
				end, "4dp"),
				costimg("xfc_exit", exit_path, function()
					window.removeView(xfc)
					luajava.exit()
					os.exit()
				end, "4dp"),
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
						text = "⭐️",
						gravity = "center",
						layout_width = "20dp",
						textSize = "13sp",
						layout_height = -1,
						id = "page_delete",
						onClick = function()
							local coumt = view_list.getChildCount()
							if coumt > 1 then
								view_list.removeViewAt(coumt - 1)
							else
								gg.toast("Antarmuka menu utama yang tidak dapat dihapus")
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
			layout_width = "20dp",
			layout_height = "20dp",
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
		layout_width = "50dp",
		layout_height = "50dp",
		{
			ImageView,
			layout_width = "50dp",
			src = icon_file,
			id = "suspended_ball",
			layout_height = "50dp",
		},
	})
	moveTouch(suspended_ball, xfq, mainLayoutParams)
	function suspended_ball.onClick()
		window.removeView(xfq)
		window.addView(xfc, mainLayoutParams)
	end

	xfc = loadlayout(xfc)
	view_list.addView(loadlayout(natext("Menu Utama", main_list)))
	laytab = { main_list }
	cpage = laytab[1]
	moveTouch(touch, xfc, mainLayoutParams)
	view_list.getChildAt(0).getPaint().setFakeBoldText(true)

	for i = 1, #menus do
		local btn = loadlayout({
			RelativeLayout,
			layout_height = "40dp",
			layout_width = -1,
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
				text = menus[i][1],
				textSize = "14sp",
				textColor = 0xFFF6EDFF,
			},
			{
				TextView,
				layout_height = "16dp",
				layout_width = -1,
				layout_alignParentBottom = "true",
				layout_marginBottom = "3dp",
				textSize = "11sp",
				text = menus[i][2],
				textColor = 0xFFCAC4D0,
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
				ooo.setBackground(miaobian(5, 30, "#FF405688", "#FF00FF00"))
			elseif width > max then
				ooo.setBackground(miaobian(5, 30, "#FF405688", "#FFFF0000"))
				params.width = max
			elseif width < min then
				ooo.setBackground(miaobian(5, 30, "#FF405688", "#FFFF0000"))
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
			ooo.setBackground(getShepeBackground(0xFF405688, 30))
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
