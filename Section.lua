-- Section & Label Components Inside One File For Layout Organization
local SectionModule = {}

function SectionModule.AddSection(TabContainer, Text)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, 0, 0, 25)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = TabContainer

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ " .. Text
    Title.TextColor3 = Color3.fromRGB(255, 140, 0) -- برتقالي ساطع للتمييز
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SectionFrame
end

function SectionModule.AddLabel(TabContainer, Text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = "💡 " .. Text
    Label.TextColor3 = Color3.fromRGB(160, 160, 160)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = TabContainer
end

return SectionModule
