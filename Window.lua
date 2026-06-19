local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة مساعدة للسحب الناعم (للقائمة والزر العائم)
local function MakeDraggable(dragPart, targetPart)
    local Dragging, DragInput, DragStart, StartPosition

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = targetPart.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            TweenService:Create(targetPart, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "Fluent Hub"
    local DescText = Options.Description or "[+] Premium UI"
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisFluent_Hub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local success = pcall(function() self.ScreenGui.Parent = gethui() end)
    if not success then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الزر العائم (المربع الذي يظهر عند التصغير)
    self.FloatingBtn = Instance.new("TextButton")
    self.FloatingBtn.Name = "FloatingOpenButton"
    self.FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    self.FloatingBtn.Position = UDim2.new(0.5, -22, 0.1, 0)
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 25, 30) -- لون زجاجي مائل للأزرق الداكن
    self.FloatingBtn.BackgroundTransparency = 0.2
    self.FloatingBtn.Text = "A" -- حرف يمثل AxisUI أو شعار
    self.FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.FloatingBtn.Font = Enum.Font.GothamBold
    self.FloatingBtn.TextSize = 20
    self.FloatingBtn.Visible = false -- مخفي في البداية
    self.FloatingBtn.Parent = self.ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 10)
    FloatCorner.Parent = self.FloatingBtn

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(255, 255, 255)
    FloatStroke.Transparency = 0.8
    FloatStroke.Thickness = 1
    FloatStroke.Parent = self.FloatingBtn

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- برمجة لتمييز السحب عن الضغط للزر العائم
    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStartPos = input.Position
        end
    end)
    self.FloatingBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragStartPos then
            local delta = (input.Position - dragStartPos).Magnitude
            if delta < 5 then -- إذا لم يتحرك الماوس كثيراً، اعتبرها ضغطة
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, 50) -- تأثير دخول من الأسفل
                TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -350, 0.5, -225), BackgroundTransparency = 0.15}):Play()
            end
        end
    end)

    -- 3. الواجهة الرئيسية (Fluent Design)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 700, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 30) -- ألوان FluentModded
    self.MainFrame.BackgroundTransparency = 0.15 -- شفافية زجاجية
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 255, 255)
    MainStroke.Transparency = 0.85
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- 4. TopBar (شريط التحكم)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    -- نصوص TopBar
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 28)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar

    -- أزرار TopBar
    local function CreateTopBtn(name, text, posOffset)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(1, posOffset, 0, 10)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(150, 150, 150)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = self.TopBar

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end)
        return btn
    end

    self.CloseBtn = CreateTopBtn("Close", "✕", -40)
    self.MinBtn = CreateTopBtn("Minimize", "—", -75)

    -- برمجة زر التصغير والإغلاق
    self.MinBtn.MouseButton1Click:Connect(function()
        local tweenOut = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -350, 0.5, 50), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true -- إظهار الزر العائم
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- 5. Sidebar (القائمة الجانبية)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 180, 1, -50)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 50)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.MainFrame

    -- 6. Search Bar (مربع البحث)
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(1, -30, 0, 32)
    self.SearchFrame.Position = UDim2.new(0, 15, 0, 10)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(30, 45, 55)
    self.SearchFrame.BackgroundTransparency = 0.5
    self.SearchFrame.Parent = self.Sidebar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = self.SearchFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Color3.fromRGB(255, 255, 255)
    SearchStroke.Transparency = 0.9
    SearchStroke.Parent = self.SearchFrame

    self.SearchIcon = Instance.new("TextLabel")
    self.SearchIcon.Size = UDim2.new(0, 30, 1, 0)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Text = "🔍"
    self.SearchIcon.TextColor3 = Color3.fromRGB(180, 180, 180)
    self.SearchIcon.TextSize = 14
    self.SearchIcon.Parent = self.SearchFrame

    self.SearchBox = Instance.new("TextBox")
    self.SearchBox.Size = UDim2.new(1, -35, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 30, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SearchBox.Font = Enum.Font.Gotham
    self.SearchBox.TextSize = 13
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.Parent = self.SearchFrame

    -- تأثير عند كتابة أو تحديد مربع البحث
    self.SearchBox.Focused:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.5, Color = Color3.fromRGB(0, 170, 255)}):Play()
    end)
    self.SearchBox.FocusLost:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.9, Color = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    return self
end

return AxisUI
