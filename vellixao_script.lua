local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/master/source.lua", true))()

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local configFile = "VELLIXAOHaikyuuConfig.json"

local config = {
    spikePower = 1,
    diveSpeed = 1,
    blockPower = 1,
    bumpPower = 1,
    servePower = 1,
    jumpPower = 1,
    speed = 1,
    setPower = 1,
    powerfulServeEnabled = false,
    spikeHitbox = 10,
    bumpHitbox = 10,
    diveHitbox = 10,
    setHitbox = 10,
    serveHitbox = 10,
    blockHitbox = 10,
    tiltPower = 1,
    jumpsetHitbox = 10,
    autoRotate = false
}

-- Load configuration function
local function loadConfig()
    if isfile(configFile) then
        local data = readfile(configFile)
        local success, result = pcall(function()
            return HttpService:JSONDecode(data)
        end)
        if success then
            for k, v in pairs(result) do
                config[k] = v
            end
        end
    end
end

-- Save configuration function
local function saveConfig()
    local data = HttpService:JSONEncode(config)
    writefile(configFile, data)
end

loadConfig()

local Window = Luna:CreateWindow({
    Name = "VELLIXAO",
    Subtitle = "Volleyball Legends",
    LogoID = "90804827107744",
    LoadingEnabled = true,
    LoadingTitle = "VELLIXAO",
    LoadingSubtitle = "by VELLIXAO",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "VELLIXAO"
    },
    KeySystem = false -- Can be enabled if needed
})

Window:CreateHomeTab({
    SupportedExecutors = {
        "Synapse X", "Krnl", "Fluxus", "Script-Ware", "Electron", "Wave", "Delta", "CODex"
    },
    DiscordInvite = "J37PW97j6a",
    Icon = 1
})

-- Logic Helpers
local VirtualInputManager = game:GetService("VirtualInputManager")
local isRunning = false
local enablejoin = false
local powerfulServe = config.powerfulServeEnabled

local function getCharacterData()
    local char = player.Character
    if char then
        return char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    end
    return nil, nil
end

local function pressSpace()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function pressClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

local function getRandomTargetPart()
    local positionsFolder = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("BallNoCollide")
        and workspace.Map.BallNoCollide:FindFirstChild("Positions")
        and workspace.Map.BallNoCollide.Positions:FindFirstChild("2")

    if not positionsFolder then return nil end

    local parts = {}
    for _, part in ipairs(positionsFolder:GetChildren()) do
        if part:IsA("BasePart") then
            table.insert(parts, part)
        end
    end
    if #parts > 0 then
        return parts[math.random(1, #parts)]
    end
    return nil
end

local function getBall()
    for _, object in pairs(workspace:GetChildren()) do
        if object:IsA("Model") and object.Name:match("CLIENT_BALL_") then
            return object:FindFirstChild("Sphere.001") or object:FindFirstChild("Cube.001")
        end
    end
    return nil
end

local function teamSelection()
    if not enablejoin then return end
    task.wait(10)
    local teamSelectionGui = player.PlayerGui.Interface.TeamSelection
    local gameInterface = player.PlayerGui.Interface.Game
    if not gameInterface.Visible then
        teamSelectionGui.Visible = true
    end
    while not gameInterface.Visible and enablejoin do
        local randomNum = math.random(1, 6)
        local button = teamSelectionGui["2"][tostring(randomNum)]
        if button and button:IsA("ImageButton") then
            local absPos = button.AbsolutePosition
            local absSize = button.AbsoluteSize
            local clickPosition = absPos + (absSize / 2)
            VirtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(clickPosition.X, clickPosition.Y, 0, false, game, 1)
        end
        task.wait(math.random(5, 15) / 10)
    end
    if gameInterface.Visible then
        teamSelectionGui.Visible = false
    end
end

-- Tabs
local AutoFarmTab = Window:CreateTab({
    Name = "Auto Farm",
    Icon = "agriculture",
    ImageSource = "Material",
    ShowTitle = true
})

AutoFarmTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Automatically move to ball and hit it",
    CurrentValue = false,
    Callback = function(Value)
        isRunning = Value
    end
})

AutoFarmTab:CreateToggle({
    Name = "Auto Join Match",
    Description = "Automatically join a match team",
    CurrentValue = false,
    Callback = function(Value)
        enablejoin = Value
        if enablejoin then teamSelection() end
    end
})

local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "extension",
    ImageSource = "Material",
    ShowTitle = true
})

local autoRotateConnection
MiscTab:CreateToggle({
    Name = "Enable Rotate In The Air",
    Description = "Keeps AutoRotate enabled",
    CurrentValue = config.autoRotate,
    Callback = function(State)
        config.autoRotate = State
        saveConfig()
        if autoRotateConnection then autoRotateConnection:Disconnect() end
        if State then
            autoRotateConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local humanoid = getCharacterData()
                if humanoid and humanoid.AutoRotate == false then
                    humanoid.AutoRotate = true
                end
            end)
        end
    end
})

MiscTab:CreateButton({
    Name = "Break The Match",
    Description = "Stops the match (must be serving)",
    Callback = function()
        game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RF.Serve:InvokeServer(nil, 0.95)
    end
})

MiscTab:CreateToggle({
    Name = "Enable Powerful Serve",
    Description = "Press Z to Powerful Serve",
    CurrentValue = config.powerfulServeEnabled,
    Callback = function(State)
        powerfulServe = State
        config.powerfulServeEnabled = State
        saveConfig()
    end
})

local StatTab = Window:CreateTab({
    Name = "Stat Changer",
    Icon = "bolt",
    ImageSource = "Material",
    ShowTitle = true
})

local stats = {
    {Name = "Dive Speed", Attr = "GameDiveSpeedMultiplier", Conf = "diveSpeed", Max = 5},
    {Name = "Spike Power", Attr = "GameSpikePowerMultiplier", Conf = "spikePower", Max = 500},
    {Name = "Tilt Power", Attr = "GameTiltPowerMultiplier", Conf = "tiltPower", Max = 500},
    {Name = "Speed", Attr = "GameSpeedMultiplier", Conf = "speed", Max = 1.5},
    {Name = "Set Power", Attr = "GameSetPowerMultiplier", Conf = "setPower", Max = 500},
    {Name = "Serve Power", Attr = "GameServePowerMultiplier", Conf = "servePower", Max = 500},
    {Name = "Jump Power", Attr = "GameJumpPowerMultiplier", Conf = "jumpPower", Max = 5},
    {Name = "Bump Power", Attr = "GameBumpPowerMultiplier", Conf = "bumpPower", Max = 500},
    {Name = "Block Power", Attr = "GameBlockPowerMultiplier", Conf = "blockPower", Max = 500}
}

for _, stat in ipairs(stats) do
    StatTab:CreateSlider({
        Name = stat.Name,
        Range = {0, stat.Max},
        Increment = 0.1,
        CurrentValue = config[stat.Conf],
        Callback = function(Value)
            player:SetAttribute(stat.Attr, Value)
            config[stat.Conf] = Value
            saveConfig()
        end
    })
end

local HitboxTab = Window:CreateTab({
    Name = "Hitboxes",
    Icon = "fullscreen",
    ImageSource = "Material",
    ShowTitle = true
})

local hitboxes = {
    {Name = "Spike Hitbox Size", Path = "Spike", Conf = "spikeHitbox"},
    {Name = "Jump Set Hitbox Size", Path = "JumpSet", Conf = "jumpsetHitbox"},
    {Name = "Set Hitbox Size", Path = "Set", Conf = "setHitbox"},
    {Name = "Serve Hitbox Size", Path = "Serve", Conf = "serveHitbox"},
    {Name = "Dive Hitbox Size", Path = "Dive", Conf = "diveHitbox"},
    {Name = "Bump Hitbox Size", Path = "Bump", Conf = "bumpHitbox"},
    {Name = "Block Hitbox Size", Path = "Block", Conf = "blockHitbox"}
}

for _, hb in ipairs(hitboxes) do
    HitboxTab:CreateSlider({
        Name = hb.Name,
        Range = {1, 100},
        Increment = 0.1,
        CurrentValue = config[hb.Conf],
        Callback = function(Value)
            local asset = game:GetService("ReplicatedStorage").Assets.Hitboxes:FindFirstChild(hb.Path)
            local part = asset and asset:FindFirstChild("Part")
            if part and part:IsA("BasePart") then
                part.Size = Vector3.new(Value, Value, Value)
                config[hb.Conf] = Value
                saveConfig()
            end
        end
    })
end

local SpinTab = Window:CreateTab({
    Name = "Auto Spin",
    Icon = "cached",
    ImageSource = "Material",
    ShowTitle = true
})

local autoSpin = false
local desiredStyles = {"Hinata"}

local function startAutoSpin()
    coroutine.wrap(function()
        while autoSpin do
            local currentStyle = player.PlayerGui.Interface.Lobby.Styles.TopPanel.DisplayName.Text
            if table.find(desiredStyles, currentStyle) then
                autoSpin = false
                Luna:Notification({
                    Title = "Style Obtained!",
                    Icon = "check_circle",
                    Content = "You obtained: " .. currentStyle
                })
                break
            else
                game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.StylesService.RF.Roll:InvokeServer(false)
                task.wait(0.5)
            end
        end
    end)()
end

SpinTab:CreateToggle({
    Name = "Auto Spin",
    CurrentValue = false,
    Callback = function(Value)
        autoSpin = Value
        if autoSpin then startAutoSpin() end
    end
})

SpinTab:CreateDropdown({
    Name = "Select Desired Style",
    Options = {"Oikawa", "Bokuto", "Kageyama", "Sawamura", "Ushijima", "Kozume", "Kuroo", "Yamamoto", "Azumane", "Yaku", "Hinata"},
    CurrentOption = {"Hinata"},
    MultipleOptions = true,
    Callback = function(Options)
        desiredStyles = Options
    end
})

local ThemeTab = Window:CreateTab({
    Name = "Theme",
    Icon = "palette",
    ImageSource = "Material",
    ShowTitle = true
})
ThemeTab:BuildThemeSection()

local ConfigTab = Window:CreateTab({
    Name = "Config",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})
ConfigTab:BuildConfigSection()

-- Global Loops
task.spawn(function()
    local roundOverStats = player.PlayerGui.Interface.RoundOverStats
    local escPressed = false
    while true do
        if roundOverStats.Visible then
            if not escPressed then
                task.wait(5)
                for i=1,2 do
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
                    task.wait(i == 1 and 0.3 or 0.7)
                end
                escPressed = true
            end
        else
            escPressed = false
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if not isRunning then continue end
        local ballPart = getBall()
        local humanoid, humanoidRootPart = getCharacterData()
        if ballPart and humanoid and humanoidRootPart then
            humanoid:MoveTo(ballPart.Position)
            if (ballPart.Position - humanoidRootPart.Position).Magnitude <= 15 then
                local target = getRandomTargetPart()
                if target then
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, Vector3.new(target.Position.X, humanoidRootPart.Position.Y, target.Position.Z))
                end
                if ballPart.Position.Y > humanoidRootPart.Position.Y + 5 then
                    pressSpace()
                    pressClick()
                end
            end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Z and powerfulServe then
        game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RF.Serve:InvokeServer(Vector3.new(0, 0, 0), math.huge)
    end
end)

player.CharacterAdded:Connect(function()
    if enablejoin then teamSelection() end
end)
