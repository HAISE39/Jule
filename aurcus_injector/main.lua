require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.*"
import "android.content.*"

-- UI Layout (Restored to Turn 5 Style)
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

-- Inject Logic (Refinement Search)
local function runInjectSword()
  thread(function()
    local memory = require("memory")
    call(function() statusText.setText("Status: Searching 80.0...") end)

    -- 1. Search 80.0 (Float)
    if not memory.search("80.0", "Float") then
      call(function() statusText.setText("Status: 80.0 Not Found!") end)
      return
    end

    local count = memory.getResultsCount()
    call(function() statusText.setText("Status: Found " .. count .. ". Refining (72.0)...") end)

    -- 2. Verify 72.0 at offset 192
    if not memory.offset("72.0", 192, "Float") then
      call(function() statusText.setText("Status: 72.0 Offset Fail!") end)
      return
    end

    -- 3. Verify 2.0 at offset 196
    if not memory.offset("2.0", 196, "Float") then
      call(function() statusText.setText("Status: 2.0 Offset Fail!") end)
      return
    end

    count = memory.getResultsCount()
    call(function() statusText.setText("Status: Found " .. count .. ". Writing...") end)

    -- 4. Write 100000.0 at offsets 0 and 192
    memory.write("100000.0", 0, "Float")
    memory.write("100000.0", 192, "Float")

    call(function()
      statusText.setText("Status: Injected Successfully!")
      Toast.makeText(activity, "Sword Injected!", Toast.LENGTH_SHORT).show()
    end)
  end)
end

-- Menu Setup
local menuItems = {"START AURCUS ONLINE", "INJECT SWORD", "EXIT MOD"}
local adapter = ArrayAdapter(activity, android.R.layout.simple_list_item_1, menuItems)
menuList.setAdapter(adapter)

-- ListView Background handling (ensure text is visible)
menuList.onItemClick = function(l, v, p, i)
  local cmd = menuItems[p+1]
  if cmd == "INJECT SWORD" then
    runInjectSword()
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
