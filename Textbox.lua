local TextBoxModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function TextBoxModule.Create(ParentFrame, Options)
    local TName = Options.Name or "Input"
    local Placeholder = Options.Placeholder or "Type..."
    local Callback = Options.Callback or function() end

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, 0, 0, 42)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    BoxFrame.Parent = ParentFrame
    Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.4, 0, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = BoxFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0.5, -15, 0, 30)
    Input.Position = UDim2.new(0.5, 0, 0.5, -15)
    Input.BackgroundColor3 = Color3.fromRGB(35, 25, 20)
    Input.Text = ""
    Input.PlaceholderText = Placeholder
    Input.TextColor3 = THEME_ORANGE
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.Parent = BoxFrame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)

    Input.FocusLost:Connect(function(enterPressed)
        Callback(Input.Text, enterPressed)
    end)

    return BoxFrame
end

return TextBoxModule
