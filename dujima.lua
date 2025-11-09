local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Bersihkan GUI lama jika ada
local oldGui = PlayerGui:FindFirstChild("CustomGui")
if oldGui then oldGui:Destroy() end

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Fungsi membuat frame draggable (bisa digeser)
local function makeDraggable(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local newX = startPos.X.Offset + delta.X
            local newY = startPos.Y.Offset + delta.Y
            -- Batasi agar tidak keluar layar (opsional)
            newX = math.clamp(newX, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X)
            newY = math.clamp(newY, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
            frame.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

--========================
-- CREATE MAIN FRAME GUI
--========================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 360, 0, 460)
mainFrame.Position = UDim2.new(0, 20, 0, 60)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.45
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Rounded corners
local uicornerMain = Instance.new("UICorner")
uicornerMain.CornerRadius = UDim.new(0, 12)
uicornerMain.Parent = mainFrame

makeDraggable(mainFrame)

--========================
-- CREATE MINIMIZE ICON "D"
--========================
local minimized = false

local minimizeIcon = Instance.new("Frame")
minimizeIcon.Name = "MinimizeIcon"
minimizeIcon.Size = UDim2.new(0, 40, 0, 40)
minimizeIcon.Position = UDim2.new(0, 10, 1, -50)
minimizeIcon.BackgroundColor3 = Color3.fromRGB(18,18,30)
minimizeIcon.BackgroundTransparency = 0.3
minimizeIcon.BorderSizePixel = 0
minimizeIcon.Parent = screenGui
minimizeIcon.ZIndex = 10

local uicornerMin = Instance.new("UICorner")
uicornerMin.CornerRadius = UDim.new(0, 20)
uicornerMin.Parent = minimizeIcon

local labelD = Instance.new("TextLabel")
labelD.Text = "D"
labelD.Font = Enum.Font.GothamBold
labelD.TextSize = 30
labelD.TextColor3 = Color3.fromRGB(190, 190, 255)
labelD.BackgroundTransparency = 1
labelD.Size = UDim2.new(1, 0, 1, 0)
labelD.Parent = minimizeIcon

minimizeIcon.Visible = false

makeDraggable(minimizeIcon)

minimizeIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        minimized = false
        mainFrame.Visible = true
        minimizeIcon.Visible = false
    end
end)

-- Tombol minimize di mainFrame
local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 32, 0, 28)
btnMinimize.Position = UDim2.new(1, -38, 0, 6)
btnMinimize.Text = "–"
btnMinimize.TextColor3 = Color3.fromRGB(220, 220, 230)
btnMinimize.BackgroundColor3 = Color3.fromRGB(35,35,45)
btnMinimize.BorderSizePixel = 0
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 24
btnMinimize.Parent = mainFrame

btnMinimize.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    minimizeIcon.Visible = true
end)

--========================
-- Create Tab Button Frame
--========================
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 46)
tabButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
tabButtonsFrame.BorderSizePixel = 0
tabButtonsFrame.Parent = mainFrame

local uicornerTab = Instance.new("UICorner")
uicornerTab.CornerRadius = UDim.new(0, 12)
uicornerTab.Parent = tabButtonsFrame

--========================
-- Create Title Label (atas mainFrame)
--========================
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 36)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(190, 190, 235)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.Text = "Chloe X | Version 1.0.5"
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Position = UDim2.new(0, 0, 0, 3)
titleLabel.Parent = mainFrame

--========================
-- Content Frame - ScrollFrame untuk tab konten
--========================
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -95)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 7
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- otomatis atur tinggi canvas
contentFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 7)
uiListLayout.Parent = contentFrame

--========================
-- Fungsi membuat tombol tab
--========================
local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Text = name
    button.Size = UDim2.new(0, 90, 1, 0)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(180, 180, 230)
    button.BackgroundColor3 = Color3.fromRGB(30,30,40)
    button.AutoButtonColor = false
    button.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button

    return button
end

--========================
-- Utilities: toggle switch sederhana
--========================
local function createToggleSwitch(default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 56, 0, 26)
    frame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    frame.BorderSizePixel = 0
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 24, 0, 24)
    button.Position = UDim2.new(0, 2, 0, 1)
    button.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    button.Text = ""
    button.Parent = frame

    local bgOn = Color3.fromRGB(0, 170, 60)
    local bgOff = Color3.fromRGB(170, 0, 0)
    local toggled = default or false

    local function update()
        if toggled then
            button.Position = UDim2.new(0, 30, 0, 1)
            frame.BackgroundColor3 = bgOn
        else
            button.Position = UDim2.new(0, 2, 0, 1)
            frame.BackgroundColor3 = bgOff
        end
    end
    update()

    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        update()
        if frame.OnToggle then
            frame.OnToggle(toggled)
        end
    end)

    frame.GetState = function() return toggled end
    frame.SetState = function(v) toggled = v; update() end

    return frame
end

--========================
-- Utilities: tombol sederhana
--========================
local function createButton(text,width)
    width = width or 160
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 19
    btn.TextColor3 = Color3.fromRGB(230, 230, 250)
    btn.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

--============================
-- Utilities: input angka sederhana untuk kecepatan
--============================
local function createSpeedInput(defaultValue, label)
    local frame = Instance.new("Frame")
    frame.Size= UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, 0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 18
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5,0,0.7,0)
    input.Position = UDim2.new(0.5,0,0.15,0)
    input.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    input.TextColor3 = Color3.fromRGB(210, 210, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 18
    input.ClearTextOnFocus = false
    input.Text = tostring(defaultValue)
    input.Parent= frame

    input.FocusLost:Connect(function(enterPressed)
        local val = tonumber(input.Text)
        if not val or val < 1 then
            val = defaultValue
            input.Text = tostring(val)
        elseif val > 500 then
            val = 500
            input.Text = "500"
        end
        if frame.OnSpeedChange then
            frame.OnSpeedChange(val)
        end
    end)

    frame.GetValue = function() return tonumber(input.Text) or defaultValue end
    frame.SetValue = function(val) input.Text = tostring(val) end

    return frame
end

--==================================
-- Script Fitur Player: walk speed, fly, noclip, freeze, rename, delete notification
--==================================

local char = Player.Character or Player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local rootPart = char:WaitForChild("HumanoidRootPart")

local walkSpeedDefault = 16
local flyEnabled = false
local flying = false
local flySpeedDefault = 50
local noclipEnabled = false
local freezeEnabled = false
local renameEnabled = false
local originalName = Player.Name

local bodyGyro
local bodyVelocity
local noclipConnection
local freezeConnection

-- WalkSpeed Toggle 
local function setWalkSpeed(enabled, speed)
    if enabled then
        humanoid.WalkSpeed = speed or walkSpeedDefault
    else
        humanoid.WalkSpeed = walkSpeedDefault
    end
end

-- Fly Logic
local function enableFly()
    if flying then return end
    flying = true
    bodyGyro = Instance.new("BodyGyro", rootPart)
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 4000
    bodyGyro.CFrame = rootPart.CFrame

    bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
end

local function disableFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() bodyGyro=nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity=nil end
end

local function setFly(enabled)
    if enabled then
        enableFly()
    else
        disableFly()
    end
end

local function updateFlySpeed(speed)
    if flying and bodyVelocity then
        local cam = workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        if dir.Magnitude > 0 then
            dir = dir.Unit
        end
        bodyVelocity.Velocity = dir * speed
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyGyro.CFrame = cam.CFrame
    elseif bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(0,0,0)
    end
end

-- NoClip (set CanCollide false tiap frame)
local function setNoclip(enabled)
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Freeze character (set WalkSpeed dan JumpPower 0)
local function setFreeze(enabled)
    if enabled then
        freezeConnection = RunService.Stepped:Connect(function()
            if humanoid and humanoid.Health > 0 then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
                humanoid.AutoRotate = false
            end
        end)
    else
        if freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
            if humanoid and humanoid.Health > 0 then
                humanoid.WalkSpeed = walkSpeedDefault
                humanoid.JumpPower = 50
                humanoid.AutoRotate = true
            end
        end
    end
end

-- Rename nickname (ubah DisplayName)
local function setRename(enabled, newName)
    if enabled then
        if newName and newName ~= "" then
            Player.DisplayName = newName
        else
            Player.DisplayName = originalName
        end
    else
        Player.DisplayName = originalName
    end
end

--============================
-- Buat Tab Info (tanpa scroll)
--============================
local infoContent = {}

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 300)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(210, 210, 230)
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 18
infoLabel.Text = [[
Chloe X Information

Status: Masih tahap development!
Ada kemungkinan terdeteksi jika dipakai di public.
Jika ada saran atau bug silahkan lapor.
Gunakan dengan risiko sendiri.

Official Discord Chloe X!
]]
table.insert(infoContent, infoLabel)
tabsContent["Info"] = infoContent

--============================
-- Buat Tab Player
--============================
local playerContent = {}

local function addPlayerItem(item)
    item.LayoutOrder = #playerContent + 1
    table.insert(playerContent, item)
end

-- Walkspeed
local walkFrame = Instance.new("Frame")
walkFrame.Size = UDim2.new(1, 0, 0, 70)
walkFrame.BackgroundTransparency = 1

local walkLabel = Instance.new("TextLabel")
walkLabel.Size = UDim2.new(0.44, 0, 1, 0)
walkLabel.BackgroundTransparency = 1
walkLabel.Text = "WalkSpeed"
walkLabel.TextColor3 = Color3.new(1,1,1)
walkLabel.TextXAlignment = Enum.TextXAlignment.Left
walkLabel.Font = Enum.Font.Gotham
walkLabel.TextSize = 20
walkLabel.Parent = walkFrame

local walkToggle = createToggleSwitch(false)
walkToggle.Parent = walkFrame
walkToggle.Position = UDim2.new(0.46, 0, 0.2, 0)

local walkInput = createSpeedInput(walkSpeedDefault, "Speed:")
walkInput.Parent = walkFrame
walkInput.Position = UDim2.new(0.65, 0, 0.15, 0)
walkInput.Size = UDim2.new(0.35, 0, 0.7, 0)

walkToggle.OnToggle = function(state)
    setWalkSpeed(state, walkInput:GetValue())
end

walkInput.OnSpeedChange = function(val)
    if walkToggle:GetState() then
        humanoid.WalkSpeed = val
    end
end

addPlayerItem(walkFrame)

-- Fly
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, 0, 0, 70)
flyFrame.BackgroundTransparency = 1

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(0.44, 0, 1, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly"
flyLabel.TextColor3 = Color3.new(1,1,1)
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 20
flyLabel.Parent = flyFrame

local flyToggle = createToggleSwitch(false)
flyToggle.Parent = flyFrame
flyToggle.Position = UDim2.new(0.46, 0, 0.2, 0)

local flyInput = createSpeedInput(flySpeedDefault, "Speed:")
flyInput.Parent = flyFrame
flyInput.Position = UDim2.new(0.65, 0, 0.15, 0)
flyInput.Size = UDim2.new(0.35, 0, 0.7, 0)

flyToggle.OnToggle = function(state)
    setFly(state)
end

flyInput.OnSpeedChange = function(val)
    updateFlySpeed(val)
end

addPlayerItem(flyFrame)

-- NoClip
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1,0,0,45)
noclipFrame.BackgroundTransparency = 1

local noclipLabel = Instance.new("TextLabel")
noclipLabel.Size = UDim2.new(0.7,0,1,0)
noclipLabel.BackgroundTransparency = 1
noclipLabel.Text = "NoClip"
noclipLabel.TextColor3 = Color3.new(1,1,1)
noclipLabel.TextXAlignment = Enum.TextXAlignment.Left
noclipLabel.Font = Enum.Font.Gotham
noclipLabel.TextSize = 20
noclipLabel.Parent = noclipFrame

local noclipToggle = createToggleSwitch(false)
noclipToggle.Parent = noclipFrame
noclipToggle.Position = UDim2.new(0.75, 0, 0.15, 0)

noclipToggle.OnToggle = function(state)
    setNoclip(state)
end

addPlayerItem(noclipFrame)

-- Freeze
local freezeFrame = Instance.new("Frame")
freezeFrame.Size = UDim2.new(1,0,0,45)
freezeFrame.BackgroundTransparency = 1

local freezeLabel = Instance.new("TextLabel")
freezeLabel.Size = UDim2.new(0.7,0,1,0)
freezeLabel.BackgroundTransparency = 1
freezeLabel.Text = "Freeze Character"
freezeLabel.TextColor3 = Color3.new(1,1,1)
freezeLabel.TextXAlignment = Enum.TextXAlignment.Left
freezeLabel.Font = Enum.Font.Gotham
freezeLabel.TextSize = 20
freezeLabel.Parent = freezeFrame

local freezeToggle = createToggleSwitch(false)
freezeToggle.Parent = freezeFrame
freezeToggle.Position = UDim2.new(0.75, 0, 0.15, 0)

freezeToggle.OnToggle = function(state)
    setFreeze(state)
end

addPlayerItem(freezeFrame)

-- Rename Nickname
local renameFrame = Instance.new("Frame")
renameFrame.Size = UDim2.new(1,0,0,70)
renameFrame.BackgroundTransparency = 1

local renameLabel = Instance.new("TextLabel")
renameLabel.Size = UDim2.new(0.4,0,1,0)
renameLabel.BackgroundTransparency = 1
renameLabel.Text = "Rename Nickname"
renameLabel.TextColor3 = Color3.new(1,1,1)
renameLabel.TextXAlignment = Enum.TextXAlignment.Left
renameLabel.Font = Enum.Font.Gotham
renameLabel.TextSize = 20
renameLabel.Parent = renameFrame

local renameToggle = createToggleSwitch(false)
renameToggle.Parent = renameFrame
renameToggle.Position = UDim2.new(0.42, 0, 0.25, 0)

local renameInput = Instance.new("TextBox")
renameInput.Size = UDim2.new(0.55, 0, 0.65, 0)
renameInput.Position = UDim2.new(0.45, 0, 0.2, 0)
renameInput.BackgroundColor3 = Color3.fromRGB(65, 65, 85)
renameInput.TextColor3 = Color3.fromRGB(220, 220, 230)
renameInput.Font = Enum.Font.Gotham
renameInput.TextSize = 18
renameInput.ClearTextOnFocus = false
renameInput.PlaceholderText = "New nickname..."
renameInput.Parent = renameFrame

local function applyRename()
    setRename(renameToggle:GetState(), renameInput.Text)
end

renameToggle.OnToggle = applyRename
renameInput.FocusLost:Connect(function(enter)
    if enter then applyRename() end
end)

addPlayerItem(renameFrame)

-- Delete Notification Fish button
local btnDeleteNotif = createButton("Delete Notification Fish", 320)
btnDeleteNotif.LayoutOrder = #playerContent + 1
btnDeleteNotif.MouseButton1Click:Connect(function()
    local notif = PlayerGui:FindFirstChild("Small Notification")
    if notif then notif:Destroy() end
end)
table.insert(playerContent, btnDeleteNotif)

tabsContent["Player"] = playerContent

--============================
-- Tab Server Content
--============================
local serverContent = {}

local btnRejoin = createButton("Rejoin Server")
btnRejoin.LayoutOrder = 1
btnRejoin.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)
table.insert(serverContent, btnRejoin)

local joinFrame = Instance.new("Frame")
joinFrame.Size = UDim2.new(1,0,0,50)
joinFrame.BackgroundTransparency = 1
joinFrame.LayoutOrder = 2

local joinInput = Instance.new("TextBox")
joinInput.Size = UDim2.new(0.65,0,0.7,0)
joinInput.Position = UDim2.new(0, 5, 0.15, 0)
joinInput.BackgroundColor3 = Color3.fromRGB(70,70,70)
joinInput.PlaceholderText = "Paste server link or id"
joinInput.TextColor3 = Color3.fromRGB(220,220,230)
joinInput.Font = Enum.Font.Gotham
joinInput.TextSize = 16
joinInput.Parent = joinFrame

local btnJoinLink = createButton("Join Server", 95)
btnJoinLink.Parent = joinFrame
btnJoinLink.Position = UDim2.new(0.75,0,0.15,0)

btnJoinLink.MouseButton1Click:Connect(function()
    local val = joinInput.Text
    if val and val ~= "" then
        local jobId = val:match("%d%d+")
        if jobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Player)
        else
            warn("Invalid Job ID or Link")
        end
    end
end)
table.insert(serverContent, joinFrame)

local btnRandomJoin = createButton("Random Join Server")
btnRandomJoin.LayoutOrder = 3
btnRandomJoin.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, nil, Player)
end)
table.insert(serverContent, btnRandomJoin)

tabsContent["Server"] = serverContent

--============================
-- Tab Teleport Content
--============================
local teleportContent = {}

local playersLabel = Instance.new("TextLabel")
playersLabel.Text = "Teleport to Player"
playersLabel.TextColor3 = Color3.fromRGB(230,230,255)
playersLabel.Font = Enum.Font.GothamBold
playersLabel.TextSize = 20
playersLabel.BackgroundTransparency = 1
playersLabel.LayoutOrder = 1
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.Parent = mainFrame

local refreshBtn = createButton("Refresh", 80)
refreshBtn.LayoutOrder = 1
refreshBtn.Parent = mainFrame
refreshBtn.Position = UDim2.new(1, -90, 0, 50)

-- Scroll frame daftar player
local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, -20, 0, 160)
playerListFrame.Position = UDim2.new(0, 10, 0, 80)
playerListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
playerListFrame.BorderSizePixel = 0
playerListFrame.ScrollBarThickness = 7
playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListFrame.Visible = false
playerListFrame.Parent = mainFrame

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerListLayout.Parent = playerListFrame

local function refreshPlayerList()
    playerListFrame:ClearAllChildren()
    playerListLayout.Parent = playerListFrame
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = createButton(plr.Name, playerListFrame.AbsoluteSize.X - 20)
            btn.LayoutOrder = #playerListFrame:GetChildren() + 1
            btn.Parent = playerListFrame
            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                end
            end)
        end
    end
end

refreshBtn.MouseButton1Click:Connect(function()
    refreshPlayerList()
    playerListFrame.Visible = not playerListFrame.Visible
end)

-- Save & Reset Position frame
local posFrame = Instance.new("Frame")
posFrame.Size = UDim2.new(1, -20, 0, 50)
posFrame.Position = UDim2.new(0, 10, 0, 250)
posFrame.BackgroundTransparency = 1
posFrame.Parent = mainFrame

local btnSavePos = createButton("Save Position", 165)
btnSavePos.Parent = posFrame
btnSavePos.Position = UDim2.new(0, 0, 0, 8)

local btnResetPos = createButton("Reset Position", 165)
btnResetPos.Parent = posFrame
btnResetPos.Position = UDim2.new(0, 175, 0, 8)

local savedPosition = nil

btnSavePos.MouseButton1Click:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = Player.Character.HumanoidRootPart.CFrame
        print("Position saved.")
    end
end)

btnResetPos.MouseButton1Click:Connect(function()
    if savedPosition and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = savedPosition
        print("Position reset.")
    end
end)

--Tambahkan teleport tab
tabsContent["Teleport"] = {}

for _, v in pairs({playersLabel, refreshBtn, playerListFrame, posFrame}) do
    table.insert(tabsContent["Teleport"], v)
end

--============================
-- Fungsi bersihkan konten
--============================
local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child.Parent = nil
        end
    end
end

--============================
-- Fungsi tampilkan tab
--============================
local function showTab(name)
    clearContent()
    if tabsContent[name] then
        for _, item in ipairs(tabsContent[name]) do
            item.Parent = contentFrame
        end
    end

    -- Tab Info non-scrollable
    if name == "Info" then
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteSize.Y)
        contentFrame.ScrollBarThickness = 0
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    else
        contentFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
        contentFrame.ScrollBarThickness = 7
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    end

    for tName, btn in pairs(tabButtons) do
        if tName == name then
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
            btn.TextColor3 = Color3.fromRGB(230, 230, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            btn.TextColor3 = Color3.fromRGB(180, 180, 230)
        end
    end
end

--============================
-- Buat Tab Buttons dan koneksi klik
--============================
local tabButtons = {}
local tabs = {"Info", "Player", "Server", "Teleport"}

for i, tabName in ipairs(tabs) do
    local btn = createTabButton(tabName)
    btn.Parent = tabButtonsFrame
    btn.Position = UDim2.new((i-1)*0.25, 10, 0, 7)
    btn.Size = UDim2.new(0.22, 0, 0, 32)
    tabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        showTab(tabName)
    end)
end

-- Tampilkan tab awal
showTab("Info")

--============================
-- Loop Update fitur Fly & Walkspeed tiap frame
--============================
RunService.RenderStepped:Connect(function()
    if walkToggle:GetState() then
        humanoid.WalkSpeed = walkInput:GetValue()
    else
        if humanoid.WalkSpeed ~= walkSpeedDefault then
            humanoid.WalkSpeed = walkSpeedDefault
        end
    end

    if flyToggle:GetState() then
        updateFlySpeed(flyInput:GetValue())
    end
end)

--============================
-- Respawn handler agar toggle tetap aktif
--============================
Player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    char:WaitForChild("HumanoidRootPart")
    char:GetPropertyChangedSignal("Parent"):Wait()
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")

    if noclipToggle:GetState() then setNoclip(true) else setNoclip(false) end
    if freezeToggle:GetState() then setFreeze(true) else setFreeze(false) end
    if walkToggle:GetState() then humanoid.WalkSpeed = walkInput:GetValue()
    else humanoid.WalkSpeed = walkSpeedDefault end
    if flyToggle:GetState() then enableFly() else disableFly() end
end)