
--// Chloe X Style UI (Server Tools v0.5) by Majid
-- EDITED FINAL: polished layout, scrollable tabs, card UI, hover, fade tab animation,
-- minimize -> draggable "D" icon (glow), teleport tab, freeze, delete notification, comments
-- Version: dujima_ui_final.lua (developer-friendly, commented)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- -----------------------------
-- Helper: safe find PlayerGui
-- -----------------------------
local function getPlayerGui()
    return LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
end

-- -----------------------------
-- Create main GUI
-- -----------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI_Final"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0, 600, 0, 400)
main.Position = UDim2.new(0.5, -300, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(12,12,12)
main.BackgroundTransparency = 0.12
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 1.2
mainStroke.Color = Color3.fromRGB(110,110,255)
mainStroke.Transparency = 0.2

-- Title
local title = Instance.new("TextLabel", main)
title.Text = "Chloe X | v0.5 — Final"
title.Size = UDim2.new(1, -120, 0, 36)
title.Position = UDim2.new(0, 16, 0, 10)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize and Close buttons container
local controls = Instance.new("Frame", main)
controls.Size = UDim2.new(0, 100, 0, 36)
controls.Position = UDim2.new(1, -120, 0, 10)
controls.BackgroundTransparency = 1

local minBtn = Instance.new("TextButton", controls)
minBtn.Name = "Minimize"
minBtn.Text = "–"
minBtn.Size = UDim2.new(0, 36, 1, 0)
minBtn.Position = UDim2.new(0, 0, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 22
minBtn.TextColor3 = Color3.fromRGB(200,200,200)

local closeBtn = Instance.new("TextButton", controls)
closeBtn.Name = "Close"
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 36, 1, 0)
closeBtn.Position = UDim2.new(0, 40, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(255,70,70)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 160, 1, -72)
sidebar.Position = UDim2.new(0, 16, 0, 56)
sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)
sidebar.BorderSizePixel = 0
local sideCorner = Instance.new("UICorner", sidebar); sideCorner.CornerRadius = UDim.new(0,10)
local sidePadding = Instance.new("UIPadding", sidebar)
sidePadding.PaddingTop = UDim.new(0,8)
sidePadding.PaddingLeft = UDim.new(0,8)
sidePadding.PaddingRight = UDim.new(0,8)
sidePadding.PaddingBottom = UDim.new(0,8)

-- Sidebar layout buttons
local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0,10)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createTabButton(name)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(230,230,230)
    local c = Instance.new("UICorner", btn); c.CornerRadius = UDim.new(0,8)
    return btn
end

-- Content area (right side)
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -200, 1, -72)
content.Position = UDim2.new(0, 188, 0, 56)
content.BackgroundTransparency = 1

-- Info Frame (non-scrollable simple info)
local infoFrame = Instance.new("Frame", content)
infoFrame.BackgroundTransparency = 1
infoFrame.Size = UDim2.new(1,0,1,0)

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Text = "Versi: ChloeX UI v0.5 (Final)\nStatus: Aktif\n\n- Semua tab scrollable\n- Fitur dibungkus kartu (card)\n- Hover & fade animations\n- Minimize -> draggable 'D' icon\n\nNote: fitur teleport memindahkan HumanoidRootPart ke target."
infoText.Size = UDim2.new(1,-20,1,-20)
infoText.Position = UDim2.new(0,10,0,10)
infoText.BackgroundTransparency = 1
infoText.TextColor3 = Color3.fromRGB(220,220,220)
infoText.TextWrapped = true
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 15
infoText.TextYAlignment = Enum.TextYAlignment.Top

-- Utility: create scrollable tab frame with automatic layout + padding
local function createScrollableTab()
    local s = Instance.new("ScrollingFrame", content)
    s.Size = UDim2.new(1,0,1,0)
    s.BackgroundTransparency = 1
    s.ScrollBarThickness = 6
    s.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local pad = Instance.new("UIPadding", s)
    pad.PaddingTop = UDim.new(0,12)
    pad.PaddingLeft = UDim.new(0,12)
    pad.PaddingRight = UDim.new(0,12)
    pad.PaddingBottom = UDim.new(0,12)
    local layout = Instance.new("UIListLayout", s)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,12) -- 12 px spacing between cards
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return s, layout
end

local serverTab, serverLayout = createScrollableTab()
local playerTab, playerLayout = createScrollableTab()
local teleportTab, teleportLayout = createScrollableTab()

-- Card factory: consistent card look and hover animation
local function createCard(parent, height)
    local card = Instance.new("Frame", parent)
    card.Size = UDim2.new(1, -24, 0, height)
    card.BackgroundColor3 = Color3.fromRGB(25,25,25)
    card.BorderSizePixel = 0
    local corner = Instance.new("UICorner", card); corner.CornerRadius = UDim.new(0,8)
    local padding = Instance.new("UIPadding", card)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingLeft = UDim.new(0,10)
    padding.PaddingRight = UDim.new(0,10)
    padding.PaddingBottom = UDim.new(0,8)

    -- hover: tween to slightly lighter color on MouseEnter/Leave
    card.Active = true
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
        end
    end)
    card.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play()
        end
    end)

    return card
end

-- Simple label helper
local function label(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = text
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(230,230,230)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- Button helper
local function makeButton(parent, text, width)
    local b = Instance.new("TextButton", parent)
    b.Text = text
    b.Size = UDim2.new(0, width or 140, 0, 32)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local c = Instance.new("UICorner", b); c.CornerRadius = UDim.new(0,6)
    return b
end

-- Slider helper (compact)
local function createSlider(parent, labelText, minVal, maxVal, defaultVal)
    label(parent, labelText)
    local sliderBg = Instance.new("Frame", parent)
    sliderBg.Size = UDim2.new(1, -120, 0, 20)
    sliderBg.Position = UDim2.new(0,10,0,26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local sc = Instance.new("UICorner", sliderBg); sc.CornerRadius = UDim.new(0,6)
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(110,110,255)
    local knob = Instance.new("ImageButton", sliderBg)
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.ImageRectOffset = Vector2.new(924,724)
    knob.ImageRectSize = Vector2.new(36,36)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(0, 80, 0, 28)
    box.Position = UDim2.new(1, -90, 0, 22)
    box.Text = tostring(defaultVal)
    box.PlaceholderText = tostring(defaultVal)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.BackgroundColor3 = Color3.fromRGB(25,25,25)
    local function setValue(v)
        v = math.clamp(tonumber(v) or minVal, minVal, maxVal)
        local pct = (v-minVal)/(maxVal-minVal)
        fill.Size = UDim2.new(pct,0,1,0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        box.Text = tostring(math.floor(v*100)/100)
        return v
    end
    local val = setValue(defaultVal)
    local dragging = false
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local rel = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            val = setValue(minVal + rel/sliderBg.AbsoluteSize.X*(maxVal-minVal))
        end
    end)
    sliderBg.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            val = setValue(minVal + rel/sliderBg.AbsoluteSize.X*(maxVal-minVal))
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)
    box.FocusLost:Connect(function(enter)
        if enter then val = setValue(tonumber(box.Text) or minVal) else box.Text = tostring(val) end
    end)
    return {
        Get = function() return val end,
        Set = function(v) val = setValue(v) end
    }
end

-- Toggle helper (returns API similar to previous)
local function createToggle(parent, text)
    label(parent, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 84, 0, 28)
    btn.Position = UDim2.new(1, -94, 0, 0)
    btn.Text = "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local uc = Instance.new("UICorner", btn); uc.CornerRadius = UDim.new(0,6)
    local state = false
    local function setState(s)
        state = s
        if state then
            btn.Text = "ON"
            btn.BackgroundColor3 = Color3.fromRGB(80,120,255)
        else
            btn.Text = "OFF"
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        end
    end
    setState(false)
    btn.MouseButton1Click:Connect(function() setState(not state) end)
    return { Button = btn, Get = function() return state end, Set = setState }
end

-- =====================
-- SERVER TAB CONTENT
-- =====================
-- Rejoin card
local rejoinCard = createCard(serverTab, 60)
do
    local b = makeButton(rejoinCard, "Rejoin Server", 160)
    b.Position = UDim2.new(0,10,0,10)
    b.MouseButton1Click:Connect(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end

-- Join by link card (fixed width so it won't overflow)
local joinCard = createCard(serverTab, 90)
do
    local lbl = label(joinCard, "Join Server To Link:")
    local linkBox = Instance.new("TextBox", joinCard)
    linkBox.PlaceholderText = "Link here"
    linkBox.Size = UDim2.new(1, -140, 0, 34)
    linkBox.Position = UDim2.new(0,10,0,28)
    linkBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
    linkBox.Font = Enum.Font.Gotham
    linkBox.TextSize = 14
    local joinBtn = makeButton(joinCard, "Join", 100)
    joinBtn.Position = UDim2.new(1, -110, 0, 28)
    joinBtn.MouseButton1Click:Connect(function()
        local link = linkBox.Text
        if not link or link == "" then return end
        local code = string.match(link, "privateServerLinkCode=([%w_-]+)")
        if code then
            local ok, err = pcall(function()
                TeleportService:TeleportToPrivateServer(game.PlaceId, code, {LocalPlayer})
            end)
            if not ok then warn("Gagal join server: "..tostring(err)) end
        else
            warn("Link server tidak valid!")
        end
    end)
end

-- =====================
-- PLAYER TAB CONTENT (cards laid out by UIListLayout)
-- =====================
-- WalkSpeed
local walkCard = createCard(playerTab, 100)
local walkToggleApi, walkSliderApi
do
    walkToggleApi = createToggle(walkCard, "WalkSpeed")
    walkSliderApi = createSlider(walkCard, "WalkSpeed Value", 8, 200, 16)
    walkToggleApi.Button.MouseButton1Click:Connect(function()
        -- handled by main loop below; keep simple here
    end)
end

-- Fly
local flyCard = createCard(playerTab, 120)
local flyToggleApi, flySliderApi
do
    flyToggleApi = createToggle(flyCard, "Fly")
    flySliderApi = createSlider(flyCard, "Fly Speed", 10, 200, 50)
end

-- NoClip
local noclipCard = createCard(playerTab, 80)
local noclipToggleApi
do
    noclipToggleApi = createToggle(noclipCard, "NoClip")
end

-- Freeze Character
local freezeCard = createCard(playerTab, 80)
local freezeToggleApi
do
    freezeToggleApi = createToggle(freezeCard, "Freeze Character")
end

-- Delete Small Notification (button)
local delCard = createCard(playerTab, 80)
do
    local delBtn = makeButton(delCard, "Delete Small Notification", 220)
    delBtn.Position = UDim2.new(0,10,0,18)
    delBtn.MouseButton1Click:Connect(function()
        local pg = getPlayerGui()
        if pg then
            local sn = pg:FindFirstChild("Small Notification")
            if sn then
                pcall(function() sn:Destroy() end)
                print("Small Notification removed.")
            else
                warn("Small Notification not found in PlayerGui.")
            end
        end
    end)
end

-- =====================
-- TELEPORT TAB CONTENT
-- =====================
local teleportCard = createCard(teleportTab, 160)
local playersScrollingFrame = Instance.new("ScrollingFrame", teleportCard)
playersScrollingFrame.Size = UDim2.new(1, -20, 0, 90)
playersScrollingFrame.Position = UDim2.new(0,10,0,36)
playersScrollingFrame.BackgroundTransparency = 1
playersScrollingFrame.ScrollBarThickness = 6
local playersLayout = Instance.new("UIListLayout", playersScrollingFrame)
playersLayout.Padding = UDim.new(0,6)
playersLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedTarget = nil
local function refreshPlayerList()
    for _,c in ipairs(playersScrollingFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local b = Instance.new("TextButton", playersScrollingFrame)
            b.Size = UDim2.new(1, -8, 0, 28)
            b.Text = pl.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            local bc = Instance.new("UICorner", b); bc.CornerRadius = UDim.new(0,6)
            b.MouseButton1Click:Connect(function()
                selectedTarget = pl
                -- highlight
                for _,ch in ipairs(playersScrollingFrame:GetChildren()) do if ch:IsA("TextButton") then ch.BackgroundColor3 = Color3.fromRGB(45,45,45) end end
                b.BackgroundColor3 = Color3.fromRGB(80,120,255)
            end)
        end
    end
end

local refreshBtn = makeButton(teleportCard, "Refresh Players", 140)
refreshBtn.Position = UDim2.new(1, -160, 0, 12)
refreshBtn.MouseButton1Click:Connect(refreshPlayerList)

local tpBtn = makeButton(teleportCard, "Teleport To Player", 180)
tpBtn.Position = UDim2.new(1, -200, 0, 56)
tpBtn.BackgroundColor3 = Color3.fromRGB(80,120,255)
tpBtn.MouseButton1Click:Connect(function()
    if not selectedTarget then warn("No player selected.") return end
    local ok, err = pcall(function()
        local targetChar = selectedTarget.Character
        local myChar = LocalPlayer.Character
        if targetChar and myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
            if targetHRP then
                myChar.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
            else
                warn("Target has no HRP/Torso.")
            end
        end
    end)
    if not ok then warn("Teleport error: "..tostring(err)) end
end)

-- initial population
refreshPlayerList()

-- =====================
-- Functionality implementations: Walk, Fly, NoClip, Freeze
-- =====================
-- WalkSpeed
local originalWalkSpeed = 16
local walkConn = nil
local function applyWalkSpeed(enabled)
    if enabled then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                originalWalkSpeed = originalWalkSpeed or hum.WalkSpeed or 16
                hum.WalkSpeed = walkSliderApi.Get()
            end
        end
        if not walkConn then
            walkConn = LocalPlayer.CharacterAdded:Connect(function(c)
                local hum = c:WaitForChild("Humanoid",5)
                if hum and walkToggleApi.Get() then hum.WalkSpeed = walkSliderApi.Get() end
            end)
        end
    else
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = originalWalkSpeed end
        end
        if walkConn then walkConn:Disconnect(); walkConn = nil end
    end
end

-- Fly (BodyVelocity)
local flyBV = nil
local flyLoop = nil
local flyState = false
local function enableFly()
    flyState = true
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.P = 1250
            flyBV.Parent = hrp
        end
    end
    if flyLoop then flyLoop:Disconnect() end
    flyLoop = RunService.RenderStepped:Connect(function()
        if not flyState then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and flyBV then
            local move = humanoid.MoveDirection
            local horiz = Vector3.new(move.X,0,move.Z) * flySliderApi.Get()
            local vert = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vert = flySliderApi.Get() end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vert = -flySliderApi.Get() end
            flyBV.Velocity = Vector3.new(horiz.X, vert, horiz.Z)
            pcall(function() humanoid.PlatformStand = false end)
        end
    end)
end
local function disableFly()
    flyState = false
    if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
end

-- NoClip
local noClipData = {enabled=false, originals={}, conns={} , charAdded=nil}
local function enableNoClipForChar(char)
    if not char then return end
    noClipData.originals = {}
    for _,part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() noClipData.originals[part] = part.CanCollide; part.CanCollide = false end)
        end
    end
    local c = char.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then pcall(function() noClipData.originals[d] = d.CanCollide; d.CanCollide = false end) end
    end)
    table.insert(noClipData.conns, c)
end
local function disableNoClip()
    for part,orig in pairs(noClipData.originals) do
        if part and part.Parent then pcall(function() part.CanCollide = orig end) end
    end
    for _,c in ipairs(noClipData.conns) do pcall(function() c:Disconnect() end) end
    noClipData.conns = {}
    noClipData.originals = {}
    noClipData.enabled = false
    if noClipData.charAdded then pcall(function() noClipData.charAdded:Disconnect() end); noClipData.charAdded = nil end
end

-- Freeze Character
local freeze = {enabled=false, conn=nil, origWalk=nil, origJump=nil, origPlatform=nil}
local function enableFreezeForChar(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    freeze.origWalk = hum.WalkSpeed
    freeze.origJump = hum.JumpPower
    freeze.origPlatform = hum.PlatformStand
    pcall(function()
        hum.WalkSpeed = 0
        hum.JumpPower = 0
        hum.PlatformStand = true
    end)
    if freeze.conn then freeze.conn:Disconnect(); freeze.conn = nil end
    freeze.conn = LocalPlayer.CharacterAdded:Connect(function(nc)
        wait(0.5)
        local nh = nc:FindFirstChildOfClass("Humanoid")
        if nh then pcall(function() nh.WalkSpeed = 0; nh.JumpPower = 0; nh.PlatformStand = true end) end
    end)
end
local function disableFreeze()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function()
            if freeze.origWalk then hum.WalkSpeed = freeze.origWalk end
            if freeze.origJump then hum.JumpPower = freeze.origJump end
            hum.PlatformStand = freeze.origPlatform or false
        end) end
    end
    if freeze.conn then freeze.conn:Disconnect(); freeze.conn = nil end
    freeze.origWalk = nil; freeze.origJump = nil; freeze.origPlatform = nil
    freeze.enabled = false
end

-- Wiring toggles to functionality
walkToggleApi.Button.MouseButton1Click:Connect(function()
    walkToggleApi.Set(not walkToggleApi.Get())
    applyWalkSpeed(walkToggleApi.Get())
end)

flyToggleApi.Button.MouseButton1Click:Connect(function()
    flyToggleApi.Set(not flyToggleApi.Get())
    if flyToggleApi.Get() then enableFly() else disableFly() end
end)

noclipToggleApi.Button.MouseButton1Click:Connect(function()
    noclipToggleApi.Set(not noclipToggleApi.Get())
    if noclipToggleApi.Get() then
        noClipData.enabled = true
        if LocalPlayer.Character then enableNoClipForChar(LocalPlayer.Character) end
        if not noClipData.charAdded then
            noClipData.charAdded = LocalPlayer.CharacterAdded:Connect(function(ch) if noClipData.enabled then ch:WaitForChild("Humanoid",5); enableNoClipForChar(ch) end end)
        end
    else
        disableNoClip()
    end
end)

freezeToggleApi.Button.MouseButton1Click:Connect(function()
    local newState = not freezeToggleApi.Get()
    freezeToggleApi.Set(newState)
    freeze.enabled = newState
    if newState then
        if LocalPlayer.Character then enableFreezeForChar(LocalPlayer.Character) end
    else
        disableFreeze()
    end
end)

-- Apply walk slider live while enabled
spawn(function()
    local last = walkSliderApi.Get()
    while gui and gui.Parent do
        local cur = walkSliderApi.Get()
        if cur ~= last then
            last = cur
            if walkToggleApi.Get() then
                local char = LocalPlayer.Character
                if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum.WalkSpeed = cur end end
            end
        end
        wait(0.15)
    end
end)

-- Reapply on respawn if toggles active
LocalPlayer.CharacterAdded:Connect(function(char)
    spawn(function()
        local hum = char:WaitForChild("Humanoid",5)
        if hum then
            if walkToggleApi.Get() then hum.WalkSpeed = walkSliderApi.Get() end
            if flyToggleApi.Get() then enableFly() end
            if noclipToggleApi.Get() then enableNoClipForChar(char) end
            if freeze.enabled then pcall(function() hum.WalkSpeed = 0; hum.JumpPower = 0; hum.PlatformStand = true end) end
        end
    end)
end)

-- =====================
-- Tab fade in/out animation helpers (simple recursive transparency tweens)
-- =====================
local function setGuiTransparencyRecursive(frame, transparency)
    if frame:IsA("TextLabel") or frame:IsA("TextButton") or frame:IsA("TextBox") then
        frame.TextTransparency = transparency
    end
    if frame:IsA("ImageLabel") or frame:IsA("ImageButton") then
        frame.ImageTransparency = transparency
    end
    if frame:IsA("Frame") or frame:IsA("ScrollingFrame") then
        frame.BackgroundTransparency = transparency * 0.9
    end
    for _,c in ipairs(frame:GetChildren()) do
        setGuiTransparencyRecursive(c, transparency)
    end
end

local function fadeInFrame(frame)
    frame.Visible = true
    setGuiTransparencyRecursive(frame, 1)
    local start = tick(); local dur = 0.22
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local p = math.clamp((tick()-start)/dur,0,1)
        setGuiTransparencyRecursive(frame, 1 - p)
        if p >= 1 then conn:Disconnect() end
    end)
end

local function fadeOutFrame(frame)
    local start = tick(); local dur = 0.18
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local p = math.clamp((tick()-start)/dur,0,1)
        setGuiTransparencyRecursive(frame, p)
        if p >= 1 then conn:Disconnect(); frame.Visible = false end
    end)
end

-- Tabs and wiring
local tabs = {}
tabs.Info = createTabButton("Info")
tabs.Server = createTabButton("Server")
tabs.Player = createTabButton("Player")
tabs.Teleport = createTabButton("Teleport")

local function deselectAllTabs()
    for _,v in pairs(tabs) do
        v.BackgroundColor3 = Color3.fromRGB(30,30,30)
    end
end

local currentFrame = infoFrame
local function selectTab(name)
    deselectAllTabs()
    tabs[name].BackgroundColor3 = Color3.fromRGB(80,80,120)
    if currentFrame then fadeOutFrame(currentFrame) end
    if name == "Info" then fadeInFrame(infoFrame); currentFrame = infoFrame end
    if name == "Server" then fadeInFrame(serverTab); currentFrame = serverTab end
    if name == "Player" then fadeInFrame(playerTab); currentFrame = playerTab end
    if name == "Teleport" then fadeInFrame(teleportTab); currentFrame = teleportTab end
end

tabs.Info.MouseButton1Click:Connect(function() selectTab("Info") end)
tabs.Server.MouseButton1Click:Connect(function() selectTab("Server") end)
tabs.Player.MouseButton1Click:Connect(function() selectTab("Player") end)
tabs.Teleport.MouseButton1Click:Connect(function() selectTab("Teleport") end)

-- start on Info
selectTab("Info")

-- Update CanvasSize for scrolling frames after small delay to ensure layout measured
delay(0.14, function()
    serverTab.CanvasSize = UDim2.new(0,0,0, serverTab.UIListLayout.AbsoluteContentSize.Y)
    playerTab.CanvasSize = UDim2.new(0,0,0, playerTab.UIListLayout.AbsoluteContentSize.Y)
    teleportTab.CanvasSize = UDim2.new(0,0,0, teleportTab.UIListLayout.AbsoluteContentSize.Y)
end)

-- Keep canvas sizes updated
serverTab.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() serverTab.CanvasSize = UDim2.new(0,0,0, serverTab.UIListLayout.AbsoluteContentSize.Y) end)
playerTab.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() playerTab.CanvasSize = UDim2.new(0,0,0, playerTab.UIListLayout.AbsoluteContentSize.Y) end)
teleportTab.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() teleportTab.CanvasSize = UDim2.new(0,0,0, teleportTab.UIListLayout.AbsoluteContentSize.Y) end)

-- =====================
-- Minimize -> draggable "D" icon implementation
-- =====================
local dIcon = Instance.new("ImageButton", gui)
dIcon.Name = "MinIcon"
dIcon.Size = UDim2.new(0, 52, 0, 52)
dIcon.Position = UDim2.new(1, -86, 1, -106) -- default: bottom-right-ish
dIcon.AnchorPoint = Vector2.new(0,0)
dIcon.BackgroundColor3 = Color3.fromRGB(20,20,30)
dIcon.AutoButtonColor = true
dIcon.BorderSizePixel = 0
dIcon.Visible = false -- hidden initially
dIcon.ZIndex = 999
local dCorner = Instance.new("UICorner", dIcon); dCorner.CornerRadius = UDim.new(0,12)
local dLabel = Instance.new("TextLabel", dIcon)
dLabel.Size = UDim2.new(1,0,1,0)
dLabel.BackgroundTransparency = 1
dLabel.Text = "D"
dLabel.Font = Enum.Font.GothamBold
dLabel.TextSize = 26
dLabel.TextColor3 = Color3.fromRGB(205,235,255)
dLabel.ZIndex = 1000
dLabel.TextStrokeTransparency = 0.8

-- Glow effect behind icon
local glow = Instance.new("ImageLabel", dIcon)
glow.Size = UDim2.new(1.8,0,1.8,0)
glow.Position = UDim2.new(-0.4,0,-0.4,0)
glow.Image = "rbxassetid://3570695787"
glow.BackgroundTransparency = 1
glow.ImageColor3 = Color3.fromRGB(100,150,255)
glow.ImageTransparency = 0.85
glow.ZIndex = 998

-- draggable behaviour (manual)
local dragging = false
local dragStartPos, iconStartPos = nil, nil
dIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = input.Position
        iconStartPos = dIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragStartPos and iconStartPos then
        local mouseLoc = UserInputService:GetMouseLocation()
        local delta = mouseLoc - dragStartPos
        local newX = iconStartPos.X.Offset + delta.X
        local newY = iconStartPos.Y.Offset + delta.Y
        dIcon.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- hover effects on icon
dIcon.MouseEnter:Connect(function()
    TweenService:Create(glow, TweenInfo.new(0.18), {ImageTransparency = 0.45}):Play()
    TweenService:Create(dIcon, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30,30,45)}):Play()
end)
dIcon.MouseLeave:Connect(function()
    TweenService:Create(glow, TweenInfo.new(0.18), {ImageTransparency = 0.85}):Play()
    TweenService:Create(dIcon, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(20,20,30)}):Play()
end)

-- Minimize button: hide main and show icon
minBtn.MouseButton1Click:Connect(function()
    fadeOutFrame(main)
    delay(0.18, function()
        dIcon.Visible = true
        TweenService:Create(glow, TweenInfo.new(0.2), {ImageTransparency = 0.85}):Play()
    end)
end)

-- Restore main from icon
dIcon.MouseButton1Click:Connect(function()
    dIcon.Visible = false
    fadeInFrame(main)
end)

-- Close button: destroy GUI
closeBtn.MouseButton1Click:Connect(function() pcall(function() gui:Destroy() end) end)

-- Safety: hide icon if GUI destroyed externally
gui.DescendantRemoving:Connect(function(desc)
    if desc == main then
        if dIcon and dIcon.Parent then dIcon.Visible = false end
    end
end)

-- done
