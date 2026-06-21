local Slider = {} -- بداية الموديول الصحيحة

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function Slider.Create(Tab, Options)
    local Name = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local LeftIconID = Options.LeftIcon
    local RightIconID = Options.RightIcon
    local Callback = Options.Callback or function() end

    -- الألوان الاحترافية (أسود، أبيض، وسماوي نيون)
    local THEME_CYAN = Color3.fromRGB(0, 255, 255) -- سماوي نيون
    local BUBBLE_COLOR = Color3.fromRGB(15, 15, 15) -- أسود غامق للفقاعة
    local TEXT_WHITE = Color3.fromRGB(255, 255, 255)

    -- 1. الحاوية الأساسية للـ Slider
    local SliderContainer = Instance.new("Frame", Tab)
    SliderContainer.Size = UDim2.new(1, -20, 0, 55)
    SliderContainer.BackgroundTransparency = 1

    local TitleLabel = Instance.new("TextLabel", SliderContainer)
    TitleLabel.Size = UDim2.new(1, -40, 0, 20)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = TEXT_WHITE
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ValueDisplay = Instance.new("TextLabel", SliderContainer)
    ValueDisplay.Size = UDim2.new(0, 40, 0, 20)
    ValueDisplay.Position = UDim2.new(1, -45, 0, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(Default)
    ValueDisplay.TextColor3 = THEME_CYAN
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
        LeftIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        TrackPadding = TrackPadding + 25
    end

    local RightPadding = 0
    if RightIconID then
        local RightIcon = Instance.new("ImageLabel", TrackArea)
        RightIcon.Size = UDim2.new(0, 16, 0, 16)
        RightIcon.Position = UDim2.new(1, -16, 0.5, -8)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = RightIconID
        RightIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
        RightPadding = 25
    end

    -- 3. مسار الـ Slider (Track & Fill)
    local Track = Instance.new("Frame", TrackArea)
    Track.Size = UDim2.new(1, -(TrackPadding + RightPadding), 0, 4)
    Track.Position = UDim2.new(0, TrackPadding, 0.5, -2)
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME_CYAN
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- 4. المقبض (Knob)
    local Knob = Instance.new("ImageLabel", Track)
    Knob.Size = UDim2.new(0, 22, 0, 22)
    Knob.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.BackgroundTransparency = 1
    Knob.Image = "rbxassetid://105854070513330" 
    Knob.ImageColor3 = TEXT_WHITE

    -- 5. الـ Chat Bubble والـ Arrow
    local Bubble = Instance.new("Frame", Knob)
    Bubble.Size = UDim2.new(0, 36, 0, 24)
    Bubble.Position = UDim2.new(0.5, 0, 0, -10)
    Bubble.AnchorPoint = Vector2.new(0.5, 1)
    Bubble.BackgroundColor3 = BUBBLE_COLOR
    Bubble.BackgroundTransparency = 1 
    Instance.new("UICorner", Bubble).CornerRadius = UDim.new(0, 6)
    
    -- إضافة حدود للفقاعة لتبرز أكثر
    local BubbleStroke = Instance.new("UIStroke", Bubble)
    BubbleStroke.Color = Color3.fromRGB(40, 40, 40)
    BubbleStroke.Thickness = 1
    BubbleStroke.Transparency = 1

    local Arrow = Instance.new("ImageLabel", Bubble)
    Arrow.Size = UDim2.new(0, 12, 0, 6)
    Arrow.Position = UDim2.new(0.5, 0, 1, 0)
    Arrow.AnchorPoint = Vector2.new(0.5, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://125083578015333" 
    Arrow.ImageColor3 = BUBBLE_COLOR
    Arrow.ImageTransparency = 1

    local BubbleText = Instance.new("TextLabel", Bubble)
    BubbleText.Size = UDim2.new(1, 0, 1, 0)
    BubbleText.BackgroundTransparency = 1
    BubbleText.Text = tostring(Default)
    BubbleText.TextColor3 = THEME_CYAN
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
        local targetY = visible and -28 or -10 
        local easeStyle = visible and Enum.EasingStyle.Back or Enum.EasingStyle.Sine
        
        TweenService:Create(Bubble, TweenInfo.new(0.3, easeStyle, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, targetY),
            BackgroundTransparency = targetAlpha
        }):Play()
        TweenService:Create(BubbleStroke, TweenInfo.new(0.3), {Transparency = targetAlpha}):Play()
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

    RunService.RenderStepped:Connect(function()
        if Dragging then
            local pos = math.clamp((Mouse.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            TargetPct = pos
        end

        CurrentPct = CurrentPct + (TargetPct - CurrentPct) * 0.4
        
        if math.abs(TargetPct - CurrentPct) < 0.001 then CurrentPct = TargetPct end

        Knob.Position = UDim2.new(CurrentPct, 0, 0.5, 0)
        Fill.Size = UDim2.new(CurrentPct, 0, 1, 0)

        local val = math.floor(Min + (CurrentPct * (Max - Min)))
        BubbleText.Text = tostring(val)
        ValueDisplay.Text = tostring(val)

        if Dragging or math.abs(TargetPct - CurrentPct) > 0.001 then
            Callback(val)
        end
    end)

    return SliderContainer
end

return Slider -- أهم سطر لإرجاع الموديول
