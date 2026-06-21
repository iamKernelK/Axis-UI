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
    local IconID = Options.Icon -- ميزة إضافة أيقونة على اليسار
    local Callback = Options.Callback or function() end

    -- الألوان متطابقة مع الستايل البرتقالي الخاص بك 100%
    local THEME_ORANGE = Color3.fromRGB(255, 140, 0) 
    local TRACK_BLACK = Color3.fromRGB(25, 25, 25)
    local TEXT_WHITE = Color3.fromRGB(255, 255, 255)

    -- 1. الحاوية الأساسية
    local SliderContainer = Instance.new("Frame", Tab)
    SliderContainer.Size = UDim2.new(1, -20, 0, 50) -- الارتفاع متناسق وبدون مساحة فارغة للـ Bubble
    SliderContainer.BackgroundTransparency = 1

    -- 2. قسم العنوان (يحتوي على النص، الأيقونة، والقيمة)
    local Header = Instance.new("Frame", SliderContainer)
    Header.Size = UDim2.new(1, 0, 0, 20)
    Header.BackgroundTransparency = 1

    -- إذا حطيت أيقونة، راح تترتب تلقائياً
    local TitleOffset = 5
    if IconID then
        local Icon = Instance.new("ImageLabel", Header)
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(0, 5, 0.5, -8)
        Icon.BackgroundTransparency = 1
        Icon.Image = IconID
        Icon.ImageColor3 = THEME_ORANGE
        TitleOffset = 26 -- إبعاد النص لليمين عشان الأيقونة تاخذ راحتها
    end

    local TitleLabel = Instance.new("TextLabel", Header)
    TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    TitleLabel.Position = UDim2.new(0, TitleOffset, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = TEXT_WHITE
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ValueDisplay = Instance.new("TextLabel", Header)
    ValueDisplay.Size = UDim2.new(0, 40, 1, 0)
    ValueDisplay.Position = UDim2.new(1, -45, 0, 0)
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Text = tostring(Default)
    ValueDisplay.TextColor3 = THEME_ORANGE
    ValueDisplay.Font = Enum.Font.GothamBold
    ValueDisplay.TextSize = 13
    ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right

    -- 3. منطقة التحريك ومسار الـ Slider
    local TrackArea = Instance.new("Frame", SliderContainer)
    TrackArea.Size = UDim2.new(1, -10, 0, 20)
    TrackArea.Position = UDim2.new(0, 5, 0, 25)
    TrackArea.BackgroundTransparency = 1

    local Track = Instance.new("Frame", TrackArea)
    Track.Size = UDim2.new(1, 0, 0, 4)
    Track.Position = UDim2.new(0, 0, 0.5, -2)
    Track.BackgroundColor3 = TRACK_BLACK
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Track)
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME_ORANGE
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- 4. المقبض (Thumb) - أصبح أعرض ولا يختفي
    local Thumb = Instance.new("ImageLabel", Track)
    Thumb.Size = UDim2.new(0, 32, 0, 18) -- مقاس عريض وممتاز (مستطيل بدلاً من مربع)
    Thumb.Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0)
    Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    Thumb.BackgroundTransparency = 1
    Thumb.Image = "rbxassetid://125083578015333" 
    Thumb.ImageColor3 = TEXT_WHITE
    Thumb.ScaleType = Enum.ScaleType.Fit -- يحافظ على شكل الـ ID بدون تمطيط بشع

    -- 5. المنطق والأنيميشن (بدون فقاعة)
    local Dragging = false
    local TargetPct = (Default - Min) / (Max - Min)
    local CurrentPct = TargetPct
    local Mouse = Players.LocalPlayer:GetMouse()

    Thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            -- أنيميشن احترافي: يكبر المقبض شوي عند المسك بدون ما يختفي
            TweenService:Create(Thumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 36, 0, 22)}):Play()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if Dragging then
                Dragging = false
                -- يرجع لحجمه العريض الطبيعي عند الإفلات
                TweenService:Create(Thumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 32, 0, 18)}):Play()
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
        ValueDisplay.Text = tostring(val) -- الرقم يتحدث مباشرة بجانب العنوان

        if Dragging or math.abs(TargetPct - CurrentPct) > 0.001 then
            Callback(val)
        end
    end)

    return SliderContainer
end

return Slider
