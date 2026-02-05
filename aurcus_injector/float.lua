-- float.lua
-- Floating Mod Menu for Aurcus Online
-- Layanan Menu Mod Melayang untuk Aurcus Online

require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.graphics.drawable.*"
import "android.content.*"
import "android.os.*"
import "android.util.DisplayMetrics"

-- Debug Toast / Toast Debug
Toast.makeText(service, "Float Service Started", Toast.LENGTH_SHORT).show()

-- Import our memory utility / Impor alat bantu memori kami
local memory = require("memory")

local wm = service.getSystemService(Context.WINDOW_SERVICE)
local lp = WindowManager.LayoutParams()

-- Set Overlay Type based on Android version / Atur tipe overlay berdasarkan versi Android
if Build.VERSION.SDK_INT >= 26 then
  lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
else
  lp.type = WindowManager.LayoutParams.TYPE_PHONE
end

-- Fixed size for better visibility / Ukuran tetap agar lebih terlihat
local dm = service.getResources().getDisplayMetrics()
local iconSize = math.floor(54 * dm.density)

lp.format = PixelFormat.RGBA_8888
lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
lp.width = iconSize
lp.height = iconSize
lp.gravity = Gravity.LEFT | Gravity.TOP
lp.x = 100
lp.y = 100

-- Floating Icon (The small button) / Ikon Melayang (Tombol kecil)
local icon = ImageView(service)
icon.setImageResource(android.R.drawable.ic_menu_compass)

-- Safe programmatic background / Latar belakang terprogram yang aman
local iconBG = GradientDrawable()
iconBG.setColor(0xFFFF0000) -- Red / Merah
iconBG.setCornerRadius(math.floor(27 * dm.density))
icon.setBackgroundDrawable(iconBG)
icon.setPadding(10, 10, 10, 10)

-- Draggable Logic / Logika Seret
local lastX, lastY, startX, startY
icon.onTouch = function(v, event)
  local action = event.getAction()
  if action == MotionEvent.ACTION_DOWN then
    startX = event.getRawX()
    startY = event.getRawY()
    lastX = lp.x
    lastY = lp.y
  elseif action == MotionEvent.ACTION_MOVE then
    lp.x = lastX + (event.getRawX() - startX)
    lp.y = lastY + (event.getRawY() - startY)
    wm.updateViewLayout(icon, lp)
  elseif action == MotionEvent.ACTION_UP then
    -- If it's a tap, show the menu / Jika diketuk, tampilkan menu
    if math.abs(event.getRawX() - startX) < 10 and math.abs(event.getRawY() - startY) < 10 then
      showMenu()
    end
  end
  return true
end

wm.addView(icon, lp)

local menuView = nil

-- Mod Menu Dialog / Dialog Menu Mod
function showMenu()
  if menuView then return end -- Prevent multiple menus / Cegah menu ganda

  -- Simple Layout without dangerous attributes
  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="220dp",
    padding="15dp",
    id="menu_main",
    {
      TextView,
      text="AURCUS MOD MENU",
      textColor="#FFFFFF",
      gravity="center",
      textSize="16sp",
      layout_marginBottom="10dp",
    },
    {
      CheckBox,
      id="chk_godmode",
      text="God Mode (Dalvik)",
      textColor="#FFFFFF",
    },
    {
      CheckBox,
      id="chk_onehit",
      text="One Hit Kill (Dalvik)",
      textColor="#FFFFFF",
    },
    {
      Button,
      text="HIDE / SEMBUNYIKAN",
      layout_marginTop="10dp",
      id="btn_hide",
    },
    {
      Button,
      text="EXIT INJECTOR / KELUAR",
      layout_marginTop="5dp",
      id="btn_exit",
    }
  }

  local menuLP = WindowManager.LayoutParams()
  menuLP.type = lp.type
  menuLP.format = PixelFormat.RGBA_8888
  menuLP.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
  menuLP.width = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.height = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.gravity = Gravity.CENTER

  -- Load layout safely
  local ids = {}
  menuView = loadlayout(menuLayout, ids)

  -- Set background programmatically to avoid loadlayout errors
  -- Atur latar belakang secara terprogram untuk menghindari kesalahan loadlayout
  local menuBG = GradientDrawable()
  menuBG.setColor(0xEE222222)
  menuBG.setCornerRadius(20)
  menuBG.setStroke(3, 0xFFFFFFFF) -- White border / Pinggiran putih
  ids.menu_main.setBackgroundDrawable(menuBG)

  wm.addView(menuView, menuLP)

  -- Button Listeners
  ids.btn_hide.onClick = function()
    wm.removeView(menuView)
    menuView = nil
  end

  ids.btn_exit.onClick = function()
    service.stopSelf()
  end

  -- CheckBox Events / Kejadian Kotak Centang
  ids.chk_godmode.onCheckedChange = function(v, isChecked)
    if isChecked then
      local start_addr, end_addr = memory.getDalvikMain()
      if start_addr then
        print("God Mode ON - Dalvik: " .. string.format("%X", start_addr))
      else
        print("Dalvik range not found! / Rentang Dalvik tidak ditemukan!")
        v.setChecked(false)
      end
    else
      print("God Mode OFF")
    end
  end

  ids.chk_onehit.onCheckedChange = function(v, isChecked)
    if isChecked then
       print("One Hit Kill ON")
    else
       print("One Hit Kill OFF")
    end
  end
end

-- Cleanup when service stops / Pembersihan saat layanan berhenti
function onDestroy()
  if icon then pcall(function() wm.removeView(icon) end) end
  if menuView then pcall(function() wm.removeView(menuView) end) end
end
