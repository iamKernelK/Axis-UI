local TweenService = game:GetService("TweenService")
local SectionModule = {}

-- ==========================================
-- 🎨 ألوان هادئة واحترافية (بدون نيون أو بهرجة)
-- ==========================================
local THEME = {
    ContainerBg    = Color3.fromRGB(25, 25, 25), -- خلفية السيكشن وهو مفتوح
    HeaderBg       = Color3.fromRGB(30, 30, 30), -- خلفية الزر
    HeaderHover    = Color3.fromRGB(38, 38, 38), -- لون الزر عند مرور الماوس
    Text           = Color3.fromRGB(240, 240, 240), -- أبيض هادئ
    Icon           = Color3.fromRGB(170, 170, 170)  -- رمادي فاتح للسهم
}

function SectionModule.Create(ParentFrame, SectionName)
    local isExpanded = false
    local headerHeight = 32 -- حجم أنحف وأكثر احترافية
    
    -- 1. الحاوية الرئيسية
    local Container = Instance.new("Frame")
    Container.Name = SectionName .. "_Section"
    Container.Size = UDim2.new(1, 0, 0, headerHeight)
    Container.BackgroundColor3 = THEME.ContainerBg
    Container.ClipsDescendants = true 
    Container.Parent = ParentFrame
    
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 5)

    -- 2. زر الهيدر
    local HeaderBtn = Instance.new("TextButton")
    HeaderBtn.Size = UDim2.new(1, 0, 0, headerHeight)
    HeaderBtn.BackgroundColor3 = THEME.HeaderBg
    HeaderBtn.AutoButtonColor = false
    HeaderBtn.Text = ""
    HeaderBtn.Parent = Container
    
    Instance.new("UICorner", HeaderBtn).CornerRadius = UDim.new(0, 5)

    -- 3. نص السيكشن
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = SectionName
    Title.TextColor3 = THEME.Text
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = HeaderBtn

    -- 4. السهم (أيقونة نظيفة وبسيطة)
    local Arrow = Instance.new("ImageLabel")
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -24, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = "rbxassetid://10392248278" -- أيقونة سهم أنيقة
    Arrow.ImageColor3 = THEME.Icon
    Arrow.Rotation = 0 
    Arrow.Parent = HeaderBtn

    -- 5. حاوية العناصر المخفية
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    ContentFrame.Position = UDim2.new(0, 0, 0, headerHeight) 
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = Container
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 4) -- مسافة صغيرة بين الأزرار
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.Parent = ContentFrame

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 6)
    UIPadding.PaddingBottom = UDim.new(0, 6)
    UIPadding.Parent = ContentFrame
    
    -- ==========================================
    -- ⚡ تفاعلات سريعة جداً (Snappy Animations)
    -- ==========================================
    
    HeaderBtn.MouseEnter:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.HeaderHover}):Play()
    end)
    
    HeaderBtn.MouseLeave:Connect(function()
        TweenService:Create(HeaderBtn, TweenInfo.new(0.15), {BackgroundColor3 = THEME.HeaderBg}):Play()
    end)
    
    HeaderBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        
        -- سهم سريع (0.2 ثانية)
        TweenService:Create(Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = isExpanded and 90 or 0
        }):Play()
        
        local targetHeight = isExpanded and (headerHeight + UIListLayout.AbsoluteContentSize.Y + 12) or headerHeight
        
        -- فتح/إغلاق سريع وسلس بدون ارتداد بطيء (0.25 ثانية)
        TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetHeight)
        }):Play()
    end)
    
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if isExpanded then
            Container.Size = UDim2.new(1, 0, 0, headerHeight + UIListLayout.AbsoluteContentSize.Y + 12)
        end
    end)
    
    return ContentFrame
end

return SectionModule
