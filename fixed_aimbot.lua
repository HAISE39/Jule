local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local fovRadius = 300

-- Notifikasi function
local function notif(title, teks, durasi)
    durasi = durasi or 2
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Notif"
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Name = "NotifFrame"
    frame.Size = UDim2.new(0, 250, 0, 60)
    frame.Position = UDim2.new(0.5, -125, 0, -80)
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = frame

    local uistroke = Instance.new("UIStroke")
    uistroke.Color = Color3.fromRGB(255, 255, 0)
    uistroke.Thickness = 1.5
    uistroke.Parent = frame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.Parent = frame

    local teksLabel = Instance.new("TextLabel")
    teksLabel.Name = "Teks"
    teksLabel.Size = UDim2.new(1, -20, 0, 20)
    teksLabel.Position = UDim2.new(0, 10, 0, 30)
    teksLabel.BackgroundTransparency = 1
    teksLabel.Text = teks
    teksLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    teksLabel.TextXAlignment = Enum.TextXAlignment.Left
    teksLabel.Font = Enum.Font.Gotham
    teksLabel.TextSize = 13
    teksLabel.TextWrapped = true
    teksLabel.Parent = frame

    frame.Position = UDim2.new(0.5, -125, 0, -80)
    local tweenIn = tweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -125, 0, 20)})
    tweenIn:Play()

    task.delay(durasi, function()
        local tweenOut = tweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -125, 0, -80)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
end

-- FOV Circle
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotFOV"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVCircle"
fovFrame.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.BackgroundTransparency = 1
fovFrame.BorderSizePixel = 0
fovFrame.Parent = screenGui

local fovUIStroke = Instance.new("UIStroke")
fovUIStroke.Name = "FOVStroke"
fovUIStroke.Color = Color3.fromRGB(255, 255, 0)
fovUIStroke.Thickness = 2
fovUIStroke.LineJoinMode = Enum.LineJoinMode.Round
fovUIStroke.Parent = fovFrame

local fovUICorner = Instance.new("UICorner")
fovUICorner.CornerRadius = UDim.new(1, 0)
fovUICorner.Parent = fovFrame

-- Ambil modul
local globalStuff
local gameUIMod
local gunModule

pcall(function()
    globalStuff = require(game:GetService("ReplicatedStorage").Modules.GlobalStuff)
end)

pcall(function()
    gameUIMod = require(localPlayer.PlayerGui.GameUI.GameUIMod)
end)

pcall(function()
    gunModule = require(localPlayer.PlayerGui.ControllerGUI.NewMainLocal.Tools.Tool.Gun)
end)

-- Visibility Check
local function isPointVisible(point, character)
    local origin = camera.CFrame.Position
    local direction = point - origin
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {localPlayer.Character, camera}

    local result = workspace:Raycast(origin, direction, raycastParams)

    if result then
        local hitInstance = result.Instance
        if hitInstance:IsDescendantOf(character) or hitInstance == character then
            return true
        end
    else
        return true -- No obstruction
    end
    return false
end

-- Hitbox diperbesar - scan banyak titik di sekitar kepala
local function getHeadHitbox(character)
    local head = character:FindFirstChild("Head")
    if not head then return nil end

    -- Hitbox points
    local points = {
        head.Position,                                          -- Tengah kepala
        head.Position + Vector3.new(0, 0.8, 0),                -- Atas kepala
        head.Position + Vector3.new(0, -0.5, 0),               -- Bawah kepala (leher)
        head.Position + Vector3.new(0.6, 0.2, 0),              -- Samping kanan
        head.Position + Vector3.new(-0.6, 0.2, 0),             -- Samping kiri
    }

    local bestPoint = nil
    local bestDist = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    for _, point in ipairs(points) do
        local screenPos, onScreen = camera:WorldToScreenPoint(point)
        if onScreen then
            if isPointVisible(point, character) then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    bestPoint = point
                end
            end
        end
    end

    return bestPoint
end

-- Ambil target terdekat (hanya musuh)
local function getClosestTarget()
    local closestTarget, shortestDist = nil, fovRadius
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    local mobsFolder = workspace:FindFirstChild("Mobs")
    if not mobsFolder then return nil end

    for _, mob in ipairs(mobsFolder:GetChildren()) do
        -- Skip tim
        local sameTeam = false
        if globalStuff and globalStuff.SameTeam then
            if globalStuff:SameTeam(localPlayer, mob) then
                sameTeam = true
            end
        end

        if not sameTeam then
            local humanoid = mob:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPoint = getHeadHitbox(mob)
                if targetPoint then
                    local screenPos, onScreen = camera:WorldToScreenPoint(targetPoint)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = mob
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Hook GameUI
if gameUIMod then
    local originalGetMousePos = gameUIMod.GetMousePos
    gameUIMod.GetMousePos = function(self, ...)
        local target = getClosestTarget()
        if target then
            local point = getHeadHitbox(target)
            if point then
                return point
            end
        end
        return originalGetMousePos(self, ...)
    end
end

-- Hook Gun
if gunModule then
    if gunModule.ConeOfFire then
        local originalConeOfFire = gunModule.ConeOfFire
        gunModule.ConeOfFire = function(self, origin, mousePos, spread)
            local target = getClosestTarget()
            if target then
                local point = getHeadHitbox(target)
                if point then
                    local direction = (point - origin).Unit
                    return direction
                end
            end
            return originalConeOfFire(self, origin, mousePos, spread)
        end
    end

    if gunModule.GetTotalSpread then
        local originalGetTotalSpread = gunModule.GetTotalSpread
        gunModule.GetTotalSpread = function(self)
            if getClosestTarget() then
                return 0
            end
            return originalGetTotalSpread(self)
        end
    end

    if gunModule.Fire then
        local originalFire = gunModule.Fire
        gunModule.Fire = function(self, ...)
            local args = {...}
            local target = getClosestTarget()
            if target then
                local point = getHeadHitbox(target)
                if point and #args >= 1 then
                    local origin = args[1]
                    local direction = (point - origin).Unit
                    args[2] = direction
                    return originalFire(self, table.unpack(args))
                end
            end
            return originalFire(self, table.unpack(args))
        end
    end
end

-- Notifikasi sukses
notif("✅ Aimbot Improved", "Wall Check Aktif • No Spread • Fixed Damage", 3)
