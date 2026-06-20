local TweenService = game:GetService("TweenService")

local ButtonModule = {}

-- إعدادات الألوان (Theme)
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)
local BUTTON_BG = Color3.fromRGB(20, 15, 12)
local BUTTON_HOVER_BG = Color3.fromRGB(28, 18, 11)
local TEXT_COLOR = Color3.fromRGB(210, 210, 210)

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    local leftIconId = Options.LeftIcon or "rbxassetid://107150227368485"
    local rightIconId = Options.RightIcon 
    
    -- 1. الزر الأساسي
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    -- العرض 100% مع الاعتماد على UIPadding في الـ Parent لمنع التداخل
    Button.Size = UDim2.new(1, 0, 0, 42) 
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.ClipsDescendants = false -- [مهم جداً] إغلاقها هنا لمنع خلل الـ UIStroke
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    -- 2. إطار الزر (UIStroke)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 1 
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    -- 3. حاوية القص (Clip Container) لحل مشاكل تداخل الحواف والتموج
    local ClipContainer = Instance.new("Frame")
    ClipContainer.Name = "ClipContainer"
    ClipContainer.Size = UDim2.new(1, 0, 1, 0)
    ClipContainer.BackgroundTransparency = 1
    ClipContainer.ClipsDescendants = true -- يتم تفعيل القص هنا فقط
    ClipContainer.Parent = Button
    
    local ClipCorner = Instance.new("UICorner")
    ClipCorner.CornerRadius = UDim.new(0, 6)
    ClipCorner.Parent = ClipContainer
    
    -- 4. إبعاد العناصر عن الحواف (Padding)
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 12)
    Padding.PaddingRight = UDim.new(0, 12)
    Padding.Parent = Button
    
    -- 5. الأيقونة اليسرى
    local LeftIcon = Instance.new("ImageLabel")
    LeftIcon.Size = UDim2.new(0, 20, 0, 20)
    LeftIcon.Position = UDim2.new(0, 0, 0.5, 0)
    LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
    LeftIcon.BackgroundTransparency = 1
    LeftIcon.Image = leftIconId
    LeftIcon.ImageColor3 = Color3.new(1, 1, 1)
    LeftIcon.ZIndex = 2
    LeftIcon.Parent = Button
    
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(1, THEME_ORANGE)
    })
    IconGradient.Parent = LeftIcon
    
    -- 6. النص الاحترافي
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -30, 1, 0) 
    Title.Position = UDim2.new(0, 30, 0, 0) -- إزاحة النص بمقدار الأيقونة
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = TEXT_COLOR
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Button
    
    -- 7. الأيقونة اليمنى (إن وجدت)
    if rightIconId then
        local RightIcon = Instance.new("ImageLabel")
        RightIcon.Size = UDim2.new(0, 18, 0, 18)
        RightIcon.Position = UDim2.new(1, 0, 0.5, 0)
        RightIcon.AnchorPoint = Vector2.new(1, 0.5)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = rightIconId
        RightIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        RightIcon.ZIndex = 2
        RightIcon.Parent = Button
    end
    
    -- 8. تفاعلات الزر (Hover & Click)
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = 0.5}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Transparency = 1}):Play()
        TweenService:Create(Title, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {TextColor3 = TEXT_COLOR}):Play()
    end)
    
    -- نظام تأثير التموج (Ripple Effect) العالي الجودة
    Button.MouseButton1Down:Connect(function()
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local AbsolutePos = Button.AbsolutePosition
        -- حساب موقع الضغطة داخل الزر
        local X = Mouse.X - AbsolutePos.X
        local Y = Mouse.Y - AbsolutePos.Y
        
        local Circle = Instance.new("Frame")
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.BackgroundTransparency = 0.8
        Circle.BorderSizePixel = 0
        Circle.Position = UDim2.new(0, X, 0, Y)
        Circle.Size = UDim2.new(0, 0, 0, 0)
        Circle.AnchorPoint = Vector2.new(0.5, 0.5)
        Circle.ZIndex = 1
        
        local CircleCorner = Instance.new("UICorner")
        CircleCorner.CornerRadius = UDim.new(1, 0)
        CircleCorner.Parent = Circle
        
        Circle.Parent = ClipContainer -- وضع الدائرة في حاوية القص لكي لا تخرج من الحواف
        
        -- أنيميشن التموج
        local maxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        local Tween = TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
        
        Tween:Play()
        Tween.Completed:Connect(function()
            Circle:Destroy()
        end)
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
