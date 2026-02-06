require "import"
import "android.content.*"
import "android.widget.*"

-- --- Main Entry Point ---

-- Auto Launch Game
local function launchGame()
  local pkg = "com.asobimo.aurcusonline.wx"
  local intent = activity.getPackageManager().getLaunchIntentForPackage(pkg)
  if intent then
    activity.startActivity(intent)
  else
    Toast.makeText(activity, "Game Aurcus Online tidak ditemukan!", Toast.LENGTH_SHORT).show()
  end
end

-- Initialize the system
local function init()
  -- Launch game
  launchGame()

  -- Start UI and Floating Menu
  local ui = require("ui")
  ui.start()
end

init()
