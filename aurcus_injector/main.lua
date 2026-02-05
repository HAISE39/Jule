-- main.lua
-- Injector for Aurcus Online
-- Targets: com.asobimo.aurcusonline.wx

require "import"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.app.*"
import "android.net.Uri"
import "android.provider.Settings"
import "android.os.Build"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.util.DisplayMetrics"

-- Import memory engine
local memory = require("memory")

-- Set UI Layout
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"
local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local dm = activity.getResources().getDisplayMetrics()

-- Mod Logic
-- Pattern: FF FF FF FF 02 00 00 00 FF FF FF FF 00 00 00 00 00 00 00 00
local MOD_PATTERN = "\xff\xff\xff\xff\x02\0\0\0\xff\xff\xff\xff\0\0\0\0\0\0\0\0"
local VAL_TARGET = 12 -- Decimal
local VAL_ORIGINAL = 2

-- UI State
local iconView = nil
local menuView = nil
local isMenuOpen = false

-- Helper for background
function setSafeBackground(view, color, radius)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(color)
  view.setBackgroundDrawable(drawable)
end

function runOpenBag(isChecked)
  thread(function(checked)
    require "import"
    local memory = require("memory")

    call("updateStatus", "Searching...")

    local start, stop = memory.getJavaHeapRange()
    if not start then
      call("updateStatus", "Error: Heap not found")
      return
    end

    local addr = memory.search(MOD_PATTERN, start, stop)
    if addr then
      -- User said: "edit pada offset addres 4 nya menjadi 12 type dword"
      local target_addr = addr + 4
      local value = checked and VAL_TARGET or VAL_ORIGINAL

      if memory.writeDword(target_addr, value) then
        call("updateStatus", checked and "Bag Open: ACTIVE" or "Bag Open: RESET")
      else
        call("updateStatus", "Error: Write Failed")
      end
    else
      call("updateStatus", "Error: Code Not Found")
    end
  end, isChecked)
end

function updateStatus(msg)
  status_text.setText("Status: " .. msg)
end

function showMenu()
  if menuView then return end

  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="220dp",
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
        padding="15dp",
        {
          TextView,
          text="AURCUS MOD MENU",
          textColor="#40C4FF",
          textSize="16sp",
          textStyle="bold",
          gravity="center",
          layout_marginBottom="15dp",
        },
        {
          CheckBox,
          id="chk_bag",
          text="Open Bag",
          textColor="#FFFFFF",
        },
        {
          Button,
          id="btn_hide",
          text="HIDE MENU",
          layout_marginTop="20dp",
          layout_width="fill",
        },
      }
    }
  }

  local ids = {}
  menuView = loadlayout(menuLayout, ids)
  setSafeBackground(ids.btn_hide, 0xFF333333, 10)
  ids.btn_hide.setTextColor(0xFFFFFFFF)

  ids.btn_hide.onClick = function()
    wm.removeView(menuView)
    menuView = nil
    isMenuOpen = false
  end

  ids.chk_bag.onCheckedChange = function(v, isChecked)
    runOpenBag(isChecked)
  end

  local menuLP = WindowManager.LayoutParams()
  menuLP.type = Build.VERSION.SDK_INT >= 26 and WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY or WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
  menuLP.format = PixelFormat.RGBA_8888
  menuLP.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
  menuLP.width = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.height = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.gravity = Gravity.CENTER
  wm.addView(menuView, menuLP)
  isMenuOpen = true
end

function startInjector()
  if Build.VERSION.SDK_INT >= 23 and not Settings.canDrawOverlays(activity) then
    local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" .. activity.getPackageName()))
    activity.startActivity(intent)
    return
  end

  if not iconView then
    iconView = ImageView(activity)
    iconView.setImageResource(android.R.drawable.ic_menu_compass)
    iconView.setPadding(10, 10, 10, 10)
    setSafeBackground(iconView, 0xFF40C4FF, math.floor(27 * dm.density))

    local iconLP = WindowManager.LayoutParams()
    iconLP.type = Build.VERSION.SDK_INT >= 26 and WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY or WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
    iconLP.format = PixelFormat.RGBA_8888
    iconLP.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    iconLP.width = math.floor(54 * dm.density)
    iconLP.height = math.floor(54 * dm.density)
    iconLP.gravity = Gravity.LEFT | Gravity.TOP
    iconLP.x, iconLP.y = 100, 300

    local lastX, lastY, startX, startY
    iconView.onTouch = function(v, event)
      local action = event.getAction()
      if action == MotionEvent.ACTION_DOWN then
        startX, startY = event.getRawX(), event.getRawY()
        lastX, lastY = iconLP.x, iconLP.y
      elseif action == MotionEvent.ACTION_MOVE then
        iconLP.x, iconLP.y = lastX + (event.getRawX() - startX), lastY + (event.getRawY() - startY)
        wm.updateViewLayout(iconView, iconLP)
      elseif action == MotionEvent.ACTION_UP then
        if math.abs(event.getRawX() - startX) < 10 then
          if isMenuOpen then wm.removeView(menuView) menuView = nil isMenuOpen = false else showMenu() end
        end
      end
      return true
    end
    wm.addView(iconView, iconLP)
  end

  updateStatus("Injector Active")

  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then activity.startActivity(intent) end
  activity.moveTaskToBack(true)
end

btn_start.onClick = startInjector
btn_stop.onClick = function()
  if menuView then wm.removeView(menuView) menuView = nil isMenuOpen = false end
  if iconView then wm.removeView(iconView) iconView = nil end
  updateStatus("Stopped")
end
btn_game.onClick = function()
  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then activity.startActivity(intent) else print("Game not installed!") end
end
btn_exit.onClick = function()
  if iconView then wm.removeView(iconView) end
  activity.finish()
end
function onDestroy() if iconView then wm.removeView(iconView) end end
