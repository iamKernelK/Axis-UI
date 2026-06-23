local TabSection = {}
local TweenService = game:GetService("TweenService")

function TabSection.Create(Parent, Options)
    local Name = Options.Name or "Section"
    local Type = Options.Type or "Element" -- "Element" أو "Tab"
    local IsOpen = Options.Default or false 
    
    local ARROW_ICON = "rbxassetid://134243273101015"
    local BaseHeight = 35 
    
    -- 1. الحاوية الأساسية
    local MainFrame = Instance.new("Frame", Parent)
    MainFrame.Size = UDim2.new(1, (Type == "Tab" and -10 or 0), 0, BaseHeight)
    MainFrame.ClipsDescendants = true 
    
    if Type == "Element" then
        MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
        MainFrame.BackgroundTransparency = 0
        Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
    else
        MainFrame.BackgroundTransparency = 1 
    end

    -- 2. زر الهيدر
    local HeaderBtn = Instance.new("TextButton", MainFrame)
    HeaderBtn.Size = UDim2.new(1, 0, 0, BaseHeight)
    HeaderBtn.BackgroundTransparency = 1
    HeaderBtn.Text = "" 

    local Title = Instance.new("TextLabel", HeaderBtn)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, (Type == "Tab" and 5 or 10), 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- 3. أيقونة السهم
    local Arrow = Instance.new("ImageLabel", HeaderBtn)
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -25, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = ARROW_ICON
    Arrow.ImageColor3 = Color3.fromRGB(150, 150, 150)
    Arrow.Rotation = IsOpen and 180 or 0 

    -- 4. حاوية المحتوى
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, 0, 1, -BaseHeight)
    ContentContainer.Position = UDim2.new(0, 0, 0, BaseHeight)
    ContentContainer.BackgroundTransparency = 1

    local ListLayout = Instance.new("UIListLayout", ContentContainer)
    ListLayout.Padding = UDim.new(0, 5)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    if Type == "Element" then
        ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    end

    -- 🌟 [هذا هو الحل السحري اللي يمنع الأزرار من الاختراق ويشيل السواد]
    local Padding = Instance.new("UIPadding", ContentContainer)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)
    if Type == "Tab" then
        Padding.PaddingLeft = UDim.new(0, 15)
    end

    -- 5. نظام الأنيميشن الأصلي (نزول سلس وبدون أخطاء)
    local function UpdateSize()
        local TargetHeight = BaseHeight
        if IsOpen then
            -- حساب الطول: الزر + الأزرار الداخلية + مسافة البادينغ العلوية والسفلية (16)
            TargetHeight = BaseHeight + ListLayout.AbsoluteContentSize.Y + 16
        end

        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, (Type == "Tab" and -10 or 0), 0, TargetHeight)
        }):Play()

        TweenService:Create(Arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Rotation = IsOpen and 180 or 0
        }):Play()
        
        -- إضاءة خفيفة للنص عند الفتح (أبيض نقي بدل السمائي)
        TweenService:Create(Title, TweenInfo.new(0.2), {
            TextColor3 = IsOpen and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(220, 220, 220)
        }):Play()
    end

    HeaderBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        UpdateSize()
    end)

    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if IsOpen then
            UpdateSize()
        end
    end)
    
    -- لضمان تحديث الحجم فوراً لو كانت الخانة Default = true
    if IsOpen then UpdateSize() end

    return ContentContainer 
end

return TabSection
