local TweenService = game:GetService("TweenService")
local ToggleModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

function ToggleModule.Create(ParentFrame, Options)
    local TName = Options.Name or "Toggle"
    local TType = Options.Type or "Default" -- يقبل "Default" أو "Box"
    local State = Options.Default or false
    local Callback = Options.Callback or function() end

    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = TName .. "_Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    ToggleFrame.Parent = ParentFrame
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = TName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255) -- نص أبيض ناصع
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = ToggleFrame

    local InteractBtn = Instance.new("TextButton")
    InteractBtn.Size = UDim2.new(1, 0, 1, 0)
    InteractBtn.BackgroundTransparency = 1
    InteractBtn.Text = ""
    InteractBtn.Parent = ToggleFrame

    if TType == "Box" then
        local Box = Instance.new("Frame")
        Box.Size = UDim2.new(0, 24, 0, 24)
        Box.Position = UDim2.new(1, -35, 0.5, -12)
        Box.BackgroundColor3 = Color3.fromRGB(30, 20, 15)
        Box.Parent = ToggleFrame
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)

        local Stroke = Instance.new("UIStroke", Box)
        Stroke.Thickness = 1.5
        Stroke.Color = Color3.fromRGB(100, 100, 100)

        local Check = Instance.new("ImageLabel")
        Check.Size = UDim2.new(0, 0, 0, 0)
        Check.AnchorPoint = Vector2.new(0.5, 0.5)
        Check.Position = UDim2.new(0.5, 0, 0.5, 0)
        Check.BackgroundTransparency = 1
        Check.Image = "rbxassetid://6031094667"
        Check.ImageColor3 = THEME_ORANGE
        Check.Parent = Box

        local function Update()
            if State then
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = THEME_ORANGE}):Play()
                TweenService:Create(Check, TweenInfo.new(0.4, Enum.EasingStyle.Bounce), {Size = UDim2.new(0.8, 0, 0.8, 0)}):Play()
            else
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 100)}):Play()
                TweenService:Create(Check, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            end
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State; Update(); Callback(State) end)
        Update()
    else
        -- Default (الشكل البيضاوي)
        local Pill = Instance.new("Frame")
        Pill.Size = UDim2.new(0, 44, 0, 22)
        Pill.Position = UDim2.new(1, -55, 0.5, -11)
        Pill.BackgroundColor3 = Color3.fromRGB(40, 35, 35)
        Pill.Parent = ToggleFrame
        Instance.new("UICorner", Pill).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 2, 0.5, -9)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Pill
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local function Update()
            local targetBg = State and THEME_ORANGE or Color3.fromRGB(40, 35, 35)
            local targetPos = State and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            TweenService:Create(Pill, TweenInfo.new(0.3), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.3), {Position = targetPos}):Play()
        end

        InteractBtn.MouseButton1Click:Connect(function() State = not State; Update(); Callback(State) end)
        Update()
    end

    return ToggleFrame
end

return ToggleModule
