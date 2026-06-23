local TabSection = {}
local TweenService = game:GetService("TweenService")

function TabSection.Create(Parent, Options)
    local Name = Options.Name or "Section"
    local IsOpen = Options.Default or false
    local BaseHeight = 35 
    local ARROW_ICON = "rbxassetid://10137265036" -- أيقونة سهم عصرية متوافقة مع الفيديو
    
    -- 1. الحاوية الأساسية (شفافة تماماً، دورها فقط ترتيب الهيدر والأزرار تحته)
    local MainContainer = Instance.new("Frame", Parent)
    MainContainer.Name = Name .. "_Section"
    MainContainer.Size = UDim2.new(1, 0, 0, 0)
    MainContainer.BackgroundTransparency = 1
    MainContainer.AutomaticSize = Enum.AutomaticSize.Y
    
    local MainLayout = Instance.new("UIListLayout", MainContainer)
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Padding = UDim.new(0, 4) -- المسافة بين الهيدر والأزرار التي ستظهر

    -- 2. زر الهيدر (المكان الذي تضغط عليه)
    local HeaderBtn = Instance.new("TextButton", MainContainer)
    HeaderBtn.Size = UDim2.new(1, -10, 0, BaseHeight)
    HeaderBtn.Position = UDim2.new(0, 5, 0, 0)
    HeaderBtn.BackgroundColor3 = Color3.fromRGB(22, 20, 20) -- لون أنيق مطابق لستايل القائمة
    HeaderBtn.AutoButtonColor = false -- أوقفنا اللون الافتراضي لنصنع تأثير التموج الخاص بنا
    HeaderBtn.Text = ""
    HeaderBtn.ClipsDescendants = true -- 🌟 السر لكي لا تخرج الدائرة (التموج) خارج الزر
    Instance.new("UICorner", HeaderBtn).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", HeaderBtn)
    Stroke.Color = Color3.fromRGB(45, 40, 40)
    Stroke.Thickness = 1

    local Title = Instance.new("TextLabel", HeaderBtn)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(240, 240, 240)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Arrow = Instance.new("ImageLabel", HeaderBtn)
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -25, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = ARROW_ICON
    Arrow.ImageColor3 = Color3.fromRGB(180, 180, 180)
    Arrow.Rotation = IsOpen and 180 or -90 -- حركة سهم احترافية (من اليمين للأسفل)

    -- 3. حاوية الأزرار الوهمية (لا يوجد لها Gui مرئي، مجرد مكان لتجميع الأزرار)
    local ContentContainer = Instance.new("Frame", MainContainer)
    ContentContainer.Size = UDim2.new(1, -10, 0, 0)
    ContentContainer.Position = UDim2.new(0, 5, 0, 0)
    ContentContainer.BackgroundTransparency = 1 -- مخفية تماماً!
    ContentContainer.AutomaticSize = Enum.AutomaticSize.Y
    ContentContainer.Visible = IsOpen
    
    local ContentLayout = Instance.new("UIListLayout", ContentContainer)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 4)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ==========================================
    -- 🌟 تأثير التموج (Ripple Effect) عند الضغط
    -- ==========================================
    HeaderBtn.MouseButton1Down:Connect(function()
        -- جلب مكان الماوس بدقة داخل الزر
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local X = Mouse.X - HeaderBtn.AbsolutePosition.X
        local Y = Mouse.Y - HeaderBtn.AbsolutePosition.Y
        
        -- إنشاء الدائرة
        local Ripple = Instance.new("Frame", HeaderBtn)
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- لون الدائرة (أبيض شفاف لستايل نظيف)
        Ripple.BackgroundTransparency = 0.7
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Ripple.Size = UDim2.new(0, 0, 0, 0)
        Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)
        
        -- حساب أقصى حجم تحتاجه الدائرة لتغطي الزر بالكامل
        local targetSize = math.max(HeaderBtn.AbsoluteSize.X, HeaderBtn.AbsoluteSize.Y) * 2.5
        
        -- تشغيل أنيميشن التموج والاختفاء
        local Tween = TweenService:Create(Ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        })
        Tween:Play()
        
        -- حذف الدائرة بعد انتهاء الأنيميشن لتنظيف اللعبة
        task.delay(0.45, function()
            Ripple:Destroy()
        end)
    end)

    -- ==========================================
    -- 🔄 تفاعل الفتح والإغلاق (دوران السهم وإظهار الأزرار)
    -- ==========================================
    HeaderBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        ContentContainer.Visible = IsOpen
        
        -- دوران السهم بسلاسة
        TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Rotation = IsOpen and 180 or -90
        }):Play()
    end)

    return ContentContainer
end

return TabSection
