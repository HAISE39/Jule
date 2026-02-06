require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"
import "android.graphics.Typeface"

-- Modern UI Background Helper
local function getModernBackground(color, radius, strokeColor)
  local gd = GradientDrawable()
  gd.setColor(color)
  gd.setCornerRadius(radius or 30)
  if strokeColor then
    gd.setStroke(4, strokeColor)
  end
  return gd
end

-- --- UI Layouts ---

-- 1. Floating Icon Layout
local iconLayout = {
  LinearLayout,
  layout_width="50dp",
  layout_height="50dp",
  gravity="center",
  id="floatingIcon",
  {
    TextView,
    text="V",
    textColor="#00FF00",
    textSize="24sp",
    textStyle="bold",
  }
}

-- 2. Main Menu Layout
local menuLayout = {
  LinearLayout,
  orientation="vertical",
  layout_width="280dp",
  layout_height="wrap_content",
  id="mainMenu",
  padding="16dp",
  {
    TextView,
    text="VELLIXAO AURCUS",
    textColor="#00FF00",
    textSize="18sp",
    textStyle="bold",
    gravity="center",
    layout_width="fill",
  },
  {
    TextView,
    id="statusText",
    text="Status: Ready",
    textColor="#AAAAAA",
    textSize="12sp",
    gravity="center",
    layout_marginTop="4dp",
    layout_width="fill",
  },
  {
    LinearLayout,
    orientation="horizontal",
    layout_width="fill",
    layout_marginTop="16dp",
    gravity="center_vertical",
    {
      TextView,
      text="Refresh Skill",
      textColor="#FFFFFF",
      textSize="16sp",
      layout_weight=1,
    },
    {
      Switch,
      id="switchRefreshSkill",
    }
  },
  {
    Button,
    id="btnClose",
    text="HIDE MENU",
    textColor="#FFFFFF",
    layout_marginTop="20dp",
    layout_width="fill",
  },
}

-- --- Initialization ---

local iconView = loadlayout(iconLayout)
local menuView = loadlayout(menuLayout)

iconView.setBackground(getModernBackground(0xCC000000, 25, 0xFF00FF00))
menuView.setBackground(getModernBackground(0xEE111111, 40, 0xFF00FF00))

-- WindowManager Setup
local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local lp = WindowManager.LayoutParams()
lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
lp.format = 1
lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
lp.width = WindowManager.LayoutParams.WRAP_CONTENT
lp.height = WindowManager.LayoutParams.WRAP_CONTENT
lp.gravity = Gravity.LEFT | Gravity.TOP
lp.x = 100
lp.y = 300

-- Initial state: Show Icon
wm.addView(iconView, lp)

-- --- Logic Functions ---

-- Auto Launch Game
local function launchGame()
  local pkg = "com.asobimo.aurcusonline.wx"
  local intent = activity.getPackageManager().getLaunchIntentForPackage(pkg)
  if intent then
    activity.startActivity(intent)
  else
    Toast.makeText(activity, "Game not found!", Toast.LENGTH_SHORT).show()
  end
end

launchGame()

-- Toggle UI
local isMenuVisible = false

local function showMenu()
  wm.removeView(iconView)
  wm.addView(menuView, lp)
  isMenuVisible = true
end

local function hideMenu()
  wm.removeView(menuView)
  wm.addView(iconView, lp)
  isMenuVisible = false
end

-- Dragging Logic
local startX, startY, initialX, initialY
local function handleTouch(v, e)
  if e.getAction() == MotionEvent.ACTION_DOWN then
    startX = e.getRawX()
    startY = e.getRawY()
    initialX = lp.x
    initialY = lp.y
  elseif e.getAction() == MotionEvent.ACTION_MOVE then
    lp.x = initialX + (e.getRawX() - startX)
    lp.y = initialY + (e.getRawY() - startY)
    wm.updateViewLayout(v, lp)
  end
  return false
end

iconView.onTouch = handleTouch
menuView.onTouch = handleTouch

-- Click to Open Menu
iconView.onClick = showMenu
btnClose.onClick = hideMenu

-- --- Feature: Refresh Skill ---

local function runRefreshSkill(enabled)
  if not enabled then
    statusText.setText("Status: Disabled")
    return
  end

  thread(function()
    local memory = require("memory")
    call(function() statusText.setText("Status: Scanning Skill...") end)

    -- Pattern 3;81;20 (Dword)
    local pattern = "3;81;20"
    local results = memory.search(pattern, "Dword")

    if #results > 0 then
      -- Edit 3 (offset 0) to 25
      memory.writeBatch(results, "25", 0, "Dword")
      call(function()
        statusText.setText("Status: Skill Refreshed ("..#results..")")
        Toast.makeText(activity, "Refresh Skill Applied!", Toast.LENGTH_SHORT).show()
      end)
    else
      call(function()
        statusText.setText("Status: Skill Not Found")
        Toast.makeText(activity, "Refresh Skill Failed", Toast.LENGTH_SHORT).show()
      end)
    end
  end)
end

switchRefreshSkill.onCheckedChange = function(v, isChecked)
  runRefreshSkill(isChecked)
end
