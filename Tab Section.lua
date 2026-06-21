local TabSection = {}
local TweenService = game:GetService("TweenService")

function TabSection.Create(Parent, Options)
    local Name = Options.Name or "Section"
    local Type = Options.Type or "Element" -- "Element" أو "Tab"
    local IsOpen = Options.Default or false -- هل هي مفتوحة افتراضياً؟
    
    local ARROW_ICON = "rbxassetid://134243273101015"
    local BaseHeight = 35 -- ارتفاع الزر الأساسي
    
    -- 1. الحاوية الأساسية (التي تكبر وتصغر)
    local MainFrame = Instance.new("Frame", Parent)
    MainFrame.Size = UDim2.new(1, (Type == "Tab" and -10 or 0), 0, BaseHeight)
    MainFrame.ClipsDescendants = true -- السر في إخفاء العناصر عند الإغلاق
    
    -- التفرقة في الشكل بناءً على المكان
    if Type == "Element" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- لون خلفية زر العناصر
        MainFrame.BackgroundTransparency = 0
        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    else
        MainFrame.BackgroundTransparency = 1 -- شفاف في قائمة التبويبات الجانبية
    end

    -- 2. زر التحكم (الهيدر)
    local HeaderBtn = Instance.new("TextButton", MainFrame)
    HeaderBtn.Size = UDim2.new(1, 0, 0, BaseHeight)
    HeaderBtn.BackgroundTransparency = 1
    HeaderBtn.Text = "" -- سنستخدم TextLabel منفصل لترتيب أفضل

    local Title = Instance.new("TextLabel", HeaderBtn)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, (Type == "Tab" and 5 or 10), 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- 3. أيقونة السهم (التي تدور)
    local Arrow = Instance.new("ImageLabel", HeaderBtn)
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -25, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = ARROW_ICON
    Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.Rotation = IsOpen and 180 or 0 -- 0 لأسفل، 180 لأعلى

    -- 4. حاوية المحتوى (التي سنضع فيها الأزرار والسلايدرات)
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, 0, 1, -BaseHeight)
    ContentContainer.Position = UDim2.new(0, 0, 0, BaseHeight)
    ContentContainer.BackgroundTransparency = 1

    local ListLayout = Instance.new("UIListLayout", ContentContainer)
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    if Type == "Element" then
        ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    else
        -- إذا كان في التبويبات، نعطيه مسافة من اليمين لتبدو كقائمة فرعية (Sub-menu)
        Instance.new("UIPadding", ContentContainer).PaddingLeft = UDim.new(0, 15)
    end

    -- 5. نظام الأنيميشن الديناميكي
    local function UpdateSize()
        -- حساب الطول المطلوب (طول الهيدر + طول العناصر + مسافة بادئة)
        local TargetHeight = BaseHeight
        if IsOpen then
            TargetHeight = BaseHeight + ListLayout.AbsoluteContentSize.Y + 10
        end

        -- أنيميشن الحاوية (تطول وتقصر)
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, (Type == "Tab" and -10 or 0), 0, TargetHeight)
        }):Play()

        -- أنيميشن دوران السهم (180 درجة)
        TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Rotation = IsOpen and 180 or 0
        }):Play()
        
        -- تغيير لون النص للجمالية
        TweenService:Create(Title, TweenInfo.new(0.2), {
            TextColor3 = IsOpen and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(220, 220, 220)
        }):Play()
    end

    -- تشغيل الفتح والإغلاق عند الضغط
    HeaderBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        UpdateSize()
    end)

    -- تحديث الحجم تلقائياً إذا أضفت عناصر جديدة والخانة مفتوحة
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if IsOpen then
            UpdateSize()
        end
    end)

    return ContentContainer -- نعيد هذه الحاوية لكي نضع العناصر بداخلها!
end

return TabSection

