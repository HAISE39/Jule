-- Record Values Script for ELGG
-- Target: Capture Byte, Word, Float from search results and generate a sequence script.

local recorded_steps = {}
local is_recording = false

function mainMenu()
    while true do
        local menu = gg.choice({
            "Start Record",
            "List Record (" .. #recorded_steps .. ")",
            "Clear Records",
            "Exit"
        }, nil, "Value Recorder v1.0")

        if menu == 1 then
            startRecording()
        elseif menu == 2 then
            listRecords()
        elseif menu == 3 then
            recorded_steps = {}
            gg.toast("Records cleared")
        elseif menu == 4 or menu == nil then
            os.exit()
        end
    end
end

function listRecords()
    if #recorded_steps == 0 then
        gg.alert("No records yet.")
        return
    end

    local list = ""
    for i, step in ipairs(recorded_steps) do
        list = list .. string.format("[%d] B:%s, W:%s, F:%s\n", i, tostring(step.byte), tostring(step.word), tostring(step.float))
    end
    gg.alert(list)
end

function captureStep()
    local count = gg.getResultCount()
    if count == 0 then
        gg.toast("Error: Search results are empty!")
        return false
    end

    local results = gg.getResults(count)
    local values = gg.getValues(results)

    local step = {byte = nil, word = nil, float = nil}
    for _, v in ipairs(values) do
        if v.type == gg.TYPE_BYTE and not step.byte then
            step.byte = v.value
        elseif v.type == gg.TYPE_WORD and not step.word then
            step.word = v.value
        elseif v.type == gg.TYPE_FLOAT and not step.float then
            step.float = v.value
        end
    end

    if step.byte or step.word or step.float then
        table.insert(recorded_steps, step)
        gg.toast("Record #" .. #recorded_steps .. " added.")
        return true
    else
        gg.toast("No Byte, Word, or Float found in results.")
        return false
    end
end

function saveRecordedScript()
    if #recorded_steps == 0 then
        gg.alert("Nothing to save.")
        return
    end

    local output = "-- Generated Value Recorder Script\n\n"
    for _, step in ipairs(recorded_steps) do
        output = output .. "gg.sleep(100)\n"
        if step.byte then
            -- Note the user wants a trailing comma for Byte as per example: gg.editAll("96,", gg.TYPE_BYTE)
            output = output .. string.format('gg.editAll("%s,", gg.TYPE_BYTE)\n', tostring(step.byte))
        end
        if step.word then
            output = output .. string.format('gg.editAll("%s", gg.TYPE_WORD)\n', tostring(step.word))
        end
        if step.float then
            output = output .. string.format('gg.editAll("%s", gg.TYPE_FLOAT)\n', tostring(step.float))
        end
    end

    local path = "/sdcard/recorded_script.lua"
    local f = io.open(path, "w")
    if f then
        f:write(output)
        f:close()
        gg.alert("Script saved successfully to:\n" .. path)
    else
        -- Fallback to internal storage path if /sdcard/ fails
        path = gg.EXT_STORAGE .. "/recorded_script.lua"
        f = io.open(path, "w")
        if f then
            f:write(output)
            f:close()
            gg.alert("Script saved successfully to:\n" .. path)
        else
            gg.alert("Failed to save script to file. Copy the content below:\n\n" .. output)
        end
    end
end

-- Placeholder for startRecording
function startRecording()
    if not luajava then
        gg.alert("Floating UI requires ELGG/AndLua+ environment.")
        -- Fallback to basic GG menu
        while true do
            local choice = gg.choice({"[ADD] Record Current Values", "[DONE] Save and Exit Recording", "Cancel"}, nil, "Recording Mode")
            if choice == 1 then
                captureStep()
            elseif choice == 2 then
                saveRecordedScript()
                break
            else
                break
            end
        end
        return
    end

    gg.setVisible(false)

    -- Load Android classes
    local WindowManager = luajava.bindClass("android.view.WindowManager")
    local LayoutParams = luajava.bindClass("android.view.WindowManager$LayoutParams")
    local Gravity = luajava.bindClass("android.view.Gravity")
    local PixelFormat = luajava.bindClass("android.graphics.PixelFormat")
    local Button = luajava.bindClass("android.widget.Button")
    local LinearLayout = luajava.bindClass("android.widget.LinearLayout")
    local Color = luajava.bindClass("android.graphics.Color")
    local MotionEvent = luajava.bindClass("android.view.MotionEvent")
    local Context = luajava.bindClass("android.content.Context")

    local wm = activity.getSystemService(Context.WINDOW_SERVICE)
    local display = wm.getDefaultDisplay()

    local layout = luajava.newInstance("android.widget.LinearLayout", activity)
    layout.setOrientation(LinearLayout.VERTICAL)
    layout.setBackgroundColor(Color.parseColor("#CC000000"))
    layout.setPadding(10, 10, 10, 10)

    local btnAdd = luajava.newInstance("android.widget.Button", activity)
    btnAdd.setText("ADD (" .. #recorded_steps .. ")")
    btnAdd.setBackgroundColor(Color.parseColor("#FFBB86FC"))

    local btnDone = luajava.newInstance("android.widget.Button", activity)
    btnDone.setText("DONE")
    btnDone.setBackgroundColor(Color.parseColor("#FF03DAC6"))

    local btnBack = luajava.newInstance("android.widget.Button", activity)
    btnBack.setText("BACK")

    layout.addView(btnAdd)
    layout.addView(btnDone)
    layout.addView(btnBack)

    local lp = luajava.newInstance("android.view.WindowManager$LayoutParams")
    lp.width = WindowManager.LayoutParams.WRAP_CONTENT
    lp.height = WindowManager.LayoutParams.WRAP_CONTENT
    lp.type = WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
    lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
    lp.format = PixelFormat.TRANSLUCENT
    lp.gravity = Gravity.LEFT | Gravity.TOP
    lp.x = 100
    lp.y = 100

    -- Draggable logic
    local startX, startY, initialX, initialY
    layout.setOnTouchListener(luajava.createProxy("android.view.View$OnTouchListener", {
        onTouch = function(v, event)
            local action = event.getAction()
            if action == MotionEvent.ACTION_DOWN then
                startX = event.getRawX()
                startY = event.getRawY()
                initialX = lp.x
                initialY = lp.y
                return true
            elseif action == MotionEvent.ACTION_MOVE then
                lp.x = initialX + (event.getRawX() - startX)
                lp.y = initialY + (event.getRawY() - startY)
                wm.updateViewLayout(layout, lp)
                return true
            end
            return false
        end
    }))

    btnAdd.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            if captureStep() then
                btnAdd.setText("ADD (" .. #recorded_steps .. ")")
            end
        end
    }))

    btnDone.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            saveRecordedScript()
            wm.removeView(layout)
            gg.setVisible(true)
        end
    }))

    btnBack.setOnClickListener(luajava.createProxy("android.view.View$OnClickListener", {
        onClick = function(v)
            wm.removeView(layout)
            gg.setVisible(true)
        end
    }))

    wm.addView(layout, lp)
    gg.toast("Floating controls active. Click ADD to record values.")
end

-- Entry point
if gg then
    mainMenu()
else
    print("This script must be run within GameGuardian/ELGG")
end
