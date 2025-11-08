-- Universal Orion UI LocalScript
-- Place this as a LocalScript in StarterPlayerScripts.
-- Make sure a ModuleScript named "OrionLib" exists in ReplicatedStorage (the Orion UI library).

-- Robust guards & environment
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
if not localPlayer then
    warn("Orion UI script: LocalPlayer not found. Script must be a LocalScript.")
    return
end

-- Try to require Orion safely
local OrionLib
local ok, e = pcall(function()
    local module = ReplicatedStorage:FindFirstChild("OrionLib")
    assert(module, "OrionLib ModuleScript not found in ReplicatedStorage (required).")
    OrionLib = require(module)
end)
if not ok then
    warn("Failed to load OrionLib:", e)
    return
end

-- UI init
local Window = OrionLib:MakeWindow({
    Name = "Universal Utility",
    HidePremium = true,
    IntroText = "Universal Orion UI",
    SaveConfig = true,
    ConfigFolder = "UniversalOrionConfig"
})

-- SETTINGS (default)
local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    ESPEnabled = false,
    ESPDistance = 250,
    UIKeybind = Enum.KeyCode.RightControl,
    AntiAFK = false,
    ShowHumanoidHealth = true,
}

-- Utility functions
local function safeWait(seconds)
    if seconds and seconds > 0 then
        local t0 = tick()
        repeat RunService.Heartbeat:Wait() until tick() - t0 >= seconds
    else
        RunService.Heartbeat:Wait()
    end
end

local function getCharacter(player)
    return player and player.Character
end

local function getHumanoid(player)
    local char = getCharacter(player)
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- PLAYER TAB
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- WalkSpeed
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 4,
    Max = 250,
    Default = Settings.WalkSpeed,
    Color = Color3.new(1,1,1),
    Increment = 1,
    ValueName = "studs/s",
    Callback = function(val)
        Settings.WalkSpeed = val
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

-- JumpPower
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 300,
    Default = Settings.JumpPower,
    Increment = 1,
    ValueName = "power",
    Callback = function(val)
        Settings.JumpPower = val
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

PlayerTab:AddButton({
    Name = "Reset Movement",
    Callback = function()
        Settings.WalkSpeed = 16
        Settings.JumpPower = 50
        local char = localPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = Settings.WalkSpeed
                hum.JumpPower = Settings.JumpPower
            end
        end
        OrionLib:MakeNotification({
            Name = "Player",
            Content = "WalkSpeed and JumpPower reset.",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

-- Anti-AFK toggle (simulated)
PlayerTab:AddToggle({
    Name = "Anti-AFK (simulate input)",
    Default = Settings.AntiAFK,
    Callback = function(state)
        Settings.AntiAFK = state
    end
})

-- VISUALS TAB (ESP)
local VisualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://6023426915",
    PremiumOnly = false
})

VisualsTab:AddToggle({
    Name = "Enable ESP",
    Default = Settings.ESPEnabled,
    Callback = function(state)
        Settings.ESPEnabled = state
    end
})

VisualsTab:AddSlider({
    Name = "ESP Max Distance",
    Min = 50,
    Max = 2000,
    Default = Settings.ESPDistance,
    Increment = 25,
    ValueName = "studs",
    Callback = function(val)
        Settings.ESPDistance = val
    end
})

VisualsTab:AddToggle({
    Name = "Show Humanoid Health",
    Default = Settings.ShowHumanoidHealth,
    Callback = function(state)
        Settings.ShowHumanoidHealth = state
    end
})

-- Create a simple ESP manager
local ESP = {}
ESP.guis = {}

local function makePlayerGui(p)
    if not p or p == localPlayer then return end
    if ESP.guis[p] then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "UniversalESP"
    billboard.Adornee = nil
    billboard.Size = UDim2.new(0, 120, 0, 36)
    billboard.AlwaysOnTop = true
    billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local namelbl = Instance.new("TextLabel", frame)
    namelbl.Name = "Name"
    namelbl.Size = UDim2.new(1, -4, 0.5, -2)
    namelbl.Position = UDim2.new(0,2,0,2)
    namelbl.BackgroundTransparency = 1
    namelbl.TextScaled = true
    namelbl.RichText = true
    namelbl.TextXAlignment = Enum.TextXAlignment.Left

    local infolbl = Instance.new("TextLabel", frame)
    infolbl.Name = "Info"
    infolbl.Size = UDim2.new(1, -4, 0.5, -2)
    infolbl.Position = UDim2.new(0,2,0.5,0)
    infolbl.BackgroundTransparency = 1
    infolbl.TextScaled = true
    infolbl.TextXAlignment = Enum.TextXAlignment.Left

    ESP.guis[p] = billboard
    return billboard
end

local function removePlayerGui(p)
    local g = ESP.guis[p]
    if g then
        g:Destroy()
        ESP.guis[p] = nil
    end
end

Players.PlayerAdded:Connect(function(p)
    -- nothing to do here until character exists
end)
Players.PlayerRemoving:Connect(function(p)
    removePlayerGui(p)
end)

-- Teleports tab
local TeleportsTab = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://7072727664",
    PremiumOnly = false
})

TeleportsTab:AddButton({
    Name = "Teleport to Spawn / Workspace SpawnLocation",
    Callback = function()
        local char = localPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if not hrp then
            OrionLib:MakeNotification({Name = "Teleport", Content = "No HumanoidRootPart found", Time = 3})
            return
        end

        local spawnLoc = Workspace:FindFirstChildOfClass("SpawnLocation") or Workspace:FindFirstChild("Spawn")
        if spawnLoc and spawnLoc:IsA("BasePart") then
            hrp.CFrame = spawnLoc.CFrame + Vector3.new(0, 5, 0)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Teleported to spawn.", Time = 3})
        else
            -- fallback: teleport to world origin
            hrp.CFrame = CFrame.new(0, 10, 0)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Spawn not found. Teleported to origin.", Time = 3})
        end
    end
})

-- Teleport to any player (text input)
TeleportsTab:AddTextbox({
    Name = "Teleport to player (username)",
    PlaceholderText = "Exact username",
    TextDisappear = true,
    Callback = function(txt)
        if txt == "" then return end
        local target = Players:FindFirstChild(txt)
        if not target then
            OrionLib:MakeNotification({Name = "Teleport", Content = "Player not found.", Time = 2})
            return
        end
        local tChar = target.Character
        local myChar = localPlayer.Character
        if not tChar or not myChar then
            OrionLib:MakeNotification({Name = "Teleport", Content = "Either character missing.", Time = 2})
            return
        end
        local tHRP = tChar:FindFirstChild("HumanoidRootPart")
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if tHRP and myHRP then
            myHRP.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0)
            OrionLib:MakeNotification({Name = "Teleport", Content = "Teleported to "..txt, Time = 3})
        end
    end
})

-- Tools tab: simple local tool generator
local ToolsTab = Window:MakeTab({
    Name = "Tools",
    Icon = "rbxassetid://6031110007",
    PremiumOnly = false
})

ToolsTab:AddButton({
    Name = "Spawn Local Tool: 'Bounce'",
    Callback = function()
        local backpack = localPlayer:FindFirstChild("Backpack") or localPlayer:WaitForChild("Backpack", 2)
        if not backpack then
            OrionLib:MakeNotification({Name = "Tool", Content = "Backpack not found.", Time = 2})
            return
        end
        local tool = Instance.new("Tool")
        tool.Name = "Bounce"
        tool.RequiresHandle = false
        tool.Parent = backpack

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1,1,1)
        handle.CanCollide = false
        handle.Transparency = 1
        handle.Parent = tool

        local scriptLocal = Instance.new("LocalScript")
        scriptLocal.Source = [[
            local tool = script.Parent
            tool.Activated:Connect(function()
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hrp and hum then
                    hum.JumpPower = (hum.JumpPower or 50) + 30
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait(0.5)
                    hum.JumpPower = math.clamp(hum.JumpPower - 30, 0, 500)
                end
            end)
        ]]
        scriptLocal.Parent = tool

        OrionLib:MakeNotification({Name = "Tool", Content = "Local tool 'Bounce' created in Backpack.", Time = 3})
    end
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "Settings",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

SettingsTab:AddBind({
    Name = "Toggle UI",
    Default = Settings.UIKeybind,
    Hold = false,
    Callback = function(key)
        Settings.UIKeybind = key
    end
})

SettingsTab:AddButton({
    Name = "Save Config (Orion handles saving too)",
    Callback = function()
        OrionLib:MakeNotification({Name = "Config", Content = "Config is saved automatically by Orion when toggles change.", Time = 3})
    end
})

-- Toggle UI hotkey
OrionLib:MakeNotification({Name = "Universal UI", Content = "Toggle UI with Right Ctrl by default.", Time = 4})
-- Orion provides keybind management internally; however we also add a basic toggle:
local userInputService = game:GetService("UserInputService")
userInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Settings.UIKeybind then
        OrionLib:ToggleUI()
    end
end)

-- Character update handlers (apply player movement changes on spawn)
localPlayer.CharacterAdded:Connect(function(char)
    -- small delay to let humanoid load
    safeWait(0.1)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = Settings.WalkSpeed or 16
        hum.JumpPower = Settings.JumpPower or 50
    end
end)

-- Anti-AFK implementation (simulate jumping/mouse movement)
spawn(function()
    while true do
        safeWait(1)
        if Settings.AntiAFK then
            -- simulate a tiny camera rotation and small jump input to avoid AFK detection in some games
            pcall(function()
                local virtualUser = game:GetService("VirtualUser")
                virtualUser:CaptureController()
                virtualUser:ClickButton2(Vector2.new(0,0))
            end)
            -- also perform a small jump if possible
            local char = localPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- ESP render loop
spawn(function()
    while RunService.Heartbeat:Wait() do
        if Settings.ESPEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= localPlayer then
                    local char = p.Character
                    if char then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hrp and hum then
                            local dist = (localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and (localPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude) or math.huge
                            if dist <= Settings.ESPDistance then
                                local gui = makePlayerGui(p)
                                if gui and not gui.Parent then
                                    -- parent to player's head if exists, otherwise to character
                                    gui.Adornee = hrp
                                    gui.Parent = p.Character
                                end
                                if gui then
                                    local nameLbl = gui:FindFirstChild("Frame") and gui.Frame:FindFirstChild("Name")
                                    local infoLbl = gui:FindFirstChild("Frame") and gui.Frame:FindFirstChild("Info")
                                    if nameLbl then nameLbl.Text = "<b>"..p.Name.."</b>" end
                                    if infoLbl then
                                        local info = ("%.0f studs"):format(dist)
                                        if Settings.ShowHumanoidHealth and hum.Health and hum.MaxHealth then
                                            info = info .. " • " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                                        end
                                        infoLbl.Text = info
                                    end
                                end
                            else
                                removePlayerGui(p)
                            end
                        else
                            removePlayerGui(p)
                        end
                    else
                        removePlayerGui(p)
                    end
                end
            end
        else
            -- ESP disabled: cleanup
            for p,_ in pairs(ESP.guis) do removePlayerGui(p) end
        end
    end
end)

-- Clean shutdown protections
local function cleanup()
    for p,_ in pairs(ESP.guis) do
        removePlayerGui(p)
    end
end
game:BindToClose(cleanup)

-- Final friendly notify
OrionLib:MakeNotification({
    Name = "Universal UI Ready",
    Content = "Universal Orion UI loaded. Explore tabs for Player, Visuals, Teleports, Tools & Settings.",
    Image = "rbxassetid://4483345998",
    Time = 5
})
