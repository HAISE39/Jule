-- float.lua
-- Floating Mod Menu for Aurcus Online
-- Inspired by HAISE39/andl style

require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.content.*"
import "android.os.*"
import "android.util.DisplayMetrics"

-- Import our memory utility
local memory = require("memory")

local wm = service.getSystemService(Context.WINDOW_SERVICE)
local dm = service.getResources().getDisplayMetrics()

-- Helper function to set background programmatically (Safe for AndLua+)
function setSafeBackground(view, color, radius, strokeColor)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(color)
  if strokeColor then
    drawable.setStroke(3, strokeColor)
  end
  view.setBackgroundDrawable(drawable)
end

-- Layout Parameters for Floating Icon
local iconLP = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
  iconLP.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
else
  iconLP.type = WindowManager.LayoutParams.TYPE_PHONE
end
iconLP.format = PixelFormat.RGBA_8888
iconLP.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
iconLP.width = math.floor(54 * dm.density)
iconLP.height = math.floor(54 * dm.density)
iconLP.gravity = Gravity.LEFT | Gravity.TOP
iconLP.x = 100
iconLP.y = 100

-- Floating Icon
local iconView = ImageView(service)
iconView.setImageResource(android.R.drawable.ic_menu_compass)
iconView.setPadding(10, 10, 10, 10)
setSafeBackground(iconView, 0xFF40C4FF, math.floor(27 * dm.density), 0xFFFFFFFF)

-- Draggable Logic for Icon
local lastX, lastY, startX, startY
iconView.onTouch = function(v, event)
  local action = event.getAction()
  if action == MotionEvent.ACTION_DOWN then
    startX = event.getRawX()
    startY = event.getRawY()
    lastX = iconLP.x
    lastY = iconLP.y
  elseif action == MotionEvent.ACTION_MOVE then
    iconLP.x = lastX + (event.getRawX() - startX)
    iconLP.y = lastY + (event.getRawY() - startY)
    wm.updateViewLayout(iconView, iconLP)
  elseif action == MotionEvent.ACTION_UP then
    if math.abs(event.getRawX() - startX) < 10 and math.abs(event.getRawY() - startY) < 10 then
      toggleMenu()
    end
  end
  return true
end

wm.addView(iconView, iconLP)

local menuView = nil
local isMenuOpen = false

-- Layout Parameters for Main Menu
local menuLP = WindowManager.LayoutParams()
menuLP.type = iconLP.type
menuLP.format = PixelFormat.RGBA_8888
menuLP.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
menuLP.width = WindowManager.LayoutParams.WRAP_CONTENT
menuLP.height = WindowManager.LayoutParams.WRAP_CONTENT
menuLP.gravity = Gravity.CENTER

function toggleMenu()
  if isMenuOpen then
    wm.removeView(menuView)
    menuView = nil
    isMenuOpen = false
  else
    showMenu()
  end
end

function showMenu()
  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="240dp",
    id="main_container",
    padding="1dp",
    {
      CardView,
      layout_width="fill",
      layout_height="wrap",
      cardBackgroundColor="#202428",
      radius="12dp",
      {
        LinearLayout,
        orientation="vertical",
        layout_width="fill",
        padding="12dp",
        {
          TextView,
          text="AURCUS MOD MENU",
          textColor="#40C4FF",
          textSize="16sp",
          textStyle="bold",
          gravity="center",
          layout_marginBottom="10dp",
        },
        {
          ScrollView,
          layout_width="fill",
          layout_height="200dp",
          {
            LinearLayout,
            orientation="vertical",
            layout_width="fill",
            {
              CheckBox,
              id="chk_godmode",
              text="God Mode",
              textColor="#FFFFFF",
            },
            {
              CheckBox,
              id="chk_onehit",
              text="One Hit Kill",
              textColor="#FFFFFF",
            },
            {
              CheckBox,
              id="chk_speed",
              text="Speed Hack",
              textColor="#FFFFFF",
            },
          }
        },
        {
          Button,
          id="btn_hide",
          text="HIDE MENU",
          layout_marginTop="10dp",
          layout_width="fill",
        },
      }
    }
  }

  local ids = {}
  menuView = loadlayout(menuLayout, ids)

  -- Apply styles
  setSafeBackground(ids.btn_hide, 0xFF333333, 10)
  ids.btn_hide.setTextColor(0xFFFFFFFF)

  -- Listeners
  ids.btn_hide.onClick = function()
    toggleMenu()
  end

  ids.chk_godmode.onCheckedChange = function(v, isChecked)
    if isChecked then
      local start, _ = memory.getDalvikMain()
      if start then
        print("God Mode Active @ " .. string.format("%X", start))
      else
        print("Dalvik not found!")
        v.setChecked(false)
      end
    end
  end

  wm.addView(menuView, menuLP)
  isMenuOpen = true
end

function onDestroy()
  if iconView then pcall(function() wm.removeView(iconView) end) end
  if menuView then pcall(function() wm.removeView(menuView) end) end
end
