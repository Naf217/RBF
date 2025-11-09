local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Hapus GUI lama jika ada
local oldGui = PlayerGui:FindFirstChild("CustomGui")
if oldGui then oldGui:Destroy() end

-- Buat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGui"
screenGui.Parent = PlayerGui
screenGui.ResetOnSpawn = false

-- Utility function untuk draggable frame
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--====================
-- Main Frame
--====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 520)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

--====================
-- Minimize Button (ikon D)
--====================
local minimized = false

local function createMinimizeIcon()
    local iconSize = UDim2.new(0, 50, 0, 50)
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "MinimizeIcon"
    iconFrame.Size = iconSize
    iconFrame.Position = UDim2.new(0.1, 0, 0.1, 0) -- awal posisi
    iconFrame.BackgroundColor3 = Color3.fromRGB(10,10,40)
    iconFrame.BorderSizePixel = 0
    iconFrame.Parent = screenGui
    iconFrame.ZIndex = 10

    -- Buat rounded corners (optional)
    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 25)
    uicorner.Parent = iconFrame

    -- Tulisan "D"
    local label = Instance.new("TextLabel")
    label.Text = "D"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Parent = iconFrame

    -- Draggable icon
    makeDraggable(iconFrame)

    -- Klik toggle
    iconFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minimized = not minimized
            mainFrame.Visible = not minimized
            iconFrame.Visible = minimized
        end
    end)

    iconFrame.Visible = false -- awal hidden karena GUI terbuka

    return iconFrame
end

local minimizeIcon = createMinimizeIcon()

-- Tombol minimize di mainFrame (pojok kanan atas)
local btnMinimize = Instance.new("TextButton")
btnMinimize.Size = UDim2.new(0, 30, 0, 30)
btnMinimize.Position = UDim2.new(1, -35, 0, 5)
btnMinimize.Text = "—"
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 24
btnMinimize.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btnMinimize.TextColor3 = Color3.fromRGB(220, 220, 220)
btnMinimize.BorderSizePixel = 0
btnMinimize.Parent = mainFrame

btnMinimize.MouseButton1Click:Connect(function()
    minimized = true
    mainFrame.Visible = false
    minimizeIcon.Visible = true
end)

--====================
-- Tab Buttons Frame
--====================
local tabButtonsFrame = Instance.new("Frame")
tabButtonsFrame.Size = UDim2.new(1, 0, 0, 50)
tabButtonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tabButtonsFrame.BorderSizePixel = 0
tabButtonsFrame.Parent = mainFrame

--====================
-- Content Frame (tabs)
--====================
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -50)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.CanvasSize = UDim2.new(0, 0, 3, 0)
contentFrame.ScrollBarThickness = 8
contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.Parent = contentFrame

--====================
-- Buat Tab Button dengan toggle style
--====================
local function createTabButton(name)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    button.TextColor3 = Color3.fromRGB(220, 220, 220)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.Parent = tabButtonsFrame
    return button
end

--====================
-- Simpan konten tab dalam dictionary
--====================
local tabsContent = {}

--====================
-- Fungsi bersihkan content
--====================
local function clearContent()
    for _, v in pairs(contentFrame:GetChildren()) do
        if not v:IsA("UIListLayout") then
            v:Destroy()
        end
    end
end

--====================
-- Fungsi tampilkan tab
--====================
local function showTab(tabName)
    clearContent()
    local contentItems = tabsContent[tabName]
    if not contentItems then return end

    for _, item in ipairs(contentItems) do
        item.Parent = contentFrame
    end

    -- Special: Kalau tab Info non-scroll (disable scrollbar)
    if tabName == "Info" then
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentFrame.AbsoluteSize.Y)
        contentFrame.ScrollBarThickness = 0
        contentFrame.ScrollBarImageTransparency = 1
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    else
        contentFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
        contentFrame.ScrollBarThickness = 8
        contentFrame.ScrollBarImageTransparency = 0
        contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    end
end

--====================
-- Create Toggle Switch (On/Off)
--====================
local function createToggleSwitch(initialState)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 60, 0, 25)
    frame.BackgroundColor3 = Color3.fromRGB(70,70,70)
    frame.BorderSizePixel = 0

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 25, 0, 25)
    button.Position = UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    button.BorderSizePixel = 0
    button.Parent = frame
    button.Text = ""

    local bgOn = Color3.fromRGB(0, 180, 0)
    local bgOff = Color3.fromRGB(180, 0, 0)

    local toggled = initialState or false
    local function updateAppearance()
        if toggled then
            button.Position = UDim2.new(0.5, 5, 0, 0)
            frame.BackgroundColor3 = bgOn
        else
            button.Position = UDim2.new(0, 0, 0, 0)
            frame.BackgroundColor3 = bgOff
        end
    end
    updateAppearance()

    button.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateAppearance()
        if frame.OnToggle then
            frame.OnToggle(toggled)
        end
    end)

    -- Properties for outside script
    frame.GetState = function() return toggled end
    frame.SetState = function(state)
        toggled = state
        updateAppearance()
    end

    return frame
end

--====================
-- Create Button
--====================
local function createButton(text, width)
    width = width or 150
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, width, 0, 30)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.TextColor3 = Color3.fromRGB(230, 230, 230)
    return button
end

--====================
-- Create Speed Input (Textbox)
--====================
local function createSpeedInput(defaultVal, labelText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0.4, 0, 0.7, 0)
    inputBox.Position = UDim2.new(0.55, 0, 0.15, 0)
    inputBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    inputBox.TextColor3 = Color3.fromRGB(220,220,220)
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 18
    inputBox.ClearTextOnFocus = false
    inputBox.Text = tostring(defaultVal)
    inputBox.Parent = frame

    inputBox.FocusLost:Connect(function(enterPressed)
        local val = tonumber(inputBox.Text)
        if not val or val < 1 then
            inputBox.Text = tostring(defaultVal)
            val = defaultVal
        elseif val > 500 then
            inputBox.Text = "500"
            val = 500
        end
        if frame.OnSpeedChange then
            frame.OnSpeedChange(val)
        end
    end)

    frame.GetValue = function() return tonumber(inputBox.Text) or defaultVal end
    frame.SetValue = function(val)
        inputBox.Text = tostring(val)
    end

    return frame
end

-- ===================
-- FUNGSI UNTUK FITUR PLAYER
-- ===================

local walkSpeedDefault = 16
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local freezeEnabled = false
local renameEnabled = false
local originalNickname = Player.Name
local customNickname = nil

local character = Player.Character or Player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Fungsi update Walkspeed per frame jika toggle ON
local walkSpeedToggle
local walkSpeedInput

-- Fly mechanic sederhana
local flying = false
local flySpeedInput
local bodyGyro
local bodyVelocity

local noclipConnection
local freezeConnection

-- Toggle Walkspeed
local function updateWalkspeed(state)
    if state then
        humanoid.WalkSpeed = walkSpeedInput:GetValue()
    else
        humanoid.WalkSpeed = 16
    end
end

local function setupWalkspeed()
    if walkSpeedToggle and walkSpeedInput then
        walkSpeedInput.OnSpeedChange = function(val)
            if walkSpeedToggle:GetState() then
                humanoid.WalkSpeed = val
            end
        end
    end
end

-- Fly function toggle
local function enableFly()
    if flying then return end
    flying = true

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 4000
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
end

local function disableFly()
    flying = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end

    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
end

local function updateFly(state)
    if state then
        enableFly()
    else
        disableFly()
    end
end

-- Update fly speed
local function updateFlySpeed(val)
    if flying and bodyVelocity then
        local moveDirection = Vector3.new()
        local camera = workspace.CurrentCamera
        local camCF = camera.CFrame
        local ws = flySpeedInput:GetValue()
        local direction = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        bodyVelocity.Velocity = direction * ws
        bodyVelocity.MaxForce = Vector3.new(9e4,9e4,9e4)
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    else
        if bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(0,0,0)
        end
    end
end

-- Noclip: set CanCollide = false pada semua bagian character
local function setNoclip(state)
    if state then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            if character then
                for _, part in pairs(character:GetChildren()) do
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
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Freeze character
local function setFreeze(state)
    if state then
        freezeConnection = game:GetService("RunService").Stepped:Connect(function()
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
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                humanoid.AutoRotate = true
            end
        end
    end
end

-- Rename Nickname (mengganti DisplayName)
local function setNickname(state, newName)
    if state then
        if newName and newName ~= "" then
            Player.DisplayName = newName
            customNickname = newName
        else
            Player.DisplayName = Player.Name
        end
    else
        Player.DisplayName = Player.Name
    end
end

-- ===================
-- GUI Tab Info (deskripsi tanpa scroll)
-- ===================
local infoTabContent = {}

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 300)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 18
infoLabel.Position = UDim2.new(0, 10, 0, 10)
infoLabel.Text = [[
Chloe X Information

Status: Still under development!
There is still a possibility it may get detected if used in public.
If there is suggestions or found bugs, please report them.
Use at your own risk.

Official link Discord Chloe X!
]]

table.insert(infoTabContent, infoLabel)
tabsContent["Info"] = infoTabContent

-- ===============
-- Tab Player Content
-- ===============
local playerTabContent = {}

local function addItemToPlayerTab(item)
    item.LayoutOrder = #playerTabContent + 1
    table.insert(playerTabContent, item)
end

-- WalkSpeed toggle + input speed
local walkSpeedFrame = Instance.new("Frame")
walkSpeedFrame.Size = UDim2.new(1, 0, 0, 60)
walkSpeedFrame.BackgroundTransparency = 1
walkSpeedFrame.LayoutOrder = 1

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Parent = walkSpeedFrame
walkSpeedLabel.Size = UDim2.new(0.4, 0, 1, 0)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Text = "WalkSpeed"
walkSpeedLabel.TextColor3 = Color3.new(1,1,1)
walkSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextSize = 20

local walkSpeedToggleUI = createToggleSwitch(false)
walkSpeedToggleUI.Parent = walkSpeedFrame
walkSpeedToggleUI.Position = UDim2.new(0.42, 0, 0.2, 0)

walkSpeedInput = createSpeedInput(16, "Speed:")
walkSpeedInput.Parent = walkSpeedFrame
walkSpeedInput.Position = UDim2.new(0.65, 0, 0.15, 0)
walkSpeedInput.Size = UDim2.new(0.35, 0, 0.7, 0)

walkSpeedToggleUI.OnToggle = function(state)
    updateWalkspeed(state)
end

walkSpeedInput.OnSpeedChange = function(val)
    if walkSpeedToggleUI:GetState() then
        humanoid.WalkSpeed = val
    end
end

addItemToPlayerTab(walkSpeedFrame)

walkSpeedToggle = walkSpeedToggleUI

-- Fly Toggle + input speed
local flyFrame = Instance.new("Frame")
flyFrame.Size = UDim2.new(1, 0, 0, 60)
flyFrame.BackgroundTransparency = 1
flyFrame.LayoutOrder = 2

local flyLabel = Instance.new("TextLabel")
flyLabel.Parent = flyFrame
flyLabel.Size = UDim2.new(0.4, 0, 1, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "Fly"
flyLabel.TextColor3 = Color3.new(1,1,1)
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.Font = Enum.Font.Gotham
flyLabel.TextSize = 20

local flyToggleUI = createToggleSwitch(false)
flyToggleUI.Parent = flyFrame
flyToggleUI.Position = UDim2.new(0.42, 0, 0.2, 0)

flySpeedInput = createSpeedInput(50, "Speed:")
flySpeedInput.Parent = flyFrame
flySpeedInput.Position = UDim2.new(0.65, 0, 0.15, 0)
flySpeedInput.Size = UDim2.new(0.35, 0, 0.7, 0)

flyToggleUI.OnToggle = function(state)
    updateFly(state)
end

flySpeedInput.OnSpeedChange = function(val)
    updateFlySpeed(val)
end

addItemToPlayerTab(flyFrame)

-- NoClip toggle
local noclipFrame = Instance.new("Frame")
noclipFrame.Size = UDim2.new(1, 0, 0, 40)
noclipFrame.BackgroundTransparency = 1
noclipFrame.LayoutOrder = 3

local noclipLabel = Instance.new("TextLabel")
noclipLabel.Parent = noclipFrame
noclipLabel.Size = UDim2.new(0.7, 0, 1, 0)
noclipLabel.BackgroundTransparency = 1
noclipLabel.Text = "NoClip"
noclipLabel.TextColor3 = Color3.new(1,1,1)
noclipLabel.TextXAlignment = Enum.TextXAlignment.Left
noclipLabel.Font = Enum.Font.Gotham
noclipLabel.TextSize = 20

local noclipToggleUI = createToggleSwitch(false)
noclipToggleUI.Parent = noclipFrame
noclipToggleUI.Position = UDim2.new(0.75, 0, 0.15, 0)

noclipToggleUI.OnToggle = function(state)
    setNoclip(state)
end

addItemToPlayerTab(noclipFrame)

-- Freeze Character toggle
local freezeFrame = Instance.new("Frame")
freezeFrame.Size = UDim2.new(1, 0, 0, 40)
freezeFrame.BackgroundTransparency = 1
freezeFrame.LayoutOrder = 4

local freezeLabel = Instance.new("TextLabel")
freezeLabel.Parent = freezeFrame
freezeLabel.Size = UDim2.new(0.7, 0, 1, 0)
freezeLabel.BackgroundTransparency = 1
freezeLabel.Text = "Freeze Character"
freezeLabel.TextColor3 = Color3.new(1,1,1)
freezeLabel.TextXAlignment = Enum.TextXAlignment.Left
freezeLabel.Font = Enum.Font.Gotham
freezeLabel.TextSize = 20

local freezeToggleUI = createToggleSwitch(false)
freezeToggleUI.Parent = freezeFrame
freezeToggleUI.Position = UDim2.new(0.75, 0, 0.15, 0)

freezeToggleUI.OnToggle = function(state)
    setFreeze(state)
end

addItemToPlayerTab(freezeFrame)

-- Rename Nickname toggle + input text
local renameFrame = Instance.new("Frame")
renameFrame.Size = UDim2.new(1, 0, 0, 60)
renameFrame.BackgroundTransparency = 1
renameFrame.LayoutOrder = 5

local renameLabel = Instance.new("TextLabel")
renameLabel.Parent = renameFrame
renameLabel.Size = UDim2.new(0.35, 0, 1, 0)
renameLabel.BackgroundTransparency = 1
renameLabel.Text = "Rename Nickname"
renameLabel.TextColor3 = Color3.new(1,1,1)
renameLabel.TextXAlignment = Enum.TextXAlignment.Left
renameLabel.Font = Enum.Font.Gotham
renameLabel.TextSize = 20

local renameToggleUI = createToggleSwitch(false)
renameToggleUI.Parent = renameFrame
renameToggleUI.Position = UDim2.new(0.37, 0, 0.2, 0)

local renameInput = Instance.new("TextBox")
renameInput.Parent = renameFrame
renameInput.Size = UDim2.new(0.55, 0, 0.6, 0)
renameInput.Position = UDim2.new(0.45, 0, 0.2, 0)
renameInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
renameInput.TextColor3 = Color3.fromRGB(220, 220, 220)
renameInput.Font = Enum.Font.Gotham
renameInput.TextSize = 18
renameInput.ClearTextOnFocus = false
renameInput.PlaceholderText = "Enter New Name"

local function applyRename()
    if renameToggleUI:GetState() then
        local newName = renameInput.Text
        setNickname(true, newName)
    else
        setNickname(false)
    end
end

renameToggleUI.OnToggle = function(state)
    applyRename()
end

renameInput.FocusLost:Connect(function(enter)
    if enter then
        applyRename()
    end
end)

addItemToPlayerTab(renameFrame)

-- Delete Notification Fish button (update mencari "Small Notification")
local btnDeleteNotif = createButton("Delete Notification Fish")
btnDeleteNotif.LayoutOrder = 6
btnDeleteNotif.MouseButton1Click:Connect(function()
    local notif = PlayerGui:FindFirstChild("Small Notification")
    if notif then
        notif:Destroy()
    end
end)
table.insert(playerTabContent, btnDeleteNotif)

tabsContent["Player"] = playerTabContent

--=====================
-- Tab Server Content
--=====================
local serverTabContent = {}

-- Rejoin server button
local btnRejoin = createButton("Rejoin Server")
btnRejoin.LayoutOrder = 1
btnRejoin.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)
table.insert(serverTabContent, btnRejoin)

-- Join server via input link
local joinFrame = Instance.new("Frame")
joinFrame.Size = UDim2.new(1, 0, 0, 50)
joinFrame.BackgroundTransparency = 1
joinFrame.LayoutOrder = 2

local joinInput = Instance.new("TextBox")
joinInput.Parent = joinFrame
joinInput.PlaceholderText = "Paste server link or job id here"
joinInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
joinInput.Size = UDim2.new(0.65, 0, 0.7, 0)
joinInput.Position = UDim2.new(0, 5, 0.15, 0)
joinInput.TextColor3 = Color3.fromRGB(220,220,220)
joinInput.Font = Enum.Font.Gotham
joinInput.TextSize = 16

local btnJoinLink = createButton("Join Server", 100)
btnJoinLink.Parent = joinFrame
btnJoinLink.Position = UDim2.new(0.75, 0, 0.15, 0)

btnJoinLink.MouseButton1Click:Connect(function()
    local val = joinInput.Text
    if val and val ~= "" then
        local jobId = val:match("%d%d+")
        if jobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Player)
        else
            warn("Invalid job ID/link")
        end
    end
end)
table.insert(serverTabContent, joinFrame)

-- Random Join Server (Join server random tapi game sama)
local btnRandomJoin = createButton("Random Join Server")
btnRandomJoin.LayoutOrder = 3
btnRandomJoin.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, nil, Player)
end)
table.insert(serverTabContent, btnRandomJoin)

tabsContent["Server"] = serverTabContent

--=====================
-- Tab Teleport Content
--=====================
local teleportTabContent = {}

-- Label player list & Refresh button
local playersLabel = Instance.new("TextLabel")
playersLabel.Text = "Select Player to Teleport"
playersLabel.Size = UDim2.new(1, -60, 0, 25)
playersLabel.BackgroundTransparency = 1
playersLabel.Font = Enum.Font.Gotham
playersLabel.TextSize = 18
playersLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
playersLabel.TextXAlignment = Enum.TextXAlignment.Left
playersLabel.LayoutOrder = 1
table.insert(teleportTabContent, playersLabel)

-- Refresh Button
local btnRefreshPlayers = createButton("Refresh", 50)
btnRefreshPlayers.LayoutOrder = 1
btnRefreshPlayers.Size = UDim2.new(0, 60, 0, 25)

-- Kita buat Frame horizontal untuk label+button bersama
local playersTopFrame = Instance.new("Frame")
playersTopFrame.Size = UDim2.new(1, 0, 0, 30)
playersTopFrame.BackgroundTransparency = 1
playersTopFrame.LayoutOrder = 1
playersLabel.Parent = playersTopFrame
playersLabel.Size = UDim2.new(0.8, -10, 1, 0)
btnRefreshPlayers.Parent = playersTopFrame
btnRefreshPlayers.Position = UDim2.new(0.8, 5, 0, 0)

table.insert(teleportTabContent, playersTopFrame)

-- Dropdown list player untuk teleport
local playerDropdown = Instance.new("ScrollingFrame")
playerDropdown.Size = UDim2.new(1, -20, 0, 150)
playerDropdown.Position = UDim2.new(0, 10, 0, 0)
playerDropdown.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
playerDropdown.BorderSizePixel = 0
playerDropdown.ScrollBarThickness = 6
playerDropdown.LayoutOrder = 2
playerDropdown.Parent = contentFrame

local dropdownLayout = Instance.new("UIListLayout")
dropdownLayout.Parent = playerDropdown
dropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
dropdownLayout.Padding = UDim.new(0,3)

playerDropdown.CanvasSize = UDim2.new(0,0,0,0)

-- Function Refresh player list
local function refreshPlayersList()
    playerDropdown:ClearAllChildren()
    playerDropdown.CanvasSize = UDim2.new(0,0,0,0)
    dropdownLayout.Parent = playerDropdown

    local layoutOrder = 1
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            local btn = createButton(plr.Name, 350)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.LayoutOrder = layoutOrder
            btn.Parent = playerDropdown
            layoutOrder +=1

            btn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                end
            end)
        end
    end
    wait()
    playerDropdown.CanvasSize = UDim2.new(0,0,0,layoutOrder*35)
end

btnRefreshPlayers.MouseButton1Click:Connect(function()
    refreshPlayersList()
end)

table.insert(teleportTabContent, playerDropdown)

refreshPlayersList()

-- Save Position & Reset Position button frame horizontal
local saveResetFrame = Instance.new("Frame")
saveResetFrame.BackgroundTransparency = 1
saveResetFrame.Size = UDim2.new(1, 0, 0, 40)
saveResetFrame.LayoutOrder = #teleportTabContent + 1

-- Save Position Button
local btnSavePos = createButton("Save Position", 200)
btnSavePos.Parent = saveResetFrame
btnSavePos.Position = UDim2.new(0, 10, 0, 5)

-- Reset Position Button
local btnResetPos = createButton("Reset Position", 200)
btnResetPos.Parent = saveResetFrame
btnResetPos.Position = UDim2.new(0, 220, 0, 5)

table.insert(teleportTabContent, saveResetFrame)

local savedPos = nil

btnSavePos.MouseButton1Click:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = Player.Character.HumanoidRootPart.CFrame
        print("Position saved!")
    end
end)

btnResetPos.MouseButton1Click:Connect(function()
    if savedPos and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = savedPos
        print("Position reset!")
    end
end)

tabsContent["Teleport"] = teleportTabContent

--====================
-- Buat Tab Button dan koneksi klik untuk switch tab
--====================
local tabButtons = {}
local tabNames = {"Info", "Player", "Server", "Teleport"}

for i, tabName in ipairs(tabNames) do
    local btn = createTabButton(tabName)
    btn.LayoutOrder = i
    tabButtons[tabName] = btn

    btn.MouseButton1Click:Connect(function()
        showTab(tabName)
        for name, button in pairs(tabButtons) do
            if name == tabName then
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
            else
                button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end
        end
    end)
end

-- Tampilkan tab Info awal, set warna tab aktif
showTab("Info")
tabButtons["Info"].BackgroundColor3 = Color3.fromRGB(80, 80, 110)

--====================
-- Update loop untuk fitur yg butuh repeat (walkspeed & fly)
--====================
game:GetService("RunService").RenderStepped:Connect(function()
    if walkSpeedToggle and walkSpeedToggle:GetState() then
        humanoid.WalkSpeed = walkSpeedInput:GetValue()
    else
        if humanoid.WalkSpeed ~= 16 then
            humanoid.WalkSpeed = 16
        end
    end

    if flyToggleUI and flyToggleUI:GetState() then
        updateFlySpeed(flySpeedInput:GetValue())
    end
end)

-- Ketika karakter respawn, kirim ulang nilai toggle (untuk no clip dll)
Player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")

    -- Reset toggles agar tetap berfungsi
    if noclipToggleUI:GetState() then
        setNoclip(true)
    else
        setNoclip(false)
    end
    if freezeToggleUI:GetState() then
        setFreeze(true)
    else
        setFreeze(false)
    end
    if walkSpeedToggle:GetState() then
        humanoid.WalkSpeed = walkSpeedInput:GetValue()
    else
        humanoid.WalkSpeed = 16
    end

    if flyToggleUI:GetState() then
        enableFly()
    else
        disableFly()
    end
end)