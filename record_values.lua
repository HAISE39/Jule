-- Record Values Script for Standard GameGuardian
-- Target: Capture Byte, Word, Float from search results and generate a sequence script.

local recorded_steps = {}

function mainMenu()
    while true do
        local menu = gg.choice({
            "Start Record",
            "List Record (" .. #recorded_steps .. ")",
            "Clear Records",
            "Exit"
        }, nil, "Value Recorder v1.1 (Standard GG)")

        if menu == 1 then
            startRecording()
        elseif menu == 2 then
            listRecords()
        elseif menu == 3 then
            recorded_steps = {}
            gg.toast("Records cleared")
        elseif menu == 4 or menu == nil then
            return
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
        if v.flags == gg.TYPE_BYTE and not step.byte then
            step.byte = v.value
        elseif v.flags == gg.TYPE_WORD and not step.word then
            step.word = v.value
        elseif v.flags == gg.TYPE_FLOAT and not step.float then
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
            -- Trailing comma for Byte as requested
            output = output .. string.format('gg.editAll("%s,", gg.TYPE_BYTE)\n', tostring(step.byte))
        end
        if step.word then
            output = output .. string.format('gg.editAll("%s", gg.TYPE_WORD)\n', tostring(step.word))
        end
        if step.float then
            output = output .. string.format('gg.editAll("%s", gg.TYPE_FLOAT)\n', tostring(step.float))
        end
    end

    local path = gg.EXT_STORAGE .. "/recorded_script.lua"
    local f = io.open(path, "w")
    if f then
        f:write(output)
        f:close()
        gg.alert("Script saved successfully to:\n" .. path)
    else
        gg.alert("Failed to save script to file. Copy the content below:\n\n" .. output)
    end
end

function startRecording()
    gg.setVisible(false)
    while true do
        if gg.isVisible() then
            local choice = gg.choice({
                "Add record (#" .. #recorded_steps .. ")",
                "Done and Save",
                "Back to Main Menu"
            }, nil, "Recording Mode\n(Script is hidden to let you interact with game)")

            if choice == 1 then
                captureStep()
                gg.setVisible(false)
            elseif choice == 2 then
                saveRecordedScript()
                break
            elseif choice == 3 or choice == nil then
                break
            end
        end
        gg.sleep(100)
    end
    gg.setVisible(true)
end

-- Entry point
if gg then
    mainMenu()
else
    print("This script must be run within GameGuardian")
end
