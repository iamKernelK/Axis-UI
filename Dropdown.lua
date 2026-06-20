local TweenService = game:GetService("TweenService")
local DropdownModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function DropdownModule.Create(ParentFrame, Options)
    local DName = Options.Name or "Dropdown"
    local List = Options.Options or {}
    local Callback = Options.Callback or function() end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 42)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = ParentFrame
    Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 0, 42)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = DName .. " : ..."
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = DropdownFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 20, 0, 20)
    Icon.Position = UDim2.new(1, -30, 0, 11)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://6034818372"
    Icon.ImageColor3 = THEME_ORANGE
    Icon.Parent = DropdownFrame

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Size = UDim2.new(1, 0, 0, 42)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = ""
    OpenBtn.Parent = DropdownFrame

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -20, 0, 100)
    Container.Position = UDim2.new(0, 10, 0, 45)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = THEME_ORANGE
    Container.Parent = DropdownFrame
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 4)

    local IsOpen = false
    OpenBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = IsOpen and UDim2.new(1, 0, 0, 150) or UDim2.new(1, 0, 0, 42)}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = IsOpen and 180 or 0}):Play()
    end)

    for _, opt in ipairs(List) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 30)
        OptBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 15)
        OptBtn.Text = "  " .. opt
        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 13
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.Parent = Container
        Instance.new("UICorner", OptBtn).CornerRadius = UDim.new(0, 4)

        OptBtn.MouseButton1Click:Connect(function()
            Title.Text = DName .. " : " .. opt
            Callback(opt)
            IsOpen = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 42)}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play()
        end)
    end

    return DropdownFrame
end

return DropdownModule
