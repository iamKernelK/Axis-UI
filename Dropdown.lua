-- Dropdown Component
local TweenService = game:GetService("TweenService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local DName = Options.Name or "Dropdown"
    local List = Options.Options or {}
    local Callback = Options.Callback or function() end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = TabContainer
    Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 0, 40)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = DName .. " : Unselected"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = DropdownFrame

    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -30, 0, 12)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://6034818372"
    Arrow.ImageColor3 = THEME_ORANGE
    Arrow.Parent = DropdownFrame

    local OptionsContainer = Instance.new("ScrollingFrame")
    OptionsContainer.Size = UDim2.new(1, -20, 0, 100)
    OptionsContainer.Position = UDim2.new(0, 10, 0, 42)
    OptionsContainer.BackgroundTransparency = 1
    OptionsContainer.ScrollBarThickness = 2
    OptionsContainer.ScrollBarImageColor3 = THEME_ORANGE
    OptionsContainer.Parent = DropdownFrame
    Instance.new("UIListLayout", OptionsContainer).Padding = UDim.new(0, 4)

    local Open = false
    local function ToggleDropdown()
        Open = not Open
        local targetSize = Open and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 40)
        local targetRot = Open and 180 or 0
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = targetRot}):Play()
    end

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(1, 0, 0, 40)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = ""
    OpenBtn.Parent = DropdownFrame
    OpenBtn.MouseButton1Click:Connect(ToggleDropdown)

    for _, opt in ipairs(List) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 28)
        OptBtn.BackgroundColor3 = Color3.fromRGB(25, 18, 15)
        OptBtn.Text = "  " .. opt
        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 13
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.Parent = OptionsContainer
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

        OptBtn.MouseButton1Click:Connect(function()
            TitleLabel.Text = DName .. " : " .. opt
            ToggleDropdown()
            Callback(opt)
        end)
    end
end
