-- Buat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChloeX_InfoMenu"
ScreenGui.Parent = game.CoreGui

-- Buat Frame utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Bayangan halus (UI Stroke)
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(100, 100, 255)
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Stroke.Parent = MainFrame

-- Rounded corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Judul (Info)
local Title = Instance.new("TextLabel")
Title.Text = "Chloe X | Info"
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Tombol Close (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.TextColor3 = Color3.fromRGB(255, 85, 85)
CloseButton.TextScaled = true
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
end)

-- Konten teks di dalam menu
local InfoText = Instance.new("TextLabel")
InfoText.Size = UDim2.new(1, -20, 1, -50)
InfoText.Position = UDim2.new(0, 10, 0, 40)
InfoText.Text = "Versi: Contoh\nStatus: Aktif\n\nIni hanya tampilan contoh info menu seperti Chloe X."
InfoText.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoText.TextWrapped = true
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.BackgroundTransparency = 1
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = 14
InfoText.Parent = MainFrame
