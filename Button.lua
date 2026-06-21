local TweenService = game:GetService("TweenService")
local ButtonModule = {}

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local BUTTON_BG = Color3.fromRGB(16, 12, 10)
local BUTTON_HOVER_BG = Color3.fromRGB(24, 16, 12)

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Premium Button"
    local callback = Options.Callback or function() end
    local iconId = Options.Icon or "rbxassetid://107150227368485" 
    
    -- 1. الهيكل الفخم للزر
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, 0, 0, 44) 
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.Parent = ParentFrame
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    
    -- تأثير تدرج اللوني الفخم للواجهة الخلفية
    local UIModGradient = Instance.new("UIGradient")
    UIModGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 190))
    })
    UIModGradient.Rotation = 90
    UIModGradient.Parent = Button
    
    -- حاوية التموج المائي (Ripple)
    local ClipContainer = Instance.new("Frame", Button)
    ClipContainer.Size = UDim2.new(1, 0, 1, 0)
    ClipContainer.BackgroundTransparency = 1
    ClipContainer.ClipsDescendants = true
    Instance.new("UICorner", ClipContainer).CornerRadius = UDim.new(0, 8)

    -- إطار الإشعاع المحيط المطور (Stroke Expansion Effect)
    local Stroke = Instance.new("UIStroke", Button)
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.7
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    -- نص العنصر الاحترافي
    local Title = Instance.new("TextLabel", Button)
    Title.Size = UDim2.new(1, -55, 1, 0) 
    Title.Position = UDim2.new(0, 16, 0, 0) 
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = THEME_ORANGE
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13.5
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2 
    
    -- الأيقونة التفاعلية
    local RightIcon = Instance.new("ImageLabel", Button)
    RightIcon.Size = UDim2.new(0, 18, 0, 18)
    RightIcon.Position = UDim2.new(1, -16, 0.5, 0) 
    RightIcon.AnchorPoint = Vector2.new(1, 0.5)
    RightIcon.BackgroundTransparency = 1
    RightIcon.Image = iconId
    RightIcon.ImageColor3 = THEME_ORANGE 
    RightIcon.ZIndex = 2

    -- الأنيميشن الاحترافي عند التفاعل
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Thickness = 1.6, Transparency = 0.2}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Thickness = 1, Transparency = 0.7}):Play()
    end)

    -- تأثير موجة الطاقة (Energy Ripple) عند الضغط بالماوس
    Button.MouseButton1Down:Connect(function()
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local X, Y = Mouse.X - Button.AbsolutePosition.X, Mouse.Y - Button.AbsolutePosition.Y
        
        local Ripple = Instance.new("Frame", ClipContainer)
        Ripple.BackgroundColor3 = THEME_ORANGE 
        Ripple.BackgroundTransparency = 0.4
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)
        
        local targetSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.6
        TweenService:Create(Ripple, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.45, function() Ripple:Destroy() end)
    end)
    
    Button.MouseButton1Click:Connect(callback)
    
    -- [🔗 ربط القفل الشامل التلقائي]
    if Options.Locked then
        local success, LockModule = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Lock.lua"))()
        end)
        if success and LockModule and LockModule.Apply then
            LockModule.Apply(Button, Options)
        end
    end
    
    return Button
end

return ButtonModule
