local SectionModule = {}

function SectionModule.Create(ParentFrame, Options)
    local Text = Options.Name or "Section"

    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, 0, 0, 25)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = ParentFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ " .. Text
    Title.TextColor3 = Color3.fromRGB(255, 140, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = SectionFrame

    return SectionFrame
end

return SectionModule
