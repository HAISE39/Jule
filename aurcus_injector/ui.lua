local ui = {}

require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"

local wm, lp, iconView, menuView
local statusText

-- Helper: Rounded Background
local function getBackground(color, radius)
  local gd = GradientDrawable()
  gd.setColor(color)
  gd.setCornerRadius(radius)
  gd.setStroke(2, 0xFF00FF00) -- Green border
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

  -- 1. Floating Icon
  local iconLayout = {
    LinearLayout,
    layout_width="50dp",
    layout_height="50dp",
    gravity="center",
    {
      TextView,
      text="V",
      textColor="#00FF00",
      textSize="24sp",
      textStyle="bold",
    }
  }
  iconView = loadlayout(iconLayout)
  iconView.setBackground(getBackground(0xCC000000, 25))

  -- 2. Mod Menu
  local menuLayout = {
    LinearLayout,
    orientation="vertical",
    layout_width="280dp",
    layout_height="wrap_content",
    padding="16dp",
    {
      TextView,
      text="VELLIXAO - AURCUS",
      textColor="#00FF00",
      textSize="18sp",
      textStyle="bold",
      gravity="center",
      layout_width="fill",
    },
    {
      TextView,
      id="status",
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
        id="btnSkill",
      }
    },
    {
      Button,
      id="btnHide",
      text="HIDE MENU",
      textColor="#FFFFFF",
      layout_marginTop="20dp",
      layout_width="fill",
    },
  }
  menuView = loadlayout(menuLayout)
  menuView.setBackground(getBackground(0xEE111111, 40))

  -- Internal Refs
  statusText = menuView.findViewById("status")
  local btnSkill = menuView.findViewById("btnSkill")
  local btnHide = menuView.findViewById("btnHide")

  -- --- Actions ---

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

  -- Dragging
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

  -- Hack Implementation
  btnSkill.onCheckedChange = function(v, isChecked)
    local logic = require("logic")
    logic.runRefreshSkill(isChecked, function(msg)
      statusText.setText("Status: " .. msg)
    end)
  end

  -- Start with Icon
  wm.addView(iconView, lp)
end

return ui
