-- ProgressBar Component
local TweenService = game:GetService("TweenService")
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return function(TabContainer, Options)
    local Name = Options.Name or "Status"
    local Progress = Options.Progress or 0 -- من 0 إلى 100

    local BarFrame = Instance.new("Frame")
    BarFrame.Size = UDim2.new(1, 0, 0, 45)
    BarFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    BarFrame.Parent = TabContainer
    Instance.new("UICorner", BarFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -15, 0, 20)
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = BarFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 6)
    Track.Position = UDim2.new(0, 15, 1, -12)
    Track.BackgroundColor3 = Color3.fromRGB(45, 40, 40)
    Track.Parent = BarFrame
    Instance.new("UICorner", Track)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(Progress / 100, 0, 1, 0)
    Fill.BackgroundColor3 = THEME_ORANGE
    Fill.Parent = Track
    Instance.new("UICorner", Fill)

    -- دالة لتحديث النسبة من خارج السكربت بأنيميشن ناعم جداً
    local Controller = {}
    function Controller:SetProgress(NewValue)
        local clamped = math.clamp(NewValue / 100, 0, 1)
        TweenService:Create(Fill, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Size = UDim2.new(clamped, 0, 1, 0)}):Play()
    end

    return Controller
end
