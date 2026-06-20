local TweenService = game:GetService("TweenService")
local ProgressModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function ProgressModule.Create(ParentFrame, Options)
    local Name = Options.Name or "Loading..."
    local Default = Options.Progress or 0

    local BarFrame = Instance.new("Frame")
    BarFrame.Size = UDim2.new(1, 0, 0, 45)
    BarFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    BarFrame.Parent = ParentFrame
    Instance.new("UICorner", BarFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = BarFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 8)
    Track.Position = UDim2.new(0, 15, 1, -12)
    Track.BackgroundColor3 = Color3.fromRGB(40, 30, 25)
    Track.Parent = BarFrame
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(Default / 100, 0, 1, 0)
    Fill.BackgroundColor3 = THEME_ORANGE
    Fill.Parent = Track
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    -- نرجع جدول فيه الدالة اللي تحدث القيمة
    local Controller = {}
    function Controller:SetProgress(Value)
        local clamped = math.clamp(Value / 100, 0, 1)
        TweenService:Create(Fill, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = UDim2.new(clamped, 0, 1, 0)}):Play()
    end

    return Controller
end

return ProgressModule
