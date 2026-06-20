local TweenService = game:GetService("TweenService")

local ButtonModule = {}

-- الألوان الخاصة بك
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)
local BUTTON_BG = Color3.fromRGB(20, 15, 12)
local BUTTON_HOVER_BG = Color3.fromRGB(28, 18, 11)

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    -- تم نقل أيقونة الـ Click لتكون هي الأيقونة اليمنى الافتراضية
    local rightIconId = Options.RightIcon or "rbxassetid://107150227368485" 
    local leftIconId = Options.LeftIcon 
    
    -- 1. الزر الأساسي
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, 0, 0, 42) -- الحجم الكامل، الـ ListLayout سيتكفل بالترتيب
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.ClipsDescendants = false -- [مهم] إغلاقها هنا لمنع خلل الـ UIStroke
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- حاوية القص (لمنع تأثير التموج من الخروج عن حواف الزر)
    local ClipContainer = Instance.new("Frame")
    ClipContainer.Size = UDim2.new(1, 0, 1, 0)
    ClipContainer.BackgroundTransparency = 1
    ClipContainer.ClipsDescendants = true
    ClipContainer.Parent = Button
    
    local ClipCorner = Instance.new("UICorner")
    ClipCorner.CornerRadius = UDim.new(0, 8)
    ClipCorner.Parent = ClipContainer
    
    -- 2. إطار الزر (UIStroke) وأنيميشن النبض
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()
    
    -- 3. الأيقونة اليمنى (مكانها الجديد)
    local RightIcon = Instance.new("ImageLabel")
    RightIcon.Size = UDim2.new(0, 20, 0, 20)
    RightIcon.Position = UDim2.new(1, -30, 0.5, 0)
    RightIcon.AnchorPoint = Vector2.new(0, 0.5)
    RightIcon.BackgroundTransparency = 1
    RightIcon.Image = rightIconId
    RightIcon.ImageColor3 = Color3.new(1, 1, 1)
    RightIcon.ZIndex = 2
    RightIcon.Parent = Button
    
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(1, THEME_ORANGE)
    })
    IconGradient.Parent = RightIcon
    
    -- 4. الأيقونة اليسرى (تظهر فقط إذا أضفتها في الخيارات)
    if leftIconId then
        local LeftIcon = Instance.new("ImageLabel")
        LeftIcon.Size = UDim2.new(0, 18, 0, 18)
        LeftIcon.Position = UDim2.new(0, 15, 0.5, 0)
        LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = leftIconId
        LeftIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        LeftIcon.ZIndex = 2
        LeftIcon.Parent = Button
    end
    
    -- 5. النص
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0) 
    Title.Position = leftIconId and UDim2.new(0, 42, 0, 0) or UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = THEME_ORANGE
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 15 
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = Button
    
    -- 6. تفاعلات الماوس والأنيميشنات الاحترافية
    
    -- [أنيميشن 1]: Hover (انزياح الأيقونة اليمنى لليمين كأنها سهم)
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -22, 0.5, 0)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.4), {TextColor3 = THEME_ORANGE}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -30, 0.5, 0), ImageColor3 = Color3.new(1, 1, 1)}):Play()
        IconGradient.Enabled = true
    end)

    -- [أنيميشن 2]: Press (انعكاس لوني كامل)
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundColor3 = THEME_ORANGE}):Play()
        TweenService:Create(Title, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 15, 12)}):Play() 
        TweenService:Create(RightIcon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(20, 15, 12)}):Play()
        IconGradient.Enabled = false 
    end)
    
    -- [أنيميشن 3]: Release + Ripple Effect (عودة الألوان وانطلاق التموج)
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.4), {TextColor3 = THEME_ORANGE}):Play()
        IconGradient.Enabled = true 
        TweenService:Create(RightIcon, TweenInfo.new(0.4), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
        
        -- إنشاء دائرة التموج
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local X = Mouse.X - Button.AbsolutePosition.X
        local Y = Mouse.Y - Button.AbsolutePosition.Y
        
        local Ripple = Instance.new("Frame")
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.6
        Ripple.BorderSizePixel = 0
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.ZIndex = 1
        
        local RC = Instance.new("UICorner")
        RC.CornerRadius = UDim.new(1, 0)
        RC.Parent = Ripple
        
        Ripple.Parent = ClipContainer
        
        local maxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        local rTween = TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
        rTween:Play()
        
        -- حذف دائرة التموج بعد الانتهاء
        game:GetService("Debris"):AddItem(Ripple, 0.5)
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
