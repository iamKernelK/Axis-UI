local TweenService = game:GetService("TweenService")
local ToggleModule = {}

-- الألوان الموحدة
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local ELEMENT_BG = Color3.fromRGB(20, 15, 12)
local ELEMENT_HOVER = Color3.fromRGB(28, 18, 11)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

function ToggleModule.Create(ParentFrame, Options)
    local TName = Options.Name or "Toggle"
    -- تحويل النوع إلى حروف صغيرة لتجنب أخطاء الكتابة (box أو default)
    local TType = string.lower(Options.Type or "default") 
    local State = Options.Default or false
    local Callback = Options.Callback or function() end
    
    -- نظام الأيقونات
    local IconId = Options.Icon
    local Pos = Options.Pos or "None"
    local hasLeft = (Pos == "Left" or Pos == "Both") and IconId ~= nil
    local hasRight = (Pos == "Right" or Pos == "Both") and IconId ~= nil

    -- 1. الحاوية الأساسية (نفس شكل الزر بالضبط)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = TName .. "_Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = ELEMENT_BG
    ToggleFrame.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleFrame

    -- إطار النبض
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = ToggleFrame
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()

    -- 2. زر التفاعل (يغطي الحاوية بالكامل)
    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = ToggleFrame

    -- 3. الأيقونات والنص
    local titleOffset = 15
    if hasLeft then
        local LeftIcon = Instance.new("ImageLabel")
        LeftIcon.Size = UDim2.new(0, 20, 0, 20)
        LeftIcon.Position = UDim2.new(0, 15, 0.5, 0)
        LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = IconId
        LeftIcon.ImageColor3 = THEME_ORANGE
        LeftIcon.Parent = ToggleFrame
        titleOffset = 45 -- إزاحة النص إذا كانت هناك أيقونة
    end

    local rightOffset = -15
    if hasRight then
        local RightIcon = Instance.new("ImageLabel")
        RightIcon.Size = UDim2.new(0, 20, 0, 20)
        RightIcon.Position = UDim2.new(1, -15, 0.5, 0)
        RightIcon.AnchorPoint = Vector2.new(1, 0.5)
        RightIcon.BackgroundTransparency = 1
        RightIcon.Image = IconId
        RightIcon.ImageColor3 = THEME_ORANGE
        RightIcon.Parent = ToggleFrame
        rightOffset = -45 -- إزاحة زر التوجل إذا كانت هناك أيقونة يمنى
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0, titleOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = TEXT_COLOR
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = ToggleFrame

    -- 4. تصميم التوجل بناءً على النوع
    if TType == "box" then
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 24, 0, 24)
        Box.Position = UDim2.new(1, rightOffset, 0.5, 0)
        Box.AnchorPoint = Vector2.new(1, 0.5)
        Box.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
        Box.Parent = ToggleFrame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

        local BoxStroke = Instance.new("UIStroke", Box)
        BoxStroke.Thickness = 1.5
        BoxStroke.Color = Color3.fromRGB(80, 80, 80)

        local Check = Instance.new("ImageLabel")
        Check.Size = UDim2.new(0, 0, 0, 0)
        Check.AnchorPoint = Vector2.new(0.5, 0.5)
        Check.Position = UDim2.new(0.5, 0, 0.5, 0)
        Check.BackgroundTransparency = 1
        Check.Image = "rbxassetid://6257079049" -- الأيدي الذي طلبته
        Check.ImageColor3 = Color3.fromRGB(20, 15, 12) -- لون الصح داكن ليتناسب مع الخلفية البرتقالية
        Check.Parent = Box

        local function Update()
            if State then
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = THEME_ORANGE}):Play()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = THEME_ORANGE}):Play()
                TweenService:Create(Check, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0.8, 0, 0.8, 0)}):Play()
            else
                TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15, 10, 8)}):Play()
                TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 80)}):Play()
                TweenService:Create(Check, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            end
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State; Update(); Callback(State) end)
        Update()

    else
        -- Default (الشكل البيضاوي)
        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 44, 0, 22)
        Pill.Position = UDim2.new(1, rightOffset, 0.5, 0)
        Pill.AnchorPoint = Vector2.new(1, 0.5)
        Pill.BackgroundColor3 = Color3.fromRGB(40, 35, 35)
        Pill.Parent = ToggleFrame
        Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 2, 0.5, 0)
        Circle.AnchorPoint = Vector2.new(0, 0.5)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Pill
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local function Update()
            local targetBg = State and THEME_ORANGE or Color3.fromRGB(40, 35, 35)
            local targetPos = State and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            TweenService:Create(Pill, TweenInfo.new(0.3), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State; Update(); Callback(State) end)
        Update()
    end

    -- تأثيرات الماوس
    InteractBtn.MouseEnter:Connect(function() TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_HOVER}):Play() end)
    InteractBtn.MouseLeave:Connect(function() TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_BG}):Play() end)

    return ToggleFrame
end

return ToggleModule
