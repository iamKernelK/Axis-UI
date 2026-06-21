local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function AxisUI.CreateSlider(Tab, Options)
    local Name = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local LeftIconID = Options.LeftIcon -- اختياري
    local RightIconID = Options.RightIcon -- اختياري
    local Callback = Options.Callback or function() end

    -- ثوابت الألوان
    local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
    local BUBBLE_COLOR = Color3.fromRGB(35, 25, 20) -- لون غامق يتناسب مع الستايل

    -- 1. الحاوية الأساسية للـ Slider
    local SliderContainer = Instance.new("Frame", Tab)
    SliderFrame = SliderContainer -- للاستخدام الداخلي
    SliderContainer.Size = UDim2.new(1, -20, 0, 55)
    SliderContainer.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", SliderContainer)
    TitleLabel.Size = UDim2.new(1, -40, 0, 20)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ValueDisplay = Instance.new("TextLabel", SliderContainer)
    ValueDisplay.Size = UDim2.new(0, 40, 0, 20)
    ValueDisplay.Position = UDim2.new(1, -45, 0, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(Default)
    ValueDisplay.TextColor3 = THEME_ORANGE
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextSize = 13
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

    -- 2. منطقة التحريك والأيقونات
    local TrackArea = Instance.new("Frame", SliderContainer)
    TrackArea.Size = UDim2.new(1, -10, 0, 20)
    TrackArea.Position = UDim2.new(0, 5, 0, 25)
    TrackArea.BackgroundTransparency = 1

    local TrackPadding = 0
    if LeftIconID then
        local LeftIcon = Instance.new("ImageLabel", TrackArea)
        LeftIcon.Size = UDim2.new(0, 16, 0, 16)
        LeftIcon.Position = UDim2.new(0, 0, 0.5, -8)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = LeftIconID
        LeftIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        TrackPadding = TrackPadding + 25
    end

    local RightPadding = 0
    if RightIconID then
        local RightIcon = Instance.new("ImageLabel", TrackArea)
        RightIcon.Size = UDim2.new(0, 16, 0, 16)
        RightIcon.Position = UDim2.new(1, -16, 0.5, -8)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = RightIconID
        RightIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
        RightPadding = 25
    end

    -- 3. مسار الـ Slider (Track & Fill)
    local Track = Instance.new("Frame", TrackArea)
    Track.Size = UDim2.new(1, -(TrackPadding + RightPadding), 0, 4)
    Track.Position = UDim2.new(0, TrackPadding, 0.5, -2)
    Track.BackgroundColor3 = Color3.fromRGB(40, 35, 30)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME_ORANGE
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- 4. المقبض (Knob) باستخدام الـ ID الخاص بك
    local Knob = Instance.new("ImageLabel", Track)
    Knob.Size = UDim2.new(0, 22, 0, 22)
    Knob.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.BackgroundTransparency = 1
    Knob.Image = "rbxassetid://105854070513330" -- الـ Knob الخاص بك
    Knob.ImageColor3 = Color3.new(1, 1, 1)

    -- 5. الـ Chat Bubble والـ Arrow
    local Bubble = Instance.new("Frame", Knob)
    Bubble.Size = UDim2.new(0, 36, 0, 24)
    Bubble.Position = UDim2.new(0.5, 0, 0, -10) -- تبدأ منخفضة قليلاً للأنيميشن
    Bubble.AnchorPoint = Vector2.new(0.5, 1)
    Bubble.BackgroundColor3 = BUBBLE_COLOR
    Bubble.BackgroundTransparency = 1 -- مخفية افتراضياً
    Instance.new("UICorner", Bubble).CornerRadius = UDim.new(0, 6)

    local Arrow = Instance.new("ImageLabel", Bubble)
    Arrow.Size = UDim2.new(0, 12, 0, 6)
    Arrow.Position = UDim2.new(0.5, 0, 1, 0)
    Arrow.AnchorPoint = Vector2.new(0.5, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://125083578015333" -- السهم الخاص بك
    Arrow.ImageColor3 = BUBBLE_COLOR
    Arrow.ImageTransparency = 1

    local BubbleText = Instance.new("TextLabel", Bubble)
    BubbleText.Size = UDim2.new(1, 0, 1, 0)
    BubbleText.BackgroundTransparency = 1
    BubbleText.Text = tostring(Default)
    BubbleText.TextColor3 = Color3.new(1, 1, 1)
    BubbleText.Font = Enum.Font.GothamBold
    BubbleText.TextSize = 11
    BubbleText.TextTransparency = 1

    -- 6. المنطق والأنيميشن (Lerp & 40% Speed Effect)
    local Dragging = false
    local TargetPct = (Default - Min) / (Max - Min)
    local CurrentPct = TargetPct
    local Mouse = Players.LocalPlayer:GetMouse()

    local function ToggleBubble(visible)
        local targetAlpha = visible and 0 or 1
        local targetY = visible and -28 or -10 -- الارتفاع والانخفاض بسلاسة
        local easeStyle = visible and Enum.EasingStyle.Back or Enum.EasingStyle.Sine
        
        TweenService:Create(Bubble, TweenInfo.new(0.3, easeStyle, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, targetY),
            BackgroundTransparency = targetAlpha
        }):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.2), {ImageTransparency = targetAlpha}):Play()
        TweenService:Create(BubbleText, TweenInfo.new(0.2), {TextTransparency = targetAlpha}):Play()
    end

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            ToggleBubble(true)
            TweenService:Create(Knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 26, 0, 26)}):Play()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if Dragging then
                Dragging = false
                ToggleBubble(false)
                TweenService:Create(Knob, TweenInfo.new(0.2), {Size = UDim2.new(0, 22, 0, 22)}):Play()
            end
        end
    end)

    -- نظام الحركة الانسيابية (Smoothening) بنسبة 40% كما طلبت
    RunService.RenderStepped:Connect(function()
        if Dragging then
            local pos = math.clamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            TargetPct = pos
        end

        -- هنا السر: الحركة لا تنتقل فوراً، بل تلحق الهدف بنسبة 40% (0.4) كل فريم لتعطي توقف جميل
        CurrentPct = CurrentPct + (TargetPct - CurrentPct) * 0.4
        
        -- إيقاف الحسابات الدقيقة جداً لمنع الاهتزاز (Jittering)
        if math.abs(TargetPct - CurrentPct) < 0.001 then CurrentPct = TargetPct end

        Knob.Position = UDim2.new(CurrentPct, 0, 0.5, 0)
        Fill.Size = UDim2.new(CurrentPct, 0, 1, 0)

        local val = math.floor(Min + (CurrentPct * (Max - Min)))
        BubbleText.Text = tostring(val)
        ValueDisplay.Text = tostring(val)

        -- استدعاء الدالة فقط إذا كان هناك تغيير فعلي في الحركة
        if Dragging or math.abs(TargetPct - CurrentPct) > 0.001 then
            Callback(val)
        end
    end)

    return SliderContainer
end
