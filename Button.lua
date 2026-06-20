local TweenService = game:GetService("TweenService")

local ButtonModule = {}

-- ألوان الهوية الخاصة بك (نفسها الموجودة في Window)
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)
local BUTTON_BG = Color3.fromRGB(20, 15, 12)
local BUTTON_PRESS_BG = Color3.fromRGB(35, 20, 10) -- لون عند الضغط

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    local leftIconId = Options.LeftIcon or "rbxassetid://107150227368485"
    local rightIconId = Options.RightIcon -- اختياري
    
    -- 1. الزر الأساسي (المستطيل)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, 0, 0, 42)
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" -- النص سيكون في TextLabel منفصل للاحترافية
    Button.AutoButtonColor = false
    Button.ClipsDescendants = true
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- 2. الـ UIStroke بأنيميشن خفيف (Pulse Effect)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    -- أنيميشن شفافية للـ Stroke (لا يستهلك مساحة أو Memory)
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()
    
    -- 3. الأيقونة اليسرى (مع UIGradient)
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
    
    -- 4. الأيقونة اليمنى (تظهر فقط إذا أضفتها في الخيارات)
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
    
    -- 5. النص الاحترافي
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0) -- المساحة تترك مكان للأيقونات
    Title.Position = UDim2.new(0, 42, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(230, 230, 230)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Button
    
    -- 6. أنيميشن الضغط (تغيير اللون والتوهج بدلاً من الحجم)
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = BUTTON_PRESS_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.1), {TextColor3 = THEME_ORANGE}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(230, 230, 230)}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
