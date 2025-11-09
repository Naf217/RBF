
--// Chloe X Style UI (Server Tools v0.5) by Majid (EDITED: scrollable tabs, cards, teleport, freeze, cleanup)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 560, 0, 380)
main.Position = UDim2.new(0.5, -280, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
main.BackgroundTransparency = 0.18
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1.2
stroke.Color = Color3.fromRGB(110, 110, 255)
stroke.Transparency = 0.2

-- Title
local title = Instance.new("TextLabel", main)
title.Text = "Chloe X | v0.5 (Edited)"
title.Size = UDim2.new(1, -50, 0, 34)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local close = Instance.new("TextButton", main)
close.Text = "×"
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 8)
close.BackgroundTransparency = 1
close.TextColor3 = Color3.fromRGB(255, 70, 70)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.MouseButton1Click:Connect(function()
 gui:Destroy()
end)

-- Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 140, 1, -80)
sidebar.Position = UDim2.new(0, 15, 0, 50)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BackgroundTransparency = 0.15

local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 10)

-- Content area
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -180, 1, -90)
content.Position = UDim2.new(0, 165, 0, 50)
content.BackgroundTransparency = 1

-- helper: create card frame for features
local function createCard(parent, height)
 local card = Instance.new("Frame", parent)
 card.Size = UDim2.new(1, -20, 0, height)
 card.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
 card.BorderSizePixel = 0
 local c = Instance.new("UICorner", card)
 c.CornerRadius = UDim.new(0, 8)
 local pad = Instance.new("UIPadding", card)
 pad.PaddingTop = UDim.new(0,6)
 pad.PaddingBottom = UDim.new(0,6)
 pad.PaddingLeft = UDim.new(0,8)
 pad.PaddingRight = UDim.new(0,8)
 return card
end

-- helper: create tab button
local function createTab(name, index)
 local tab = Instance.new("TextButton")
 tab.Text = name
 tab.Size = UDim2.new(1, -20, 0, 36)
 tab.Position = UDim2.new(0, 10, 0, (index - 1) * 44 + 10)
 tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 tab.TextColor3 = Color3.fromRGB(230, 230, 230)
 tab.Font = Enum.Font.Gotham
 tab.TextSize = 16
 tab.Parent = sidebar

 local c = Instance.new("UICorner", tab)
 c.CornerRadius = UDim.new(0, 8)

 tab.MouseEnter:Connect(function()
  if not tab.Selected then
   tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
  end
 end)

 tab.MouseLeave:Connect(function()
  if not tab.Selected then
   tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
  end
 end)

 return tab
end

-- Info Frame (non-scroll)
local infoFrame = Instance.new("Frame", content)
infoFrame.Size = UDim2.new(1, 0, 1, 0)
infoFrame.BackgroundTransparency = 1

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Text = "Versi: ChloeX UI v0.5 (Edited)\nStatus: Aktif\n\nUI diperbarui: semua tab sekarang scrollable. Setiap fitur dibungkus 'card' dengan sudut melengkung untuk kenyamanan visual.\n\nTambah Tab: Teleport.\nTambahan fitur di Player: Freeze Character, Delete Small Notification."
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 16
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.BackgroundTransparency = 1

-- Create scrollable frames for tabs (server, player, teleport)
local function createScrollTab(name)
 local frame = Instance.new("ScrollingFrame", content)
 frame.Name = name
 frame.Size = UDim2.new(1, 0, 1, 0)
 frame.CanvasSize = UDim2.new(0, 0, 2, 0)
 frame.BackgroundTransparency = 1
 frame.ScrollBarThickness = 6
 frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
 frame.Visible = false

 local layout = Instance.new("UIListLayout", frame)
 layout.Padding = UDim.new(0, 10)
 layout.SortOrder = Enum.SortOrder.LayoutOrder
 layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

 return frame
end

local serverFrame = createScrollTab("ServerFrame")
local playerFrame = createScrollTab("PlayerFrame")
local teleportFrame = createScrollTab("TeleportFrame")

-- SERVER TAB CONTENT
-- Rejoin card
local rejoinCard = createCard(serverFrame, 50)
local rejoinBtn = Instance.new("TextButton", rejoinCard)
rejoinBtn.Size = UDim2.new(1, 0, 1, 0)
rejoinBtn.Position = UDim2.new(0, 0, 0, 0)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 16
rejoinBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
local rc = Instance.new("UICorner", rejoinBtn); rc.CornerRadius = UDim.new(0,6)
rejoinBtn.MouseButton1Click:Connect(function()
 TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Join server link card (fixed to fit)
local joinCard = createCard(serverFrame, 80)
local joinLabel = Instance.new("TextLabel", joinCard)
joinLabel.Text = "Join Server To Link:"
joinLabel.Size = UDim2.new(1, -20, 0, 20)
joinLabel.Position = UDim2.new(0, 10, 0, 6)
joinLabel.BackgroundTransparency = 1
joinLabel.TextColor3 = Color3.fromRGB(230,230,230)
joinLabel.Font = Enum.Font.GothamBold
joinLabel.TextSize = 14
joinLabel.TextXAlignment = Enum.TextXAlignment.Left

local linkBox = Instance.new("TextBox", joinCard)
linkBox.PlaceholderText = "Link here"
linkBox.Size = UDim2.new(1, -140, 0, 30) -- shrink to not overflow
linkBox.Position = UDim2.new(0, 10, 0, 30)
linkBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
linkBox.TextColor3 = Color3.fromRGB(255,255,255)
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 14
linkBox.TextXAlignment = Enum.TextXAlignment.Left
local lc = Instance.new("UICorner", linkBox); lc.CornerRadius = UDim.new(0,6)

local joinBtn = Instance.new("TextButton", joinCard)
joinBtn.Text = "Join"
joinBtn.Size = UDim2.new(0, 100, 0, 30)
joinBtn.Position = UDim2.new(1, -110, 0, 30)
joinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 14
local jc = Instance.new("UICorner", joinBtn); jc.CornerRadius = UDim.new(0,6)

joinBtn.MouseButton1Click:Connect(function()
 local link = linkBox.Text
 if link == "" or link == nil then return end
 local code = string.match(link, "privateServerLinkCode=([%w_-]+)")
 if code then
  local success, err = pcall(function()
   TeleportService:TeleportToPrivateServer(game.PlaceId, code, { LocalPlayer })
  end)
  if not success then
   warn("Gagal join server: " .. tostring(err))
  end
 else
  warn("Link server tidak valid!")
 end
end)

-- PLAYER TAB CONTENT
-- We'll create cards for WalkSpeed, Fly, NoClip, Freeze, Delete Small Notification
-- Helper small label creator
local function makeLabel(parent, text)
 local lbl = Instance.new("TextLabel", parent)
 lbl.Text = text
 lbl.Size = UDim2.new(0.6, 0, 0, 22)
 lbl.Position = UDim2.new(0, 10, 0, 6)
 lbl.BackgroundTransparency = 1
 lbl.TextColor3 = Color3.fromRGB(235,235,235)
 lbl.Font = Enum.Font.GothamBold
 lbl.TextSize = 14
 lbl.TextXAlignment = Enum.TextXAlignment.Left
 return lbl
end

-- Reuse existing toggle/slider creators but place inside cards
local function createToggleInCard(card, text)
 local lbl = makeLabel(card, text)
 local btn = Instance.new("TextButton", card)
 btn.Size = UDim2.new(0, 80, 0, 28)
 btn.Position = UDim2.new(1, -100, 0, 6)
 btn.Text = "OFF"
 btn.Font = Enum.Font.GothamBold
 btn.TextSize = 14
 btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
 btn.TextColor3 = Color3.fromRGB(255,255,255)
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
 btn.MouseButton1Click:Connect(function()
  setState(not state)
 end)
 return { Label = lbl, Button = btn, Get = function() return state end, Set = setState }
end

local function createSliderInCard(card, labelText, minVal, maxVal, defaultVal)
 local lbl = makeLabel(card, labelText)
 local sliderBg = Instance.new("Frame", card)
 sliderBg.Size = UDim2.new(0.6, 0, 0, 20)
 sliderBg.Position = UDim2.new(0, 10, 0, 34)
 sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
 local sCorner = Instance.new("UICorner", sliderBg); sCorner.CornerRadius = UDim.new(0,6)
 local fill = Instance.new("Frame", sliderBg)
 fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
 fill.BackgroundColor3 = Color3.fromRGB(110,110,255)
 local knob = Instance.new("ImageButton", sliderBg)
 knob.Size = UDim2.new(0, 14, 0, 14)
 knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
 knob.BackgroundTransparency = 1
 knob.Image = "rbxassetid://3926305904"
 local box = Instance.new("TextBox", card)
 box.Size = UDim2.new(0, 80, 0, 28)
 box.Position = UDim2.new(1, -90, 0, 30)
 box.Text = tostring(defaultVal)
 box.PlaceholderText = tostring(defaultVal)
 box.Font = Enum.Font.Gotham
 box.TextSize = 14
 box.BackgroundColor3 = Color3.fromRGB(25,25,25)
 local function setValue(v)
  v = math.clamp(tonumber(v) or minVal, minVal, maxVal)
  local pct = (v - minVal) / (maxVal - minVal)
  fill.Size = UDim2.new(pct, 0, 1, 0)
  knob.Position = UDim2.new(pct, -7, 0.5, -7)
  box.Text = tostring(math.floor(v*100)/100)
  return v
 end
 local val = setValue(defaultVal)
 -- simple mouse drag:
 local dragging = false
 sliderBg.InputBegan:Connect(function(input)
  if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
   dragging = true
   local rel = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
   local pct = rel/sliderBg.AbsoluteSize.X
   val = setValue(minVal + pct*(maxVal-minVal))
  end
 end)
 sliderBg.InputChanged:Connect(function(input)
  if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
   local rel = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
   local pct = rel/sliderBg.AbsoluteSize.X
   val = setValue(minVal + pct*(maxVal-minVal))
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
 return { Get = function() return val end, Set = function(v) val = setValue(v) end }
end

-- WalkSpeed card
local walkCard = createCard(playerFrame, 78)
local walkToggle = createToggleInCard(walkCard, "WalkSpeed")
local walkSlider = createSliderInCard(walkCard, "WalkSpeed Value", 8, 200, 16)

-- Fly card
local flyCard = createCard(playerFrame, 110)
local flyToggle = createToggleInCard(flyCard, "Fly")
local flySlider = createSliderInCard(flyCard, "Fly Speed", 10, 200, 50)

-- NoClip card
local noclipCard = createCard(playerFrame, 60)
local noclipToggle = createToggleInCard(noclipCard, "NoClip")

-- Freeze Character card
local freezeCard = createCard(playerFrame, 60)
local freezeToggle = createToggleInCard(freezeCard, "Freeze Character")

-- Delete Small Notification card (button)
local delCard = createCard(playerFrame, 60)
local delBtn = Instance.new("TextButton", delCard)
delBtn.Size = UDim2.new(0.4, 0, 0, 36)
delBtn.Position = UDim2.new(0.5, - (0.4*delCard.AbsoluteSize.X)/2, 0, 10)
delBtn.AnchorPoint = Vector2.new(0.5,0)
delBtn.Text = "Delete Small Notification"
delBtn.Font = Enum.Font.GothamBold
delBtn.TextSize = 14
delBtn.BackgroundColor3 = Color3.fromRGB(65,65,65)
local dcorner = Instance.new("UICorner", delBtn); dcorner.CornerRadius = UDim.new(0,6)

delBtn.MouseButton1Click:Connect(function()
 local success, err = pcall(function()
  local pg = LocalPlayer:FindFirstChild("PlayerGui")
  if pg then
   local sn = pg:FindFirstChild("Small Notification")
   if sn then
    sn:Destroy()
    print("Small Notification deleted.")
   else
    warn("Small Notification not found in PlayerGui.")
   end
  end
 end)
 if not success then warn("Error deleting Small Notification: "..tostring(err)) end
end)

-- Teleport Tab content
local teleportCard = createCard(teleportFrame, 140)
local tLabel = Instance.new("TextLabel", teleportCard)
tLabel.Text = "Teleport To Player"
tLabel.Size = UDim2.new(1, -20, 0, 20)
tLabel.Position = UDim2.new(0,10,0,6)
tLabel.BackgroundTransparency = 1
tLabel.TextColor3 = Color3.fromRGB(230,230,230)
tLabel.Font = Enum.Font.GothamBold
tLabel.TextSize = 14
tLabel.TextXAlignment = Enum.TextXAlignment.Left

local playersListFrame = Instance.new("Frame", teleportCard)
playersListFrame.Size = UDim2.new(1, -20, 0, 80)
playersListFrame.Position = UDim2.new(0, 10, 0, 30)
playersListFrame.BackgroundTransparency = 1
local playersScrolling = Instance.new("ScrollingFrame", playersListFrame)
playersScrolling.Size = UDim2.new(1, 0, 1, 0)
playersScrolling.BackgroundTransparency = 1
playersScrolling.ScrollBarThickness = 6
local pLayout = Instance.new("UIListLayout", playersScrolling)
pLayout.Padding = UDim.new(0,6)
pLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedTarget = nil

local function refreshPlayerList()
 -- clear previous
 for _,c in ipairs(playersScrolling:GetChildren()) do
  if c:IsA("TextButton") then c:Destroy() end
 end
 for _,pl in ipairs(Players:GetPlayers()) do
  if pl ~= LocalPlayer then
   local b = Instance.new("TextButton", playersScrolling)
   b.Size = UDim2.new(1, -10, 0, 28)
   b.Text = pl.Name
   b.Font = Enum.Font.Gotham
   b.TextSize = 14
   b.BackgroundColor3 = Color3.fromRGB(45,45,45)
   local bc = Instance.new("UICorner", b); bc.CornerRadius = UDim.new(0,6)
   b.MouseButton1Click:Connect(function()
    selectedTarget = pl
    -- highlight selection
    for _,ch in ipairs(playersScrolling:GetChildren()) do
     if ch:IsA("TextButton") then ch.BackgroundColor3 = Color3.fromRGB(45,45,45) end
    end
    b.BackgroundColor3 = Color3.fromRGB(80,120,255)
   end)
  end
 end
end

local refreshBtn = Instance.new("TextButton", teleportCard)
refreshBtn.Text = "Refresh Players"
refreshBtn.Size = UDim2.new(0, 120, 0, 28)
refreshBtn.Position = UDim2.new(1, -130, 0, 30)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 14
refreshBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
local rcorner = Instance.new("UICorner", refreshBtn); rcorner.CornerRadius = UDim.new(0,6)
refreshBtn.MouseButton1Click:Connect(refreshPlayerList)

local tpBtn = Instance.new("TextButton", teleportCard)
tpBtn.Text = "Teleport To Player"
tpBtn.Size = UDim2.new(0, 160, 0, 36)
tpBtn.Position = UDim2.new(1, -170, 0, 60)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 14
tpBtn.BackgroundColor3 = Color3.fromRGB(80,120,255)
local tpcorner = Instance.new("UICorner", tpBtn); tpcorner.CornerRadius = UDim.new(0,6)

tpBtn.MouseButton1Click:Connect(function()
 if not selectedTarget then
  warn("No player selected.")
  return
 end
 local success, err = pcall(function()
  local targetChar = selectedTarget.Character
  if targetChar then
   local targetHRP = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso")
   local myChar = LocalPlayer.Character
   if targetHRP and myChar and myChar:FindFirstChild("HumanoidRootPart") then
    myChar.HumanoidRootPart.CFrame = targetHRP.CFrame + Vector3.new(0,3,0)
   else
    warn("Unable to teleport; missing parts.")
   end
  end
 end)
 if not success then warn("Teleport error: "..tostring(err)) end
end)

-- initial population
refreshPlayerList()

-- ===========================
-- Functionality wiring (WalkSpeed, Fly, NoClip, Freeze) adapted to new controls
-- ===========================
local originalWalkSpeed = 16
local originalJumpPower = nil
local walkConnection = nil

local function applyWalkSpeedNow(val)
 local character = LocalPlayer.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 if humanoid then humanoid.WalkSpeed = val end
end

local function handleWalkToggle(state)
 if state then
  if LocalPlayer.Character then
   local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
   if hum then
    originalWalkSpeed = originalWalkSpeed or hum.WalkSpeed or 16
    hum.WalkSpeed = walkSlider.Get()
   end
  end
  if not walkConnection then
   walkConnection = LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then hum.WalkSpeed = walkSlider.Get() end
   end)
  end
 else
  if LocalPlayer.Character then
   local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
   if hum then hum.WalkSpeed = originalWalkSpeed end
  end
  if walkConnection then walkConnection:Disconnect(); walkConnection = nil end
 end
end

-- poll slider to apply live when toggled
spawn(function()
 local last = walkSlider.Get()
 while gui and gui.Parent do
  local cur = walkSlider.Get()
  if cur ~= last then
   last = cur
   if walkToggle.Get() then applyWalkSpeedNow(cur) end
  end
  wait(0.15)
 end
end)
walkToggle.Button.MouseButton1Click:Connect(function()
 wait(0.05)
 handleWalkToggle(walkToggle.Get())
end)

if LocalPlayer.Character then
 local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
 if hum then originalWalkSpeed = hum.WalkSpeed or originalWalkSpeed; originalJumpPower = hum.JumpPower or humanoid and humanoid.JumpPower end
end

-- Fly (adapted)
local flyState = { enabled = false; speed = flySlider.Get(); }
local flyBV = nil
local flyLoopConn = nil
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

local function onHumanoidJumping(isJumping)
 if isJumping then
  ascendFlag = true
  delay(0.25, function() ascendFlag = false end)
 end
end

local function enableFlyForCharacter(char)
 if not char then return end
 local humanoid = char:FindFirstChildOfClass("Humanoid")
 local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
 if not humanoid or not hrp then return end

 flyBV = flyBV and flyBV.Parent and flyBV or Instance.new("BodyVelocity")
 flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
 flyBV.P = 1250
 flyBV.Velocity = Vector3.new(0,0,0)
 flyBV.Parent = hrp

 pcall(function() humanoid.PlatformStand = false end)
 if humanoid and humanoid.Jumping then humanoid.Jumping:Connect(onHumanoidJumping) end
end

local function stopFlyLoop()
 if flyLoopConn then flyLoopConn:Disconnect(); flyLoopConn = nil end
 if flyBV and flyBV.Parent then flyBV:Destroy(); flyBV = nil end
end

local function startFlyLoop()
 if flyLoopConn then return end
 flyLoopConn = RunService.RenderStepped:Connect(function(dt)
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
  elseif shiftDown or touchCount >= 2 then vert = -flySlider.Get()
  else vert = 0 end

  local targetVel = Vector3.new(horizPart.X, vert, horizPart.Z)
  if flyBV then flyBV.Velocity = targetVel end

  pcall(function() humanoid.PlatformStand = false end)
 end)
end

local function handleFlyToggle(state)
 if state then
  flyState.enabled = true
  flyState.speed = flySlider.Get()
  if LocalPlayer.Character then enableFlyForCharacter(LocalPlayer.Character) end
  LocalPlayer.CharacterAdded:Connect(function(char)
   if flyState.enabled then
    char:WaitForChild("HumanoidRootPart", 5)
    enableFlyForCharacter(char)
   end
  end)
  startFlyLoop()
 else
  flyState.enabled = false
  stopFlyLoop()
  if flyBV and flyBV.Parent then flyBV:Destroy() end
 end
end

spawn(function()
 local last = flySlider.Get()
 while gui and gui.Parent do
  local cur = flySlider.Get()
  if cur ~= last then
   last = cur
   if flyToggle.Get() then flyState.speed = cur end
  end
  wait(0.15)
 end
end)
flyToggle.Button.MouseButton1Click:Connect(function() wait(0.05); handleFlyToggle(flyToggle.Get()) end)

-- NoClip logic
local noClipData = { enabled = false; original = {}; connections = {}; charAddedConn = nil; }

local function enableNoClipForCharacter(char)
 if not char then return end
 noClipData.original = {}
 for _, desc in ipairs(char:GetDescendants()) do
  if desc:IsA("BasePart") then
   pcall(function() noClipData.original[desc] = desc.CanCollide; desc.CanCollide = false end)
  end
 end
 local conn = char.DescendantAdded:Connect(function(desc)
  if desc:IsA("BasePart") then pcall(function() noClipData.original[desc] = desc.CanCollide; desc.CanCollide = false end) end
 end)
 table.insert(noClipData.connections, conn)
end

local function disableNoClip()
 for part, orig in pairs(noClipData.original) do
  if part and part.Parent then pcall(function() part.CanCollide = orig end) end
 end
 for _, c in ipairs(noClipData.connections) do pcall(function() c:Disconnect() end) end
 noClipData.connections = {}
 noClipData.original = {}
 noClipData.enabled = false
 if noClipData.charAddedConn then pcall(function() noClipData.charAddedConn:Disconnect() end); noClipData.charAddedConn = nil end
end

local function handleNoClipToggle(state)
 if state then
  noClipData.enabled = true
  if LocalPlayer.Character then enableNoClipForCharacter(LocalPlayer.Character) end
  if not noClipData.charAddedConn then
   noClipData.charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
    if noClipData.enabled then char:WaitForChild("Humanoid",5); enableNoClipForCharacter(char) end
   end)
  end
 else
  disableNoClip()
 end
end

noclipToggle.Button.MouseButton1Click:Connect(function() wait(0.05); handleNoClipToggle(noclipToggle.Get()) end)

-- Freeze Character implementation
local freezeData = { enabled = false; originalWalk = nil; originalJump = nil; originalPlatformStand = nil; conn = nil }

local function enableFreezeForCharacter(char)
 if not char then return end
 local hum = char:FindFirstChildOfClass("Humanoid")
 if not hum then return end
 -- store originals
 freezeData.originalWalk = hum.WalkSpeed
 freezeData.originalJump = hum.JumpPower
 freezeData.originalPlatformStand = hum.PlatformStand
 -- apply freeze
 pcall(function()
  hum.WalkSpeed = 0
  hum.JumpPower = 0
  hum.PlatformStand = true
 end)
 -- ensure on respawn we reapply freeze
 if freezeData.conn then freezeData.conn:Disconnect(); freezeData.conn = nil end
 freezeData.conn = LocalPlayer.CharacterAdded:Connect(function(newChar)
  wait(0.5)
  local nh = newChar:FindFirstChildOfClass("Humanoid")
  if nh then
   pcall(function() nh.WalkSpeed = 0; nh.JumpPower = 0; nh.PlatformStand = true end)
  end
 end)
end

local function disableFreeze()
 -- restore on current character
 local char = LocalPlayer.Character
 if char then
  local hum = char:FindFirstChildOfClass("Humanoid")
  if hum then
   pcall(function()
    if freezeData.originalWalk then hum.WalkSpeed = freezeData.originalWalk end
    if freezeData.originalJump then hum.JumpPower = freezeData.originalJump end
    hum.PlatformStand = freezeData.originalPlatformStand or false
   end)
  end
 end
 if freezeData.conn then freezeData.conn:Disconnect(); freezeData.conn = nil end
 freezeData.originalWalk = nil; freezeData.originalJump = nil; freezeData.originalPlatformStand = nil
 freezeData.enabled = false
end

freezeToggle.Button.MouseButton1Click:Connect(function()
 wait(0.05)
 local newState = not freezeData.enabled
 freezeData.enabled = newState
 freezeToggle.Set(newState)
 if newState then
  if LocalPlayer.Character then enableFreezeForCharacter(LocalPlayer.Character) end
 else
  disableFreeze()
 end
end)

-- Reapply on respawn if toggles active
LocalPlayer.CharacterAdded:Connect(function(char)
 spawn(function()
  local hum = char:WaitForChild("Humanoid", 5)
  if hum then
   if walkToggle.Get() then hum.WalkSpeed = walkSlider.Get() end
   if flyToggle.Get() then enableFlyForCharacter(char) end
   if noclipToggle.Get() then enableNoClipForCharacter(char) end
   if freezeData.enabled then
    pcall(function() hum.WalkSpeed = 0; hum.JumpPower = 0; hum.PlatformStand = true end)
   end
  end
 end)
end)

-- TABS wiring
local tabInfo = createTab("Info", 1)
local tabServer = createTab("Server", 2)
local tabPlayer = createTab("Player", 3)
local tabTeleport = createTab("Teleport", 4)

local function selectTab(t)
 for _, v in ipairs(sidebar:GetChildren()) do
  if v:IsA("TextButton") then
   v.Selected = false
   v.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
  end
 end
 t.Selected = true
 t.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
 -- show correct content
 infoFrame.Visible = (t == tabInfo)
 serverFrame.Visible = (t == tabServer)
 playerFrame.Visible = (t == tabPlayer)
 teleportFrame.Visible = (t == tabTeleport)
end

tabInfo.MouseButton1Click:Connect(function() selectTab(tabInfo) end)
tabServer.MouseButton1Click:Connect(function() selectTab(tabServer) end)
tabPlayer.MouseButton1Click:Connect(function() selectTab(tabPlayer) end)
tabTeleport.MouseButton1Click:Connect(function() selectTab(tabTeleport) end)

selectTab(tabInfo)

-- populate canvas sizes after small delay to ensure AutomaticCanvasSize works
delay(0.15, function()
 serverFrame.CanvasSize = UDim2.new(0,0,0,serverFrame.UIListLayout.AbsoluteContentSize.Y)
 playerFrame.CanvasSize = UDim2.new(0,0,0,playerFrame.UIListLayout.AbsoluteContentSize.Y)
 teleportFrame.CanvasSize = UDim2.new(0,0,0,teleportFrame.UIListLayout.AbsoluteContentSize.Y)
end)

-- end of edited script
