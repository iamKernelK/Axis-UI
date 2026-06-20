local LabelModule = {}

function LabelModule.Create(ParentFrame, Options)
    local Text = Options.Name or "Information..."

    local LabelFrame = Instance.new("TextLabel")
    LabelFrame.Size = UDim2.new(1, 0, 0, 20)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Text = "ℹ️ " .. Text
    LabelFrame.TextColor3 = Color3.fromRGB(180, 180, 180) -- رمادي فاتح
    LabelFrame.Font = Enum.Font.GothamMedium
    LabelFrame.TextSize = 12
    LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
    LabelFrame.Parent = ParentFrame

    return LabelFrame
end

return LabelModule

