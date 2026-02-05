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

-- Set UI Layout
activity.setContentView(loadlayout("layout"))

local target_package = "com.asobimo.aurcusonline.wx"

function checkPermission()
  if Build.VERSION.SDK_INT >= 23 then
    if not Settings.canDrawOverlays(activity) then
      print("Please allow Overlay Permission")
      local intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
      intent.setData(Uri.parse("package:" .. activity.getPackageName()))
      activity.startActivity(intent)
      return false
    end
  end
  return true
end

function startInjector()
  if not checkPermission() then return end

  local luaPath = activity.getLuaPath("float.lua")
  local ok, err = pcall(function()
    local intent = Intent()
    intent.setClassName(activity.getPackageName(), "com.androlua.LuaService")
    intent.putExtra("luaPath", luaPath)
    activity.startService(intent)
  end)

  if ok then
    status_text.setText("Status: Active")
    status_text.setTextColor(0xFF40C4FF)
    print("Injector Started")

    -- Auto Launch Game
    launchGame()

    -- Minimize
    activity.moveTaskToBack(true)
  else
    print("Error: " .. tostring(err))
  end
end

function stopInjector()
  local ok, err = pcall(function()
    local intent = Intent()
    intent.setClassName(activity.getPackageName(), "com.androlua.LuaService")
    activity.stopService(intent)
  end)

  if ok then
    status_text.setText("Status: Stopped")
    status_text.setTextColor(0xFFF44336)
    print("Injector Stopped")
  end
end

function launchGame()
  local pm = activity.getPackageManager()
  local intent = pm.getLaunchIntentForPackage(target_package)
  if intent then
    activity.startActivity(intent)
  else
    print("Game not installed!")
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
