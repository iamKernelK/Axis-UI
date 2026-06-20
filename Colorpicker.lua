local TweenService = game:GetService("TweenService")
local ColorPickerModule = {}

function ColorPickerModule.Create(ParentFrame, Options)
    local Name = Options.Name or "Color Picker"
    local Default = Options.Default or Color3.fromRGB(255, 255, 255)
    local Callback = Options.Callback or function() end

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(1, 0, 0, 42)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    MainFrame.Parent = ParentFrame
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local ColorShow = Instance.new("Frame")
    ColorShow.Size = UDim2.new(0, 30, 0, 20)
    ColorShow.Position = UDim2.new(1, -45, 0.5, -10)
    ColorShow.BackgroundColor3 = Default
    ColorShow.Parent = MainFrame
    Instance.new("UICorner", ColorShow).CornerRadius = UDim.new(0, 4)

    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = MainFrame

    InteractBtn.MouseButton1Click:Connect(function()
        -- يمكنك لاحقاً ربطها بنافذة ألوان حقيقية، هنا يختار لون برتقالي عشوائي للتجربة
        local newColor = Color3.fromRGB(math.random(200,255), math.random(100,150), 0)
        TweenService:Create(ColorShow, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        Callback(newColor)
    end)

    return MainFrame
end

return ColorPickerModule
