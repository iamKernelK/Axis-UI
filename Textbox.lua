local TweenService = game:GetService("TweenService")

-- الألوان المتناسقة مع هوية مكتبتك
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local TEXTBOX_BG = Color3.fromRGB(20, 15, 12)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)

return {
    Create = function(Container, Config)
        -- استخراج البيانات مع وضع قيم افتراضية لتجنب الأخطاء
        local name = Config.Name or "Textbox Element"
        local callback = Config.Callback or function() end
        local placeholder = Config.Placeholder or "Type here..."

        -- 1. الحاوية الأساسية (Frame)
        local Frame = Instance.new("Frame")
        Frame.Name = name .. "_TextboxFrame"
        Frame.Size = UDim2.new(1, 0, 0, 40)
        Frame.BackgroundTransparency = 1 -- شفاف لكي يندمج مع خلفية القائمة
        Frame.Parent = Container

        -- 2. العنوان في اليسار (TextLabel)
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        -- نترك مساحة 160 بكسل في اليمين لمربع النص (150 حجم المربع + 10 مسافة)
        Title.Size = UDim2.new(1, -160, 1, 0) 
        Title.Position = UDim2.new(0, 10, 0, 0) -- يبدأ بعد 10 بكسل من اليسار
        Title.BackgroundTransparency = 1
        Title.Text = name
        Title.TextColor3 = THEME_ORANGE
        Title.Font = Enum.Font.GothamSemibold
        Title.TextScaled = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Frame

        -- إضافة حد أقصى لحجم النص حتى لا يصبح عملاقاً بسبب TextScaled
        local TitleConstraint = Instance.new("UITextSizeConstraint")
        TitleConstraint.MaxTextSize = 14
        TitleConstraint.Parent = Title

        -- 3. مربع إدخال النص في اليمين (TextBox)
        local InputBox = Instance.new("TextBox")
        InputBox.Name = "Input"
        InputBox.Size = UDim2.new(0, 150, 0, 30)
        InputBox.Position = UDim2.new(1, -10, 0.5, 0) -- 10 بكسل من اليمين
        InputBox.AnchorPoint = Vector2.new(1, 0.5) -- ارتكاز في المنتصف اليمين
        InputBox.BackgroundColor3 = TEXTBOX_BG
        InputBox.Text = ""
        InputBox.PlaceholderText = placeholder
        InputBox.TextColor3 = TEXT_COLOR
        InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
        InputBox.Font = Enum.Font.GothamSemibold
        InputBox.TextScaled = true
        InputBox.ClearTextOnFocus = false -- لكي لا يُمسح النص تلقائياً عند الضغط عليه للنسخ/التعديل
        InputBox.ClipsDescendants = true
        InputBox.Parent = Frame

        -- حد أقصى لحجم نص الكتابة
        local InputConstraint = Instance.new("UITextSizeConstraint")
        InputConstraint.MaxTextSize = 13
        InputConstraint.Parent = InputBox

        -- حواف دائرية لمربع النص
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 6)
        UICorner.Parent = InputBox

        -- إطار (Stroke) لمربع النص بأنيميشن احترافي
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = THEME_ORANGE
        UIStroke.Thickness = 1
        UIStroke.Transparency = 0.8 -- يكون شبه مخفي في البداية
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        UIStroke.Parent = InputBox

        -- 4. التفاعلات (Interactions)
        
        -- عند الضغط على المربع للبدء بالكتابة (يضيء الإطار)
        InputBox.Focused:Connect(function()
            TweenService:Create(UIStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
            TweenService:Create(InputBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 18, 11)}):Play()
        end)

        -- عند الانتهاء من الكتابة (الضغط على Enter أو النقر خارج المربع)
        InputBox.FocusLost:Connect(function(enterPressed)
            -- إعادة الشكل إلى حالته الطبيعية
            TweenService:Create(UIStroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
            TweenService:Create(InputBox, TweenInfo.new(0.3), {BackgroundColor3 = TEXTBOX_BG}):Play()
            
            -- استدعاء الوظيفة وإرسال النص المكتوب
            callback(InputBox.Text)
        end)

        return Frame
    end
}
