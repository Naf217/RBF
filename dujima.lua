--// Chloe X Style UI (Server Tools v0.8) by Majid (Final fix: stable layout, scrollable tabs, all features)
-- Features: Info / Server / Player tabs, Server: Rejoin + Join private, Player: WalkSpeed, Fly, NoClip, Freeze Character, Delete Small Notification
-- Robust: proper parenting, UIListLayout for ScrollFrames, clean connection handling, restore on respawn

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Parent GUI to CoreGui if possible, otherwise PlayerGui
local guiParent = game:GetService("CoreGui")
if not guiParent then
    guiParent = LocalPlayer:WaitForChild("PlayerGui", 5)
end

-- Remove old instance safely
pcall(function()
    local old = guiParent:FindFirstChild("ChloeX_UI")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.ResetOnSpawn = false
gui.Parent = guiParent

-- Main window
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 520, 0, 360)
main.Position = UDim2.new(0.5, -260, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(0,0,0)
main.BackgroundTransparency = 0.28
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 1.4
mainStroke.Color = Color3.fromRGB(110,110,255)
mainStroke.Transparency = 0.2

-- Title + Close
local title = Instance.new("TextLabel", main)
title.Name = "Title"
title.Text = "Chloe X | v0.8"
title.Size = UDim2.new(1, -50, 0, 32)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", main)
close.Name = "Close"
close.Text = "×"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255,70,70)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -80)
sidebar.Position = UDim2.new(0, 15, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15,15,15)
sidebar.BackgroundTransparency = 0.23
local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0,10)

-- Content area
local content = Instance.new("Frame", main)
content.Name = "Content"
content.Size = UDim2.new(1, -160, 1, -90)
content.Position = UDim2.new(0, 145, 0, 50)
content.BackgroundTransparency = 1

-- helper: create tab button
local function createTabButton(name, index)
    local tab = Instance.new("TextButton")
    tab.Name = name.."_Tab"
    tab.Text = name
    tab.Size = UDim2.new(1, -20, 0, 36)
    tab.Position = UDim2.new(0, 10, 0, (index - 1) * 45 + 5)
    tab.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tab.TextColor3 = Color3.fromRGB(230,230,230)
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 16
    tab.Parent = sidebar
    local uc = Instance.new("UICorner", tab)
    uc.CornerRadius = UDim.new(0,8)
    -- hover effects
    tab.MouseEnter:Connect(function() if not tab.Selected then tab.BackgroundColor3 = Color3.fromRGB(55,55,55) end end)
    tab.MouseLeave:Connect(function() if not tab.Selected then tab.BackgroundColor3 = Color3.fromRGB(30,30,30) end end)
    return tab
end

-- helper: create scrollable page with UIListLayout
local function createScrollablePage(parent)
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1,0,1,0)
    page.BackgroundTransparency = 1
    page.Parent = parent

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll"
    scroll.Size = UDim2.new(1, -12, 1, 0)
    scroll.Position = UDim2.new(0, 6, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = page

    local layout = Instance.new("UIListLayout", scroll)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,8)

    local padding = Instance.new("UIPadding", scroll)
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingLeft = UDim.new(0,8)
    padding.PaddingRight = UDim.new(0,8)

    return page, scroll, layout
end

-- create pages
local infoPage = Instance.new("Frame", content)
infoPage.Size = UDim2.new(1,0,1,0)
infoPage.BackgroundTransparency = 1
local serverPage, serverScroll, serverLayout = createScrollablePage(content)
serverPage.Visible = false
local playerPage, playerScroll, playerLayout = createScrollablePage(content)
playerPage.Visible = false

-- Info content
local infoLabel = Instance.new("TextLabel", infoPage)
infoLabel.Text = "Versi: ChloeX UI v0.8\nStatus: Aktif\n\nUI besar, clean, dan rapi seperti Chloe X."
infoLabel.Position = UDim2.new(0,10,0,10)
infoLabel.Size = UDim2.new(1,-20,1,-20)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.fromRGB(230,230,230)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 17
infoLabel.TextWrapped = true
infoLabel.TextYAlignment = Enum.TextYAlignment.Top

-- UI factory helpers for scroll contents
local function createFullButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text
    btn.LayoutOrder = #parent:GetChildren() + 1
    local uc = Instance.new("UICorner", btn)
    uc.CornerRadius = UDim.new(0,8)
    btn.Parent = parent
    return btn
end

local function createLabelToggle(parent, labelText, default)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 36)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #parent:GetChildren() + 1
    container.Parent = parent

    local lbl = Instance.new("TextLabel", container)
    lbl.Text = labelText
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.28, 0, 0.7, 0)
    btn.Position = UDim2.new(0.72, 0, 0.15, 0)
    btn.Text = default and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = default and Color3.fromRGB(80,120,255) or Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    local uc = Instance.new("UICorner", btn)
    uc.CornerRadius = UDim.new(0,6)

    local state = default and true or false
    local function setState(s)
        state = s
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(80,120,255) or Color3.fromRGB(60,60,60)
    end

    btn.MouseButton1Click:Connect(function()
        setState(not state)
        if container.OnToggle then
            pcall(function() container.OnToggle(state) end)
        end
    end)

    container.Set = setState
    container.Get = function() return state end
    container.Button = btn
    return container
end

local function createSlider(parent, labelText, minv, maxv, default)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 0, 60)
    container.BackgroundTransparency = 1
    container.LayoutOrder = #parent:GetChildren() + 1
    container.Parent = parent

    local lbl = Instance.new("TextLabel", container)
    lbl.Text = labelText
    lbl.Size = UDim2.new(0.6, 0, 0, 18)
    lbl.Position = UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(235,235,235)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", container)
    sliderBg.Size = UDim2.new(0.6, 0, 0, 14)
    sliderBg.Position = UDim2.new(0, 0, 0, 22)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sliderBg.BorderSizePixel = 0
    local sCorner = Instance.new("UICorner", sliderBg)
    sCorner.CornerRadius = UDim.new(0,6)

    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new((default - minv)/(maxv - minv), 0, 1, 0)
    local fCorner = Instance.new("UICorner", fill)
    fCorner.CornerRadius = UDim.new(0,6)
    fill.BackgroundColor3 = Color3.fromRGB(110,110,255)

    local knob = Instance.new("ImageButton", sliderBg)
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
    knob.BackgroundTransparency = 1
    knob.Image = "rbxassetid://3926305904"
    knob.ImageRectOffset = Vector2.new(924,724)
    knob.ImageRectSize = Vector2.new(36,36)

    local box = Instance.new("TextBox", container)
    box.Size = UDim2.new(0.28, 0, 0, 28)
    box.Position = UDim2.new(0.68, 0, 0, 18)
    box.Text = tostring(default)
    box.PlaceholderText = tostring(default)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.BackgroundColor3 = Color3.fromRGB(25,25,25)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    local bc = Instance.new("UICorner", box)
    bc.CornerRadius = UDim.new(0,6)

    local dragging = false
    local val = default

    local function setValue(v)
        v = math.clamp(tonumber(v) or minv, minv, maxv)
        val = v
        local pct = (val - minv)/(maxv - minv)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        knob.Position = UDim2.new(pct, -7, 0.5, -7)
        box.Text = tostring(math.floor(val*100)/100)
        if container.OnChange then pcall(function() container.OnChange(val) end) end
    end

    local function updateFromInput(pos)
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local relativeX = math.clamp(pos.X - absPos.X, 0, absSize.X)
        local pct = relativeX / absSize.X
        setValue(minv + pct*(maxv - minv))
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
        if enter then setValue(tonumber(box.Text) or minv) else box.Text = tostring(val) end
    end)

    setValue(default)
    container.Get = function() return val end
    container.Set = setValue
    return container
end

-- =====================
-- Server page content
-- =====================
local rejoinBtn = createFullButton(serverScroll, "Rejoin Server")
rejoinBtn.MouseButton1Click:Connect(function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

-- join private
local joinFrame = Instance.new("Frame")
joinFrame.Size = UDim2.new(1, -16, 0, 64)
joinFrame.BackgroundTransparency = 1
joinFrame.LayoutOrder = #serverScroll:GetChildren() + 1
joinFrame.Parent = serverScroll

local joinLabel = Instance.new("TextLabel", joinFrame)
joinLabel.Text = "Join Server To Link:"
joinLabel.Size = UDim2.new(0.6, 0, 0, 20)
joinLabel.Position = UDim2.new(0,0,0,6)
joinLabel.BackgroundTransparency = 1
joinLabel.TextColor3 = Color3.fromRGB(255,255,255)
joinLabel.Font = Enum.Font.GothamBold
joinLabel.TextSize = 14
joinLabel.TextXAlignment = Enum.TextXAlignment.Left

local linkBox = Instance.new("TextBox", joinFrame)
linkBox.PlaceholderText = "Link server..."
linkBox.Size = UDim2.new(0.95, 0, 0, 28)
linkBox.Position = UDim2.new(0,0,0,28)
linkBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
linkBox.TextColor3 = Color3.fromRGB(255,255,255)
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 14
local lcorner = Instance.new("UICorner", linkBox)
lcorner.CornerRadius = UDim.new(0,6)

local joinBtn = Instance.new("TextButton", joinFrame)
joinBtn.Size = UDim2.new(0.4, 0, 0, 28)
joinBtn.Position = UDim2.new(0.58, 0, 0, 28)
joinBtn.Text = "Join"
joinBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 14
joinBtn.TextColor3 = Color3.fromRGB(255,255,255)
local jcorner = Instance.new("UICorner", joinBtn)
jcorner.CornerRadius = UDim.new(0,6)

joinBtn.MouseButton1Click:Connect(function()
    local link = linkBox.Text or ""
    local code = string.match(link, "privateServerLinkCode=([%w_-]+)")
    if code then
        local success, err = pcall(function() TeleportService:TeleportToPrivateServer(game.PlaceId, code, {LocalPlayer}) end)
        if not success then warn("Gagal join server: "..tostring(err)) end
    else
        warn("Link server tidak valid!")
    end
end)

-- =====================
-- Player page content
-- =====================
local walkToggle = createLabelToggle(playerScroll, "WalkSpeed", false)
local walkSlider = createSlider(playerScroll, "WalkSpeed Value", 8, 200, 16)

local flyToggle = createLabelToggle(playerScroll, "Fly", false)
local flySlider = createSlider(playerScroll, "Fly Speed", 10, 200, 50)

local noclipToggle = createLabelToggle(playerScroll, "NoClip", false)

local freezeToggle = createLabelToggle(playerScroll, "Freeze Character", false)

local deleteNotifBtn = createFullButton(playerScroll, "Delete Small Notification")

local note = Instance.new("TextLabel", playerScroll)
note.Text = "Fly: gunakan WASD / virtual-stick untuk gerak horizontal.\nNaik: tombol Jump. Turun: tahan Shift (PC) atau sentuh 2 jari (mobile).\nNoClip: tembus objek saat aktif."
note.Size = UDim2.new(1, -16, 0, 48)
note.TextWrapped = true
note.TextYAlignment = Enum.TextYAlignment.Top
note.BackgroundTransparency = 1
note.TextColor3 = Color3.fromRGB(200,200,200)
note.Font = Enum.Font.Gotham
note.TextSize = 13
note.LayoutOrder = #playerScroll:GetChildren() + 1
note.Parent = playerScroll

-- =====================
-- Feature implementations (clean, robust)
-- =====================
-- WalkSpeed
local originalWalkSpeed = 16
local walkConn = nil
local walkHeartbeat = nil

local function safeSetWalk(hum, speed)
    if hum and hum:IsA("Humanoid") then
        pcall(function() hum.WalkSpeed = speed end)
    end
end

local function enableWalk(on)
    if on then
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                originalWalkSpeed = originalWalkSpeed or hum.WalkSpeed or 16
                safeSetWalk(hum, walkSlider.Get())
            end
        end
        if not walkConn then
            walkConn = LocalPlayer.CharacterAdded:Connect(function(char)
                local hum = char:WaitForChild("Humanoid", 5)
                if hum then safeSetWalk(hum, walkSlider.Get()) end
            end)
        end
        if not walkHeartbeat then
            walkHeartbeat = RunService.Heartbeat:Connect(function()
                if walkToggle.Get() then
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then safeSetWalk(hum, walkSlider.Get()) end
                    end
                end
            end)
        end
    else
        if walkConn then walkConn:Disconnect(); walkConn = nil end
        if walkHeartbeat then walkHeartbeat:Disconnect(); walkHeartbeat = nil end
        local char = LocalPlayer.Character
        if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum.WalkSpeed = originalWalkSpeed end) end end
    end
end

walkToggle.OnToggle = function(state) enableWalk(state) end
walkSlider.OnChange = function(v) if walkToggle.Get() then local char=LocalPlayer.Character if char then local hum=char:FindFirstChildOfClass("Humanoid") if hum then safeSetWalk(hum,v) end end end end

-- Fly
local flyState = { enabled = false, charConn = nil }
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
    flyBV.Parent = hrp
    pcall(function() humanoid.PlatformStand = false end)
end

local function startFlyLoop()
    if flyLoop then return end
    flyLoop = RunService.RenderStepped:Connect(function()
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
        if ascendFlag then vert = flySlider.Get()
        elseif shiftDown or touchCount >= 2 then vert = -flySlider.Get() else vert = 0 end
        local targetVel = Vector3.new(horizPart.X, vert, horizPart.Z)
        if flyBV then flyBV.Velocity = targetVel end
        pcall(function() humanoid.PlatformStand = false end)
    end)
end

local function stopFly()
    if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
    if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
end

local function handleFly(on)
    flyState.enabled = on
    if on then
        if LocalPlayer.Character then enableFlyForChar(LocalPlayer.Character) end
        if not flyState.charConn then
            flyState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if flyState.enabled then char:WaitForChild("HumanoidRootPart",5) enableFlyForChar(char) end
            end)
        end
        startFlyLoop()
    else
        if flyState.charConn then flyState.charConn:Disconnect(); flyState.charConn = nil end
        stopFly()
    end
end

flyToggle.OnToggle = function(state) handleFly(state) end
flySlider.OnChange = function(v) if flyToggle.Get() then flyState.speed = v end end

-- NoClip
local noclipState = { enabled = false, originals = {}, connections = {}, charConn = nil }

local function enableNoClipForChar(char)
    if not char then return end
    noclipState.originals = {}
    for _,desc in ipairs(char:GetDescendants()) do
        if desc:IsA("BasePart") then
            local ok, prev = pcall(function() return desc.CanCollide end)
            if ok then
                noclipState.originals[desc] = prev
                pcall(function() desc.CanCollide = false end)
            end
        end
    end
    local conn = char.DescendantAdded:Connect(function(desc)
        if desc:IsA("BasePart") then
            local ok, prev = pcall(function() return desc.CanCollide end)
            if ok then noclipState.originals[desc] = prev pcall(function() desc.CanCollide = false end) end
        end
    end)
    table.insert(noclipState.connections, conn)
end

local function disableNoClip()
    for part, prev in pairs(noclipState.originals) do
        if part and part.Parent then pcall(function() part.CanCollide = prev end) end
    end
    for _,c in ipairs(noclipState.connections) do pcall(function() c:Disconnect() end) end
    noclipState.connections = {}
    noclipState.originals = {}
    if noclipState.charConn then pcall(function() noclipState.charConn:Disconnect() end); noclipState.charConn = nil end
    noclipState.enabled = false
end

local function handleNoClip(on)
    if on then
        noclipState.enabled = true
        if LocalPlayer.Character then enableNoClipForChar(LocalPlayer.Character) end
        if not noclipState.charConn then
            noclipState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if noclipState.enabled then char:WaitForChild("Humanoid",5) enableNoClipForChar(char) end
            end)
        end
    else
        disableNoClip()
    end
end

noclipToggle.OnToggle = function(state) handleNoClip(state) end

-- Freeze Character
local freezeState = { enabled = false, original = {}, charConn = nil }
local function setFreeze(on)
    freezeState.enabled = on
    if on then
        local char = LocalPlayer.Character
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
        if not freezeState.charConn then
            freezeState.charConn = LocalPlayer.CharacterAdded:Connect(function(char)
                if freezeState.enabled then
                    local hum = char:WaitForChild("Humanoid",5)
                    if hum then pcall(function() hum.WalkSpeed=0 hum.JumpPower=0 hum.PlatformStand=true hum.AutoRotate=false end) end
                end
            end)
        end
    else
        if freezeState.charConn then freezeState.charConn:Disconnect(); freezeState.charConn = nil end
        local char = LocalPlayer.Character
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

freezeToggle.OnToggle = function(state) setFreeze(state) end

-- Delete Small Notification
deleteNotifBtn.MouseButton1Click:Connect(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local notif = pg:FindFirstChild("Small Notification")
        if notif then pcall(function() notif:Destroy() end) end
    end
end)

-- Reapply active features on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    spawn(function()
        local hum = char:WaitForChild("Humanoid",5)
        if hum then
            if walkToggle.Get() then safeSetWalk(hum, walkSlider.Get()) end
            if flyToggle.Get() then enableFlyForChar(char) end
            if noclipToggle.Get() then enableNoClipForChar(char) end
            if freezeToggle.Get() then pcall(function() freezeState.original.walk = hum.WalkSpeed freezeState.original.jump = hum.JumpPower hum.WalkSpeed = 0 hum.JumpPower = 0 hum.PlatformStand = true hum.AutoRotate = false end) end
        end
    end)
end)

-- Tabs wiring
local tabInfo = createTabButton("Info", 1)
local tabServer = createTabButton("Server", 2)
local tabPlayer = createTabButton("Player", 3)

local function selectTab(tab)
    for _,v in ipairs(sidebar:GetChildren()) do
        if v:IsA("TextButton") then v.Selected = false v.BackgroundColor3 = Color3.fromRGB(30,30,30) end
    end
    tab.Selected = true
    tab.BackgroundColor3 = Color3.fromRGB(80,80,120)
end

tabInfo.MouseButton1Click:Connect(function()
    selectTab(tabInfo)
    infoPage.Visible = true
    serverPage.Visible = false
    playerPage.Visible = false
end)
tabServer.MouseButton1Click:Connect(function()
    selectTab(tabServer)
    infoPage.Visible = false
    serverPage.Visible = true
    playerPage.Visible = false
end)
tabPlayer.MouseButton1Click:Connect(function()
    selectTab(tabPlayer)
    infoPage.Visible = false
    serverPage.Visible = false
    playerPage.Visible = true
end)

-- default
selectTab(tabInfo)

-- Cleanup when GUI removed
gui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        pcall(function() 
            if walkConn then walkConn:Disconnect(); walkConn=nil end
            if walkHeartbeat then walkHeartbeat:Disconnect(); walkHeartbeat=nil end
            if flyLoop then flyLoop:Disconnect(); flyLoop=nil end
            if flyState.charConn then flyState.charConn:Disconnect(); flyState.charConn=nil end
            if noclipState.charConn then noclipState.charConn:Disconnect(); noclipState.charConn=nil end
            if freezeState.charConn then freezeState.charConn:Disconnect(); freezeState.charConn=nil end
        end)
    end
end)

-- end of script
