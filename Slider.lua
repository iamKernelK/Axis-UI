-- Slider Component
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local SName = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local Callback = Options.Callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    SliderFrame.Parent = TabContainer
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -100, 0, 25)
    SliderLabel.Position = UDim2.new(0, 15, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = SName
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.Font = Enum.Font.GothamMedium
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 70, 0, 25)
    ValueLabel.Position = UDim2.new(1, -85, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Default)
    ValueLabel.TextColor3 = THEME_ORANGE
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(1, -30, 0, 6)
    SliderTrack.Position = UDim2.new(0, 15, 1, -15)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 35, 35)
    SliderTrack.Parent = SliderFrame
    Instance.new("UICorner", SliderTrack)

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    SliderFill.BackgroundColor3 = THEME_ORANGE
    SliderFill.Parent = SliderTrack
    Instance.new("UICorner", SliderFill)

    local Dragging = false
    local function UpdateSlider(input)
        local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(Min + (Max - Min) * percentage)
        ValueLabel.Text = tostring(value)
        TweenService:Create(SliderFill, TweenInfo.new(0.05), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        Callback(value)
    end

    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
    end)
end
