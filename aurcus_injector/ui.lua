local ui = {}

require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"

-- --- UI Module ---
-- Handles the floating window and modern mod menu interface

local wm, lp, iconView, menuView
local statusText

-- Helper: Rounded Background with Border
local function getBackground(color, radius)
  local gd = GradientDrawable()
  gd.setColor(color)
  gd.setCornerRadius(radius)
  gd.setStroke(3, 0xFF00FF00) -- Professional Green border
  return gd
end

function ui.start()
  wm = activity.getSystemService(Context.WINDOW_SERVICE)
  lp = WindowManager.LayoutParams()
  lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
  lp.format = 1
  lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
  lp.width = WindowManager.LayoutParams.WRAP_CONTENT
  lp.height = WindowManager.LayoutParams.WRAP_CONTENT
  lp.gravity = Gravity.LEFT | Gravity.TOP
  lp.x = 100
  lp.y = 300

  -- 1. Floating Icon Layout
  local iconLayout = {
    LinearLayout,
    layout_width="55dp",
    layout_height="55dp",
    gravity="center",
    {
      TextView,
      text="V",
      textColor="#00FF00",
      textSize="26sp",
      textStyle="bold",
    }
  }
  iconView = loadlayout(iconLayout)
  iconView.setBackground(getBackground(0xCC000000, 27))

  -- 2. Modern Mod Menu Layout
  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="300dp",
    layout_height="wrap_content",
    padding="20dp",
    {
      TextView,
      text="VELLIXAO - AURCUS INJECTOR",
      textColor="#00FF00",
      textSize="20sp",
      textStyle="bold",
      gravity="center",
      layout_width="fill",
    },
    {
      TextView,
      id="status",
      text="Status: System Initialized",
      textColor="#CCCCCC",
      textSize="13sp",
      gravity="center",
      layout_marginTop="6dp",
      layout_width="fill",
    },
    {
      LinearLayout,
      orientation="horizontal",
      layout_width="fill",
      layout_marginTop="20dp",
      gravity="center_vertical",
      {
        TextView,
        text="Refresh Skill",
        textColor="#FFFFFF",
        textSize="17sp",
        layout_weight=1,
      },
      {
        Switch,
        id="btnSkill",
      }
    },
    {
      Button,
      id="btnHide",
      text="MINIMIZE MENU",
      textColor="#FFFFFF",
      layout_marginTop="25dp",
      layout_width="fill",
    },
  }

  -- Correct ID Retrieval in AndLua+
  local ids = {}
  menuView = loadlayout(menuLayout, ids)
  menuView.setBackground(getBackground(0xEE111111, 45))

  -- Internal References from ID table
  statusText = ids.status
  local btnSkill = ids.btnSkill
  local btnHide = ids.btnHide

  -- --- Interactivity ---

  local isMenuVisible = false

  local function toggle()
    if isMenuVisible then
      wm.removeView(menuView)
      wm.addView(iconView, lp)
    else
      wm.removeView(iconView)
      wm.addView(menuView, lp)
    end
    isMenuVisible = not isMenuVisible
  end

  iconView.onClick = toggle
  btnHide.onClick = toggle

  -- Dragging Logic for both Icon and Menu
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

  -- Feature Logic Binding
  btnSkill.onCheckedChange = function(v, isChecked)
    local logic = require("logic")
    logic.runRefreshSkill(isChecked, function(msg)
      statusText.setText("Status: " .. msg)
    end)
  end

  -- Initial Deployment: Floating Icon
  wm.addView(iconView, lp)
end

return ui
