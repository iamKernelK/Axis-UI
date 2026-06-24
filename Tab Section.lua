local TweenService = game:GetService("TweenService")

local SectionModule = {}

-- ألوان AxisUI
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local HEADER_BG = Color3.fromRGB(20, 15, 12)
local HEADER_HOVER_BG = Color3.fromRGB(28, 18, 11)

function SectionModule.Create(ParentFrame, SectionName)
    local isExpanded = false
    local headerHeight = 40
    
    -- 1. الحاوية الرئيسية للسيكشن (تتمدد وتتقلص)
    local SectionContainer = Instance.new("Frame")
    SectionContainer.Name = SectionName .. "_Section"
    SectionContainer.Size = UDim2.new(1, 0, 0, headerHeight)
    SectionContainer.BackgroundTransparency = 1
    SectionContainer.ClipsDescendants = true -- ضروري جداً لإخفاء العناصر عند الإغلاق
    SectionContainer.Parent = ParentFrame
    
    -- 2. زر الهيدر (الرأس اللي تضغط عليه)
    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Size = UDim2.new(1, 0, 0, headerHeight)
    HeaderBtn.BackgroundColor3 = HEADER_BG
    HeaderBtn.AutoButtonColor = false
    HeaderBtn.Text = ""
    HeaderBtn.ZIndex = 2
    HeaderBtn.Parent = SectionContainer
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = HeaderBtn
    
    local HeaderStroke = Instance.new("UIStroke")
    HeaderStroke.Color = THEME_ORANGE
    HeaderStroke.Thickness = 1
    HeaderStroke.Transparency = 0.7
    HeaderStroke.Parent = HeaderBtn

    -- 3. نص السيكشن
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = SectionName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    Title.Parent = HeaderBtn

    -- 4. السهم (يتجه لليمين بالوضع الطبيعي)
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 16, 0, 16)
    Arrow.Position = UDim2.new(1, -15, 0.5, 0)
    Arrow.AnchorPoint = Vector2.new(1, 0.5)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://10392248278" 
    Arrow.ImageColor3 = THEME_ORANGE
    Arrow.Rotation = 0 -- يشير لليمين
    Arrow.ZIndex = 3
    Arrow.Parent = HeaderBtn

    -- 5. حاوية العناصر (التي ستحتوي على الأزرار وغيرها)
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    ContentFrame.Position = UDim2.new(0, 0, 0, headerHeight + 5) -- تبدأ تحت الهيدر مباشرة مع مسافة بسيطة
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = SectionContainer
    
    -- منظم العناصر داخل السيكشن
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 8)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ContentFrame
    
    -- ==========================================
    -- ⚡ الأنيميشن والتفاعلات
    -- ==========================================
    
    -- تأثير الماوس
    HeaderBtn.MouseEnter:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.2), {BackgroundColor3 = HEADER_HOVER_BG}):Play()
    end)
    
    HeaderBtn.MouseLeave:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.3), {BackgroundColor3 = HEADER_BG}):Play()
    end)
    
    -- وظيفة الفتح والإغلاق
    HeaderBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        
        -- أنيميشن السهم (0 لليمين، 90 للأسفل)
        local arrowRot = isExpanded and 90 or 0
        TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = arrowRot}):Play()
        
        -- حساب الارتفاع المطلوب
        local contentHeight = UIListLayout.AbsoluteContentSize.Y
        local targetHeight = isExpanded and (headerHeight + contentHeight + 10) or headerHeight
        
        -- أنيميشن فتح/إغلاق الحاوية بسرعة وسلاسة
        TweenService:Create(SectionContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
    end)
    
    -- تحديث الارتفاع تلقائياً إذا أضفنا أزرار جديدة والسيكشن مفتوح
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isExpanded then
            local newHeight = headerHeight + UIListLayout.AbsoluteContentSize.Y + 10
            SectionContainer.Size = UDim2.new(1, 0, 0, newHeight)
        end
    end)
    
    -- إرجاع ContentFrame لكي نضع بداخله الأزرار
    return ContentFrame
end

return SectionModule
