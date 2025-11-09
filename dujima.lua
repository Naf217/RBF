--// Chloe X Style UI (Server Tools v0.7) by Majid (Recode: cleaned, scrollable, Freeze + Delete Notification, bug fixes)
-- Reworked to reduce GUI bugs (clean connection handling, scrollable tabs, consistent layout)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Safety: if coregui not available, fallback to PlayerGui
local parentGui = game:GetService("CoreGui")
if not parentGui then
    parentGui = LocalPlayer:WaitForChild("PlayerGui", 5)
end

-- Destroy previous UI if exists
pcall(function()
    local existing = parentGui:FindFirstChild("ChloeX_UI")
    if existing then existing:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = parentGui
gui.ResetOnSpawn = false

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.5, -260, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.28
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.4
stroke.Color = Color3.fromRGB(110, 110, 255)
stroke.Transparency = 0.2
stroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Text = "Chloe X | v0.7"
title.Size = UDim2.new(1, -50, 0, 32)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Close Button
local close = Instance.new("TextButton")
close.Name = "Close"
close.Text = "×"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255, 70, 70)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.Parent = main
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -70)
sidebar.Position = UDim2.new(0, 15, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BackgroundTransparency = 0.23
sidebar.Parent = main

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 10)
sideCorner.Parent = sidebar

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -160, 1, -90)
content.Position = UDim2.new(0, 145, 0, 50)
content.BackgroundTransparency = 1
content.Parent = main

-- Tab creation helper
local function createTab(name, index)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "_Tab"
    tab.Text = name
    tab.Size = UDim2.new(1, -20, 0, 36)
    tab.Position = UDim2.new(0, 10, 0, (index - 1) * 45 + 5)
    tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tab.TextColor3 = Color3.fromRGB(230, 230, 230)
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 16
    tab.Parent = sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = tab

    tab.MouseEnter:Connect(function()
        if not tab.Selected then
            tab.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end
    end)

    tab.MouseLeave:Connect(function()
        if not tab.Selected then
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end)

    return tab
end

-- Make a scrollable page
local function makeScrollablePage(parent)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Parent = parent

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.Size = UDim2.new(1, -10, 1, 0)
    scroll.Position = UDim2.new(0, 5, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scroll.Parent = page

    local uiList = Instance.new("UIListLayout")
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 8)
    uiList.Parent = scroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = scroll

    return page, scroll, uiList
end

-- Info page (simple, not scroll heavy)
local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, 0, 1, 0)
infoFrame.BackgroundTransparency = 1
infoFrame.Parent = content

local infoText = Instance.new("TextLabel")
infoText.Text = "Versi: ChloeX UI v0.7\nStatus: Aktif\n\nUI besar, clean, dan rapi seperti Chloe X."
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 17
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.BackgroundTransparency = 1
infoText.Parent = infoFrame

-- Server page (scrollable)
local serverPage, serverScroll = makeScrollablePage(content)
serverPage.Visible = false

-- Player page (scrollable)
local playerPage, playerScroll = makeScrollablePage(content)
playerPage.Visible = false

-- Utility helper to add a full-width button inside a scrolling frame
local function addFullButton(scrollFrame, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text
    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0,8)
    uc.Parent = btn
    btn.Parent = scrollFrame
    return btn
end

-- Utility helper to create label + toggle (aligned)
local function addLabelToggle(scrollFrame, labelText, defaultState)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 36)
    container.BackgroundTransparency = 1
    container.Parent = scrollFrame

    local lbl = Instance.new("TextLabel")
    lbl.Text = labelText
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0.7, 0)
    btn.Position = UDim2.new(0.72, 0, 0.15, 0)
    btn.Text = defaultState and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(80,120,255) or Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = container

    local uc = Instance.new("UICorner")
    uc.CornerRadius = UDim.new(0,6)
    uc.Parent = btn

    local state = defaultState or false
    local function setState(s)
        state = s
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(80,120,255) or Color3.fromRGB(60,60,60)
    end

    btn.MouseButton1Click:Connect(function()
        setState(not state)
        -- expose event: state changed -> call handlers if needed
        if container._OnToggle then
            container._OnToggle(state)
        end
    end)

    -- API
    container.Set = setState
    container.Get = function() return state end
    container.Button = btn
    return container
end

-- Utility helper to add slider with textbox (compact vertical)
local function addSlider(scrollFrame, labelText, minVal, maxVal, defaultVal)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = scrollFrame

    local lbl = Instance.new("TextLabel")
    lbl.Text = labelText
    lbl.Size = UDim2.new(0.6, 0, 0, 18)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.6, 0, 0, 14)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0,6)
    sCorner.Parent = sliderBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(110,110,255)
    fill.Parent = sliderBg
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0,6)
    fCorner.Parent = fill

    local knob = Instance.new("ImageButton")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.ImageRectOffset = Vector2.new(924, 724)
    knob.ImageRectSize = Vector2.new(36, 36)
    knob.Parent = sliderBg

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.28, 0, 0, 28)
    box.Position = UDim2.new(0.68, 0, 0, 18)
    box.Text = tostring(defaultVal)
    box.PlaceholderText = tostring(defaultVal)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.BackgroundColor3 = Color3.fromRGB(25,25,25)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,6)
    bc.Parent = box
    box.Parent = container

    local dragging = false
    local val = defaultVal

    local function setValue(v)
        v = math.clamp(tonumber(v) or minVal, minVal, maxVal)
        val = v
        local pct = (val - minVal)/(maxVal - minVal)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        box.Text = tostring(math.floor(val*100)/100)
    end

    local function updateFromInput(inputPos)
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local relativeX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
        local pct = relativeX / absSize.X
        setValue(minVal + pct*(maxVal - minVal))
        if container._OnChange then container._OnChange(val) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input.Position)
        end
    end)
    sliderBg.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
        end
    end)

    box.FocusLost:Connect(function(enter)
        if enter then setValue(tonumber(box.Text) or minVal) else box.Text = tostring(val) end
        if container._OnChange then container._OnChange(val) end
    end)

    setValue(defaultVal)

    container.Get = function() return val end
    container.Set = setValue
    return container
end

-- ===============
-- Server page content (rejoin + join private)
-- ===============
-- Rejoin button (full width)
local rejoinBtn = addFullButton(serverScroll, "Rejoin Server")
rejoinBtn.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

-- Join by private server link (label + text box + button)
local joinContainer = Instance.new("Frame")
joinContainer.Size = UDim2.new(1, -16, 0, 64)
joinContainer.BackgroundTransparency = 1
joinContainer.Parent = serverScroll

local joinLabel = Instance.new("TextLabel")
joinLabel.Text = "Join Server To Link:"
joinLabel.Size = UDim2.new(0.6, 0, 0, 20)
joinLabel.Position = UDim2.new(0, 0, 0, 6)
joinLabel.BackgroundTransparency = 1
joinLabel.TextColor3 = Color3.fromRGB(255,255,255)
joinLabel.Font = Enum.Font.GothamBold
joinLabel.TextSize = 14
joinLabel.TextXAlignment = Enum.TextXAlignment.Left
joinLabel.Parent = joinContainer

local linkBox = Instance.new("TextBox")
linkBox.PlaceholderText = "Link server..."
linkBox.Size = UDim2.new(0.95, 0, 0, 28)
linkBox.Position = UDim2.new(0, 0, 0, 28)
linkBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
linkBox.TextColor3 = Color3.fromRGB(255,255,255)
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 14
linkBox.TextXAlignment = Enum.TextXAlignment.Left
linkBox.Parent = joinContainer
local linkCorner = Instance.new("UICorner")
linkCorner.CornerRadius = UDim.new(0,6)
linkCorner.Parent = linkBox

local joinBtn = Instance.new("TextButton")
joinBtn.Size = UDim2.new(0.4, 0, 0, 28)
joinBtn.Position = UDim2.new(0.58, 0, 0, 28)
joinBtn.Text = "Join"
joinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 14
joinBtn.TextColor3 = Color3.fromRGB(255,255,255)
joinBtn.Parent = joinContainer
local joinCorner = Instance.new("UICorner")
joinCorner.CornerRadius = UDim.new(0,6)
joinCorner.Parent = joinBtn

joinBtn.MouseButton1Click:Connect(function()
    local link = linkBox.Text or ""
    local code = string.match(link, "privateServerLinkCode=([%w_-]+)")
    if code then
        local success, err = pcall(function()
            TeleportService:TeleportToPrivateServer(game.PlaceId, code, { LocalPlayer })
        end)
        if not success then warn("Gagal join server: "..tostring(err)) end
    else
        warn("Link server tidak valid!")
    end
end)

-- ===============
-- Player page content (WalkSpeed, Fly, NoClip, Freeze, Delete Notification)
-- ===============
-- WalkSpeed
local walkToggle = addLabelToggle(playerScroll, "WalkSpeed", false)
local walkSlider = addSlider(playerScroll, "WalkSpeed Value", 8, 200, 16)

-- Fly
local flyToggle = addLabelToggle(playerScroll, "Fly", false)
local flySlider = addSlider(playerScroll, "Fly Speed", 10, 200, 50)

-- NoClip
local noclipToggle = addLabelToggle(playerScroll, "NoClip", false)

-- Freeze Character
local freezeToggle = addLabelToggle(playerScroll, "Freeze Character", false)

-- Delete Small Notification (button)
local deleteNotifBtn = addFullButton(playerScroll, "Delete Small Notification")

-- explanatory note
local note = Instance.new("TextLabel")
note.Text = "Fly: gunakan WASD / virtual-stick untuk gerak horizontal.\nNaik: tombol Jump. Turun: tahan Shift (PC) atau sentuh 2 jari (mobile).\nNoClip: tembus objek saat aktif."
note.Size = UDim2.new(1, -16, 0, 48)
note.TextWrapped = true
note.TextYAlignment = Enum.TextYAlignment.Top
note.BackgroundTransparency = 1
note.TextColor3 = Color3.fromRGB(200,200,200)
note.Font = Enum.Font.Gotham
note.TextSize = 13
note.Parent = playerScroll

-- ===============
-- Functionality implementation with safe connection handling
-- ===============
-- WalkSpeed handling
local originalWalkSpeed = 16
local walkConn = nil
local walkHeartbeat = nil

local function applyWalkSpeedToHumanoid(hum, speed)
    if hum and hum:IsA("Humanoid") then
        pcall(function() hum.WalkSpeed = speed end)
    end
end

local function enableWalkFeature(enabled)
    if enabled then
        -- set current
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                originalWalkSpeed = originalWalkSpeed or hum.WalkSpeed or 16
                applyWalkSpeedToHumanoid(hum, walkSlider.Get())
            end
        end
        -- listen for respawn
        if not walkConn then
            walkConn = LocalPlayer.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid", 5)
                if hum then
                    applyWalkSpeedToHumanoid(hum, walkSlider.Get())
                end
            end)
        end
        -- live update loop
        if not walkHeartbeat then
            walkHeartbeat = RunService.Heartbeat:Connect(function()
                if walkToggle.Get() then
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            applyWalkSpeedToHumanoid(hum, walkSlider.Get())
                        end
                    end
                end
            end)
        end
    else
        -- disable
        if walkConn then walkConn:Disconnect(); walkConn = nil end
        if walkHeartbeat then walkHeartbeat:Disconnect(); walkHeartbeat = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function() hum.WalkSpeed = originalWalkSpeed end)
            end
        end
    end
end

-- Walk toggle behaviour
walkToggle._OnToggle = function(state)
    enableWalkFeature(state)
end
-- live slider change
walkSlider._OnChange = function(v)
    if walkToggle.Get() then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then applyWalkSpeedToHumanoid(hum, v) end
        end
    end
end

-- Fly handling
local flyState = { enabled = false }
local flyBV = nil
local flyLoop = nil
local touchCount = 0
local shiftDown = false
local ascendFlag = false

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then touchCount = touchCount + 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then shiftDown = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then touchCount = math.max(0, touchCount - 1) end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then shiftDown = false end
end)

local function enableFlyForChar(char)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if not humanoid or not hrp then return end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.P = 1250
    flyBV.Velocity = Vector3.new(0,0,0)
    flyBV.Parent = hrp
    pcall(function() humanoid.PlatformStand = false end)
end

local function startFlyLoop()
    if flyLoop then return end
    flyLoop = RunService.RenderStepped:Connect(function(dt)
        if not flyState.enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not hrp then return end
        if not flyBV or not flyBV.Parent then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.P = 1250
            flyBV.Parent = hrp
        else
            flyBV.Parent = hrp
        end
        local moveDir = humanoid.MoveDirection or Vector3.new(0,0,0)
        local horizPart = Vector3.new(moveDir.X, 0, moveDir.Z) * flySlider.Get()
        local vert = 0
        if ascendFlag then
            vert = flySlider.Get()
        elseif shiftDown or touchCount >= 2 then
            vert = -flySlider.Get()
        else
            vert = 0
        end
        local targetVel = Vector3.new(horizPart.X, vert, horizPart.Z)
        if flyBV then flyBV.Velocity = targetVel end
        pcall(function() humanoid.PlatformStand = false end)
    end)
end

local function stopFlyLoop()
    if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
end

local function handleFly(enabled)
    flyState.enabled = enabled
    if enabled then
        if LocalPlayer.Character then enableFlyForChar(LocalPlayer.Character) end
        if not Players.CharacterAdded then end
        -- Reapply on respawn
        if not flyState.charConn then
            flyState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if flyState.enabled then
                    char:WaitForChild("HumanoidRootPart", 5)
                    enableFlyForChar(char)
                end
            end)
        end
        startFlyLoop()
    else
        stopFlyLoop()
        if flyState.charConn then flyState.charConn:Disconnect(); flyState.charConn = nil end
    end
end

flyToggle._OnToggle = function(state)
    handleFly(state)
end
flySlider._OnChange = function(v)
    if flyToggle.Get() then flyState.speed = v end
end

-- NoClip handling
local noClipState = { enabled = false, originals = {}, connections = {} , charConn = nil }

local function enableNoClipForChar(char)
    if not char then return end
    -- clear previous map
    noClipState.originals = {}
    for _, desc in ipairs(char:GetDescendants()) do
        if desc:IsA("BasePart") then
            local ok, prev = pcall(function() return desc.CanCollide end)
            if ok then
                noClipState.originals[desc] = prev
                pcall(function() desc.CanCollide = false end)
            end
        end
    end
    local conn = char.DescendantAdded:Connect(function(desc)
        if desc:IsA("BasePart") then
            local ok, prev = pcall(function() return desc.CanCollide end)
            if ok then
                noClipState.originals[desc] = prev
                pcall(function() desc.CanCollide = false end)
            end
        end
    end)
    table.insert(noClipState.connections, conn)
end

local function disableNoClip()
    for part, prev in pairs(noClipState.originals) do
        if part and part.Parent then
            pcall(function() part.CanCollide = prev end)
        end
    end
    for _, c in ipairs(noClipState.connections) do
        pcall(function() c:Disconnect() end)
    end
    noClipState.connections = {}
    noClipState.originals = {}
    if noClipState.charConn then pcall(function() noClipState.charConn:Disconnect() end) noClipState.charConn = nil end
    noClipState.enabled = false
end

local function handleNoClip(enabled)
    if enabled then
        noClipState.enabled = true
        if LocalPlayer.Character then enableNoClipForChar(LocalPlayer.Character) end
        if not noClipState.charConn then
            noClipState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if noClipState.enabled then
                    char:WaitForChild("Humanoid", 5)
                    enableNoClipForChar(char)
                end
            end)
        end
    else
        disableNoClip()
    end
end

noclipToggle._OnToggle = function(state)
    handleNoClip(state)
end

-- Freeze Character handling
local freezeState = { enabled = false, original = {} }
local function setFreeze(enabled)
    freezeState.enabled = enabled
    local char = LocalPlayer.Character
    if enabled then
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                freezeState.original.walk = hum.WalkSpeed
                freezeState.original.jump = hum.JumpPower
                freezeState.original.platform = hum.PlatformStand
                freezeState.original.autorotate = hum.AutoRotate
                pcall(function()
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                    hum.AutoRotate = false
                end)
            end
        end
        -- ensure future respawns are frozen too
        if not freezeState.charConn then
            freezeState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if freezeState.enabled then
                    local hum = char:WaitForChild("Humanoid", 5)
                    if hum then
                        pcall(function()
                            hum.WalkSpeed = 0
                            hum.JumpPower = 0
                            hum.PlatformStand = true
                            hum.AutoRotate = false
                        end)
                    end
                end
            end)
        end
    else
        -- unfreeze and restore
        if freezeState.charConn then freezeState.charConn:Disconnect(); freezeState.charConn = nil end
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum.WalkSpeed = freezeState.original.walk or 16
                    hum.JumpPower = freezeState.original.jump or 50
                    hum.PlatformStand = freezeState.original.platform or false
                    hum.AutoRotate = freezeState.original.autorotate or true
                end)
            end
        end
    end
end

freezeToggle._OnToggle = function(state)
    setFreeze(state)
end

-- Delete Small Notification button action
deleteNotifBtn.MouseButton1Click:Connect(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local notif = pg:FindFirstChild("Small Notification")
        if notif then
            pcall(function() notif:Destroy() end)
        end
    end
end)

-- Reapply features on respawn if toggles are active
LocalPlayer.CharacterAdded:Connect(function(char)
    spawn(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            -- walk
            if walkToggle.Get() then
                applyWalkSpeedToHumanoid(hum, walkSlider.Get())
            end
            -- fly
            if flyToggle.Get() then
                enableFlyForChar(char)
            end
            -- noclip
            if noclipToggle.Get() then
                enableNoClipForChar(char)
            end
            -- freeze
            if freezeToggle.Get() then
                pcall(function()
                    freezeState.original.walk = hum.WalkSpeed
                    freezeState.original.jump = hum.JumpPower
                    hum.WalkSpeed = 0
                    hum.JumpPower = 0
                    hum.PlatformStand = true
                    hum.AutoRotate = false
                end)
            end
        end
    end)
end)

-- Tabs wiring
local tabInfo = createTab("Info", 1)
local tabServer = createTab("Server", 2)
local tabPlayer = createTab("Player", 3)

local function selectTab(t)
    for _, v in ipairs(sidebar:GetChildren()) do
        if v:IsA("TextButton") then
            v.Selected = false
            v.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
    end
    t.Selected = true
    t.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
end

tabInfo.MouseButton1Click:Connect(function()
    selectTab(tabInfo)
    infoFrame.Visible = true
    serverPage.Visible = false
    playerPage.Visible = false
end)

tabServer.MouseButton1Click:Connect(function()
    selectTab(tabServer)
    infoFrame.Visible = false
    serverPage.Visible = true
    playerPage.Visible = false
end)

tabPlayer.MouseButton1Click:Connect(function()
    selectTab(tabPlayer)
    infoFrame.Visible = false
    serverPage.Visible = false
    playerPage.Visible = true
end)

-- default select
selectTab(tabInfo)

-- Ensure cleanup on GUI destroy
gui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        -- disconnect/cleanup all connections created above
        if walkConn then pcall(function() walkConn:Disconnect() end); walkConn = nil end
        if walkHeartbeat then pcall(function() walkHeartbeat:Disconnect() end); walkHeartbeat = nil end
        if flyLoop then pcall(function() flyLoop:Disconnect() end); flyLoop = nil end
        if flyState.charConn then pcall(function() flyState.charConn:Disconnect() end); flyState.charConn = nil end
        if noClipState.charConn then pcall(function() noClipState.charConn:Disconnect() end); noClipState.charConn = nil end
        if freezeState.charConn then pcall(function() freezeState.charConn:Disconnect() end); freezeState.charConn = nil end
        stopFlyLoop()
        disableNoClip()
    end
end)

-- End of script
