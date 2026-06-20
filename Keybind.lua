local UserInputService = game:GetService("UserInputService")
local KeybindModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function KeybindModule.Create(ParentFrame, Options)
    local Name = Options.Name or "Keybind"
    local CurrentKey = Options.Default or Enum.KeyCode.E
    local Callback = Options.Callback or function() end

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(1, 0, 0, 42)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    KeyFrame.Parent = ParentFrame
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = KeyFrame

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 70, 0, 26)
    KeyBtn.Position = UDim2.new(1, -85, 0.5, -13)
    KeyBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 20)
    KeyBtn.Text = CurrentKey.Name
    KeyBtn.TextColor3 = THEME_ORANGE
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.TextSize = 12
    KeyBtn.Parent = KeyFrame
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)

    local Listening = false
    KeyBtn.MouseButton1Click:Connect(function()
        Listening = true
        KeyBtn.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(input)
        if Listening and input.UserInputType == Enum.UserInputType.Keyboard then
            CurrentKey = input.KeyCode
            KeyBtn.Text = CurrentKey.Name
            Listening = false
            Callback(CurrentKey)
        end
    end)

    return KeyFrame
end

return KeybindModule
