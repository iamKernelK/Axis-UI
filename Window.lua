local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة سحب سلسة واحترافية
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos})
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
    local DescText = Options.Description or "Premium Interface"
    local ToggleKey = Options.ToggleKey or Enum.KeyCode.RightControl -- زر إظهار/إخفاء القائمة
    
    -- 1. إعداد ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MatrixV_PremiumHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.IgnoreGuiInset = true

    local success = pcall(function() self.ScreenGui.Parent = gethui() end)
    if not success then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الإطار الرئيسي (Main Frame) - تصميم داكن جداً
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0) -- يبدأ بصفر من أجل أنيميشن الدخول
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = false -- مفعل للظل الخارجي
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame

    -- إضافة حدود للنافذة (Stroke)
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- الظل الخارجي (Shadow) ليعطي عمق للـ UI
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    DropShadow.Size = UDim2.new(1, 40, 1, 40)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Image = "rbxassetid://1316045217"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.5
    DropShadow.ZIndex = -1
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(10, 10, 118, 118)
    DropShadow.Parent = self.MainFrame

    -- لمسة نيون علوية (Accent) تناسب طابع Matrix
    local TopAccent = Instance.new("Frame")
    TopAccent.Name = "TopAccent"
    TopAccent.Size = UDim2.new(1, 0, 0, 2)
    TopAccent.BackgroundColor3 = Color3.fromRGB(0, 255, 255) -- لون سماوي/نيون
    TopAccent.BorderSizePixel = 0
    TopAccent.Parent = self.MainFrame

    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 8)
    AccentCorner.Parent = TopAccent

    -- إخفاء الزوايا السفلية لخط النيون
    local AccentHide = Instance.new("Frame")
    AccentHide.Size = UDim2.new(1, 0, 0, 1)
    AccentHide.Position = UDim2.new(0, 0, 1, -1)
    AccentHide.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    AccentHide.BorderSizePixel = 0
    AccentHide.Parent = TopAccent

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame

    MakeDraggable(self.TopBar, self.MainFrame)

    -- 4. حاوية النصوص
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "TextContainer"
    TextContainer.Size = UDim2.new(0, 300, 1, 0)
    TextContainer.Position = UDim2.new(0, 20, 0, 0)
    TextContainer.BackgroundTransparency = 1
    TextContainer.Parent = self.TopBar

    local UIListLayout_Text = Instance.new("UIListLayout")
    UIListLayout_Text.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Text.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Text.Padding = UDim.new(0, 2)
    UIListLayout_Text.Parent = TextContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextSize = 15
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = TextContainer

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Description"
    self.DescLabel.Size = UDim2.new(1, 0, 0, 14)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    self.DescLabel.TextSize = 12
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = TextContainer

    -- 5. حاوية أزرار التحكم (أيقونات)
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
    ControlsLayout.Padding = UDim.new(0, 12)
    ControlsLayout.Parent = ControlsContainer

    local ControlsPadding = Instance.new("UIPadding")
    ControlsPadding.PaddingRight = UDim.new(0, 15)
    ControlsPadding.Parent = ControlsContainer

    -- دالة إنشاء الأيقونات (ImageButtons)
    local function CreateIconButton(name, assetId, layoutOrder, hoverColor)
        local Btn = Instance.new("ImageButton")
        Btn.Name = name
        Btn.Size = UDim2.new(0, 18, 0, 18)
        Btn.BackgroundTransparency = 1
        Btn.Image = assetId
        Btn.ImageColor3 = Color3.fromRGB(150, 150, 150)
        Btn.ScaleType = Enum.ScaleType.Fit
        Btn.LayoutOrder = layoutOrder
        Btn.Parent = ControlsContainer

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = hoverColor}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end)

        return Btn
    end

    -- استخدام الـ IDs التي طلبتها
    self.MinBtn = CreateIconButton("Minimize", "rbxassetid://118026365011536", 1, Color3.fromRGB(255, 255, 255))
    self.MaxBtn = CreateIconButton("Maximize", "rbxassetid://76045941763188", 2, Color3.fromRGB(255, 255, 255))
    self.CloseBtn = CreateIconButton("Close", "rbxassetid://110786993356448", 3, Color3.fromRGB(255, 75, 75))

    -- خط فاصل ناعم أسفل الـ TopBar
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, -30, 0, 1)
    Separator.Position = UDim2.new(0, 15, 1, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Separator.BackgroundTransparency = 0.9
    Separator.BorderSizePixel = 0
    Separator.Parent = self.TopBar

    -- =====================================
    -- 6. الأنيميشن وبرمجة الأزرار (Logic)
    -- =====================================

    -- أنيميشن الدخول الأولي السلس
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 420)}):Play()

    -- نظام زر الـ Minimize (إخفاء بالكامل وليس حذف)
    self.MinBtn.MouseButton1Click:Connect(function()
        -- أنيميشن اختفاء ناعم للأسفل
        local hideTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        hideTween:Play()
        hideTween.Completed:Wait()
        self.MainFrame.Visible = false
        -- إعادة الحجم الحقيقي بعد الإخفاء استعداداً للظهور مجدداً
        self.MainFrame.Size = UDim2.new(0, 650, 0, 420)
    end)

    -- نظام استدعاء القائمة إذا كانت مخفية (استخدام الزر للتبديل)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == ToggleKey then
            if not self.MainFrame.Visible then
                self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
                self.MainFrame.Visible = true
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 420)}):Play()
            else
                local hideTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
                hideTween:Play()
                hideTween.Completed:Wait()
                self.MainFrame.Visible = false
                self.MainFrame.Size = UDim2.new(0, 650, 0, 420)
            end
        end
    end)

    -- نظام الـ Maximize (تكبير/تصغير)
    local isMaximized = false
    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        local targetSize = isMaximized and UDim2.new(0, 850, 0, 550) or UDim2.new(0, 650, 0, 420)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    -- نظام الـ Close (حذف القائمة بالكامل)
    self.CloseBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        closeTween:Play()
        closeTween.Completed:Wait()
        self.ScreenGui:Destroy()
    end)

    return self
end

return AxisUI
