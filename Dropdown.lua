local TweenService = game:GetService("TweenService")

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local ELEMENT_BG = Color3.fromRGB(20, 15, 12)
local ELEMENT_HOVER = Color3.fromRGB(28, 18, 11)
local ITEM_BG = Color3.fromRGB(25, 20, 18)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)

return {
    Create = function(Container, Config)
        local DName = Config.Name or "Dropdown"
        local OptionsList = Config.Options or {}
        local MaxSelect = Config.Max or #OptionsList -- الحد الأقصى للاختيارات
        local Callback = Config.Callback or function() end
        
        local Selected = {} -- جدول لحفظ الخيارات المحددة
        local IsOpen = false
        local ItemHeight = 30
        local ClosedHeight = 42
        local OpenHeight = ClosedHeight + (#OptionsList * ItemHeight) + 10 -- حساب الارتفاع عند الفتح

        -- 1. الحاوية الأساسية (تتوسع وتنكمش)
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = DName .. "_Dropdown"
        DropdownFrame.Size = UDim2.new(1, -24, 0, ClosedHeight)
        DropdownFrame.BackgroundColor3 = ELEMENT_BG
        DropdownFrame.ClipsDescendants = true -- مهم جداً لإخفاء العناصر عند الإغلاق
        DropdownFrame.Parent = Container

        Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)

        local Stroke = Instance.new("UIStroke", DropdownFrame)
        Stroke.Color = THEME_ORANGE
        Stroke.Thickness = 1
        Stroke.Transparency = 0.8
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- 2. الرأس (Header) - الجزء الذي يظهر دائماً
        local HeaderBtn = Instance.new("TextButton")
        HeaderBtn.Size = UDim2.new(1, 0, 0, ClosedHeight)
        HeaderBtn.BackgroundTransparency = 1
        HeaderBtn.Text = ""
        HeaderBtn.Parent = DropdownFrame

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0.5, 0, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = DName
        Title.TextColor3 = TEXT_COLOR
        Title.Font = Enum.Font.GothamSemibold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = HeaderBtn

        -- نص يوضح الخيارات المحددة
        local ValueText = Instance.new("TextLabel")
        ValueText.Size = UDim2.new(0.5, -40, 1, 0)
        ValueText.Position = UDim2.new(0.5, 5, 0, 0)
        ValueText.BackgroundTransparency = 1
        ValueText.Text = "None"
        ValueText.TextColor3 = THEME_ORANGE
        ValueText.Font = Enum.Font.GothamMedium
        ValueText.TextSize = 12
        ValueText.TextXAlignment = Enum.TextXAlignment.Right
        ValueText.ClipsDescendants = true
        ValueText.Parent = HeaderBtn

        -- أيقونة السهم (تدور عند الفتح)
        local Arrow = Instance.new("ImageLabel")
        Arrow.Size = UDim2.new(0, 16, 0, 16)
        Arrow.Position = UDim2.new(1, -25, 0.5, 0)
        Arrow.AnchorPoint = Vector2.new(0, 0.5)
        Arrow.BackgroundTransparency = 1
        Arrow.Image = "rbxassetid://6031090990" -- أيقونة سهم
        Arrow.ImageColor3 = THEME_ORANGE
        Arrow.Parent = HeaderBtn

        -- 3. حاوية العناصر المنسدلة
        local ItemsContainer = Instance.new("Frame")
        ItemsContainer.Size = UDim2.new(1, -20, 1, -ClosedHeight - 10)
        ItemsContainer.Position = UDim2.new(0, 10, 0, ClosedHeight + 5)
        ItemsContainer.BackgroundTransparency = 1
        ItemsContainer.Parent = DropdownFrame

        local ListLayout = Instance.new("UIListLayout", ItemsContainer)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 4)

        -- دالة لتحديث النص في الرأس (Header)
        local function UpdateValueText()
            if #Selected == 0 then
                ValueText.Text = "None"
            elseif #Selected == #OptionsList then
                ValueText.Text = "All"
            else
                ValueText.Text = table.concat(Selected, ", ")
            end
        end

        -- 4. إنشاء الخيارات
        for i, option in ipairs(OptionsList) do
            local ItemBtn = Instance.new("TextButton")
            ItemBtn.Size = UDim2.new(1, 0, 0, ItemHeight)
            ItemBtn.BackgroundColor3 = ITEM_BG
            ItemBtn.Text = ""
            ItemBtn.Parent = ItemsContainer
            Instance.new("UICorner", ItemBtn).CornerRadius = UDim.new(0, 5)

            local ItemText = Instance.new("TextLabel")
            ItemText.Size = UDim2.new(1, -30, 1, 0)
            ItemText.Position = UDim2.new(0, 10, 0, 0)
            ItemText.BackgroundTransparency = 1
            ItemText.Text = option
            ItemText.TextColor3 = TEXT_COLOR
            ItemText.Font = Enum.Font.GothamMedium
            ItemText.TextSize = 13
            ItemText.TextXAlignment = Enum.TextXAlignment.Left
            ItemText.Parent = ItemBtn

            -- العلامة (Indicator) تظهر عند التحديد
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 4, 0, 16)
            Indicator.Position = UDim2.new(1, -10, 0.5, 0)
            Indicator.AnchorPoint = Vector2.new(1, 0.5)
            Indicator.BackgroundColor3 = THEME_ORANGE
            Indicator.BackgroundTransparency = 1 -- مخفي في البداية
            Indicator.Parent = ItemBtn
            Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

            local isSelected = false

            ItemBtn.MouseButton1Click:Connect(function()
                if isSelected then
                    -- إزالة التحديد
                    isSelected = false
                    for idx, val in ipairs(Selected) do
                        if val == option then table.remove(Selected, idx) break end
                    end
                    TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(ItemText, TweenInfo.new(0.2), {TextColor3 = TEXT_COLOR}):Play()
                else
                    -- إضافة التحديد (مع التحقق من الحد الأقصى)
                    if #Selected < MaxSelect then
                        isSelected = true
                        table.insert(Selected, option)
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                        TweenService:Create(ItemText, TweenInfo.new(0.2), {TextColor3 = THEME_ORANGE}):Play()
                    end
                end
                UpdateValueText()
                Callback(Selected)
            end)
        end

        -- تفاعل الفتح والإغلاق
        HeaderBtn.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            local targetHeight = IsOpen and OpenHeight or ClosedHeight
            local targetRot = IsOpen and 180 or 0

            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, -24, 0, targetHeight)}):Play()
            TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = targetRot}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = IsOpen and 0.2 or 0.8}):Play()
        end)

        return DropdownFrame
    end
}
