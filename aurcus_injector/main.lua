-- main.lua
-- Injector for Aurcus Online
-- Inspired by HAISE39/andl style

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

-- Floating Views State
local iconView = nil
local menuView = nil
local isMenuOpen = false
local isInjectorActive = false

-- Layout Parameters for Floating Icon
local iconLP = WindowManager.LayoutParams()
if Build.VERSION.SDK_INT >= 26 then
  iconLP.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
else
  iconLP.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT
end
iconLP.format = PixelFormat.RGBA_8888
iconLP.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
iconLP.width = math.floor(54 * dm.density)
iconLP.height = math.floor(54 * dm.density)
iconLP.gravity = Gravity.LEFT | Gravity.TOP
iconLP.x = 100
iconLP.y = 300

-- Layout Parameters for Main Menu
local menuLP = WindowManager.LayoutParams()
menuLP.type = iconLP.type
menuLP.format = PixelFormat.RGBA_8888
menuLP.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
menuLP.width = WindowManager.LayoutParams.WRAP_CONTENT
menuLP.height = WindowManager.LayoutParams.WRAP_CONTENT
menuLP.gravity = Gravity.CENTER

-- Helper function to set background programmatically
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

function checkPermission()
  if Build.VERSION.SDK_INT >= 23 then
    if not Settings.canDrawOverlays(activity) then
      print("Please allow Overlay Permission / Mohon izinkan Izin Hamparan")
      local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
      intent.setData(Uri.parse("package:" .. activity.getPackageName()))
      activity.startActivity(intent)
      return false
    end
  end
  return true
end

function initFloatingIcon()
  if iconView then return end

  iconView = ImageView(activity)
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
  Toast.makeText(activity, "Mod Menu Active / Menu Mod Aktif", Toast.LENGTH_SHORT).show()
end

function toggleMenu()
  if isMenuOpen then
    if menuView then wm.removeView(menuView) end
    menuView = nil
    isMenuOpen = false
  else
    showMenu()
  end
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
          id="btn_hide_menu",
          text="HIDE MENU / SEMBUNYIKAN",
          layout_marginTop="10dp",
          layout_width="fill",
        },
      }
    }
  }

  local ids = {}
  menuView = loadlayout(menuLayout, ids)

  -- Apply styles
  setSafeBackground(ids.btn_hide_menu, 0xFF333333, 10)
  ids.btn_hide_menu.setTextColor(0xFFFFFFFF)

  -- Listeners
  ids.btn_hide_menu.onClick = function()
    toggleMenu()
  end

  ids.chk_godmode.onCheckedChange = function(v, isChecked)
    if isChecked then
      local start, _ = memory.getDalvikMain()
      if start then
        print("God Mode Active @ " .. string.format("%X", start))
      else
        print("Dalvik range not found! / Rentang Dalvik tidak ditemukan!")
        v.setChecked(false)
      end
    end
  end

  wm.addView(menuView, menuLP)
  isMenuOpen = true
end

function startInjector()
  if not checkPermission() then return end

  initFloatingIcon()
  isInjectorActive = true
  status_text.setText("Status: Active / Aktif")
  status_text.setTextColor(0xFF40C4FF)

  -- Auto Launch Game
  launchGame()

  -- Minimize injector
  activity.moveTaskToBack(true)
end

function stopInjector()
  if isMenuOpen and menuView then
    wm.removeView(menuView)
    menuView = nil
    isMenuOpen = false
  end
  if iconView then
    wm.removeView(iconView)
    iconView = nil
  end
  isInjectorActive = false
  status_text.setText("Status: Stopped / Berhenti")
  status_text.setTextColor(0xFFF44336)
  print("Injector Stopped / Injector Berhenti")
end

function launchGame()
  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then
    activity.startActivity(intent)
  else
    print("Game not installed! / Game tidak terinstal!")
  end
end

-- Button Click Events
btn_start.onClick = startInjector
btn_stop.onClick = stopInjector
btn_game.onClick = launchGame
btn_exit.onClick = function()
  stopInjector()
  activity.finish()
end

-- Cleanup on activity destroy
function onDestroy()
  stopInjector()
end
