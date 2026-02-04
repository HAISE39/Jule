local Luna = loadstring(game:HttpGet("https://paste.ee/r/WSCKThwW", true))()

local HttpService = game:GetService("HttpService")

local configFile = "VELLIXAOHaikyuuConfig.json"

local player = game.Players.LocalPlayer

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
                config[k] = v  -- Update config fields directly
            end
        end
    end
end

-- Save configuration function
local function saveConfig()
    local data = HttpService:JSONEncode(config)  -- Encode the config directly
    writefile(configFile, data)
end

-- Auto-load configuration on script start
loadConfig()


local Window = Luna:CreateWindow({
    Name = "VELLIXAO",
    Subtitle = nil,
    LogoID = "90804827107744",
    LoadingEnabled = true,
    LoadingTitle = "VELLIXAO",
    LoadingSubtitle = "by VELLIXAO",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "VELLIXAO"
    },
})

Window:CreateHomeTab({
    SupportedExecutors = {},
    DiscordInvite = "J37PW97j6a",
    Icon = 1,
})

local Tab = Window:CreateTab({
    Name = "Auto Farm",
    Icon = "agriculture",
    ImageSource = "Material",
    ShowTitle = true
})

local VirtualInputManager = game:GetService("VirtualInputManager")

local isRunning = false -- Tracks the toggle state

-- Functions
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

local function getCharacterData()
    local char = player.Character
    if char then
        return char:FindFirstChild("Humanoid"), char:FindFirstChild("HumanoidRootPart")
    end
    return nil, nil
end

local roundOverStats = player.PlayerGui.Interface.RoundOverStats
local boundaryFolder = workspace:WaitForChild("Map"):WaitForChild("BallNoCollide"):WaitForChild("Boundaries")


local function pressEscTwice()
    task.wait(5)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    task.wait(0.3)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Escape, false, game)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Escape, false, game)
    task.wait(0.7)
    print("Esc key pressed twice with different delays!")
end

local escPressed = false

local function checkRoundOverStats()
    while true do
        if roundOverStats.Visible then
            if not escPressed then
                pressEscTwice()
                escPressed = true
            end
        else
            escPressed = false
        end
        task.wait(0.5)
    end
end


-- Toggle for all functionality
Tab:CreateToggle({
    Name = "Auto Farm",
    Description = "Toggle Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        isRunning = Value
        print("All functionality is now " .. (Value and "enabled" or "disabled"))
    end
})

if not boundaryFolder then
    warn("Boundary folder not found! Check the path.")
end

local ballPrefix = "CLIENT_BALL_"

-- Function to find the ball
local function getBall()
    for _, object in pairs(workspace:GetChildren()) do
        if object:IsA("Model") and object.Name:match(ballPrefix) then
            return object:FindFirstChild("Sphere.001") or object:FindFirstChild("Cube.001")
        end
    end
    return nil
end

-- Start checking RoundOverStats visibility in parallel
task.spawn(checkRoundOverStats)

task.spawn(function()
    while task.wait(0.3) do
        if not isRunning then
            continue
        end

        local ballPart = getBall()
        local humanoid, humanoidRootPart = getCharacterData()

        if ballPart and humanoid and humanoidRootPart then
            humanoid:MoveTo(ballPart.Position)

            local distance = (ballPart.Position - humanoidRootPart.Position).Magnitude

            if distance <= 15 then
                local targetPart = getRandomTargetPart()
                if targetPart then
                    local lookVector = (targetPart.Position - humanoidRootPart.Position).Unit
                    humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + lookVector)
                end

                if ballPart.Position.Y > humanoidRootPart.Position.Y + 5 then
                    pressSpace()
                    pressClick()
                end
            end
        end
    end
end)

local enablejoin = false

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

player.CharacterAdded:Connect(function(character)
    if enablejoin then
        teamSelection()
    end
end)

Tab:CreateToggle({
    Name = "Auto Join Match",
    Description = "Automatically join a match after waiting for 30 seconds(to avoid getting bugged)",
    CurrentValue = false,
    Callback = function(Value)
        enablejoin = Value
        if enablejoin then
            teamSelection()
        end
    end
})

Tab:CreateSection("Misc")

local autoRotateConnection

local function autorotateon()
    autoRotateConnection = game:GetService("RunService").Heartbeat:Connect(function()
        local humanoid = getCharacterData()
        if humanoid and humanoid.AutoRotate == false then
            humanoid.AutoRotate = true
            print("AutoRotate has been re-enabled.")
        end
    end)
end

local function autorotateoff()
    if autoRotateConnection then
        autoRotateConnection:Disconnect()
        autoRotateConnection = nil
        print("AutoRotate monitoring has been disabled.")
    end
end

Tab:CreateToggle({
    Name = "Enable Rotate In The Air",
    Description = "Toggle Rotate In The Air(Re-Enable This When You Switch Team",
    CurrentValue = config.autoRotate,
    Callback = function(State)
        config.autoRotate = State
        saveConfig()
        print("Toggle Rotate is now " .. (State and "enabled" or "disabled"))

        if State then
            autorotateon()
        else
            autorotateoff()
        end
    end
})



Tab:CreateButton({
	Name = "Break The Match",
	Description = "Stops the match(must be serving)",
	Callback = function()
            local ohNil1 = nil
            local ohNumber2 = 0.95
            game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RF.Serve:InvokeServer(ohNil1, ohNumber2)
	end
})

local UserInputService = game:GetService("UserInputService")
local powerfulServe = config.powerfulServeEnabled

Tab:CreateToggle({
    Name = "Enable Powerful Serve",
    Description = "Press Z to Powerful Serve",
    CurrentValue = config.powerfulServeEnabled,
    Callback = function(State)
        powerfulServe = State
        config.powerfulServeEnabled = State
        saveConfig()
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.Z then
        if powerfulServe then
            game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.GameService.RF.Serve:InvokeServer(Vector3.new(0, 0, 0), math.huge)
        end
    end
end)

local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "autorenew",
    ImageSource = "Material",
    ShowTitle = true
})


MiscTab:CreateSection("Stat Changer")

MiscTab:CreateSlider({
    Name = "Dive Speed",
    Range = {0, 5},
    Increment = 0.1,
    CurrentValue = config.diveSpeed,
    Callback = function(value)
        player:SetAttribute("GameDiveSpeedMultiplier", value)
        print("Dive Speed updated to " .. value)
        config.diveSpeed = value
        saveConfig()
    end
})


MiscTab:CreateSlider({
    Name = "Spike Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.spikePower,
    Callback = function(value)
        player:SetAttribute("GameSpikePowerMultiplier", value)
        print("Spike Power updated to " .. value)
        config.spikePower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Tilt Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.tiltPower,
    Callback = function(value)
        player:SetAttribute("GameTiltPowerMultiplier", value)
        print("Tilt Power updated to " .. value)
        config.tiltPower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Speed",
    Range = {0, 1.5},
    Increment = 0.1,
    CurrentValue = config.speed,
    Callback = function(value)
        player:SetAttribute("GameSpeedMultiplier", value)
        print("Speed updated to " .. value)
        config.speed = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Set Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.setPower,
    Callback = function(value)
        player:SetAttribute("GameSetPowerMultiplier", value)
        print("Set Power updated to " .. value)
        config.setPower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Serve Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.servePower,
    Callback = function(value)
        player:SetAttribute("GameServePowerMultiplier", value)
        print("Serve Power updated to " .. value)
        config.servePower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Jump Power",
    Range = {0, 5},
    Increment = 0.1,
    CurrentValue = config.jumpPower,
    Callback = function(value)
        player:SetAttribute("GameJumpPowerMultiplier", value)
        print("Jump Power updated to " .. value)
        config.jumpPower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Bump Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.bumpPower,
    Callback = function(value)
        player:SetAttribute("GameBumpPowerMultiplier", value)
        print("Bump Power updated to " .. value)
        config.bumpPower = value
        saveConfig()
    end
})

MiscTab:CreateSlider({
    Name = "Block Power",
    Range = {0, 500},
    Increment = 0.1,
    CurrentValue = config.blockPower,
    Callback = function(value)
        player:SetAttribute("GameBlockPowerMultiplier", value)
        print("Block Power updated to " .. value)
        config.blockPower = value
        saveConfig()
    end
})

local Hitbox = Window:CreateTab({
    Name = "Hitboxes",
    Icon = "settings",
    ImageSource = "Material",
    ShowTitle = true
})

Hitbox:CreateSection("Hitbox Extender")

Hitbox:CreateSlider({
    Name = "Spike Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.spikeHitbox,
    Callback = function(value)
        local spikeHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Spike
        local part = spikeHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Spike Part size updated to " .. tostring(part.Size))
	    config.spikeHitbox = value
	    saveConfig()
        else
            warn("Part not found in Spike hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Jump Set Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.jumpsetHitbox,
    Callback = function(value)
        local jumpset = game:GetService("ReplicatedStorage").Assets.Hitboxes.JumpSet
        local part = jumpset:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Jump Set Part size updated to " .. tostring(part.Size))
	    config.jumpsetHitbox = value
	    saveConfig()
        else
            warn("Part not found in Jump Set hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Set Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.setHitbox,
    Callback = function(value)
        local setHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Set
        local part = setHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Set Part size updated to " .. tostring(part.Size))
	    config.setHitbox = value
	    saveConfig()
        else
            warn("Part not found in Set hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Serve Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.serveHitbox,
    Callback = function(value)
        local serveHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Serve
        local part = serveHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Serve Part size updated to " .. tostring(part.Size))
	    config.serveHitbox = value
	    saveConfig()
        else
            warn("Part not found in Serve hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Dive Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.diveHitbox,
    Callback = function(value)
        local diveHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Dive
        local part = diveHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Dive Part size updated to " .. tostring(part.Size))
	    config.diveHitbox = value
	    saveConfig()
        else
            warn("Part not found in Dive hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Bump Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.bumpHitbox,
    Callback = function(value)
        local bumpHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Bump
        local part = bumpHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Bump Part size updated to " .. tostring(part.Size))
	    config.bumpHitbox = value
	    saveConfig()
        else
            warn("Part not found in Bump hitbox!")
        end
    end
})

Hitbox:CreateSlider({
    Name = "Block Hitbox Size",
    Range = {1, 100},
    Increment = 0.1,
    CurrentValue = config.blockHitbox,
    Callback = function(value)
        local blockHitbox = game:GetService("ReplicatedStorage").Assets.Hitboxes.Block
        local part = blockHitbox:FindFirstChild("Part")

        if part and part:IsA("BasePart") then
            part.Size = Vector3.new(value, value, value)
            print("Block Part size updated to " .. tostring(part.Size))
	    config.blockHitbox = value
	    saveConfig()
	else
            warn("Part not found in Block hitbox!")
        end
    end
})

local Spin = Window:CreateTab({
    Name = "Auto Spin",
    Icon = "shopping_cart",
    ImageSource = "Material",
    ShowTitle = true
})

local autoSpin = false
local desiredStyles = {}

local function showNotification(styleName)
	Luna:Notification({
		Title = "Style Obtained!",
		Icon = "check_circle",
		ImageSource = "Material",
		Content = "You successfully obtained the style: " .. styleName,
	})
end

local function startAutoSpin()
	coroutine.wrap(function()
		while autoSpin do
			local currentStyle = player.PlayerGui.Interface.Lobby.Styles.TopPanel.DisplayName.Text
			if table.find(desiredStyles, currentStyle) then
				print("STOP! You got:", currentStyle)
				autoSpin = false
				showNotification(currentStyle)
				break
			else
				game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.StylesService.RF.Roll:InvokeServer(false)
				print("Spinning... Current result:", currentStyle)
				task.wait(0.5)
			end
		end
	end)()
end

Spin:CreateToggle({
	Name = "Auto Spin",
	Description = nil,
	CurrentValue = false,
	Callback = function(Value)
		autoSpin = Value
		if autoSpin then
			print("Auto Spin Enabled")
			startAutoSpin()
		else
			print("Auto Spin Disabled")
		end
	end
})

Spin:CreateDropdown({
	Name = "Select Desired Style",
	Description = "Choose your desired style",
	Options = {"Oikawa", "Bokuto", "Kageyama", "Sawamura", "Ushijima", "Kozume", "Kuroo", "Yamamoto", "Azumane", "Yaku", "Hinata"},
	CurrentOption = {"Hinata"},
	MultipleOptions = true,
	SpecialType = nil,
	Callback = function(Option)
		desiredStyles = Option
		print("Selected Styles:", table.concat(desiredStyles, ", "))
	end
})
