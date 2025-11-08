--// Chloe X Style UI (Info + Server) by Majid
--// Untuk Delta Roblox Executor

-- ScreenGui utama
local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = game.CoreGui

-- Frame utama
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 330, 0, 230)
main.Position = UDim2.new(0.5, -165, 0.5, -115)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.3
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(120, 120, 255)
stroke.Transparency = 0.3

-- Judul
local title = Instance.new("TextLabel", main)
title.Text = "Chloe X | Version Contoh"
title.Size = UDim2.new(1, -40, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextScaled = true

-- Tombol X (Close)
local close = Instance.new("TextButton", main)
close.Text = "X"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.TextColor3 = Color3.fromRGB(255, 85, 85)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.BackgroundTransparency = 1

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Tab Container
local tabContainer = Instance.new("Frame", main)
tabContainer.Size = UDim2.new(1, -20, 0, 30)
tabContainer.Position = UDim2.new(0, 10, 0, 40)
tabContainer.BackgroundTransparency = 1

-- Konten Frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -20, 1, -80)
content.Position = UDim2.new(0, 10, 0, 70)
content.BackgroundTransparency = 1

-- Fungsi helper
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.Position = UDim2.new(0, (order - 1) * 110, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = tabContainer
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	end)
	
	return btn
end

-- Frame Info
local infoFrame = Instance.new("Frame", content)
infoFrame.Size = UDim2.new(1, 0, 1, 0)
infoFrame.Visible = true
infoFrame.BackgroundTransparency = 1

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.Text = "Versi: Contoh\nStatus: Aktif\n\nIni tab Info seperti di Chloe X."
infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 16
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.BackgroundTransparency = 1

-- Frame Server
local serverFrame = Instance.new("Frame", content)
serverFrame.Size = UDim2.new(1, 0, 1, 0)
serverFrame.Visible = false
serverFrame.BackgroundTransparency = 1

-- Label judul fitur
local serverLabel = Instance.new("TextLabel", serverFrame)
serverLabel.Text = "Rejoin Server"
serverLabel.Size = UDim2.new(0, 200, 0, 30)
serverLabel.Position = UDim2.new(0, 10, 0, 10)
serverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
serverLabel.Font = Enum.Font.GothamBold
serverLabel.TextSize = 16
serverLabel.BackgroundTransparency = 1
serverLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Switch (slider kecil)
local toggle = Instance.new("Frame", serverFrame)
toggle.Size = UDim2.new(0, 50, 0, 25)
toggle.Position = UDim2.new(0, 240, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.BackgroundTransparency = 0.2

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(1, 0)

local circle = Instance.new("Frame", toggle)
circle.Size = UDim2.new(0, 23, 0, 23)
circle.Position = UDim2.new(0, 1, 0, 1)
circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
local circleCorner = Instance.new("UICorner", circle)
circleCorner.CornerRadius = UDim.new(1, 0)

local tweenService = game:GetService("TweenService")
local toggleOn = false

toggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		toggleOn = not toggleOn
		if toggleOn then
			tweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -24, 0, 1)}):Play()
			circle.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
			print("Rejoin Server: ON")
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		else
			tweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0, 1)}):Play()
			circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
			print("Rejoin Server: OFF")
		end
	end
end)

-- Tombol Tab
local tabInfo = createTabButton("Info", 1)
local tabServer = createTabButton("Server", 2)

tabInfo.MouseButton1Click:Connect(function()
	infoFrame.Visible = true
	serverFrame.Visible = false
end)

tabServer.MouseButton1Click:Connect(function()
	infoFrame.Visible = false
	serverFrame.Visible = true
end)
