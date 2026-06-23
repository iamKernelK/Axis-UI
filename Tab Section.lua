local TabSection = {}
local TweenService = game:GetService("TweenService")

function TabSection.Create(Parent, Options)
    local Name = Options.Name or "Section"
    local IsOpen = Options.Default or false
    local BaseHeight = 35 -- ارتفاع الزر وهو مغلق
    local ARROW_ICON = "rbxassetid://134243273101015"
    
    -- 1. الحاوية الأساسية (تصميم داكن مع شفافية زجاجية)
    local MainFrame = Instance.new("Frame", Parent)
    MainFrame.Size = UDim2.new(1, -10, 0, BaseHeight)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- لون أسود عميق جداً
    MainFrame.BackgroundTransparency = 0.2 -- شفافية أنيقة (Glassmorphism)
    MainFrame.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", MainFrame)
    Corner.CornerRadius = UDim.new(0, 6)
    
    -- إضافة إطار (Stroke) يضيء عند الفتح
    local Stroke = Instance.new("UIStroke", MainFrame)
    Stroke.Color = Color3.fromRGB(40, 40, 40)
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- 2. زر الهيدر (Header)
    local HeaderBtn = Instance.new("TextButton", MainFrame)
    HeaderBtn.Size = UDim2.new(1, 0, 0, BaseHeight)
    HeaderBtn.BackgroundTransparency = 1
    HeaderBtn.Text = ""

    local Title = Instance.new("TextLabel", HeaderBtn)
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = Name
    -- النص أبيض، ويتحول إلى سماوي نيون عند الفتح
    Title.TextColor3 = IsOpen and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Arrow = Instance.new("ImageLabel", HeaderBtn)
    Arrow.Size = UDim2.new(0, 14, 0, 14)
    Arrow.Position = UDim2.new(1, -25, 0.5, -7)
    Arrow.BackgroundTransparency = 1
    Arrow.Image = ARROW_ICON
    Arrow.ImageColor3 = IsOpen and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(150, 150, 150)
    Arrow.Rotation = IsOpen and 180 or 0

    -- 3. حاوية العناصر (هنا تم حل مشكلة الاختراق)
    local ContentContainer = Instance.new("Frame", MainFrame)
    ContentContainer.Size = UDim2.new(1, 0, 1, -BaseHeight)
    ContentContainer.Position = UDim2.new(0, 0, 0, BaseHeight)
    ContentContainer.BackgroundTransparency = 1

    local ListLayout = Instance.new("UIListLayout", ContentContainer)
    ListLayout.Padding = UDim.new(0, 6)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- السر الذي يمنع العناصر من لمس الحواف واختراق القائمة
    local Padding = Instance.new("UIPadding", ContentContainer)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)

    -- 4. نظام الأنيميشن الديناميكي والمطور
    local function UpdateSize()
        local TargetHeight = BaseHeight
        if IsOpen then
            -- حساب دقيق: ارتفاع الهيدر + ارتفاع كل العناصر + المسافات العلوية والسفلية (8+8=16)
            TargetHeight = BaseHeight + ListLayout.AbsoluteContentSize.Y + 16
        end

        -- أنيميشن فتح الحاوية (أنعم وأكثر انسيابية)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -10, 0, TargetHeight)
        }):Play()

        -- أنيميشن السهم وتغير لونه
        TweenService:Create(Arrow, TweenInfo.new(0.3), {
            Rotation = IsOpen and 180 or 0,
            ImageColor3 = IsOpen and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(150, 150, 150)
        }):Play()
        
        -- إضاءة النص بلون النيون
        TweenService:Create(Title, TweenInfo.new(0.3), {
            TextColor3 = IsOpen and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 255, 255)
        }):Play()

        -- إضاءة خفيفة لإطار الخانة (Stroke)
        TweenService:Create(Stroke, TweenInfo.new(0.3), {
            Color = IsOpen and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(40, 40, 40)
        }):Play()
    end

    -- 5. التفاعل والتحديث
    HeaderBtn.MouseButton1Click:Connect(function()
        IsOpen = not IsOpen
        UpdateSize()
    end)

    -- تحديث فوري إذا تم إضافة عنصر جديد والخلفية مفتوحة (لمنع تشوه الشكل)
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if IsOpen then
            MainFrame.Size = UDim2.new(1, -10, 0, BaseHeight + ListLayout.AbsoluteContentSize.Y + 16)
        end
    end)

    return ContentContainer
end

return TabSection
