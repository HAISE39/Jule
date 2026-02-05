require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"

-- UI Layout (Gaya Feb 5 23:31)
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
    ListView,
    id="menuList",
    layout_width="fill",
    layout_height="fill",
    layout_marginTop="16dp",
  },
}

local mainView = loadlayout(layout)

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

-- Inject Logic v1 (Original Pattern)
local function runInjectV1()
  thread(function()
    local memory = require("memory")
    call(function() statusText.setText("Status: V1 Searching...") end)
    local results = memory.search("3;30;1;2;1", "Dword")
    if #results == 0 then
      call(function() statusText.setText("Status: V1 Not Found") end)
      return
    end
    memory.writeBatch(results, "99999", 24, "Dword")
    memory.writeBatch(results, "99999", 28, "Dword")
    memory.writeBatch(results, "99999", 32, "Dword")
    memory.writeBatch(results, "99999", 36, "Dword")
    call(function() statusText.setText("Status: V1 Success ("..#results..")") end)
  end)
end

-- Inject Logic v2 (Float Refinement)
local function runInjectV2()
  thread(function()
    local memory = require("memory")
    call(function() statusText.setText("Status: V2 Searching...") end)
    local results = memory.search("80.0", "Float")
    if #results == 0 then
      call(function() statusText.setText("Status: V2 80.0 Not Found") end)
      return
    end
    results = memory.refine(results, "72.0", 192, "Float")
    results = memory.refine(results, "2.0", 196, "Float")
    if #results == 0 then
      call(function() statusText.setText("Status: V2 Verify Fail") end)
      return
    end
    memory.writeBatch(results, "100000.0", 0, "Float")
    memory.writeBatch(results, "100000.0", 192, "Float")
    call(function() statusText.setText("Status: V2 Success ("..#results..")") end)
  end)
end

-- Menu Items
local menuItems = {"START AURCUS ONLINE", "INJECT SWORD (v1 - Pattern)", "INJECT SWORD (v2 - Float)", "EXIT MOD"}
local adapter = ArrayAdapter(activity, android.R.layout.simple_list_item_1, menuItems)
menuList.setAdapter(adapter)

menuList.onItemClick = function(l, v, p, i)
  local cmd = menuItems[p+1]
  if cmd == "INJECT SWORD (v1 - Pattern)" then
    runInjectV1()
  elseif cmd == "INJECT SWORD (v2 - Float)" then
    runInjectV2()
  elseif cmd == "START AURCUS ONLINE" then
    local intent = activity.getPackageManager().getLaunchIntentForPackage("com.asobimo.aurcusonline.wx")
    if intent then
      activity.startActivity(intent)
      statusText.setText("Status: Game Started")
    else
      Toast.makeText(activity, "Game not found!", Toast.LENGTH_SHORT).show()
    end
  elseif cmd == "EXIT MOD" then
    wm.removeView(mainView)
    activity.finish()
  end
end
