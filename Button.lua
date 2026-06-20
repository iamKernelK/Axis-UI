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
    local leftIconId = Options.LeftIcon or "rbxassetid://107150227368485"
    local rightIconId = Options.RightIcon 
    
    -- 1. الزر الأساسي
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, -24, 0, 42) 
    
    -- [تعديل الإزاحة]: تم تنزيل الزر (10 بكسل) وإزاحته لليمين (6 بكسل بشويش)
    Button.Position = UDim2.new(0.5, 6, 0, 10) 
    Button.AnchorPoint = Vector2.new(0.5, 0)
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.ClipsDescendants = true 
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- 2. إطار الزر (UIStroke)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    -- [تعديل الأنيميشن]: أنيميشن النبض المستمر (شغال دائماً حتى لو ما سويت شي)
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()
    
    -- 3. الأيقونة اليسرى
    local LeftIcon = Instance.new("ImageLabel")
    LeftIcon.Size = UDim2.new(0, 20, 0, 20)
    LeftIcon.Position = UDim2.new(0, 12, 0.5, 0)
    LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
    LeftIcon.BackgroundTransparency = 1
    LeftIcon.Image = leftIconId
    LeftIcon.ImageColor3 = Color3.new(1, 1, 1)
    LeftIcon.Parent = Button
    
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(1, THEME_ORANGE)
    })
    IconGradient.Parent = LeftIcon
    
    -- 4. النص
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0) 
    Title.Position = UDim2.new(0, 42, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    
    -- [تعديل النص]: اللون برتقالي والحجم أكبر قليلاً (من 13 إلى 15)
    Title.TextColor3 = THEME_ORANGE
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 15 
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- 5. الأيقونة اليمنى (إن وجدت)
    if rightIconId then
        local RightIcon = Instance.new("ImageLabel")
        RightIcon.Size = UDim2.new(0, 18, 0, 18)
        RightIcon.Position = UDim2.new(1, -30, 0.5, 0)
        RightIcon.AnchorPoint = Vector2.new(0, 0.5)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = rightIconId
        RightIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        RightIcon.Parent = Button
    end
    
    -- 6. تفاعلات الماوس والضغط
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = THEME_ORANGE}):Play()
        TweenService:Create(LeftIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
    end)

    -- [أنيميشن الضغط]: يظهر عند الضغط 
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = THEME_ORANGE}):Play()
        TweenService:Create(Title, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(20, 15, 12)}):Play() -- النص يصبح داكناً ليتناسب مع الخلفية البرتقالية
        TweenService:Create(LeftIcon, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(20, 15, 12)}):Play()
        IconGradient.Enabled = false 
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = THEME_ORANGE}):Play()
        IconGradient.Enabled = true 
        TweenService:Create(LeftIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    -- 3. الأيقونة اليسرى
    local LeftIcon = Instance.new("ImageLabel")
    LeftIcon.Size = UDim2.new(0, 20, 0, 20)
    LeftIcon.Position = UDim2.new(0, 12, 0.5, 0)
    LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
    LeftIcon.BackgroundTransparency = 1
    LeftIcon.Image = leftIconId
    LeftIcon.ImageColor3 = Color3.new(1, 1, 1)
    LeftIcon.Parent = Button
    
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(1, THEME_ORANGE)
    })
    IconGradient.Parent = LeftIcon
    
    -- 4. النص
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0) 
    Title.Position = UDim2.new(0, 42, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = TEXT_COLOR
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- 5. الأيقونة اليمنى (إن وجدت)
    if rightIconId then
        local RightIcon = Instance.new("ImageLabel")
        RightIcon.Size = UDim2.new(0, 18, 0, 18)
        RightIcon.Position = UDim2.new(1, -30, 0.5, 0)
        RightIcon.AnchorPoint = Vector2.new(0, 0.5)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = rightIconId
        RightIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        RightIcon.Parent = Button
    end
    
    -- 6. تفاعلات الزر (الأنيميشن)
    
    -- عند مرور الماوس
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    
    -- عند إبعاد الماوس
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = TEXT_COLOR}):Play()
        TweenService:Create(LeftIcon, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
    end)

    -- عند الضغط (اللون البرتقالي الكامل)
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = THEME_ORANGE}):Play()
        TweenService:Create(Title, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(20, 15, 12)}):Play() -- تحويل النص للون داكن للتباين
        TweenService:Create(LeftIcon, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(20, 15, 12)}):Play() -- تحويل الأيقونة للون داكن
        IconGradient.Enabled = false -- إيقاف التدرج مؤقتاً لتظهر الأيقونة واضحة
    end)
    
    -- عند إفلات الضغطة
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = TEXT_COLOR}):Play()
        IconGradient.Enabled = true -- إعادة تشغيل التدرج للأيقونة
        TweenService:Create(LeftIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
