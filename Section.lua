-- Section.lua
-- موديول القسم المحدث: يعتمد على المسافات وحجم الخط بدون خطوط فاصلة

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)

return {
    Create = function(Container, Config)
        -- جلب اسم القسم من الإعدادات
        local SectionName = Config.Name or "Section"

        -- 1. الإطار الأساسي للقسم (يعمل كمسافة فاصلة - Spacing)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Name = SectionName .. "_Section"
        -- الارتفاع 38: يعطي مسافة ممتازة وموزونة بين العناصر
        SectionFrame.Size = UDim2.new(1, 0, 0, 38) 
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Parent = Container

        -- 2. عنوان القسم (النص)
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Size = UDim2.new(1, -30, 1, 0) 
        Title.Position = UDim2.new(0, 15, 0, 0) -- إزاحة ليتماشى مع بداية الأزرار
        Title.BackgroundTransparency = 1
        Title.Text = SectionName
        Title.TextColor3 = THEME_ORANGE
        Title.Font = Enum.Font.GothamBold
        
        -- تكبير حجم الخط كما طلبت ليصبح بارزاً
        Title.TextSize = 15 
        
        Title.TextXAlignment = Enum.TextXAlignment.Left
        -- محاذاة النص للأسفل: لكي يكون الفراغ في الأعلى، والنص قريب من العناصر التي أسفله
        Title.TextYAlignment = Enum.TextYAlignment.Bottom 
        
        Title.Parent = SectionFrame

        -- تم حذف الخط الفاصل نهائياً والاكتفاء بالمسافة والنص

        return SectionFrame
    end
}
