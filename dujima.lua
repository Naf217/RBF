-- //=== Dujina Hub GUI (Black Glossy Final Edition by GPT-5) ===\\
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local placeId = game.PlaceId

-- Hapus GUI lama jika sudah ada
if playerGui:FindFirstChild("TeleportGui") then
	playerGui.TeleportGui:Destroy()
end

-- GUI utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame utama
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 230)
frame.Position = UDim2.new(0.5, -135, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui

-- Efek gradient glossy
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Rotation = 90
gradient.Parent = frame

-- Bayangan halus
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
shadow.Size = UDim2.new(1, 50, 1, 50)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.55
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = 0
shadow.Parent = frame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = frame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
headerGradient.Rotation = 90
headerGradient.Parent = header

-- Judul GUI
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ Dujina Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Tombol minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -60, 0.5, -12)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Text = "-"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = header

-- Tombol exit
local exitButton = Instance.new("TextButton")
exitButton.Size = UDim2.new(0, 25, 0, 25)
exitButton.Position = UDim2.new(1, -30, 0.5, -12)
exitButton.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
exitButton.TextColor3 = Color3.new(1, 1, 1)
exitButton.Text = "X"
exitButton.Font = Enum.Font.GothamBold
exitButton.TextSize = 18
exitButton.Parent = header

-- Kontainer isi
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -38)
content.Position = UDim2.new(0, 0, 0, 38)
content.BackgroundTransparency = 1
content.Parent = frame

-- Suara GUI
local hoverSound = Instance.new("Sound", screenGui)
hoverSound.SoundId = "rbxassetid://9118823103"
hoverSound.Volume = 0.3

local clickSound = Instance.new("Sound", screenGui)
clickSound.SoundId = "rbxassetid://9118822712"
clickSound.Volume = 0.4

local startupSound = Instance.new("Sound", screenGui)
startupSound.SoundId = "rbxassetid://9119114482"
startupSound.Volume = 0.5

-- Fungsi tombol glossy
local function createButton(text, baseColor, yPos)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 230, 0, 45)
	button.Position = UDim2.new(0, 20, 0, yPos)
	button.BackgroundColor3 = baseColor
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.Text = text
	button.AutoButtonColor = false
	button.Parent = content

	local btnGradient = Instance.new("UIGradient")
	btnGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.15, Color3.fromRGB(180, 180, 180)),
		ColorSequenceKeypoint.new(0.5, baseColor),
		ColorSequenceKeypoint.new(1, baseColor:lerp(Color3.new(0, 0, 0), 0.5))
	}
	btnGradient.Rotation = 90
	btnGradient.Transparency = NumberSequence.new(0.35)
	btnGradient.Parent = button

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = baseColor:Lerp(Color3.new(1,1,1),0.2)}):Play()
		hoverSound:Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = baseColor}):Play()
	end)
	button.MouseButton1Click:Connect(function()
		clickSound:Play()
	end)
	return button
end

-- Tombol-tombol
local deleteButton = createButton("🧹 Hapus Small Notification", Color3.fromRGB(130,60,60), 10)
local teleportButton = createButton("🚀 Pindah Server Lain", Color3.fromRGB(60,110,180), 65)
local rejoinButton = createButton("🔁 Rejoin Server", Color3.fromRGB(80,160,80), 120)
local copyIdButton = createButton("📋 Copy Server ID", Color3.fromRGB(180,140,60), 175)

-- Fungsi tombol
deleteButton.MouseButton1Click:Connect(function()
	local notif = playerGui:FindFirstChild("Small Notification")
	if notif then
		notif:Destroy()
		deleteButton.Text = "✅ Notifikasi Terhapus"
	else
		deleteButton.Text = "❌ Tidak Ditemukan"
	end
end)

teleportButton.MouseButton1Click:Connect(function()
	teleportButton.Text = "🔄 Sedang Mentransfer..."
	teleportButton.Active = false
	TeleportService:Teleport(placeId, player)
end)

rejoinButton.MouseButton1Click:Connect(function()
	rejoinButton.Text = "🔁 Rejoining..."
	rejoinButton.Active = false
	TeleportService:Teleport(placeId, player)
end)

copyIdButton.MouseButton1Click:Connect(function()
	local id = game.JobId
	if setclipboard then
		setclipboard(id)
		copyIdButton.Text = "📋 ID Disalin!"
	else
		copyIdButton.Text = "❌ Tidak bisa menyalin!"
	end
end)

-- Minimize
local minimized = false
local function toggleMinimize()
	minimized = not minimized
	minimizeButton.Text = minimized and "+" or "-"
	clickSound:Play()

	if minimized then
		TweenService:Create(content, TweenInfo.new(0.3), {
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()
	else
		content.Visible = true
		content.BackgroundTransparency = 1
		content.Size = UDim2.new(1, 0, 0, 0)
		TweenService:Create(content, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 1, -38),
			BackgroundTransparency = 0
		}):Play()
	end
end
minimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Exit
exitButton.MouseButton1Click:Connect(function()
	clickSound:Play()
	TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
	task.wait(0.4)
	screenGui:Destroy()
end)

-- Animasi awal + suara startup
frame.Size = UDim2.new(0, 0, 0, 0)
frame.BackgroundTransparency = 1
TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 270, 0, 230),
	BackgroundTransparency = 0
}):Play()
startupSound:Play()

-- Drag GUI
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
