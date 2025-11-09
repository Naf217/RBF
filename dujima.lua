--// Chloe X Style UI (Server Tools v0.5) by Majid (LAYOUT PLAYER TAB RAPIH)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 320)
main.Position = UDim2.new(0.5, -260, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.28
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1.4
stroke.Color = Color3.fromRGB(110, 110, 255)
stroke.Transparency = 0.2

-- Title
local title = Instance.new("TextLabel", main)
title.Text = "Chloe X | v0.5"
title.Size = UDim2.new(1, -50, 0, 32)
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
sidebar.Size = UDim2.new(0, 120, 1, -60)
sidebar.Position = UDim2.new(0, 15, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BackgroundTransparency = 0.23

local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 10)

-- Content
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -160, 1, -80)
content.Position = UDim2.new(0, 145, 0, 50)
content.BackgroundTransparency = 1

local function createTab(name, index)
 local tab = Instance.new("TextButton")
 tab.Text = name
 tab.Size = UDim2.new(1, -20, 0, 36)
 tab.Position = UDim2.new(0, 10, 0, (index - 1) * 45 + 5)
 tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
 tab.TextColor3 = Color3.fromRGB(230, 230, 230)
 tab.Font = Enum.Font.Gotham
 tab.TextSize = 16
 tab.Parent = sidebar

 local c = Instance.new("UICorner", tab)
 c.CornerRadius = UDim.new(0, 8)

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

-- Info Frame
local infoFrame = Instance.new("Frame", content)
infoFrame.Size = UDim2.new(1, 0, 1, 0)
infoFrame.BackgroundTransparency = 1

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Text = "Versi: ChloeX UI v0.5\nStatus: Aktif\n\nUI besar, clean, dan rapi seperti Chloe X."
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 17
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.BackgroundTransparency = 1

-- Server Frame
local serverFrame = Instance.new("Frame", content)
serverFrame.Size = UDim2.new(1, 0, 1, 0)
serverFrame.BackgroundTransparency = 1
serverFrame.Visible = false

-- Tombol Rejoin Server (FULL WIDTH)
local rejoinBtn = Instance.new("TextButton", serverFrame)
rejoinBtn.Text = "Rejoin Server"
rejoinBtn.Size = UDim2.new(1, -20, 0, 38)
rejoinBtn.Position = UDim2.new(0, 10, 0, 10)
rejoinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
rejoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rejoinBtn.Font = Enum.Font.GothamBold
rejoinBtn.TextSize = 16

local rc = Instance.new("UICorner", rejoinBtn)
rc.CornerRadius = UDim.new(0, 8)

rejoinBtn.MouseButton1Click:Connect(function()
 TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Label + Input sejajar
local joinLabel = Instance.new("TextLabel", serverFrame)
joinLabel.Text = "Join Server To Link:"
joinLabel.Size = UDim2.new(0, 180, 0, 30)
joinLabel.Position = UDim2.new(0, 10, 0, 65)
joinLabel.BackgroundTransparency = 1
joinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
joinLabel.Font = Enum.Font.GothamBold
joinLabel.TextSize = 16
joinLabel.TextXAlignment = Enum.TextXAlignment.Left

local linkBox = Instance.new("TextBox", serverFrame)
linkBox.PlaceholderText = "Link server..."
linkBox.Size = UDim2.new(0, 240, 0, 30)
linkBox.Position = UDim2.new(0, 195, 0, 65)
linkBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
linkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
linkBox.Font = Enum.Font.Gotham
linkBox.TextSize = 14
linkBox.TextXAlignment = Enum.TextXAlignment.Left

local lc = Instance.new("UICorner", linkBox)
lc.CornerRadius = UDim.new(0, 6)

-- Tombol Join (Full Width)
local joinBtn = Instance.new("TextButton", serverFrame)
joinBtn.Text = "Join"
joinBtn.Size = UDim2.new(1, -20, 0, 36)
joinBtn.Position = UDim2.new(0, 10, 0, 110)
joinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
joinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
joinBtn.Font = Enum.Font.GothamBold
joinBtn.TextSize = 16

local jc = Instance.new("UICorner", joinBtn)
jc.CornerRadius = UDim.new(0, 8)

joinBtn.MouseButton1Click:Connect(function()
 local link = linkBox.Text
 if link == "" then return end
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

-- ===========================
-- Player Tab (WalkSpeed + Fly + NoClip) - Layout diperbaiki
-- ===========================
local playerFrame = Instance.new("Frame", content)
playerFrame.Size = UDim2.new(1, 0, 1, 0)
playerFrame.BackgroundTransparency = 1
playerFrame.Visible = false

-- Helper: Create label
local function createLabel(parent, text, posY)
 local lbl = Instance.new("TextLabel", parent)
 lbl.Text = text
 lbl.Size = UDim2.new(0, 220, 0, 22)
 lbl.Position = UDim2.new(0, 10, 0, posY)
 lbl.BackgroundTransparency = 1
 lbl.TextColor3 = Color3.fromRGB(235,235,235)
 lbl.Font = Enum.Font.GothamBold
 lbl.TextSize = 14
 lbl.TextXAlignment = Enum.TextXAlignment.Left
 return lbl
end

-- Helper: Create toggle (simple switch) - toggle diposisikan konsisten di kanan
local function createToggle(parent, text, posY)
 local lbl = createLabel(parent, text, posY)
 local btn = Instance.new("TextButton", parent)
 btn.Size = UDim2.new(0, 80, 0, 28)
 btn.Position = UDim2.new(1, -90, 0, posY - 2)
 btn.Text = "OFF"
 btn.Font = Enum.Font.GothamBold
 btn.TextSize = 14
 btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
 btn.TextColor3 = Color3.fromRGB(255,255,255)

 local uc = Instance.new("UICorner", btn)
 uc.CornerRadius = UDim.new(0, 6)
 btn.Active = true

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

 return {
  Label = lbl;
  Button = btn;
  Get = function() return state end;
  Set = setState;
 }
end

-- Helper: Create slider + textbox (posY is top). Posisi slider and box kept aligned.
local function createSliderWithBox(parent, labelText, posY, minVal, maxVal, defaultVal)
 createLabel(parent, labelText, posY)

 local sliderBg = Instance.new("Frame", parent)
 sliderBg.Size = UDim2.new(0, 260, 0, 20)
 sliderBg.Position = UDim2.new(0, 10, 0, posY + 26)
 sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
 sliderBg.BorderSizePixel = 0
 local sCorner = Instance.new("UICorner", sliderBg)
 sCorner.CornerRadius = UDim.new(0,6)

 local fill = Instance.new("Frame", sliderBg)
 fill.Size = UDim2.new( (defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
 fill.Position = UDim2.new(0,0,0,0)
 fill.BackgroundColor3 = Color3.fromRGB(110,110,255)
 local fCorner = Instance.new("UICorner", fill)
 fCorner.CornerRadius = UDim.new(0,6)

 local knob = Instance.new("ImageButton", sliderBg)
 knob.Size = UDim2.new(0, 14, 0, 14)
 knob.Position = UDim2.new(fill.Size.X.Scale, -7, 0.5, -7)
 knob.BackgroundTransparency = 1
 knob.Image = "rbxassetid://3926305904"
 knob.ImageRectOffset = Vector2.new(924, 724)
 knob.ImageRectSize = Vector2.new(36, 36)

 local box = Instance.new("TextBox", parent)
 box.Size = UDim2.new(0, 80, 0, 28)
 box.Position = UDim2.new(0, 290, 0, posY + 22)
 box.Text = tostring(defaultVal)
 box.PlaceholderText = tostring(defaultVal)
 box.Font = Enum.Font.Gotham
 box.TextSize = 14
 box.BackgroundColor3 = Color3.fromRGB(25,25,25)
 box.TextColor3 = Color3.fromRGB(255,255,255)
 local bc = Instance.new("UICorner", box)
 bc.CornerRadius = UDim.new(0,6)

 local dragging = false

 local function setValue(val)
  val = math.clamp(tonumber(val) or minVal, minVal, maxVal)
  local pct = (val - minVal) / (maxVal - minVal)
  fill.Size = UDim2.new(pct, 0, 1, 0)
  knob.Position = UDim2.new(pct, -7, 0.5, -7)
  box.Text = tostring(math.floor(val*100)/100)
  return val
 end

 local val = setValue(defaultVal)

 local function updateFromInput(inputPos)
  local absPos = sliderBg.AbsolutePosition
  local absSize = sliderBg.AbsoluteSize
  local relativeX = math.clamp(inputPos.X - absPos.X, 0, absSize.X)
  local pct = relativeX / absSize.X
  local newVal = minVal + pct * (maxVal - minVal)
  val = setValue(newVal)
 end

 -- Mouse / Touch handlers
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

 -- Box manual entry
 box.FocusLost:Connect(function(enter)
  if enter then
   val = setValue(tonumber(box.Text) or minVal)
  else
   box.Text = tostring(val)
  end
 end)

 return {
  Get = function() return val end;
  Set = function(v) val = setValue(v) end;
 }
end

-- ===== Create UI elements (dengan spasi rapih)
-- Kita atur vertical spacing supaya tidak dempet:
-- WalkSpeed block -> posY base 8
-- Fly block -> posY base 120
-- NoClip block -> posY base 210

local walkBaseY = 8
local flyBaseY = 120
local noclipBaseY = 210

local walkToggle = createToggle(playerFrame, "WalkSpeed", walkBaseY)
local walkSlider = createSliderWithBox(playerFrame, "WalkSpeed Value", walkBaseY + 28, 8, 200, 16) -- default 16

local flyToggle = createToggle(playerFrame, "Fly", flyBaseY)
local flySlider = createSliderWithBox(playerFrame, "Fly Speed", flyBaseY + 28, 10, 200, 50) -- default 50

local noclipToggle = createToggle(playerFrame, "NoClip", noclipBaseY)
-- NoClip tidak perlu slider, toggle cukup

-- explanatory note (letakkan lebih bawah)
local note = Instance.new("TextLabel", playerFrame)
note.Text = "Fly: gunakan WASD / virtual-stick untuk gerak horizontal.\nNaik: tombol Jump. Turun: tahan Shift (PC) atau sentuh 2 jari (mobile).\nNoClip: tembus objek saat aktif."
note.Position = UDim2.new(0,10,0,260)
note.Size = UDim2.new(1,-20,0,52)
note.BackgroundTransparency = 1
note.TextColor3 = Color3.fromRGB(200,200,200)
note.Font = Enum.Font.Gotham
note.TextSize = 13
note.TextWrapped = true
note.TextYAlignment = Enum.TextYAlignment.Top

-- ===========================
-- Functionality: WalkSpeed (sama seperti sebelumnya)
-- ===========================
local originalWalkSpeed = 16
local walkConnection = nil

local function applyWalkSpeed(enabled)
 local character = LocalPlayer.Character
 local humanoid = character and character:FindFirstChildOfClass("Humanoid")
 if humanoid then
  if enabled then
   humanoid.WalkSpeed = walkSlider.Get()
  else
   humanoid.WalkSpeed = originalWalkSpeed
  end
 end
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
    if hum then
     hum.WalkSpeed = walkSlider.Get()
    end
   end)
  end
 else
  if LocalPlayer.Character then
   local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
   if hum then
    hum.WalkSpeed = originalWalkSpeed
   end
  end
  if walkConnection then
   walkConnection:Disconnect()
   walkConnection = nil
  end
 end
end

-- Poll walk slider to update live
spawn(function()
 local lastWalkVal = walkSlider.Get()
 while gui and gui.Parent do
  local current = walkSlider.Get()
  if current ~= lastWalkVal then
   lastWalkVal = current
   if walkToggle.Get() then
    applyWalkSpeed(true)
   end
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
 if hum then originalWalkSpeed = hum.WalkSpeed or 16 end
end
LocalPlayer.CharacterAdded:Connect(function(char)
 spawn(function()
  local hum = char:WaitForChild("Humanoid", 5)
  if hum then
   if walkToggle.Get() then
    hum.WalkSpeed = walkSlider.Get()
   else
    originalWalkSpeed = hum.WalkSpeed or originalWalkSpeed
   end
  end
 end)
end)

-- ===========================
-- Functionality: Fly (sama seperti sebelumnya)
-- ===========================
local flyState = { enabled = false; speed = flySlider.Get(); }
local flyBV = nil
local flyLoopConn = nil
local touchCount = 0
local shiftDown = false
local ascendFlag = false

UserInputService.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.Touch then
  touchCount = touchCount + 1
 end
 if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
  shiftDown = true
 end
end)
UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.Touch then
  touchCount = math.max(0, touchCount - 1)
 end
 if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
  shiftDown = false
 end
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
 if humanoid and humanoid.Jumping then
  humanoid.Jumping:Connect(onHumanoidJumping)
 end
end

local function stopFlyLoop()
 if flyLoopConn then
  flyLoopConn:Disconnect()
  flyLoopConn = nil
 end
 if flyBV and flyBV.Parent then
  flyBV:Destroy()
  flyBV = nil
 end
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
  if ascendFlag then
   vert = flySlider.Get()
  elseif shiftDown or touchCount >= 2 then
   vert = -flySlider.Get()
  else
   vert = 0
  end

  local targetVel = Vector3.new(horizPart.X, vert, horizPart.Z)
  if flyBV then
   flyBV.Velocity = targetVel
  end

  pcall(function() humanoid.PlatformStand = false end)
 end)
end

local function handleFlyToggle(state)
 if state then
  flyState.enabled = true
  flyState.speed = flySlider.Get()
  if LocalPlayer.Character then
   enableFlyForCharacter(LocalPlayer.Character)
  end
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
  if flyBV and flyBV.Parent then
   flyBV:Destroy()
  end
 end
end

spawn(function()
 local last = flySlider.Get()
 while gui and gui.Parent do
  local cur = flySlider.Get()
  if cur ~= last then
   last = cur
   if flyToggle.Get() then
    flyState.speed = cur
   end
  end
  wait(0.15)
 end
end)

flyToggle.Button.MouseButton1Click:Connect(function()
 wait(0.05)
 handleFlyToggle(flyToggle.Get())
end)

-- ===========================
-- Functionality: NoClip (sama namun layout sudah rapih)
-- ===========================
local noClipData = {
 enabled = false;
 original = {}; -- map part -> original CanCollide
 connections = {}; -- descendant connections per-character
 charAddedConn = nil;
}

local function enableNoClipForCharacter(char)
 if not char then return end
 -- clear any previous data for safety
 noClipData.original = {}
 -- set CanCollide = false for all BasePart descendants and store original
 for _, desc in ipairs(char:GetDescendants()) do
  if desc:IsA("BasePart") then
   pcall(function()
    noClipData.original[desc] = desc.CanCollide
    desc.CanCollide = false
   end)
  end
 end
 -- listen for new parts added after; set them non-collidable and store original
 local conn = char.DescendantAdded:Connect(function(desc)
  if desc:IsA("BasePart") then
   pcall(function()
    noClipData.original[desc] = desc.CanCollide
    desc.CanCollide = false
   end)
  end
 end)
 table.insert(noClipData.connections, conn)
end

local function disableNoClip()
 -- restore original CanCollide for parts we recorded
 for part, orig in pairs(noClipData.original) do
  if part and part.Parent then
   pcall(function() part.CanCollide = orig end)
  end
 end
 -- cleanup
 for _, c in ipairs(noClipData.connections) do
  pcall(function() c:Disconnect() end)
 end
 noClipData.connections = {}
 noClipData.original = {}
 noClipData.enabled = false
 -- disconnect CharacterAdded listener if exists
 if noClipData.charAddedConn then
  pcall(function() noClipData.charAddedConn:Disconnect() end)
  noClipData.charAddedConn = nil
 end
end

local function handleNoClipToggle(state)
 if state then
  noClipData.enabled = true
  if LocalPlayer.Character then
   enableNoClipForCharacter(LocalPlayer.Character)
  end
  -- reapply on respawn
  if not noClipData.charAddedConn then
   noClipData.charAddedConn = LocalPlayer.CharacterAdded:Connect(function(char)
    if noClipData.enabled then
     char:WaitForChild("Humanoid", 5)
     enableNoClipForCharacter(char)
    end
   end)
  end
 else
  disableNoClip()
 end
end

noclipToggle.Button.MouseButton1Click:Connect(function()
 wait(0.05)
 handleNoClipToggle(noclipToggle.Get())
end)

-- Ensure restore on disable when player leaves / script destroyed
gui.DescendantRemoving:Connect(function(desc)
 if desc == gui then
  disableNoClip()
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
  end
 end)
end)

-- ===========================
-- Tabs wiring
-- ===========================
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
 serverFrame.Visible = false
 playerFrame.Visible = false
end)

tabServer.MouseButton1Click:Connect(function()
 selectTab(tabServer)
 infoFrame.Visible = false
 serverFrame.Visible = true
 playerFrame.Visible = false
end)

tabPlayer.MouseButton1Click:Connect(function()
 selectTab(tabPlayer)
 infoFrame.Visible = false
 serverFrame.Visible = false
 playerFrame.Visible = true
end)

selectTab(tabInfo)

-- end of script


-- Tambahan fitur baru: Freeze Character + Delete Small Notification
local freezeBaseY = 300

-- Freeze Character toggle
local freezeToggle = createToggle(playerFrame, "Freeze Character", freezeBaseY)
local frozen = false
freezeToggle.Button.MouseButton1Click:Connect(function()
    frozen = not frozen
    if frozen then
        freezeToggle.Set(true)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 0
                hum.JumpPower = 0
                hum.AutoRotate = false
            end
        end
    else
        freezeToggle.Set(false)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
                hum.AutoRotate = true
            end
        end
    end
end)

-- Delete Small Notification button
local delBtn = Instance.new("TextButton", playerFrame)
delBtn.Text = "Delete Small Notification"
delBtn.Size = UDim2.new(1, -20, 0, 36)
delBtn.Position = UDim2.new(0, 10, 0, freezeBaseY + 45)
delBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
delBtn.Font = Enum.Font.GothamBold
delBtn.TextSize = 16
local delCorner = Instance.new("UICorner", delBtn)
delCorner.CornerRadius = UDim.new(0, 8)

delBtn.MouseButton1Click:Connect(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg and pg:FindFirstChild("Small Notification") then
        pg["Small Notification"]:Destroy()
    end
end)

-- Jadikan Player dan Server frame bisa digulir (scrollable)
local function makeScrollable(frame)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
    scroll.ScrollBarThickness = 6
    scroll.BackgroundTransparency = 1
    for _, child in ipairs(frame:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UICorner") then
            child.Parent = scroll
        end
    end
    scroll.Parent = frame
end

makeScrollable(serverFrame)
makeScrollable(playerFrame)
