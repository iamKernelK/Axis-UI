-- Keybind Component
local UserInputService = game:GetService("UserInputService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local BindName = Options.Name or "Keybind"
    local CurrentBind = Options.Default or Enum.KeyCode.E
    local Callback = Options.Callback or function() end

    local BindFrame = Instance.new("Frame")
    BindFrame.Size = UDim2.new(1, 0, 0, 42)
    BindFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    BindFrame.Parent = TabContainer
    Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = BindName
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = BindFrame

    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 80, 0, 26)
    BindBtn.Position = UDim2.new(1, -95, 0.5, -13)
    BindBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 15)
    BindBtn.Text = CurrentBind.Name
    BindBtn.TextColor3 = THEME_ORANGE
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 12
    BindBtn.Parent = BindFrame
    Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 6)

    local Listening = false
    BindBtn.MouseButton1Click:Connect(function()
        Listening = true
        BindBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input)
        if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentBind = input.KeyCode
            BindBtn.Text = CurrentBind.Name
            Listening = false
            Callback(CurrentBind)
        end
    end)
end
