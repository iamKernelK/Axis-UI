local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local ELEMENT_BG = Color3.fromRGB(20, 15, 12)
local ELEMENT_HOVER = Color3.fromRGB(30, 25, 22)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)
local TEXT_DARK = Color3.fromRGB(150, 150, 150)

return {
    Create = function(Container, Config)
        local DName = Config.Name or "Dropdown"
        local OptionsList = Config.Options or {}
        local Callback = Config.Callback or function() end
        
        local CurrentSelection = nil -- يحفظ خياراً واحداً فقط
        local IsOpen = false

        -- 1. الزر الأساسي (الموجود في القائمة)
        local DropdownFrame = Instance.new("TextButton")
        DropdownFrame.Name = DName .. "_Dropdown"
        DropdownFrame.Size = UDim2.new(1, -24, 0, 42)
        DropdownFrame.BackgroundColor3 = ELEMENT_BG
        DropdownFrame.AutoButtonColor = false
        DropdownFrame.Text = ""
        DropdownFrame.Parent = Container

        Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 5)

        local Stroke = Instance.new("UIStroke", DropdownFrame)
        Stroke.Color = THEME_ORANGE
        Stroke.Thickness = 1
        Stroke.Transparency = 0.8
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- العنوان على اليسار
        local Title = Instance.new("TextLabel", DropdownFrame)
        Title.Size = UDim2.new(0.5, 0, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = DName
        Title.TextColor3 = TEXT_COLOR
        Title.Font = Enum.Font.GothamSemibold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left

        -- القيمة المحددة على اليمين
        local ValueText = Instance.new("TextLabel", DropdownFrame)
        ValueText.Size = UDim2.new(0.5, -35, 1, 0)
        ValueText.Position = UDim2.new(0.5, 0, 0, 0)
        ValueText.BackgroundTransparency = 1
        ValueText.Text = "..."
        ValueText.TextColor3 = TEXT_DARK
        ValueText.Font = Enum.Font.GothamMedium
        ValueText.TextSize = 13
        ValueText.TextXAlignment = Enum.TextXAlignment.Right

        -- أيقونة السهم
        local Arrow = Instance.new("ImageLabel", DropdownFrame)
        Arrow.Size = UDim2.new(0, 14, 0, 14)
        Arrow.Position = UDim2.new(1, -15, 0.5, 0)
        Arrow.AnchorPoint = Vector2.new(1, 0.5)
        Arrow.BackgroundTransparency = 1
        Arrow.Image = "rbxassetid://6031090990"
        Arrow.ImageColor3 = TEXT_DARK

        -- 2. إعداد القائمة العائمة (Floating List)
        -- نضعها في الـ ScreenGui لكي تطفو فوق كل شيء ولا تدفع الأزرار
        local ScreenGui = Container:FindFirstAncestorOfClass("ScreenGui")
        
        local FloatingFrame = Instance.new("Frame")
        FloatingFrame.Size = UDim2.new(0, 0, 0, 0) -- سيتم تحديث الحجم
        FloatingFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 10)
        FloatingFrame.ZIndex = 100 -- لضمان ظهورها فوق كل شيء
        FloatingFrame.ClipsDescendants = true
        FloatingFrame.Visible = false
        FloatingFrame.Parent = ScreenGui

        Instance.new("UICorner", FloatingFrame).CornerRadius = UDim.new(0, 5)
        local FloatStroke = Instance.new("UIStroke", FloatingFrame)
        FloatStroke.Color = THEME_ORANGE
        FloatStroke.Transparency = 0.5

        local Scroll = Instance.new("ScrollingFrame", FloatingFrame)
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 3
        Scroll.ScrollBarImageColor3 = THEME_ORANGE
        Scroll.ZIndex = 101

        local ListLayout = Instance.new("UIListLayout", Scroll)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Padding = UDim.new(0, 2)

        -- 3. إنشاء الخيارات داخل القائمة العائمة
        local OptionButtons = {}

        for i, option in ipairs(OptionsList) do
            local OptBtn = Instance.new("TextButton", Scroll)
            OptBtn.Size = UDim2.new(1, 0, 0, 30)
            OptBtn.BackgroundTransparency = 1
            OptBtn.Text = "  " .. option
            OptBtn.TextColor3 = TEXT_COLOR
            OptBtn.Font = Enum.Font.GothamMedium
            OptBtn.TextSize = 13
            OptBtn.TextXAlignment = Enum.TextXAlignment.Left
            OptBtn.ZIndex = 102
            
            table.insert(OptionButtons, {Btn = OptBtn, Text = option})

            -- تأثير عند تمرير الماوس (Hover)
            OptBtn.MouseEnter:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, BackgroundColor3 = ELEMENT_HOVER}):Play()
            end)
            OptBtn.MouseLeave:Connect(function()
                TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end)

            -- منطق الاختيار (التبديل التلقائي)
            OptBtn.MouseButton1Click:Connect(function()
                CurrentSelection = option
                ValueText.Text = option
                ValueText.TextColor3 = THEME_ORANGE

                -- تحديث ألوان الأزرار لإظهار المحدد بشكل خفيف (مثل الفيديو)
                for _, data in ipairs(OptionButtons) do
                    if data.Text == option then
                        data.Btn.TextColor3 = THEME_ORANGE
                    else
                        data.Btn.TextColor3 = TEXT_COLOR
                    end
                end

                -- إغلاق القائمة بعد الاختيار
                IsOpen = false
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                FloatingFrame.Visible = false
                
                -- إرسال القيمة للسكربت
                Callback({CurrentSelection})
            end)
        end

        -- حساب ارتفاع القائمة بناءً على عدد العناصر (بحد أقصى يعادل 5 عناصر لتفعيل السكرول)
        local ItemCount = math.clamp(#OptionsList, 1, 6)
        local MaxHeight = ItemCount * 32

        -- دالة لتحديث موقع القائمة العائمة لتكون دائماً تحت الزر
        local function UpdateFloatingPosition()
            local absPos = DropdownFrame.AbsolutePosition
            local absSize = DropdownFrame.AbsoluteSize
            -- وضع القائمة أسفل الزر بـ 4 بكسل
            FloatingFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
            FloatingFrame.Size = UDim2.new(0, absSize.X, 0, MaxHeight)
            Scroll.CanvasSize = UDim2.new(0, 0, 0, #OptionsList * 32)
        end

        -- 4. منطق الفتح والإغلاق
        DropdownFrame.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            if IsOpen then
                UpdateFloatingPosition()
                FloatingFrame.Visible = true
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 180}):Play()
            else
                FloatingFrame.Visible = false
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end
        end)

        -- إغلاق القائمة إذا ضغط اللاعب خارجها
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if IsOpen then
                    local mousePos = UserInputService:GetMouseLocation()
                    -- التحقق مما إذا كانت الضغطة خارج زر القائمة وخارج القائمة نفسها
                    local btnPos = DropdownFrame.AbsolutePosition
                    local floatPos = FloatingFrame.AbsolutePosition
                    
                    local inBtnX = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + DropdownFrame.AbsoluteSize.X
                    local inBtnY = (mousePos.Y - 36) >= btnPos.Y and (mousePos.Y - 36) <= btnPos.Y + DropdownFrame.AbsoluteSize.Y
                    
                    local inFloatX = mousePos.X >= floatPos.X and mousePos.X <= floatPos.X + FloatingFrame.AbsoluteSize.X
                    local inFloatY = (mousePos.Y - 36) >= floatPos.Y and (mousePos.Y - 36) <= floatPos.Y + FloatingFrame.AbsoluteSize.Y

                    if not (inBtnX and inBtnY) and not (inFloatX and inFloatY) then
                        IsOpen = false
                        FloatingFrame.Visible = false
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    end
                end
            end
        end)

        -- إغلاق القائمة عند عمل Scroll في التاب الأساسي لتجنب تحركها بشكل خاطئ
        Container.Changed:Connect(function(prop)
            if prop == "CanvasPosition" and IsOpen then
                IsOpen = false
                FloatingFrame.Visible = false
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
            end
        end)

        return DropdownFrame
    end
}
