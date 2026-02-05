-- main.lua
-- Injector for Aurcus Online
-- Package: com.asobimo.aurcusonline.wx

require "import"
import "android.widget.*"
import "android.view.*"
import "android.content.*"
import "android.app.*"

-- Set UI Layout / Atur Tata Letak UI
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"

-- START Button Click Event / Kejadian Klik Tombol START
btn_start.onClick = function()
  -- Check if the game is installed / Periksa apakah game sudah terinstal
  local pm = activity.getPackageManager()
  local info = nil
  pcall(function() info = pm.getPackageInfo(target_package, 0) end)

  if info then
    -- Launch the game / Jalankan game
    local intent = pm.getLaunchIntentForPackage(target_package)
    activity.startActivity(intent)

    -- Start Floating Mod Menu Service / Mulai Layanan Menu Mod Melayang
    -- We use LuaService to run float.lua in the background
    -- Kita menggunakan LuaService untuk menjalankan float.lua di latar belakang
    local serviceIntent = Intent(activity, LuaService.class)
    serviceIntent.putExtra("luaPath", activity.getLuaPath("float.lua"))
    activity.startService(serviceIntent)

    print("Game started! Mod Menu is active. / Game dimulai! Menu Mod aktif.")
    -- Optional: Minimize the injector app / Opsional: Minimalkan aplikasi injector
    activity.moveTaskToBack(true)
  else
    print("Error: " .. target_package .. " not installed! / Game tidak terinstal!")
  end
end
