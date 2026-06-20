local TweenService = game:GetService("TweenService")

local ButtonModule = {}

-- الألوان الخاصة بالهوية
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local BUTTON_BG = Color3.fromRGB(20, 15, 12)
local BUTTON_HOVER_BG = Color3.fromRGB(28, 18, 11)

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    local clickIconId = Options.Icon or "rbxassetid://107150227368485" 
    
    -- 1. الزر الأساسي 
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    
    -- [الحل هنا]: الحجم 100% عرض. الـ UIPadding في الـ Tab هو اللي راح يخلي المسافات ممتازة
    Button.Size = UDim2.new(1, 0, 0, 42) 
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.ClipsDescendants = false -- خليناها false عشان الإطار (Stroke) ما ينقص من الأطراف
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- حاوية القص للتموج (Ripple) عشان ما يطلع برا الزر
    local ClipContainer = Instance.new("Frame")
    ClipContainer.Size = UDim2.new(1, 0, 1, 0)
    ClipContainer.BackgroundTransparency = 1
    ClipContainer.ClipsDescendants = true
    ClipContainer.Parent = Button
    
    local ClipCorner = Instance.new("UICorner")
    ClipCorner.CornerRadius = UDim.new(0, 8)
    ClipCorner.Parent = ClipContainer

    -- 2. إطار الزر (أنيميشن النبض المستمر)
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = 0.8
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = Button
    
    TweenService:Create(Stroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.2}):Play()
    
    -- 3. النص 
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0) 
    Title.Position = UDim2.new(0, 15, 0, 0) 
    Title.BackgroundTransparency = 1
    Title.Text = text
    Title.TextColor3 = THEME_ORANGE
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 15 
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2 
    Title.Parent = Button
    
    -- 4. أيقونة Click 
    local RightIcon = Instance.new("ImageLabel")
    RightIcon.Size = UDim2.new(0, 20, 0, 20)
    RightIcon.Position = UDim2.new(1, -15, 0.5, 0) 
    RightIcon.AnchorPoint = Vector2.new(1, 0.5)
    RightIcon.BackgroundTransparency = 1
    RightIcon.Image = clickIconId
    RightIcon.ImageColor3 = THEME_ORANGE 
    RightIcon.ZIndex = 2
    RightIcon.Parent = Button
    
    -- 5. التفاعلات والأنيميشن
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
    end)

    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Title, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.15), {ImageTransparency = 0.5}):Play()
        
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local AbsolutePos = Button.AbsolutePosition
        local X = Mouse.X - AbsolutePos.X
        local Y = Mouse.Y - AbsolutePos.Y
        
        local Ripple = Instance.new("Frame")
        Ripple.BackgroundColor3 = THEME_ORANGE 
        Ripple.BackgroundTransparency = 0.3
        Ripple.BorderSizePixel = 0
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.ZIndex = 1 
        
        local RippleCorner = Instance.new("UICorner")
        RippleCorner.CornerRadius = UDim.new(1, 0)
        RippleCorner.Parent = Ripple
        
        Ripple.Parent = ClipContainer -- وضعنا التموج داخل الحاوية عشان ما يخرج برا
        
        local maxSize = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
        local Tween = TweenService:Create(Ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        })
        
        Tween:Play()
        Tween.Completed:Connect(function()
            Ripple:Destroy()
        end)
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    return Button
end

return ButtonModule
