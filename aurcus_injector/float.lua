-- float.lua
-- Floating Mod Menu for Aurcus Online
-- Layanan Menu Mod Melayang untuk Aurcus Online

require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.*"
import "android.content.*"
import "android.os.*"

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

lp.format = PixelFormat.RGBA_8888
lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
lp.width = WindowManager.LayoutParams.WRAP_CONTENT
lp.height = WindowManager.LayoutParams.WRAP_CONTENT
lp.gravity = Gravity.LEFT | Gravity.TOP
lp.x = 100
lp.y = 100

-- Floating Icon (The small button) / Ikon Melayang (Tombol kecil)
local icon = ImageView(service)
icon.setImageResource(android.R.drawable.ic_menu_compass)
icon.setBackgroundColor(0x88000000)
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

  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="220dp",
    backgroundColor="#EE222222",
    padding="15dp",
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
      onClick=function()
        wm.removeView(menuView)
        menuView = nil
      end
    },
    {
      Button,
      text="EXIT INJECTOR / KELUAR",
      layout_marginTop="5dp",
      onClick=function()
        service.stopSelf()
      end
    }
  }

  local menuLP = WindowManager.LayoutParams()
  menuLP.type = lp.type
  menuLP.format = PixelFormat.RGBA_8888
  menuLP.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
  menuLP.width = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.height = WindowManager.LayoutParams.WRAP_CONTENT
  menuLP.gravity = Gravity.CENTER

  menuView = loadlayout(menuLayout)
  wm.addView(menuView, menuLP)

  -- CheckBox Events / Kejadian Kotak Centang
  chk_godmode.onCheckedChange = function(v, isChecked)
    if isChecked then
      local start_addr, end_addr = memory.getDalvikMain()
      if start_addr then
        print("God Mode ON - Dalvik: " .. string.format("%X", start_addr))
        -- memory.write(start_addr + 0x123, "00 00 A0 E3", "hex") -- Placeholder
      else
        print("Dalvik range not found! / Rentang Dalvik tidak ditemukan!")
        v.setChecked(false)
      end
    else
      print("God Mode OFF")
    end
  end

  chk_onehit.onCheckedChange = function(v, isChecked)
    if isChecked then
       print("One Hit Kill ON")
    else
       print("One Hit Kill OFF")
    end
  end
end

-- Cleanup when service stops / Pembersihan saat layanan berhenti
function onDestroy()
  if icon then wm.removeView(icon) end
  if menuView then wm.removeView(menuView) end
end
