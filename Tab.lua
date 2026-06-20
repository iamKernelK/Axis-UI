local TweenService = game:GetService("TweenService")
local TabModule = {}

-- الألوان المعتمدة في الستايل الخاص بك
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local TAB_BG = Color3.fromRGB(20, 15, 12)
local TAB_HOVER_BG = Color3.fromRGB(30, 20, 15)
local TAB_SELECTED_BG = Color3.fromRGB(45, 25, 10)
local TEXT_COLOR = Color3.fromRGB(180, 180, 180)
local TEXT_SELECTED = Color3.fromRGB(255, 255, 255)

function TabModule.Create(Window, Options)
    local Name = Options.Name or "Tab"
    local IconId = Options.Icon -- الأيقونة اختياري
    
    -- فحص ذكي: إذا كانت هذه أول خانة تصنعها، ستفتح تلقائياً
    local isFirstTab = false
    local existingTabs = 0
    for _, v in ipairs(Window.ElementsMenu:GetChildren()) do
        if v.Name:match("_Container") then existingTabs = existingTabs + 1 end
    end
    if existingTabs == 0 then isFirstTab = true end

    -- =====================================
    -- 1. الزر الجانبي (في TabsMenu اليسار)
    -- =====================================
    local TabButton = Instance.new("TextButton")
    TabButton.Name = Name .. "_TabBtn"
    TabButton.Size = UDim2.new(1, 0, 0, 38)
    TabButton.BackgroundColor3 = isFirstTab and TAB_SELECTED_BG or TAB_BG
    TabButton.Text = "" 
    TabButton.AutoButtonColor = false
    TabButton.ClipsDescendants = true
    TabButton.Parent = Window.TabsMenu -- يروح للقائمة اليسرى

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = TabButton
    
    -- خط التحديد البرتقالي يظهر لما تختار الخانة
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = THEME_ORANGE
    Stroke.Thickness = 1
    Stroke.Transparency = isFirstTab and 0 or 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = TabButton

    -- إضافة الأيقونة (إذا تم وضعها في الخيارات)
    local TextOffset = 15
    if IconId then
        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.Position = UDim2.new(0, 12, 0.5, 0)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.BackgroundTransparency = 1
        Icon.Image = IconId
        Icon.ImageColor3 = isFirstTab and THEME_ORANGE or TEXT_COLOR
        Icon.Parent = TabButton
        TextOffset = 36 -- إزاحة النص عشان الأيقونة
    end

    -- النص (اسم الخانة)
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -TextOffset, 1, 0)
    Title.Position = UDim2.new(0, TextOffset, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = isFirstTab and TEXT_SELECTED or TEXT_COLOR
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TabButton

    -- =====================================
    -- 2. حاوية العناصر (في ElementsMenu اليمين)
    -- =====================================
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = Name .. "_Container"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Visible = isFirstTab -- تظهر فقط إذا كانت الأولى
    TabContainer.ClipsDescendants = true
    TabContainer.Parent = Window.ElementsMenu -- هذا هو المكان اللي ستحط فيه أزرارك

    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = TabContainer

    -- =====================================
    -- 3. منطق الأنيميشن والتبديل (Logic)
    -- =====================================
    TabButton.MouseButton1Click:Connect(function()
        if TabContainer.Visible then return end -- إذا هي مفتوحة أصلاً، لا تسوي شيء
        
        -- إخفاء كل الحاويات وإرجاع شكل الأزرار الثانية لوضعها الطبيعي
        for _, child in ipairs(Window.ElementsMenu:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.Visible = false end
        end
        
        for _, btn in ipairs(Window.TabsMenu:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = TAB_BG}):Play()
                TweenService:Create(btn:FindFirstChild("UIStroke"), TweenInfo.new(0.25), {Transparency = 1}):Play()
                
                local txt = btn:FindFirstChildOfClass("TextLabel")
                if txt then TweenService:Create(txt, TweenInfo.new(0.25), {TextColor3 = TEXT_COLOR}):Play() end
                
                local icon = btn:FindFirstChildOfClass("ImageLabel")
                if icon then TweenService:Create(icon, TweenInfo.new(0.25), {ImageColor3 = TEXT_COLOR}):Play() end
            end
        end

        -- إظهار الحاوية الجديدة وتشغيل أنيميشن التفعيل
        TabContainer.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundColor3 = TAB_SELECTED_BG}):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextColor3 = TEXT_SELECTED}):Play()
        
        local currentIcon = TabButton:FindFirstChildOfClass("ImageLabel")
        if currentIcon then TweenService:Create(currentIcon, TweenInfo.new(0.3), {ImageColor3 = THEME_ORANGE}):Play() end
    end)
    
    -- أنيميشن عند وضع الماوس على الزر
    TabButton.MouseEnter:Connect(function()
        if not TabContainer.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = TAB_HOVER_BG}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabContainer.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = TAB_BG}):Play()
        end
    end)

    -- نرجع "TabContainer" عشان إذا صنعت زر، ينحط داخلها
    return TabContainer 
end

return TabModule

