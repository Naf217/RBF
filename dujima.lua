--// Chloe X Style UI (Server Tools v0.3) by Majid

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
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
title.Text = "Chloe X | v0.3"
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
infoText.Text = "Versi: ChloeX UI v0.3\nStatus: Aktif\n\nUI besar, clean, dan rapi seperti Chloe X."
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

-- Tabs
local tabInfo = createTab("Info", 1)
local tabServer = createTab("Server", 2)

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
end)

tabServer.MouseButton1Click:Connect(function()
	selectTab(tabServer)
	infoFrame.Visible = false
	serverFrame.Visible = true
end)

selectTab(tabInfo)
