require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"

-- UI Layout
local layout = {
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  layout_height="fill",
  backgroundColor="#CC000000",
  padding="16dp",
  {
    TextView,
    text="VELLIXAO - AURCUS INJECTOR",
    textColor="#00FF00",
    textSize="18sp",
    gravity="center",
    layout_width="fill",
  },
  {
    TextView,
    id="statusText",
    text="Status: Ready",
    textColor="#FFFFFF",
    textSize="14sp",
    layout_marginTop="8dp",
  },
  {
    Button,
    id="btnInject",
    text="INJECT SWORD",
    layout_width="fill",
    layout_marginTop="16dp",
  },
  {
    Button,
    id="btnStartGame",
    text="START AURCUS ONLINE",
    layout_width="fill",
    layout_marginTop="8dp",
  },
  {
    Button,
    id="btnExit",
    text="EXIT MOD",
    layout_width="fill",
    layout_marginTop="16dp",
  },
}

local mainView = loadlayout(layout)

-- Function to set button background
local function setButtonStyle(btn, color)
  local gd = GradientDrawable()
  gd.setColor(color)
  gd.setCornerRadius(8)
  gd.setStroke(2, 0xFFFFFFFF)
  btn.setBackground(gd)
end

setButtonStyle(btnInject, 0xFF444444)
setButtonStyle(btnStartGame, 0xFF006600)
setButtonStyle(btnExit, 0xFF660000)

-- Floating Window Setup
local wm = activity.getSystemService(Context.WINDOW_SERVICE)
local lp = WindowManager.LayoutParams()
lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
lp.format = 1
lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
lp.width = 600
lp.height = 800
lp.gravity = Gravity.LEFT | Gravity.TOP

wm.addView(mainView, lp)

-- Dragging logic
local startX, startY, initialX, initialY
mainView.onTouch = function(v, e)
  if e.getAction() == MotionEvent.ACTION_DOWN then
    startX = e.getRawX()
    startY = e.getRawY()
    initialX = lp.x
    initialY = lp.y
  elseif e.getAction() == MotionEvent.ACTION_MOVE then
    lp.x = initialX + (e.getRawX() - startX)
    lp.y = initialY + (e.getRawY() - startY)
    wm.updateViewLayout(mainView, lp)
  end
  return true
end

-- Inject Logic
local function runInjectSword()
  thread(function()
    local memory = require("memory")
    call(function() statusText.setText("Status: Searching Pattern...") end)

    -- Search Group pattern 3;30;1;2;1
    local success = memory.search("3;30;1;2;1", "Dword")
    local count = memory.getResultsCount()

    if success then
      call(function() statusText.setText("Status: Found " .. count .. " results. Writing...") end)

      -- Write 99999 to offsets 24, 28, 32, 36
      memory.write("99999", 24, "Dword")
      memory.write("99999", 28, "Dword")
      memory.write("99999", 32, "Dword")
      memory.write("99999", 36, "Dword")

      call(function()
        statusText.setText("Status: Injection Successful (" .. count .. " modified)")
        Toast.makeText(activity, "Sword Injected Successfully!", Toast.LENGTH_SHORT).show()
      end)
    else
      call(function()
        statusText.setText("Status: Pattern Not Found!")
        Toast.makeText(activity, "Failed to find pattern in dalvik-main", Toast.LENGTH_LONG).show()
      end)
    end
  end)
end

btnInject.onClick = runInjectSword

btnStartGame.onClick = function()
  local intent = activity.getPackageManager().getLaunchIntentForPackage("com.asobimo.aurcusonline.wx")
  if intent then
    activity.startActivity(intent)
    statusText.setText("Status: Game Started")
  else
    Toast.makeText(activity, "Game not found!", Toast.LENGTH_SHORT).show()
  end
end

btnExit.onClick = function()
  wm.removeView(mainView)
  activity.finish()
end
