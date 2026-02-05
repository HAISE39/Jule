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

-- Set UI Layout / Atur Tata Letak UI
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"

-- START Button Click Event / Kejadian Klik Tombol START
btn_start.onClick = function()
  -- Check Overlay Permission (Required for Mod Menu)
  -- Periksa Izin Hamparan (Diperlukan untuk Menu Mod)
  if Build.VERSION.SDK_INT >= 23 then
    if not Settings.canDrawOverlays(activity) then
      print("Please allow 'Display over other apps' / Mohon izinkan 'Tampilkan di atas aplikasi lain'")
      local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
      intent.setData(Uri.parse("package:" .. activity.getPackageName()))
      activity.startActivity(intent)
      return
    end
  end

  -- Check if the game is installed / Periksa apakah game sudah terinstal
  local pm = activity.getPackageManager()
  local info = nil
  pcall(function() info = pm.getPackageInfo(target_package, 0) end)

  if info then
    -- Launch the game / Jalankan game
    local intent = pm.getLaunchIntentForPackage(target_package)
    activity.startActivity(intent)

    -- Start Floating Mod Menu Service / Mulai Layanan Menu Mod Melayang
    -- In AndLua+, use service() to start a lua file as a service
    service("float")

    print("Game started! Mod Menu is active. / Game dimulai! Menu Mod aktif.")
    -- Optional: Minimize the injector app / Opsional: Minimalkan aplikasi injector
    activity.moveTaskToBack(true)
  else
    print("Error: " .. target_package .. " not installed! / Game tidak terinstal!")
  end
end
