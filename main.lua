-- Simple ELGG Mod Menu using ImGui
-- Required: ELGG version >= 1.2.5

loadImGui() -- Load ImGui library
ImGui.InitWindow()
ImGui.InitImGui()

-- Variables to store feature states
local speedHackActive = false
local wallhackActive = false

gg.toast("ELGG Mod Menu Loaded")

while true do
    ImGui.NewFrame()

    -- Set window position and size (Once)
    local viewport = ImGui.GetMainViewport()
    local vec2Pos = ImVec2(viewport.WorkPos.x + 100, viewport.WorkPos.y + 100)
    local vec2Size = ImVec2(400, 300)

    ImGui.SetNextWindowPos(vec2Pos, 1 << 2) -- ImGuiCond_FirstUseEver
    ImGui.SetNextWindowSize(vec2Size, 1 << 2)

    -- Begin the Mod Menu window
    if ImGui.Begin("ELGG Simple Mod Menu") then
        ImGui.Text("Welcome to ELGG!")
        ImGui.Text("Modern & Simple UI")
        ImGui.Separator()

        -- Feature: Speed Hack
        local oldSpeed = speedHackActive
        speedHackActive = ImGui.Checkbox("Speed Hack (2.0x)", speedHackActive)
        if speedHackActive ~= oldSpeed then
            if speedHackActive then
                gg.setSpeed(2.0)
                gg.toast("Speed Hack: ON")
            else
                gg.setSpeed(1.0)
                gg.toast("Speed Hack: OFF")
            end
        end

        -- Feature: Wallhack (Mock Logic)
        wallhackActive = ImGui.Checkbox("Wallhack (Mock)", wallhackActive)
        if ImGui.IsItemHovered() then
            ImGui.SetTooltip("This is a placeholder for Wallhack logic.")
        end

        ImGui.Spacing()
        ImGui.Separator()

        -- Exit Button
        if ImGui.Button("Exit Script", ImVec2(100, 40)) then
            gg.toast("Exiting ELGG Script...")
            os.exit()
        end

        ImGui.End()
    end

    ImGui.Render()
end
