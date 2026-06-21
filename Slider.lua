local Slider = {} 

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

function Slider.Create(Tab, Options)
    local Name = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local Callback = Options.Callback or function() end

    -- ألوان الستايل الخاصة بكم (أسود، أبيض، سماوي نيون)
    local THEME_CYAN = Color3.fromRGB(0, 255, 255) 
    local BG_BLACK = Color3.fromRGB(15, 15, 15) 
    local TRACK_BLACK = Color3.fromRGB(25, 25, 25)
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

    -- 2. منطقة التحريك
    local TrackArea = Instance.new("Frame", SliderContainer)
    TrackArea.Size = UDim2.new(1, -10, 0, 20)
    TrackArea.Position = UDim2.new(0, 5, 0, 25)
    TrackArea.BackgroundTransparency = 1

    -- 3. مسار الـ Slider
    local Track = Instance.new("Frame", TrackArea)
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0.5, -2)
    Track.BackgroundColor3 = TRACK_BLACK
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME_CYAN
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- 4. المقبض (Thumb) - التسمية الصحيحة والـ ID المطلوب
    local Thumb = Instance.new("ImageLabel", Track)
    Thumb.Size = UDim2.new(0, 22, 0, 22)
    Thumb.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
    Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    Thumb.BackgroundTransparency = 1
    Thumb.Image = "rbxassetid://125083578015333" 
    Thumb.ImageColor3 = TEXT_WHITE

    -- 5. الـ Bubble والـ Arrow
    local Bubble = Instance.new("Frame", Thumb)
    Bubble.Size = UDim2.new(0, 36, 0, 24)
    Bubble.Position = UDim2.new(0.5, 0, 0, -10)
    Bubble.AnchorPoint = Vector2.new(0.5, 1)
    Bubble.BackgroundColor3 = BG_BLACK
    Bubble.BackgroundTransparency = 1 
    Instance.new("UICorner", Bubble).CornerRadius = UDim.new(0, 6)

    -- السهم (Arrow) في وسط الـ Bubble من الأسفل
    local Arrow = Instance.new("ImageLabel", Bubble)
    Arrow.Size = UDim2.new(0, 10, 0, 5) -- حجم صغير ومناسب
    Arrow.Position = UDim2.new(0.5, 0, 1, 0) -- الموقع في أسفل الفقاعة
    Arrow.AnchorPoint = Vector2.new(0.5, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://105854070513330" -- الـ ID الذي ذكرته للسهم
    Arrow.ImageColor3 = BG_BLACK
    Arrow.ImageTransparency = 1

    local BubbleText = Instance.new("TextLabel", Bubble)
    BubbleText.Size = UDim2.new(1, 0, 1, 0)
    BubbleText.BackgroundTransparency = 1
    BubbleText.Text = tostring(Default)
    BubbleText.TextColor3 = THEME_CYAN
    BubbleText.Font = Enum.Font.GothamBold
    BubbleText.TextSize = 11
    BubbleText.TextTransparency = 1

    -- 6. المنطق والأنيميشن
    local Dragging = false
    local TargetPct = (Default - Min) / (Max - Min)
    local CurrentPct = TargetPct
    local Mouse = Players.LocalPlayer:GetMouse()

    local function ToggleBubble(visible)
        local targetAlpha = visible and 0 or 1
        local targetY = visible and -28 or -10 
        -- شفافية الـ Thumb عند التحريك (يصبح شفاف بالكامل عند السحب)
        local thumbTransparency = visible and 1 or 0 
        local easeStyle = visible and Enum.EasingStyle.Back or Enum.EasingStyle.Sine
        
        -- تحريك الفقاعة وإظهارها
        TweenService:Create(Bubble, TweenInfo.new(0.3, easeStyle, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, 0, 0, targetY),
            BackgroundTransparency = targetAlpha
        }):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.2), {ImageTransparency = targetAlpha}):Play()
        TweenService:Create(BubbleText, TweenInfo.new(0.2), {TextTransparency = targetAlpha}):Play()
        
        -- أنيميشن الـ Thumb (الشفافية)
        TweenService:Create(Thumb, TweenInfo.new(0.2), {ImageTransparency = thumbTransparency}):Play()
    end

    Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            ToggleBubble(true)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if Dragging then
                Dragging = false
                ToggleBubble(false)
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

        Thumb.Position = UDim2.new(CurrentPct, 0, 0.5, 0)
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

return Slider
