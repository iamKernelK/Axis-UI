local TweenService = game:GetService("TweenService")
local LockModule = {}

LockModule.UsedCodes = {} -- حفظ الأكواد المستعملة لمنع تكرارها

-- ألوان الهوية الرقمية لـ AxisUI
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_GREEN = Color3.fromRGB(46, 204, 113)
local THEME_RED = Color3.fromRGB(231, 76, 60)
local OVERLAY_BG = Color3.fromRGB(8, 6, 5)

function LockModule.Apply(Element, Options)
    if not Element then return end
    
    local requiredCode = Options.Code
    local onUnlockCallback = Options.OnUnlock or function() end
    
    -- 1. واجهة الحماية الشاملة (تغطي العنصر بالكامل وتمتص الضغطات)
    local LockOverlay = Instance.new("Frame")
    LockOverlay.Name = "AxisLock_Overlay"
    LockOverlay.Size = UDim2.new(1, 0, 1, 0)
    LockOverlay.BackgroundColor3 = OVERLAY_BG
    LockOverlay.BackgroundTransparency = 0.2 -- شفافية فخمة تظهر ما خلف القفل بشكل خفي
    LockOverlay.ZIndex = 1000 -- زاوية رؤية عليا لتغطية كل عناصر الـ UI بالداخل
    LockOverlay.Active = true -- حظر الضغط تماماً
    LockOverlay.ClipsDescendants = true
    LockOverlay.Parent = Element
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = LockOverlay

    -- تدرج لوني خفي لخلفية القفل
    local OverlayGradient = Instance.new("UIGradient")
    OverlayGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 150, 150))
    })
    OverlayGradient.Rotation = 45
    OverlayGradient.Parent = LockOverlay

    -- إطار مضيء للقفل
    local LockStroke = Instance.new("UIStroke")
    LockStroke.Color = THEME_ORANGE
    LockStroke.Thickness = 1
    LockStroke.Transparency = 0.7
    LockStroke.Parent = LockOverlay
    TweenService:Create(LockStroke, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Transparency = 0.3}):Play()

    -- 2. أيقونة القفل
    local LockIcon = Instance.new("ImageLabel")
    LockIcon.BackgroundTransparency = 1
    LockIcon.Image = "rbxassetid://15117261700" 
    LockIcon.ImageColor3 = THEME_ORANGE
    LockIcon.ZIndex = 1001
    LockIcon.Parent = LockOverlay

    -- 3. نص الحالة
    local StatusText = Instance.new("TextLabel")
    StatusText.BackgroundTransparency = 1
    StatusText.TextColor3 = THEME_ORANGE
    StatusText.Font = Enum.Font.GothamBold
    StatusText.TextSize = 12
    StatusText.ZIndex = 1001
    StatusText.Parent = LockOverlay

    -- 4. صندوق إدخال الكود (TextBox) - يتم إنشاؤه فقط إذا تم تمرير Code
    local CodeBox
    if requiredCode then
        CodeBox = Instance.new("TextBox")
        CodeBox.BackgroundColor3 = Color3.fromRGB(16, 11, 9)
        CodeBox.PlaceholderText = "Enter Code"
        CodeBox.Text = ""
        CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        CodeBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        CodeBox.Font = Enum.Font.GothamMedium
        CodeBox.TextSize = 11
        CodeBox.ZIndex = 1002
        CodeBox.Parent = LockOverlay
        
        Instance.new("UICorner", CodeBox).CornerRadius = UDim.new(0, 6)
        local BoxStroke = Instance.new("UIStroke", CodeBox)
        BoxStroke.Color = THEME_ORANGE
        BoxStroke.Thickness = 1
        BoxStroke.Transparency = 0.5
    end

    -- [🧠 نظام التنسيق الديناميكي الذكي الذاتي]
    -- يقوم بفحص حجم العنصر لتحديد شكل التصميم تلقائياً (أفقي للعناصر الصغيرة / مركزي للعناصر الكبيرة)
    local function UpdateLayout()
        local sizeY = Element.AbsoluteSize.Y
        if sizeY <= 65 then
            -- 🛠️ التنسيق الأفقي (للأزرار، السلايدرات، الدبل داون المغلق)
            LockIcon.Size = UDim2.new(0, 18, 0, 18)
            LockIcon.Position = UDim2.new(0, 15, 0.5, -9)
            LockIcon.AnchorPoint = Vector2.new(0, 0)

            StatusText.Size = UDim2.new(0, 120, 1, 0)
            StatusText.Position = UDim2.new(0, 42, 0, 0)
            StatusText.TextXAlignment = Enum.TextXAlignment.Left
            StatusText.TextYAlignment = Enum.TextYAlignment.Center
            StatusText.Text = requiredCode and "Requires Code" or "Locked"

            if CodeBox then
                CodeBox.Size = UDim2.new(0, 85, 0, 24)
                CodeBox.Position = UDim2.new(1, -12, 0.5, 0)
                CodeBox.AnchorPoint = Vector2.new(1, 0.5)
            end
        else
            -- 🗺️ التنسيق المركزي الفخم (للـ Tabs، الـ Sections الكبيرة، المجمعات الكاملة)
            LockIcon.Size = UDim2.new(0, 32, 0, 32)
            LockIcon.Position = UDim2.new(0.5, 0, 0.4, 0)
            LockIcon.AnchorPoint = Vector2.new(0.5, 0.5)

            StatusText.Size = UDim2.new(1, 0, 0, 25)
            StatusText.Position = UDim2.new(0, 0, 0.55, 0)
            StatusText.TextXAlignment = Enum.TextXAlignment.Center
            StatusText.TextYAlignment = Enum.TextYAlignment.Center
            StatusText.TextSize = 14
            StatusText.Text = requiredCode and "This Section Requires an Access Code" or "Content Locked By Developer"

            if CodeBox then
                CodeBox.Size = UDim2.new(0, 140, 0, 30)
                CodeBox.Position = UDim2.new(0.5, 0, 0.72, 0)
                CodeBox.AnchorPoint = Vector2.new(0.5, 0.5)
                CodeBox.TextSize = 13
            end
        end
    end

    UpdateLayout()
    Element:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateLayout)

    -- [🔐 منطق التحقق وفك التشفير الاحترافي]
    if CodeBox then
        CodeBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local input = CodeBox.Text
                CodeBox.Text = ""
                if input == "" then return end
                
                CodeBox.Visible = false

                -- أنيميشن الفحص السينمائي
                for i = 1, 2 do
                    StatusText.Text = "Verifying Access." task.wait(0.2)
                    StatusText.Text = "Verifying Access.." task.wait(0.2)
                    StatusText.Text = "Verifying Access..." task.wait(0.2)
                end

                if input == tostring(requiredCode) and not LockModule.UsedCodes[input] then
                    -- 🟢 نجاح العملية!
                    LockModule.UsedCodes[input] = true
                    StatusText.Text = "Access Granted!"
                    StatusText.TextColor3 = THEME_GREEN
                    LockIcon.ImageColor3 = THEME_GREEN
                    LockStroke.Color = THEME_GREEN
                    
                    -- تحويل أيقونة القفل لعلامة صح مع أنيميشن تكبير فخم
                    TweenService:Create(LockIcon, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                    task.wait(0.2)
                    LockIcon.Image = "rbxassetid://13132087769" -- أيقونة الفتح/النجاح
                    local targetSize = Element.AbsoluteSize.Y <= 65 and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 36, 0, 36)
                    TweenService:Create(LockIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = targetSize}):Play()

                    task.wait(1.5)
                    
                    -- تلاشي واجهة القفل بالكامل لفتح العنصر بسلاسة
                    local fade = TweenService:Create(LockOverlay, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
                    TweenService:Create(LockIcon, TweenInfo.new(0.4), {ImageTransparency = 1}):Play()
                    TweenService:Create(StatusText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                    TweenService:Create(LockStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
                    fade:Play()
                    
                    fade.Completed:Connect(function()
                        LockOverlay:Destroy()
                        onUnlockCallback() -- تفعيل كول باك النجاح إذا وجد
                    end)
                else
                    -- 🔴 كود خاطئ: اهتزاز متقدم وتأثير أحمر
                    StatusText.Text = "Access Denied!"
                    StatusText.TextColor3 = THEME_RED
                    LockIcon.ImageColor3 = THEME_RED
                    LockStroke.Color = THEME_RED
                    
                    local origPos = StatusText.Position
                    for i = 1, 6 do
                        StatusText.Position = origPos + UDim2.new(0, math.random(-3, 3), 0, 0)
                        task.wait(0.04)
                    end
                    StatusText.Position = origPos
                    
                    task.wait(1.2)
                    StatusText.TextColor3 = THEME_ORANGE
                    LockIcon.ImageColor3 = THEME_ORANGE
                    LockStroke.Color = THEME_ORANGE
                    UpdateLayout()
                    CodeBox.Visible = true
                end
            end
        end)
    end
end

return LockModule

