local TweenService = game:GetService("TweenService")

local ButtonModule = {}

-- نظام حفظ الأكواد المستعملة (عشان الكود يشتغل مرة وحدة بس)
ButtonModule.UsedCodes = {}

-- الألوان الخاصة بالهوية (AxisUI Theme)
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_GREEN = Color3.fromRGB(46, 204, 113)
local THEME_RED = Color3.fromRGB(231, 76, 60)
local BUTTON_BG = Color3.fromRGB(20, 15, 12)
local BUTTON_HOVER_BG = Color3.fromRGB(28, 18, 11)
local OVERLAY_BG = Color3.fromRGB(5, 3, 2)

function ButtonModule.Create(ParentFrame, Options)
    local text = Options.Name or "Button"
    local callback = Options.Callback or function() end
    local clickIconId = Options.Icon or "rbxassetid://107150227368485" 
    
    -- إعدادات القفل
    local isLocked = Options.Locked or false
    local requiredCode = Options.Code
    
    -- 1. الزر الأساسي 
    local Button = Instance.new("TextButton")
    Button.Name = text .. "_Btn"
    Button.Size = UDim2.new(1, 0, 0, 42) 
    Button.BackgroundColor3 = BUTTON_BG
    Button.Text = "" 
    Button.AutoButtonColor = false
    Button.ClipsDescendants = false 
    Button.Parent = ParentFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button
    
    -- حاوية القص للتموج (Ripple)
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

    -- ==========================================
    -- 🔒 نظام القفل (Locked System)
    -- ==========================================
    if isLocked then
        -- واجهة القفل الشفافة
        local LockOverlay = Instance.new("Frame")
        LockOverlay.Size = UDim2.new(1, 0, 1, 0)
        LockOverlay.BackgroundColor3 = OVERLAY_BG
        LockOverlay.BackgroundTransparency = 0.3
        LockOverlay.ZIndex = 5
        LockOverlay.Parent = Button
        
        local OverlayCorner = Instance.new("UICorner")
        OverlayCorner.CornerRadius = UDim.new(0, 8)
        OverlayCorner.Parent = LockOverlay

        -- أيقونة القفل
        local LockIcon = Instance.new("ImageLabel")
        LockIcon.Size = UDim2.new(0, 20, 0, 20)
        LockIcon.Position = UDim2.new(0.5, 0, 0.35, 0)
        LockIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        LockIcon.BackgroundTransparency = 1
        LockIcon.Image = "rbxassetid://15117261700" -- أيقونة القفل
        LockIcon.ImageColor3 = THEME_ORANGE
        LockIcon.ZIndex = 6
        LockIcon.Parent = LockOverlay

        -- نص الحالة (Locked أو Needs Code)
        local StatusText = Instance.new("TextLabel")
        StatusText.Size = UDim2.new(1, 0, 0, 15)
        StatusText.Position = UDim2.new(0.5, 0, 0.75, 0)
        StatusText.AnchorPoint = Vector2.new(0.5, 0.5)
        StatusText.BackgroundTransparency = 1
        StatusText.Text = requiredCode and "Needs Code" or "Locked"
        StatusText.TextColor3 = THEME_ORANGE
        StatusText.Font = Enum.Font.GothamBold
        StatusText.TextSize = 11
        StatusText.ZIndex = 6
        StatusText.Parent = LockOverlay

        -- صندوق إدخال الكود (TextBox)
        if requiredCode then
            local CodeBox = Instance.new("TextBox")
            CodeBox.Size = UDim2.new(0, 100, 0, 26)
            CodeBox.Position = UDim2.new(1, -10, 0.5, 0)
            CodeBox.AnchorPoint = Vector2.new(1, 0.5)
            CodeBox.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
            CodeBox.PlaceholderText = "Code here"
            CodeBox.Text = ""
            CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            CodeBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            CodeBox.Font = Enum.Font.GothamMedium
            CodeBox.TextSize = 12
            CodeBox.ZIndex = 7
            CodeBox.ClipsDescendants = true
            CodeBox.Parent = LockOverlay
            
            local CodeBoxCorner = Instance.new("UICorner")
            CodeBoxCorner.CornerRadius = UDim.new(0, 4)
            CodeBoxCorner.Parent = CodeBox
            
            local CodeBoxStroke = Instance.new("UIStroke")
            CodeBoxStroke.Color = THEME_ORANGE
            CodeBoxStroke.Thickness = 1
            CodeBoxStroke.Transparency = 0.5
            CodeBoxStroke.Parent = CodeBox

            -- منطق التحقق عند الضغط على Enter
            CodeBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local input = CodeBox.Text
                    CodeBox.Text = ""
                    CodeBox.Visible = false -- إخفاء المربع أثناء التحقق

                    -- أنيميشن التحقق
                    StatusText.TextColor3 = THEME_ORANGE
                    for i = 1, 3 do
                        StatusText.Text = "Checking Code."
                        task.wait(0.3)
                        StatusText.Text = "Checking Code.."
                        task.wait(0.3)
                        StatusText.Text = "Checking Code..."
                        task.wait(0.3)
                    end

                    -- التحقق من صحة الكود وأنه لم يُستخدم من قبل
                    if input == requiredCode and not ButtonModule.UsedCodes[input] then
                        -- تم بنجاح
                        ButtonModule.UsedCodes[input] = true -- تسجيل الكود كمُستخدم
                        StatusText.Text = "Successfully"
                        StatusText.TextColor3 = THEME_ORANGE -- طلبته أخضر بس عشان التصميم
                        
                        -- أنيميشن فتح القفل
                        TweenService:Create(LockIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                        task.wait(0.2)
                        LockIcon.Image = "rbxassetid://13132087769" -- أيقونة الفتح
                        LockIcon.ImageColor3 = THEME_GREEN
                        StatusText.TextColor3 = THEME_GREEN
                        TweenService:Create(LockIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24)}):Play()

                        -- الانتظار 3 ثواني ثم إزالة القفل
                        task.wait(3)
                        
                        local fadeOut = TweenService:Create(LockOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1})
                        TweenService:Create(LockIcon, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
                        TweenService:Create(StatusText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
                        fadeOut:Play()
                        
                        fadeOut.Completed:Connect(function()
                            LockOverlay:Destroy()
                            isLocked = false -- فتح الزر للاستخدام العادي
                        end)

                    else
                        -- الكود خاطئ أو مستخدم مسبقاً
                        StatusText.Text = "Wrong Code"
                        StatusText.TextColor3 = THEME_RED
                        
                        -- اهتزاز للنص (Shake Effect)
                        local originalPos = StatusText.Position
                        for i = 1, 4 do
                            StatusText.Position = originalPos + UDim2.new(0, math.random(-3, 3), 0, 0)
                            task.wait(0.05)
                        end
                        StatusText.Position = originalPos

                        task.wait(1.5)
                        StatusText.Text = "Needs Code"
                        StatusText.TextColor3 = THEME_ORANGE
                        CodeBox.Visible = true -- إرجاع المربع ليحاول مرة أخرى
                    end
                end
            end)
        end
    end
    -- ==========================================

    -- 5. التفاعلات والأنيميشن (تعمل فقط إذا كان غير مقفول)
    Button.MouseEnter:Connect(function()
        if isLocked then return end
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = BUTTON_HOVER_BG}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        if isLocked then return end
        TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = BUTTON_BG}):Play()
        TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
    end)

    Button.MouseButton1Down:Connect(function()
        if isLocked then return end
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
        
        Ripple.Parent = ClipContainer
        
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
        if isLocked then return end
        TweenService:Create(Title, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
        TweenService:Create(RightIcon, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
    end)
    
    Button.MouseButton1Click:Connect(function()
        if isLocked then return end
        callback()
    end)
    
    return Button
end

return ButtonModule
