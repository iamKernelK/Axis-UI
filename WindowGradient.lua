local TweenService = game:GetService("TweenService")

local GradientModule = {}

-- الألوان: أضفنا 3 درجات عشان اللمعة (التوهج) تكون في النص وتتحرك
local COLOR_DARK_1 = Color3.fromRGB(15, 10, 8)    -- غامق جداً (الزاوية الأولى)
local COLOR_GLOW   = Color3.fromRGB(45, 25, 15)   -- التوهج البرتقالي/البني (في المنتصف)
local COLOR_DARK_2 = Color3.fromRGB(20, 15, 12)   -- غامق (الزاوية الثانية)

function GradientModule.Apply(ParentFrame)
    local Gradient = Instance.new("UIGradient")
    Gradient.Rotation = 45 -- زاوية مائلة تعطي شكل 3D
    
    -- دمج الألوان بحيث يكون التوهج في المنتصف
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_DARK_1),
        ColorSequenceKeypoint.new(0.5, COLOR_GLOW),
        ColorSequenceKeypoint.new(1, COLOR_DARK_2)
    })
    
    -- نبدأ الإزاحة من خارج الشاشة يساراً
    Gradient.Offset = Vector2.new(-0.5, -0.5)
    Gradient.Parent = ParentFrame
    
    -- الأنيميشن الفخم (تأثير التنفس/Shimmer Effect)
    local AnimInfo = TweenInfo.new(
        7,                           -- المدة: 7 ثواني (بطيء جداً ومريح للعين)
        Enum.EasingStyle.Sine,       -- حركة ناعمة جداً
        Enum.EasingDirection.InOut,  -- النعومة في البداية والنهاية
        -1,                          -- تكرار لا نهائي (-1)
        true                         -- يعود للخلف بنعومة (PingPong) لتجنب القطع المفاجئ
    )
    
    -- تحريك الـ Offset إلى الجهة المقابلة
    local GradientTween = TweenService:Create(Gradient, AnimInfo, {
        Offset = Vector2.new(0.5, 0.5)
    })
    
    GradientTween:Play()
    
    return Gradient
end

return GradientModule

