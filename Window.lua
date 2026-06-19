local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- دالة مساعدة للسحب الناعم والاحترافي (بدون تعليق أو طلاسم)
local function MakeDraggable(dragPart, targetPart)
    local Dragging = false
    local DragInput, DragStart, StartPosition

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
            TweenService:Create(targetPart, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "FluentModded dev"
    local DescText = Options.Description or "Advanced User"
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisFluent_Blackhole"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local success = pcall(function() self.ScreenGui.Parent = gethui() end)
    if not success then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الزر العائم (المربع الذي يظهر عند التصغير)
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Name = "FloatingOpenButton"
    self.FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    self.FloatingBtn.Position = UDim2.new(0.5, -22, 0.1, 0)
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 10, 5) -- لون مائل للبرتقالي الغامق
    self.FloatingBtn.BackgroundTransparency = 0.2
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12)
    FloatCorner.Parent = self.FloatingBtn

    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Color = Color3.fromRGB(255, 140, 0) -- برتقالي
    FloatStroke.Transparency = 0.5
    FloatStroke.Thickness = 1.5
    FloatStroke.Parent = self.FloatingBtn
    
    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
    FloatIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = "rbxassetid://103845371952278" -- استخدمنا أيقونة التكبير كشعار له
    FloatIcon.Parent = self.FloatingBtn

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- حل جذري (بدون طلاسم) للتفرقة بين الضغط والسحب لفتح القائمة
    local clickStartPos = nil
    local clickStartTime = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            clickStartPos = input.Position
            clickStartTime = tick()
        end
    end)
    self.FloatingBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and clickStartPos then
            local dist = (input.Position - clickStartPos).Magnitude
            local timePassed = tick() - clickStartTime
            -- إذا الماوس ماتحرك كثير والوقت قصير = ضغطة حقيقية
            if dist < 10 and timePassed < 0.5 then
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, 50) 
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, -350, 0.5, -225), 
                    BackgroundTransparency = 0.1
                }):Play()
            end
        end
    end)

    -- 3. الواجهة الرئيسية (Blackhole + Dark Orange + Fluent Design)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 700, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- أبيض حتى يظهر الـ UIGradient
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(255, 120, 0) -- لمسة برتقالية على الإطار
    MainStroke.Transparency = 0.7
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- UIGradient الأسطوري (أنيميشن Blackhole + Orange)
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),      -- أسود غامق
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 15, 0)),  -- برتقالي غامق (Dark Orange)
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))       -- رمادي غامق جداً
    })
    MainGradient.Rotation = 45
    MainGradient.Parent = self.MainFrame

    -- تشغيل تأثير الـ Gradient (يتحرك ببطء ذهاباً وإياباً)
    spawn(function()
        local tweenInfo = TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
        MainGradient.Offset = Vector2.new(-0.3, -0.3)
        TweenService:Create(MainGradient, tweenInfo, {Offset = Vector2.new(0.3, 0.3)}):Play()
    end)

    -- 4. TopBar (شريط التحكم)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

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
    self.DescLabel.TextColor3 = Color3.fromRGB(200, 100, 0) -- برتقالي خافت
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar

    -- أزرار TopBar بالأيقونات الأصلية المطلوبة
    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 20, 0, 20)
        btn.Position = UDim2.new(1, posOffset, 0, 15)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ImageColor3 = Color3.fromRGB(150, 150, 150)
        btn.Parent = self.TopBar

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- برمجة الإغلاق والتصغير
    self.MinBtn.MouseButton1Click:Connect(function()
        local tweenOut = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -350, 0.5, 50), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true -- إظهار الزر العائم بعد التصغير
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- 5. الخطوط الفاصلة (Dividers) للمستقبل (Tabs & Elements)
    local TopDivider = Instance.new("Frame")
    TopDivider.Name = "TopDivider"
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 50)
    TopDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopDivider.BackgroundTransparency = 0.85
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = self.MainFrame

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Name = "SidebarDivider"
    SidebarDivider.Size = UDim2.new(0, 1, 1, -50)
    SidebarDivider.Position = UDim2.new(0, 180, 0, 50)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarDivider.BackgroundTransparency = 0.85
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = self.MainFrame

    -- 6. Sidebar (القائمة الجانبية)
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 180, 1, -50)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 50)
    self.Sidebar.BackgroundTransparency = 1
    self.Sidebar.Parent = self.MainFrame

    -- 7. مساحة العناصر (Elements Container للمستقبل)
    self.ElementsArea = Instance.new("Frame")
    self.ElementsArea.Size = UDim2.new(1, -181, 1, -50)
    self.ElementsArea.Position = UDim2.new(0, 181, 0, 50)
    self.ElementsArea.BackgroundTransparency = 1
    self.ElementsArea.Parent = self.MainFrame

    -- 8. Search Bar باللون والأيقونة المطلوبة
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(1, -30, 0, 32)
    self.SearchFrame.Position = UDim2.new(0, 15, 0, 15)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.SearchFrame.BackgroundTransparency = 0.6
    self.SearchFrame.Parent = self.Sidebar

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = self.SearchFrame

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = Color3.fromRGB(255, 255, 255)
    SearchStroke.Transparency = 0.8
    SearchStroke.Parent = self.SearchFrame

    self.SearchIcon = Instance.new("ImageLabel")
    self.SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    self.SearchIcon.Position = UDim2.new(0, 10, 0.5, -8)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Image = "rbxassetid://118685771787843"
    self.SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchIcon.Parent = self.SearchFrame

    self.SearchBox = Instance.new("TextBox")
    self.SearchBox.Size = UDim2.new(1, -40, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 32, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SearchBox.Font = Enum.Font.Gotham
    self.SearchBox.TextSize = 13
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.Parent = self.SearchFrame

    self.SearchBox.Focused:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.2, Color = Color3.fromRGB(255, 140, 0)}):Play()
        TweenService:Create(self.SearchIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(255, 140, 0)}):Play()
    end)
    self.SearchBox.FocusLost:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.8, Color = Color3.fromRGB(255, 255, 255)}):Play()
        TweenService:Create(self.SearchIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
    end)

    return self
end

return AxisUI
