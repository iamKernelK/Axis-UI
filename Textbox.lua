local TweenService = game:GetService("TweenService")
local TextboxModule = {}

-- الألوان الموحدة
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local ELEMENT_BG = Color3.fromRGB(20, 15, 12)
local ELEMENT_HOVER = Color3.fromRGB(28, 18, 11)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

function TextboxModule.Create(ParentFrame, Options)
    local TName = Options.Name or "Textbox Element"
    local Callback = Options.Callback or function() end
    local Placeholder = Options.Placeholder or "Type here..."
    
    -- نظام الأيقونات
    local IconId = Options.Icon
    local Pos = Options.Pos or "None"
    local hasLeft = (Pos == "Left" or Pos == "Both") and IconId ~= nil
    local hasRight = (Pos == "Right" or Pos == "Both") and IconId ~= nil

    -- 1. الحاوية الأساسية (نفس شكل الزر)
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = TName .. "_Textbox"
    TextboxFrame.Size = UDim2.new(1, 0, 0, 42)
    TextboxFrame.BackgroundColor3 = ELEMENT_BG
    TextboxFrame.Parent = ParentFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = TextboxFrame

    -- إطار النبض
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = TextboxFrame
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()

    -- 2. الأيقونات والنص
    local titleOffset = 15
    if hasLeft then
        local LeftIcon = Instance.new("ImageLabel")
        LeftIcon.Size = UDim2.new(0, 20, 0, 20)
        LeftIcon.Position = UDim2.new(0, 15, 0.5, 0)
        LeftIcon.AnchorPoint = Vector2.new(0, 0.5)
        LeftIcon.BackgroundTransparency = 1
        LeftIcon.Image = IconId
        LeftIcon.ImageColor3 = THEME_ORANGE
        LeftIcon.Parent = TextboxFrame
        titleOffset = 45 
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
        RightIcon.Parent = TextboxFrame
        rightOffset = -45
    end

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -180, 1, 0)
    Title.Position = UDim2.new(0, titleOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = TEXT_COLOR
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TextboxFrame

    -- 3. مربع إدخال النص الفعلي
    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0, 120, 0, 28)
    InputBox.Position = UDim2.new(1, rightOffset, 0.5, 0)
    InputBox.AnchorPoint = Vector2.new(1, 0.5)
    InputBox.BackgroundColor3 = Color3.fromRGB(15, 10, 8) -- أغمق قليلاً من الحاوية
    InputBox.Text = ""
    InputBox.PlaceholderText = Placeholder
    InputBox.TextColor3 = THEME_ORANGE
    InputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    InputBox.Font = Enum.Font.GothamSemibold
    InputBox.TextSize = 13
    InputBox.ClearTextOnFocus = false
    InputBox.ClipsDescendants = true
    InputBox.Parent = TextboxFrame

    Instance.new("UICorner", InputBox).CornerRadius = UDim.new(0, 6)

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = THEME_ORANGE
    InputStroke.Thickness = 1
    InputStroke.Transparency = 1
    InputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    InputStroke.Parent = InputBox

    -- 4. التفاعلات
    TextboxFrame.MouseEnter:Connect(function() TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_HOVER}):Play() end)
    TextboxFrame.MouseLeave:Connect(function() TweenService:Create(TextboxFrame, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_BG}):Play() end)

    InputBox.Focused:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        TweenService:Create(InputBox, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_HOVER}):Play()
    end)

    InputBox.FocusLost:Connect(function()
        TweenService:Create(InputStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(InputBox, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(15, 10, 8)}):Play()
        Callback(InputBox.Text)
    end)

    return TextboxFrame
end

return TextboxModule
