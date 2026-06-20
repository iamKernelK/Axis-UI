-- TextBox Component
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local TName = Options.Name or "Input Box"
    local PlaceHolder = Options.Placeholder or "Type here..."
    local Callback = Options.Callback or function() end

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, 0, 0, 42)
    BoxFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    BoxFrame.Parent = TabContainer
    Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = TName
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = BoxFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(0, 180, 0, 26)
    Input.Position = UDim2.new(1, -195, 0.5, -13)
    Input.BackgroundColor3 = Color3.fromRGB(25, 18, 15)
    Input.PlaceholderText = PlaceHolder
    Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    Input.Text = ""
    Input.TextColor3 = THEME_ORANGE
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 13
    Input.Parent = BoxFrame
    Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Input).Color = THEME_ORANGE

    Input.FocusLost:Connect(function(enterPressed)
        Callback(Input.Text, enterPressed)
    end)
end
