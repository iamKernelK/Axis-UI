local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SliderModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function SliderModule.Create(ParentFrame, Options)
    local SName = Options.Name or "Slider"
    local Min = Options.Min or 0
    local Max = Options.Max or 100
    local Default = Options.Default or Min
    local Callback = Options.Callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    SliderFrame.Parent = ParentFrame
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 0, 25)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = SName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SliderFrame

    local ValueText = Instance.new("TextLabel")
    ValueText.Size = UDim2.new(0, 50, 0, 25)
    ValueText.Position = UDim2.new(1, -65, 0, 5)
    ValueText.BackgroundTransparency = 1
    ValueText.Text = tostring(Default)
    ValueText.TextColor3 = THEME_ORANGE
    ValueText.Font = Enum.Font.GothamBold
    ValueText.TextSize = 14
    ValueText.TextXAlignment = Enum.TextXAlignment.Right
    ValueText.Parent = SliderFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 6)
    Track.Position = UDim2.new(0, 15, 1, -15)
    Track.BackgroundColor3 = Color3.fromRGB(40, 30, 25)
    Track.Parent = SliderFrame
    Instance.new("UICorner", Track)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
    Fill.BackgroundColor3 = THEME_ORANGE
    Fill.Parent = Track
    Instance.new("UICorner", Fill)

    local Dragging = false
    local function Update(Input)
        local percentage = math.clamp((Input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(Min + ((Max - Min) * percentage))
        ValueText.Text = tostring(val)
        TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        Callback(val)
    end

    SliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; Update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end
    end)

    return SliderFrame
end

return SliderModule
