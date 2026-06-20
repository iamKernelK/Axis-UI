-- Toggle Component (Default & Box)
local TweenService = game:GetService("TweenService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_DARK = Color3.fromRGB(180, 80, 0)

return function(TabContainer, Options)
    local TName = Options.Name or "Toggle"
    local TType = Options.Type or "Default" -- "Default" أو "Box"
    local State = Options.Default or false
    local Callback = Options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = TName .. "_Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    ToggleFrame.Parent = TabContainer

    local ToggleCorner = Instance.new("UICorner", ToggleFrame)
    ToggleCorner.CornerRadius = UDim.new(0, 8)

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = TName
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = ToggleFrame

    if TType == "Box" then
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 22, 0, 22)
        Indicator.Position = UDim2.new(1, -35, 0.5, -11)
        Indicator.BackgroundColor3 = Color3.fromRGB(25, 18, 15)
        Indicator.Parent = ToggleFrame
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 5)

        local BoxStroke = Instance.new("UIStroke", Indicator)
        BoxStroke.Thickness = 1.5
        BoxStroke.Color = Color3.fromRGB(100, 100, 100)

        local CheckIcon = Instance.new("ImageLabel")
        CheckIcon.Size = UDim2.new(0, 0, 0, 0)
        CheckIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CheckIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
        CheckIcon.BackgroundTransparency = 1
        CheckIcon.Image = "rbxassetid://6031094667"
        CheckIcon.ImageColor3 = THEME_ORANGE
        CheckIcon.Parent = Indicator

        local function Update()
            local targetColor = State and THEME_ORANGE or Color3.fromRGB(100, 100, 100)
            local targetBg = State and Color3.fromRGB(45, 22, 10) or Color3.fromRGB(25, 18, 15)
            local targetSize = State and UDim2.new(0.8, 0, 0.8, 0) or UDim2.new(0, 0, 0, 0)
            
            TweenService:Create(BoxStroke, TweenInfo.new(0.25), {Color = targetColor}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.25), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(CheckIcon, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Size = targetSize}):Play()
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State Update() Callback(State) end)
        Update()
    else
        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 42, 0, 20)
        Indicator.Position = UDim2.new(1, -55, 0.5, -10)
        Indicator.BackgroundColor3 = Color3.fromRGB(40, 35, 35)
        Indicator.Parent = ToggleFrame
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Indicator
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local function Update()
            local targetBg = State and THEME_ORANGE or Color3.fromRGB(40, 35, 35)
            local targetPos = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            TweenService:Create(Indicator, TweenInfo.new(0.25), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {Position = targetPos}):Play()
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State Update() Callback(State) end)
        Update()
    end
end
