-- main.lua
-- Injector for Aurcus Online
-- Package: com.asobimo.aurcusonline.wx
-- Non-Root Method: sharedUserId & shared process

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

-- Import memory utility
local memory = require("memory")

-- Set UI Layout
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"
local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local dm = activity.getResources().getDisplayMetrics()

-- Mod Constants
local MOD_PATTERN = "\xff\xff\xff\xff\x02\0\0\0\xff\xff\xff\xff\0\0\0\0\0\0\0\0"
local VAL_BAG = 12
local VAL_MARKET = 27
local VAL_RESET = -1 -- Original value FF FF FF FF

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

-- Helper for UI thread updates
function updateStatus(msg, color)
  status_text.setText("Status: " .. msg)
  if color then status_text.setTextColor(color) end
end

-- Main Mod Engine (Background Thread)
function applyMod(targetVal, featureName)
  thread(function(val, name, pat)
    require "import"
    local memory = require("memory")

    call("updateStatus", "Searching " .. name .. "...", 0xFF40C4FF)

    local s, e = memory.getDalvikMain()
    if not s then
      call("updateStatus", "Error: Range not found!", 0xFFF44336)
      return
    end

    local addr = memory.search(pat, s, e)
    if addr then
      -- Per GG Script: Write to Offset 8 from start of pattern
      if memory.writeDword(addr + 8, val) then
        call("updateStatus", name .. " Applied!", 0xFF4CAF50)
      else
        call("updateStatus", "Error: Write failed!", 0xFFF44336)
      end
    else
      call("updateStatus", "Error: Code not found!", 0xFFF44336)
    end
  end, targetVal, featureName, MOD_PATTERN)
end

function showMenu()
  if menuView then return end
  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="240dp",
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
          text="Open Bag / Buka Tas",
          textColor="#FFFFFF",
        },
        {
          CheckBox,
          id="chk_market",
          text="Open Market / Buka Pasar",
          textColor="#FFFFFF",
          layout_marginTop="5dp",
        },
        {
          Button,
          id="btn_hide_menu",
          text="HIDE MENU / SEMBUNYIKAN",
          layout_marginTop="20dp",
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
    if isUpdatingUI then return end
    if isChecked then
      isUpdatingUI = true
      ids.chk_market.setChecked(false)
      isUpdatingUI = false
      applyMod(VAL_BAG, "Open Bag")
    else
      applyMod(VAL_RESET, "Reset Bag")
    end
  end

  ids.chk_market.onCheckedChange = function(v, isChecked)
    if isUpdatingUI then return end
    if isChecked then
      isUpdatingUI = true
      ids.chk_bag.setChecked(false)
      isUpdatingUI = false
      applyMod(VAL_MARKET, "Open Market")
    else
      applyMod(VAL_RESET, "Reset Market")
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

  updateStatus("Injector Ready / Injector Siap", 0xFF4CAF50)

  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then activity.startActivity(intent) end
  activity.moveTaskToBack(true)
end

btn_start.onClick = startInjector
btn_stop.onClick = function()
  if menuView then wm.removeView(menuView) menuView = nil isMenuOpen = false end
  if iconView then wm.removeView(iconView) iconView = nil end
  updateStatus("Stopped / Berhenti", 0xFFF44336)
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
