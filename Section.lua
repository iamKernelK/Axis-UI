-- Section.lua
-- هذا الموديول مسؤول عن إنشاء أقسام (عناوين وخطوط فاصلة) لترتيب العناصر داخل القائمة

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return {
    Create = function(Container, Config)
        -- جلب اسم القسم من الإعدادات، مع وضع اسم افتراضي لتجنب الأخطاء
        local SectionName = Config.Name or "Section"

        -- 1. الإطار الأساسي للقسم (الحاوية الشفافة)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = SectionName .. "_Section"
        SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- الارتفاع 30 كما طلبت
        SectionFrame.BackgroundTransparency = 1 -- خلفية شفافة بالكامل
        SectionFrame.Parent = Container

        -- 2. عنوان القسم (TextLabel)
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -20, 1, 0) -- العرض ناقص 20 بكسل لترك مساحة جمالية
        Title.Position = UDim2.new(0, 15, 0, 0) -- يبدأ بعد 15 بكسل من اليسار ليتماشى مع الأزرار
        Title.BackgroundTransparency = 1
        Title.Text = SectionName
        Title.TextColor3 = THEME_ORANGE -- اللون البرتقالي
        Title.Font = Enum.Font.GothamBold -- الخط العريض لتمييزه كعنوان
        Title.TextSize = 12
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = SectionFrame

        -- 3. الخط الفاصل في أسفل القسم (Separator Line)
        local Line = Instance.new("Frame")
        Line.Name = "SeparatorLine"
        -- عرض الخط ناقص 30 بكسل ليكون له هوامش يمين ويسار، وارتفاعه 1 بكسل فقط
        Line.Size = UDim2.new(1, -30, 0, 1) 
        Line.Position = UDim2.new(0.5, 0, 1, 0) -- نضعه في أسفل الإطار تماماً
        Line.AnchorPoint = Vector2.new(0.5, 1) -- الارتكاز من المنتصف بالأسفل لضبط المكان بدقة
        Line.BackgroundColor3 = THEME_ORANGE
        Line.BorderSizePixel = 0
        -- الشفافية هنا تعطي لمسة احترافية حتى لا يكون الخط حاداً جداً (اختياري)
        Line.BackgroundTransparency = 0.4 
        Line.Parent = SectionFrame

        -- إرجاع الإطار الأساسي لكي يتمكن السكربت الرئيسي من ترتيب العناصر تحته
        return SectionFrame
    end
}

