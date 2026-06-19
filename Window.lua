-- AxisUI | Window.lua
-- السكربت مخصص للعمل على الـ Executors

local AxisUI = {}
AxisUI.__index = AxisUI

-- خدمات روبلوكس الأساسية
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    -- إعدادات النافذة
    local Title = Options.Title or "AxisUI Hub"
    local Description = Options.Description or "[+] AxisUI"
    
    -- 1. إنشاء ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisUI_Hub"
    self.ScreenGui.ResetOnSpawn = false
    -- الحماية لتشغيله في الـ Executor
    local success, _ = pcall(function()
        self.ScreenGui.Parent = (gethui and gethui()) or CoreGui
    end)
    if not success then
        self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- 2. الإطار الرئيسي (Main Frame)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "Main"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- لون داكن جداً (نفس الصورة)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame

    -- العنوان (Title)
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = Title
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar

    -- الوصف (Description)
    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Description"
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 15, 0, 30)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = Description
    self.DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150) -- لون رمادي فاتح
    self.DescLabel.TextSize = 12
    self.DescLabel.Font = Enum.Font.Gotham
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar

    -- أزرار التحكم (Control Buttons: X, -)
    -- زر الإغلاق (X)
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Name = "Close"
    self.CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    self.CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    self.CloseBtn.BackgroundTransparency = 1
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.CloseBtn.TextSize = 14
    self.CloseBtn.Font = Enum.Font.Gotham
    self.CloseBtn.Parent = self.TopBar

    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- زر التصغير (-)
    self.MinBtn = Instance.new("TextButton")
    self.MinBtn.Name = "Minimize"
    self.MinBtn.Size = UDim2.new(0, 30, 0, 30)
    self.MinBtn.Position = UDim2.new(1, -70, 0, 10)
    self.MinBtn.BackgroundTransparency = 1
    self.MinBtn.Text = "—"
    self.MinBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.MinBtn.TextSize = 14
    self.MinBtn.Font = Enum.Font.Gotham
    self.MinBtn.Parent = self.TopBar

    self.MinBtn.MouseButton1Click:Connect(function()
        -- حركة تصغير القائمة (سنطورها لاحقاً)
        self.MainFrame.Visible = not self.MainFrame.Visible
    end)

    -- 4. القائمة الجانبية (Sidebar للخانات/Tabs)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 180, 1, -60)
    self.Sidebar.Position = UDim2.new(0, 10, 0, 50)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- أفتح قليلاً من الخلفية
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 6)
    SidebarCorner.Parent = self.Sidebar

    -- 5. مساحة العرض الرئيسية (Content Area)
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -210, 1, -60)
    self.ContentContainer.Position = UDim2.new(0, 200, 0, 50)
    self.ContentContainer.BackgroundColor3 = Color3.fromRGB(22, 22, 22) -- مساحة العرض
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.Parent = self.MainFrame

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 6)
    ContentCorner.Parent = self.ContentContainer

    return self
end

return AxisUI

