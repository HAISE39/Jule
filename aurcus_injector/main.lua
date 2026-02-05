-- main.lua
-- Injector for Aurcus Online
-- Package: com.asobimo.aurcusonline.wx

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

-- Import our memory utility
local memory = require("memory")

-- Set UI Layout
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"
local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local dm = activity.getResources().getDisplayMetrics()

-- Mod Constants
local VAL_BAG = 12
local VAL_MARKET = 27
local VAL_ORIGINAL = 0xFFFFFFFF

-- UI State
local iconView = nil
local menuView = nil
local isMenuOpen = false
local isUpdatingUI = false

-- Helper for safe background
function setSafeBackground(view, color, radius, strokeColor)
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  drawable.setCornerRadii({radius, radius, radius, radius, radius, radius, radius, radius})
  drawable.setColor(color)
  if strokeColor then drawable.setStroke(3, strokeColor) end
  view.setBackgroundDrawable(drawable)
end

-- Helper for safe checkbox updates
function setCheckedSafe(cb, checked)
  isUpdatingUI = true
  cb.setChecked(checked)
  isUpdatingUI = false
end

-- UI Update Callbacks (Called from thread)
function updateStatus(msg)
  status_text.setText("Status: " .. msg)
end

function onModResult(msg, success)
  print(msg)
  if success then
    status_text.setText("Status: Active / Aktif")
    status_text.setTextColor(0xFF40C4FF)
  else
    status_text.setText("Status: Failed / Gagal")
    status_text.setTextColor(0xFFF44336)
  end
end

-- Main Mod Logic (Runs in background thread)
function runMod(targetVal, featureName)
  thread(function(val, name)
    require "import"
    local memory = require("memory")

    -- Pattern: FF FF FF FF 02 00 00 00 [GAP: FF FF FF FF] 00 00 00 00 00 00 00 00
    local prefix = "\xff\xff\xff\xff\x02\0\0\0"
    local suffix = "\0\0\0\0\0\0\0\0"

    call("updateStatus", "Searching " .. name .. "...")

    local start, stop = memory.getDalvikMain()
    if not start then
      call("onModResult", "Dalvik range not found!", false)
      return
    end

    -- Search for the pattern in Java Heap
    local addr = memory.searchPattern(prefix, suffix, 4, start, stop)
    if addr then
      -- Target is offset 8 from start of pattern (the second FF FF FF FF block)
      if memory.writeDword(addr + 8, val) then
        call("onModResult", name .. " applied!", true)
      else
        call("onModResult", "Failed to write memory!", false)
      end
    else
      call("onModResult", "Code not found! / Kode tidak ditemukan!", false)
    end
  end, targetVal, featureName)
end

function showMenu()
  if menuView then return end
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
          LinearLayout,
          orientation="vertical",
          layout_width="fill",
          {
            CheckBox,
            id="chk_bag",
            text="Open Bag / Buka Tas",
            textColor="#FFFFFF",
          },
          {
            CheckBox,
            id="chk_market",
            text="Open Market / Buka Pasar",
            textColor="#FFFFFF",
          },
        },
        {
          Button,
          id="btn_hide_menu",
          text="HIDE MENU / SEMBUNYIKAN",
          layout_marginTop="15dp",
          layout_width="fill",
        },
      }
    }
  }

  local ids = {}
  menuView = loadlayout(menuLayout, ids)
  setSafeBackground(ids.btn_hide_menu, 0xFF333333, 10)
  ids.btn_hide_menu.setTextColor(0xFFFFFFFF)

  ids.btn_hide_menu.onClick = function()
    wm.removeView(menuView)
    menuView = nil
    isMenuOpen = false
  end

  ids.chk_bag.onCheckedChange = function(v, isChecked)
    if isChecked then
      setCheckedSafe(ids.chk_market, false)
      runMod(VAL_BAG, "Open Bag")
    else
      if not isUpdatingUI then runMod(VAL_ORIGINAL, "Revert Bag") end
    end
  end

  ids.chk_market.onCheckedChange = function(v, isChecked)
    if isChecked then
      setCheckedSafe(ids.chk_bag, false)
      runMod(VAL_MARKET, "Open Market")
    else
      if not isUpdatingUI then runMod(VAL_ORIGINAL, "Revert Market") end
    end
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
    setSafeBackground(iconView, 0xFF40C4FF, math.floor(27 * dm.density), 0xFFFFFFFF)

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

  status_text.setText("Status: Active / Aktif")
  status_text.setTextColor(0xFF40C4FF)

  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then activity.startActivity(intent) end
  activity.moveTaskToBack(true)
end

btn_start.onClick = startInjector
btn_stop.onClick = function()
  if menuView then wm.removeView(menuView) menuView = nil isMenuOpen = false end
  if iconView then wm.removeView(iconView) iconView = nil end
  status_text.setText("Status: Stopped / Berhenti")
  status_text.setTextColor(0xFFF44336)
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
