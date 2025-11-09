--// Chloe X Style UI (Server Tools v0.4) by Majid (dengan tab Player: WalkSpeed & Fly)

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 300)
main.Position = UDim2.new(0.5, -260, 0.5, -150)
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
title.Text = "Chloe X | v0.4"
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
sidebar.Size = UDim2.new(0, 120, 1, -50)
sidebar.Position = UDim2.new(0, 15, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BackgroundTransparency = 0.23

local sideCorner = Instance.new("UICorner", sidebar)
sideCorner.CornerRadius = UDim.new(0, 10)

-- Content
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -160, 1, -60)
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
infoText.Text = "Versi: ChloeX UI v0.4\nStatus: Aktif\n\nUI besar, clean, dan rapi seperti Chloe X."
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
-- Player Tab (WalkSpeed + Fly)
-- ===========================
local playerFrame = Instance.new("Frame", content)
playerFrame.Size = UDim2.new(1, 0, 1, 0)
playerFrame.BackgroundTransparency = 1
playerFrame.Visible = false

-- Helper: Create label
local function createLabel(parent, text, posY)
 local lbl = Instance.new("TextLabel", parent)
 lbl.Text = text
 lbl.Size = UDim2.new(0, 200, 0, 22)
 lbl.Position = UDim2.new(0, 10, 0, posY)
 lbl.BackgroundTransparency = 1
 lbl.TextColor3 = Color3.fromRGB(235,235,235)
 lbl.Font = Enum.Font.GothamBold
 lbl.TextSize = 14
 lbl.TextXAlignment = Enum.TextXAlignment.Left
 return lbl
end

-- Helper: Create toggle (simple switch)
local function createToggle(parent, text, posY)
 local lbl = createLabel(parent, text, posY)
 local btn = Instance.new("TextButton", parent)
 btn.Size = UDim2.new(0, 80, 0, 26)
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

-- Helper: Create slider + textbox (posY is top)
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
 knob.Image = "rbxassetid://3926305904" -- circular
 knob.ImageRectOffset = Vector2.new(924, 724)
 knob.ImageRectSize = Vector2.new(36, 36)

 local box = Instance.new("TextBox", parent)
 box.Size = UDim2.new(0, 80, 0, 26)
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
			-- restore shown value
			box.Text = tostring(val)
		end
	end)

	return {
		Get = function() return val end;
		Set = function(v) val = setValue(v) end;
	}
end

-- Create UI elements inside playerFrame
local walkToggle = createToggle(playerFrame, "WalkSpeed", 8)
local walkSlider = createSliderWithBox(playerFrame, "WalkSpeed Value", 36, 8, 200, 16) -- default 16
local flyToggle = createToggle(playerFrame, "Fly", 90)
local flySlider = createSliderWithBox(playerFrame, "Fly Speed", 118, 10, 200, 50) -- default 50

-- Some explanatory note
local note = Instance.new("TextLabel", playerFrame)
note.Text = "Fly: gunakan WASD / virtual-stick untuk gerak horizontal.\nNaik: tombol Jump. Turun: tahan Shift (PC) atau sentuh 2 jari (mobile)."
note.Position = UDim2.new(0,10,0,170)
note.Size = UDim2.new(1,-20,0,60)
note.BackgroundTransparency = 1
note.TextColor3 = Color3.fromRGB(200,200,200)
note.Font = Enum.Font.Gotham
note.TextSize = 13
note.TextWrapped = true
note.TextYAlignment = Enum.TextYAlignment.Top

-- ===========================
-- Functionality: WalkSpeed
-- ===========================
local originalWalkSpeed = 16
local walkConnection = nil

local function applyWalkSpeed(enabled)
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if enabled then
			-- set to slider value
			humanoid.WalkSpeed = walkSlider.Get()
		else
			humanoid.WalkSpeed = originalWalkSpeed
		end
	end
end

-- Keep walk speed persistent while enabled and character respawns
local function handleWalkToggle(state)
	if state then
		-- set initial and monitor for respawn
		if LocalPlayer.Character then
			local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				-- store original only once
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
		-- disable
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

-- slider change observer (we'll update WalkSpeed live while ON)
-- We don't have direct event from slider; use RunService to poll small interval
local lastWalkVal = walkSlider.Get()
spawn(function()
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
	-- toggle handled in createToggle already; we just react
	wait(0.05)
	handleWalkToggle(walkToggle.Get())
end)

-- Ensure when player joins, store original speed
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
-- Functionality: Fly
-- ===========================
-- Implementation note:
-- - Uses BodyVelocity on HumanoidRootPart to move character while fly enabled.
-- - Horizontal direction uses Humanoid.MoveDirection (works for mobile & PC).
-- - Ascend when humanoid.Jumping occurs (jump button), descend when LeftShift held (PC)
--   or when touch count >= 2 (mobile).
-- - Keeps active across tab switches until turned off.

local flyState = {
	enabled = false;
	speed = flySlider.Get();
}

local flyBV = nil
local flyCharacter = nil
local flyHumanoid = nil
local flyHRP = nil

local touchCount = 0
local shiftDown = false
local ascendFlag = false

-- track touches for mobile descent detection
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

-- detect jump events
local function onHumanoidJumping(isJumping)
	if isJumping then
		ascendFlag = true
		-- small timer to avoid sticky ascend
		delay(0.2, function() ascendFlag = false end)
	end
end

local function enableFlyForCharacter(char)
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	if not humanoid or not hrp then return end

	-- store references
	flyCharacter = char
	flyHumanoid = humanoid
	flyHRP = hrp

	-- create BodyVelocity
	if not flyBV or not flyBV.Parent then
		flyBV = Instance.new("BodyVelocity")
		flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		flyBV.P = 1250
		flyBV.Velocity = Vector3.new(0,0,0)
		flyBV.Parent = flyHRP
	else
		flyBV.Parent = flyHRP
	end

	-- prevent default falling
	pcall(function() flyHumanoid.PlatformStand = false end) -- don't fully platformstand; using BV so hum still okay
	-- Connect Jumping
	flyHumanoid.Jumping:Connect(onHumanoidJumping)
end

local function disableFly()
	flyState.enabled = false
	if flyBV and flyBV.Parent then
		flyBV:Destroy()
		flyBV = nil
	end
	if flyHumanoid then
		-- nothing harmful; allow normals
		pcall(function() flyHumanoid.PlatformStand = false end)
	end
	flyCharacter = nil
	flyHumanoid = nil
	flyHRP = nil
end

-- main fly loop
local flyLoopConn = nil
local function startFlyLoop()
	if flyLoopConn then return end
	flyLoopConn = RunService.RenderStepped:Connect(function(dt)
		if not flyState.enabled then return end
		local char = LocalPlayer.Character
		if not char then return end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then return end
		-- ensure BV exists and parented
		if not flyBV or not flyBV.Parent then
			flyBV = Instance.new("BodyVelocity")
			flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
			flyBV.P = 1250
			flyBV.Parent = hrp
		else
			flyBV.Parent = hrp
		end

		-- horizontal direction from Humanoid.MoveDirection (supports mobile & keyboard)
		local moveDir = humanoid.MoveDirection -- Vector3 in world space
		local horizontal = Vector3.new(moveDir.X, 0, moveDir.Z)
		local camera = workspace.CurrentCamera
		-- Convert moveDir (which is already world-space directional) to desired horizontal velocity
		local horizontalVel = Vector3.new(horizontal.X, 0, horizontal.Z).Unit
		if horizontalVel ~= horizontalVel then horizontalVel = Vector3.new(0,0,0) end -- NaN guard

		local speed = flySlider.Get()
		local horizPart = horizontal * speed

		-- vertical control: ascendFlag (jump) => ascend; shiftDown or (touchCount >= 2) => descend
		local vert = 0
		if ascendFlag then
			vert = speed
		elseif shiftDown or touchCount >= 2 then
			vert = -speed
		else
			vert = 0
		end

		-- set velocity
		local targetVel = Vector3.new(horizPart.X, vert, horizPart.Z)
		-- smooth by lerp with current velocity
		if flyBV then
			flyBV.Velocity = Vector3.new(targetVel.X, targetVel.Y, targetVel.Z)
		end

		-- reduce gravity effect by adjusting Humanoid state
		pcall(function()
			humanoid.PlatformStand = false
		end)
	end)
end

-- stop loop
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

-- Handler to toggle fly
local function handleFlyToggle(state)
	if state then
		flyState.enabled = true
		flyState.speed = flySlider.Get()
		-- ensure applied on current char
		if LocalPlayer.Character then
			enableFlyForCharacter(LocalPlayer.Character)
		end
		-- character respawn handling
		LocalPlayer.CharacterAdded:Connect(function(char)
			if flyState.enabled then
				-- small delay to allow HRP creation
				char:WaitForChild("HumanoidRootPart", 5)
				enableFlyForCharacter(char)
			end
		end)
		startFlyLoop()
	else
		flyState.enabled = false
		stopFlyLoop()
		disableFly()
	end
end

-- Poll fly speed slider to update speed live
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

-- Ensure when player respawns we reapply if toggle still true
LocalPlayer.CharacterAdded:Connect(function(char)
	-- small delay for humanoid
	spawn(function()
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then
			if walkToggle.Get() then
				hum.WalkSpeed = walkSlider.Get()
			end
			if flyToggle.Get() then
				enableFlyForCharacter(char)
			end
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
