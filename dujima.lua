-- Universal Orion GUI script
-- Features: Player (WalkSpeed/Jump), Movement (Fly, Noclip), Visuals (ESP), Utilities (Teleport, Reset HRP)
-- Notes: Requires an executor that supports loadstring and game:HttpGet.
-- Warning: Some games have anti-cheat. Use responsibly.

-- ====== CONFIG / SAFE GUARDS ======
local OrionURL = "https://raw.githubusercontent.com/shlexware/Orion/main/source" -- Orion loader
local MIN_WALKSPEED, MAX_WALKSPEED = 16, 500
local MIN_JUMPPOWER, MAX_JUMPPOWER = 50, 500

-- ====== LOAD ORION ======
local success, Orion = pcall(function()
    return loadstring(game:HttpGet(OrionURL))()
end)
if not success or typeof(Orion) ~= "table" then
    warn("Failed to load Orion UI library. Check your executor or the URL.")
    return
end

-- ====== UTILITIES ======
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getHumanoid()
    local char = getCharacter()
    return char:FindFirstChildOfClass("Humanoid")
end

local function getRootPart()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

local function safeSetWalkSpeed(speed)
    local hum = getHumanoid()
    if hum and typeof(speed) == "number" then
        pcall(function() hum.WalkSpeed = speed end)
    end
end

local function safeSetJumpPower(power)
    local hum = getHumanoid()
    if hum and typeof(power) == "number" then
        pcall(function() hum.JumpPower = power end)
    end
end

-- ====== CREATE WINDOW ======
local Window = Orion:MakeWindow({
    Name = "Universal Utility Hub",
    HidePremium = false,
    IntroText = "Universal Orion script — use responsibly"
})

-- ====== HOME TAB ======
local homeTab = Window:MakeTab({
    Name = "Home",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

homeTab:AddParagraph("Welcome", "This GUI aims to be universal; some features may not work in games with strong anti-cheat. Features included: WalkSpeed, JumpPower, Fly, Noclip, ESP, Teleport to player.")

homeTab:AddButton({
    Name = "Restore defaults",
    Callback = function()
        safeSetWalkSpeed(16)
        safeSetJumpPower(50)
        Orion:MakeNotification({
            Name = "Defaults restored",
            Content = "WalkSpeed and JumpPower returned to defaults.",
            Image = "rbxassetid://4483345998",
            Time = 4
        })
    end
})

-- ====== PLAYER TAB ======
local playerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://6023426915",
    PremiumOnly = false
})

-- WalkSpeed slider
local currentWalk = 16
playerTab:AddSlider({
    Name = "WalkSpeed",
    Min = MIN_WALKSPEED,
    Max = MAX_WALKSPEED,
    Default = currentWalk,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "studs/s",
    Callback = function(v)
        currentWalk = v
        safeSetWalkSpeed(v)
    end
})

-- JumpPower slider
local currentJump = 50
playerTab:AddSlider({
    Name = "JumpPower",
    Min = MIN_JUMPPOWER,
    Max = MAX_JUMPPOWER,
    Default = currentJump,
    Increment = 1,
    ValueName = "power",
    Callback = function(v)
        currentJump = v
        safeSetJumpPower(v)
    end
})

playerTab:AddToggle({
    Name = "Auto-restore on respawn",
    Default = true,
    Callback = function(state)
        if state then
            -- respawn handler
            Players.PlayerAdded:Connect(function() end) -- placeholder to keep pattern
        end
    end
})

-- Ensure settings reapply on character spawn
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.5)
    safeSetWalkSpeed(currentWalk)
    safeSetJumpPower(currentJump)
end)

-- ====== MOVEMENT TAB ======
local movementTab = Window:MakeTab({
    Name = "Movement",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Noclip implementation
local noclipEnabled = false
local noclipConn = nil

movementTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            pcall(function() part.CanCollide = false end)
                        end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.CanCollide = true end)
                    end
                end
            end
        end
    end
})

-- Simple fly (works in many games) - toggle with key
local flyEnabled = false
local flySpeed = 50
local flyBV, flyBG
movementTab:AddToggle({
    Name = "Fly (Toggle with keybind)",
    Default = false,
    Callback = function(state)
        flyEnabled = state
        local root = getRootPart()
        if not root then return end
        if flyEnabled then
            -- Setup BodyVelocity and BodyGyro
            flyBV = Instance.new("BodyVelocity")
            flyBV.Velocity = Vector3.new(0,0,0)
            flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
            flyBV.Parent = root

            flyBG = Instance.new("BodyGyro")
            flyBG.D = 5
            flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
            flyBG.Parent = root

            Orion:MakeNotification({
                Name = "Fly Enabled",
                Content = "Use WASD + Space/Ctrl to move while flying. Toggle again to disable.",
                Time = 4
            })
        else
            if flyBV then flyBV:Destroy() flyBV = nil end
            if flyBG then flyBG:Destroy() flyBG = nil end
        end
    end
})

-- Fly controls (local loop)
local userInputService = game:GetService("UserInputService")
local flyingVector = Vector3.new(0,0,0)
local flyMoveConn
flyMoveConn = RunService.RenderStepped:Connect(function()
    if flyEnabled and flyBV and flyBG and getRootPart() then
        local root = getRootPart()
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.new(0,0,0)
        local isForward = userInputService:IsKeyDown(Enum.KeyCode.W)
        local isBack    = userInputService:IsKeyDown(Enum.KeyCode.S)
        local isLeft    = userInputService:IsKeyDown(Enum.KeyCode.A)
        local isRight   = userInputService:IsKeyDown(Enum.KeyCode.D)
        local isUp      = userInputService:IsKeyDown(Enum.KeyCode.Space)
        local isDown    = userInputService:IsKeyDown(Enum.KeyCode.LeftControl) or userInputService:IsKeyDown(Enum.KeyCode.C)

        if isForward then moveVec = moveVec + (cam.CFrame.LookVector) end
        if isBack    then moveVec = moveVec - (cam.CFrame.LookVector) end
        if isLeft    then moveVec = moveVec - (cam.CFrame.RightVector) end
        if isRight   then moveVec = moveVec + (cam.CFrame.RightVector) end
        if isUp      then moveVec = moveVec + Vector3.new(0,1,0) end
        if isDown    then moveVec = moveVec - Vector3.new(0,1,0) end

        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flySpeed
        end

        flyBV.Velocity = moveVec
        flyBG.CFrame = workspace.CurrentCamera.CFrame
    end
end)

movementTab:AddSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 400,
    Default = flySpeed,
    Increment = 1,
    ValueName = "speed",
    Callback = function(v)
        flySpeed = v
    end
})

-- Keybind to toggle fly quickly
movementTab:AddBind({
    Name = "Fly Keybind",
    Default = Enum.KeyCode.F,
    Hold = false,
    Callback = function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            local root = getRootPart()
            if root then
                -- create BV/BG if not exist
                if not flyBV then
                    flyBV = Instance.new("BodyVelocity")
                    flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
                    flyBV.Parent = root
                end
                if not flyBG then
                    flyBG = Instance.new("BodyGyro")
                    flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
                    flyBG.Parent = root
                end
            end
        else
            if flyBV then flyBV:Destroy() flyBV = nil end
            if flyBG then flyBG:Destroy() flyBG = nil end
        end
    end
})

-- ====== VISUALS TAB ======
local visualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Basic ESP (names + boxes) - not perfect but universal
local espEnabled = false
local espObjects = {}

local function createESPForPlayer(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not hrp then return end

    -- Billboard for name + distance
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "SimpleESP"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0, 150, 0, 50)
    billboard.AlwaysOnTop = true

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.35
    frame.BorderSizePixel = 0

    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.TextScaled = true
    txt.Font = Enum.Font.SourceSansSemibold
    txt.Text = plr.Name
    txt.TextColor3 = Color3.new(1,1,1)

    billboard.Parent = game.CoreGui or workspace -- prefer CoreGui if available

    espObjects[plr] = billboard
end

local function removeESPForPlayer(plr)
    if espObjects[plr] then
        pcall(function() espObjects[plr]:Destroy() end)
        espObjects[plr] = nil
    end
end

-- ESP toggle
visualsTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(state)
        espEnabled = state
        if state then
            -- create for existing players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then createESPForPlayer(plr) end
            end
            -- players joining
            Players.PlayerAdded:Connect(function(plr)
                if espEnabled then
                    plr.CharacterAdded:Connect(function()
                        wait(0.3)
                        if espEnabled then createESPForPlayer(plr) end
                    end)
                end
            end)
            -- characters added for existing players
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr ~= LocalPlayer then
                    pcall(function() createESPForPlayer(plr) end)
                end
            end
        else
            -- remove all
            for plr, gui in pairs(espObjects) do
                pcall(function() gui:Destroy() end)
            end
            espObjects = {}
        end
    end
})

-- Clean up if a player leaves
Players.PlayerRemoving:Connect(function(plr)
    removeESPForPlayer(plr)
end)

-- ====== UTILITIES TAB ======
local utilitiesTab = Window:MakeTab({
    Name = "Utilities",
    Icon = "rbxassetid://6034287081",
    PremiumOnly = false
})

utilitiesTab:AddTextbox({
    Name = "Teleport to Player (enter exact player name)",
    Default = "",
    TextDisappear = true,
    Callback = function(txt)
        if txt == "" then
            Orion:MakeNotification({Name="Teleport", Content="No name provided.", Time=3})
            return
        end
        local target = Players:FindFirstChild(txt)
        if not target or not target.Character then
            Orion:MakeNotification({Name="Teleport", Content="Player not found or no character.", Time=3})
            return
        end
        local root = getRootPart()
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
        if root and targetRoot then
            pcall(function() root.CFrame = targetRoot.CFrame + Vector3.new(0,3,0) end)
            Orion:MakeNotification({Name="Teleport", Content="Teleported to "..txt, Time=3})
        end
    end
})

utilitiesTab:AddButton({
    Name = "Reset HumanoidRootPart Position",
    Callback = function()
        local root = getRootPart()
        if root then
            pcall(function() root.CFrame = workspace:FindFirstChild("SpawnLocation") and workspace.SpawnLocation.CFrame + Vector3.new(0,5,0) or CFrame.new(0,50,0) end)
            Orion:MakeNotification({Name="Reset HRP", Content="Tried to reset HRP position.", Time=3})
        else
            Orion:MakeNotification({Name="Reset HRP", Content="Root part not found.", Time=3})
        end
    end
})

utilitiesTab:AddButton({
    Name = "Copy Player Display Name",
    Callback = function()
        local name = LocalPlayer.Name
        pcall(function() setclipboard(name) end)
        Orion:MakeNotification({Name="Clipboard", Content="Player name copied to clipboard (if supported).", Time=3})
    end
})

-- ====== CLEANUP ON CLOSE ======
Window:MakeNotification({
    Name = "Ready",
    Content = "GUI loaded. Use the tabs to control features.",
    Image = "rbxassetid://4483345998",
    Time = 4
})

-- When the script ends or window is destroyed, clean some things up (best-effort)
-- (Orion windows typically have a close; we provide safe disconnects as needed)
local function cleanup()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if flyBV then pcall(function() flyBV:Destroy() end) end
    if flyBG then pcall(function() flyBG:Destroy() end) end
    for plr, gui in pairs(espObjects) do
        pcall(function() gui:Destroy() end)
    end
    espObjects = {}
end

-- Try to hook the window close event if available
if Window and Window.Parent then
    -- There is no universal close event for Orion exposed here; rely on cleanup when executor script ends.
end

-- return reference (optional)
return {
    Orion = Orion,
    Window = Window,
    Cleanup = cleanup
}
