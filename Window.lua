local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة مساعدة لجعل النافذة قابلة للسحب بسلاسة واحترافية
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "AxisUI Hub"
    local DescText = Options.Description or "[+] AxisUI"
    
    -- 1. إعداد الـ ScreenGui للحماية والاستخدام في الـ Executors
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MatrixV_PremiumHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local success = pcall(function() self.ScreenGui.Parent = gethui() end)
    if not success then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الإطار الرئيسي (Main Frame) بلون داكن وفخم
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 420)
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16) -- لون أسود/رمادي داكن جداً
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = self.MainFrame

    -- إضافة حدود خفيفة (Stroke) لزيادة الاحترافية
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(35, 35, 35)
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 60)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame

    MakeDraggable(self.TopBar, self.MainFrame)

    -- 4. حاوية النصوص (العنوان والوصف)
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "TextContainer"
    TextContainer.Size = UDim2.new(0, 300, 1, 0)
    TextContainer.Position = UDim2.new(0, 20, 0, 0)
    TextContainer.BackgroundTransparency = 1
    TextContainer.Parent = self.TopBar

    local UIListLayout_Text = Instance.new("UIListLayout")
    UIListLayout_Text.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Text.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Text.Padding = UDim.new(0, 4)
    UIListLayout_Text.Parent = TextContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 20)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = TextContainer

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Description"
    self.DescLabel.Size = UDim2.new(1, 0, 0, 14)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.DescLabel.TextSize = 12
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = TextContainer

    -- 5. حاوية أزرار التحكم (يمين الشاشة)
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Name = "Controls"
    ControlsContainer.Size = UDim2.new(0, 120, 1, 0)
    ControlsContainer.Position = UDim2.new(1, -120, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = self.TopBar

    local ControlsLayout = Instance.new("UIListLayout")
    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ControlsLayout.Padding = UDim.new(0, 15)
    ControlsLayout.Parent = ControlsContainer

    local ControlsPadding = Instance.new("UIPadding")
    ControlsPadding.PaddingRight = UDim.new(0, 20)
    ControlsPadding.Parent = ControlsContainer

    -- دالة مساعدة لإنشاء الأزرار مع تأثيرات التمرير (Hover)
    local function CreateControlButton(name, icon, layoutOrder)
        local Btn = Instance.new("TextButton")
        Btn.Name = name
        Btn.Size = UDim2.new(0, 20, 0, 20)
        Btn.BackgroundTransparency = 1
        Btn.Text = icon
        Btn.TextColor3 = Color3.fromRGB(130, 130, 130)
        Btn.TextSize = 16
        Btn.Font = Enum.Font.Gotham
        Btn.LayoutOrder = layoutOrder
        Btn.Parent = ControlsContainer

        -- تأثير عند وضع الماوس
        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        -- تأثير عند إبعاد الماوس
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130, 130, 130)}):Play()
        end)

        return Btn
    end

    self.MinBtn = CreateControlButton("Minimize", "—", 1)
    self.MaxBtn = CreateControlButton("Maximize", "□", 2)
    self.CloseBtn = CreateControlButton("Close", "✕", 3)

    -- 6. برمجة الأزرار بحركات سلسة (Animations)
    local isMinimized = false
    self.MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        local targetSize = isMinimized and UDim2.new(0, 650, 0, 60) or UDim2.new(0, 650, 0, 420)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    local isMaximized = false
    local preMaxSize = UDim2.new(0, 650, 0, 420)
    local preMaxPos = self.MainFrame.Position
    self.MaxBtn.MouseButton1Click:Connect(function()
        if isMinimized then return end
        isMaximized = not isMaximized
        local targetSize = isMaximized and UDim2.new(0, 800, 0, 500) or preMaxSize
        local targetPos = isMaximized and UDim2.new(0.5, -400, 0.5, -250) or preMaxPos
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        -- تأثير اختفاء ناعم قبل الإغلاق
        local fadeOut = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 650, 0, 0), BackgroundTransparency = 1})
        TweenService:Create(self.TitleLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(self.DescLabel, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        
        fadeOut:Play()
        fadeOut.Completed:Wait()
        self.ScreenGui:Destroy()
    end)

    -- خط فاصل خفيف تحت الـ TopBar (يضيف لمسة جمالية تتناسب مع الصورة)
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.Position = UDim2.new(0, 0, 1, -1)
    Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Separator.BorderSizePixel = 0
    Separator.Parent = self.TopBar

    return self
end

return AxisUI
