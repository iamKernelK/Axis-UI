local TabSection = {}
local TweenService = game:GetService("TweenService")

function TabSection.Create(Parent, Options)
    local Name = Options.Name or "Section"
    -- 🔴 إجبار الخانة على أن تكون مغلقة في البداية ما لم تطلب أنت غير ذلك
    local IsOpen = Options.Default or false 
    
    local BaseHeight = 35 
    -- أيقونة سهم واضحة (سهم يمين كلاسيكي)
    local ARROW_ICON = "rbxassetid://6031090990" 
    
    -- 1. الإطار الرئيسي الذي يجمع الهيدر والأزرار (حجمه يتطابق 100% مع الباقي)
    local SectionFrame = Instance.new("Frame", Parent)
    SectionFrame.Name = Name .. "_Section"
    SectionFrame.Size = UDim2.new(1, 0, 0, BaseHeight)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local SectionLayout = Instance.new("UIListLayout", SectionFrame)
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 4) -- المسافة بين الهيدر والأزرار تحته

    -- 2. زر الهيدر (نفس الحجم بالضبط)
    local HeaderBtn = Instance.new("TextButton", SectionFrame)
    HeaderBtn.Size = UDim2.new(1, 0, 0, BaseHeight)
    HeaderBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    HeaderBtn.AutoButtonColor = false
    HeaderBtn.Text = ""
    HeaderBtn.ClipsDescendants = true -- لضمان بقاء الدائرة داخل الزر
    Instance.new("UICorner", HeaderBtn).CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke", HeaderBtn)
    Stroke.Color = Color3.fromRGB(45, 45, 45)
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
    Arrow.ImageColor3 = Color3.fromRGB(200, 200, 200)
    -- ضبط اتجاه السهم عند البداية (0 = يمين، 90 = أسفل)
    Arrow.Rotation = IsOpen and 90 or 0

    -- 3. حاوية العناصر المخفية
    local ItemsContainer = Instance.new("Frame", SectionFrame)
    ItemsContainer.Size = UDim2.new(1, 0, 0, 0)
    ItemsContainer.BackgroundTransparency = 1
    ItemsContainer.AutomaticSize = Enum.AutomaticSize.Y
    -- 🔴 إغلاق العناصر من بداية السكربت تماماً
    ItemsContainer.Visible = IsOpen
    
    local ItemsLayout = Instance.new("UIListLayout", ItemsContainer)
    ItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ItemsLayout.Padding = UDim.new(0, 4)
    ItemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ==========================================
    -- 🌟 تأثير التموج (Ripple) عند الضغط
    -- ==========================================
    HeaderBtn.MouseButton1Down:Connect(function()
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local X = Mouse.X - HeaderBtn.AbsolutePosition.X
        local Y = Mouse.Y - HeaderBtn.AbsolutePosition.Y
        
        local Ripple = Instance.new("Frame", HeaderBtn)
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 0.8
        Ripple.Position = UDim2.new(0, X, 0, Y)
        Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        Instance.new("UICorner", Ripple).CornerRadius = UDim.new(1, 0)
        
        local targetSize = math.max(HeaderBtn.AbsoluteSize.X, HeaderBtn.AbsoluteSize.Y) * 2.5
        
        TweenService:Create(Ripple, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, targetSize, 0, targetSize),
            BackgroundTransparency = 1
        }):Play()
        
        -- مسح الدائرة لتخفيف اللاج
        game.Debris:AddItem(Ripple, 0.5)
    end)

    -- ==========================================
    -- 🔄 تفاعل الفتح والإغلاق وأنيميشن السهم
    -- ==========================================
    HeaderBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        ItemsContainer.Visible = IsOpen
        
        -- أنيميشن السهم ليلف للأسفل عند الفتح ويرجع لليمين عند الإغلاق
        TweenService:Create(Arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Rotation = IsOpen and 90 or 0
        }):Play()
    end)

    return ItemsContainer
end

return TabSection
