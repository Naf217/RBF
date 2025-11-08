--// Chloe X v0.3 Style Menu
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChloeXv03"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.35
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "Chloe X | v0.3"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true

-- Tabs (Server / Info)
local TabsFrame = Instance.new("Frame")
TabsFrame.Parent = MainFrame
TabsFrame.Size = UDim2.new(1, -20, 0, 35)
TabsFrame.Position = UDim2.new(0, 10, 0, 45)
TabsFrame.BackgroundTransparency = 1

local function createTab(name, xPos)
	local Button = Instance.new("TextButton")
	Button.Parent = TabsFrame
	Button.Text = name
	Button.Size = UDim2.new(0, 120, 0, 30)
	Button.Position = UDim2.new(0, xPos, 0, 0)
	Button.Font = Enum.Font.Gotham
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Button.BackgroundTransparency = 0.4
	Button.AutoButtonColor = true
	Button.BorderSizePixel = 0
	return Button
end

local ServerTab = createTab("Server", 0)
local InfoTab = createTab("Info", 130)

-- Content
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -20, 1, -90)
ContentFrame.Position = UDim2.new(0, 10, 0, 80)
ContentFrame.BackgroundTransparency = 1

-- Label Join Server
local JoinLabel = Instance.new("TextLabel")
JoinLabel.Parent = ContentFrame
JoinLabel.Text = "Join Server To Link:"
JoinLabel.Size = UDim2.new(1, 0, 0, 25)
JoinLabel.Font = Enum.Font.Gotham
JoinLabel.TextScaled = true
JoinLabel.BackgroundTransparency = 1
JoinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

-- TextBox Input Link
local LinkBox = Instance.new("TextBox")
LinkBox.Parent = ContentFrame
LinkBox.Size = UDim2.new(1, 0, 0, 30)
LinkBox.Position = UDim2.new(0, 0, 0, 30)
LinkBox.PlaceholderText = "Input link"
LinkBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
LinkBox.TextColor3 = Color3.fromRGB(255, 255, 255)
LinkBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LinkBox.BackgroundTransparency = 0.5
LinkBox.BorderSizePixel = 0
LinkBox.Text = ""
LinkBox.Font = Enum.Font.Gotham
LinkBox.TextScaled = true
LinkBox.ClearTextOnFocus = false

-- Tombol Join
local JoinButton = Instance.new("TextButton")
JoinButton.Parent = ContentFrame
JoinButton.Size = UDim2.new(1, 0, 0, 35)
JoinButton.Position = UDim2.new(0, 0, 0, 70)
JoinButton.Text = "Join"
JoinButton.Font = Enum.Font.GothamBold
JoinButton.TextScaled = true
JoinButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JoinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinButton.AutoButtonColor = true
JoinButton.BorderSizePixel = 0

-- Fungsi Join Server
JoinButton.MouseButton1Click:Connect(function()
	local link = LinkBox.Text
	if link ~= "" then
		local placeId, jobId = string.match(link, "place%=(%d+).-(%w+)$")
		if placeId and jobId then
			TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, player)
		else
			warn("Link tidak valid!")
		end
	else
		warn("Isi link terlebih dahulu.")
	end
end)
