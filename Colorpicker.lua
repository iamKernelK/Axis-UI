-- ColorPicker Component
local TweenService = game:GetService("TweenService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local Name = Options.Name or "Color Picker"
    local DefaultColor = Options.Default or Color3.fromRGB(255, 140, 0)
    local Callback = Options.Callback or function() end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 0, 45)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = TabContainer
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 0, 45)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = MainFrame

    local ColorView = Instance.new("Frame")
    ColorView.Size = UDim2.new(0, 35, 0, 22)
    ColorView.Position = UDim2.new(1, -50, 0, 11)
    ColorView.BackgroundColor3 = DefaultColor
    ColorView.Parent = MainFrame
    Instance.new("UICorner", ColorView).CornerRadius = UDim.new(0, 4)

    local ExpandBtn = Instance.new("TextButton")
    ExpandBtn.Size = UDim2.new(1, 0, 0, 45)
    ExpandBtn.BackgroundTransparency = 1
    ExpandBtn.Text = ""
    ExpandBtn.Parent = MainFrame

    local Open = false
    ExpandBtn.MouseButton1Click:Connect(function()
        Open = not Open
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = Open and UDim2.new(1, 0, 0, 100) or UDim2.new(1, 0, 0, 45)}):Play()
    end)
    -- ملاحظة: يمكن ربط الـ Sliders الفرعية بالداخل لتعديل الألوان حسب الحاجة التامة
end
