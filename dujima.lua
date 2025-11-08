--// Chloe X Style UI (Side Tabs Version) by Majid

local gui = Instance.new("ScreenGui")
gui.Name = "ChloeX_UI"
gui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 230)
main.Position = UDim2.new(0.5, -180, 0.5, -115)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.35
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1.2
stroke.Color = Color3.fromRGB(120, 120, 255)
stroke.Transparency = 0.3

-- Judul atas
local title = Instance.new("TextLabel", main)
title.Text = "Chloe X | v0.1"
title.Size = UDim2.new(1, -10, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.TextScaled = true

local close = Instance.new("TextButton", main)
close.Text = "×"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.TextColor3 = Color3.fromRGB(255, 85, 85)
close.Font = Enum.Font.GothamBold
close.TextScaled = true
close.BackgroundTransparency = 1
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Bagian kiri untuk tab
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 90, 1, -40)
sidebar.Position = UDim2.new(0, 10, 0, 35)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
sidebar.BackgroundTransparency = 0.25

local sidebarCorner = Instance.new("UICorner", sidebar)
sidebarCorner.CornerRadius = UDim.new(0, 8)

-- Konten utama
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -120, 1, -50)
content.Position = UDim2.new(0, 110, 0, 40)
content.BackgroundTransparency = 1

-- Fungsi buat bikin tab
local function createTab(name, order)
	local tab = Instance.new("TextButton")
	tab.Text = name
	tab.Size = UDim2.new(1, -10, 0, 30)
	tab.Position = UDim2.new(0, 5, 0, (order - 1) * 35 + 5)
	tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tab.TextColor3 = Color3.fromRGB(220, 220, 220)
	tab.Font = Enum.Font.Gotham
	tab.TextSize = 14
	tab.Parent = sidebar
	
	local corner = Instance.new("UICorner", tab)
	corner.CornerRadius = UDim.new(0, 6)
	
	tab.MouseEnter:Connect(function()
		tab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	tab.MouseLeave:Connect(function()
		if not tab.Selected then
			tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		end
	end)
	
	return tab
end

-- Frame Info
local infoFrame = Instance.new("Frame", content)
infoFrame.Size = UDim2.new(1, 0, 1, 0)
infoFrame.BackgroundTransparency = 1
infoFrame.Visible = true

local infoText = Instance.new("TextLabel", infoFrame)
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.Text = "Versi: Chloe X UI\nStatus: Aktif\n\nTab ini menampilkan informasi dasar."
infoText.TextColor3 = Color3.fromRGB(230, 230, 230)
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 15
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.BackgroundTransparency = 1

-- Frame Server
local serverFrame = Instance.new("Frame", content)
serverFrame.Size = UDim2.new(1, 0, 1, 0)
serverFrame.BackgroundTransparency = 1
serverFrame.Visible = false

local serverLabel = Instance.new("TextLabel", serverFrame)
serverLabel.Text = "Rejoin Server"
serverLabel.Size = UDim2.new(0, 200, 0, 25)
serverLabel.Position = UDim2.new(0, 10, 0, 10)
serverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
serverLabel.Font = Enum.Font.GothamBold
serverLabel.TextSize = 15
serverLabel.BackgroundTransparency = 1
serverLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Switch slider kecil
local toggle = Instance.new("Frame", serverFrame)
toggle.Size = UDim2.new(0, 46, 0, 22)
toggle.Position = UDim2.new(0, 230, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.BackgroundTransparency = 0.2

local toggleCorner = Instance.new("UICorner", toggle)
toggleCorner.CornerRadius = UDim.new(1, 0)

local circle = Instance.new("Frame", toggle)
circle.Size = UDim2.new(0, 20, 0, 20)
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
			tweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0, 1)}):Play()
			circle.BackgroundColor3 = Color3.fromRGB(85, 255, 85)
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		else
			tweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0, 1)}):Play()
			circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
		end
	end
end)

-- Buat tombol tab
local tabInfo = createTab("Info", 1)
local tabServer = createTab("Server", 2)

-- Logika tab
local function selectTab(tab)
	for _, btn in ipairs(sidebar:GetChildren()) do
		if btn:IsA("TextButton") then
			btn.Selected = false
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		end
	end
	tab.Selected = true
	tab.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
end

tabInfo.MouseButton1Click:Connect(function()
	selectTab(tabInfo)
	infoFrame.Visible = true
	serverFrame.Visible = false
end)

tabServer.MouseButton1Click:Connect(function()
	selectTab(tabServer)
	infoFrame.Visible = false
	serverFrame.Visible = true
end)

-- Awal default tab Info aktif
selectTab(tabInfo)
