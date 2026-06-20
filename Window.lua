local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- ثوابت الألوان (Premium Dark Orange Theme)
-- ==========================================
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_DARK = Color3.fromRGB(180, 80, 0)
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)
local DARK_GLASS_BG = Color3.fromRGB(12, 8, 5) -- أغمق وأفخم للـ Background

-- ==========================================
-- دوال المساعدة (Utility Functions)
-- ==========================================

-- دالة السحب الناعم
local function MakeDraggable(dragPart, targetPart)
    local Dragging, DragInput, DragStart, StartPosition

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = targetPart.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
            TweenService:Create(targetPart, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

-- تدرج لوني للأيقونات والنصوص
local function ApplyGradient(instance)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(0.5, THEME_ORANGE),
        ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)
    })
    grad.Rotation = 45
    grad.Parent = instance
    return grad
end

-- تأثير الوميض (البحث)
local function FlashElement(element)
    local originalBg = element.BackgroundColor3
    local flashColor = Color3.fromRGB(0, 0, 0) -- لون داكن للتمويض
    
    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(element, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = flashColor}):Play()
            task.wait(0.25)
            TweenService:Create(element, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {BackgroundColor3 = originalBg}):Play()
            task.wait(0.25)
        end
    end)
end

-- ==========================================
-- بناء الواجهة الأساسية (Main UI Construction)
-- ==========================================

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "Axis Future"
    local DescText = Options.Description or "Premium UI"
    local ThemeImage = Options.ThemeImage or "rbxassetid://103845371952278" 
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisUI_Premium"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function() self.ScreenGui.Parent = gethui() end)
    if not self.ScreenGui.Parent then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. النافذة الرئيسية
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true 
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = self.MainFrame

    -- تدرج الخلفية (تأثير التنفس)
    local MainBgGradient = Instance.new("UIGradient")
    MainBgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 4, 2)),      
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 10, 5)),   -- لمعة برتقالية داكنة في المنتصف
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 4, 2))       
    })
    MainBgGradient.Rotation = 45
    MainBgGradient.Parent = self.MainFrame

    -- أنيميشن لمعة الخلفية (PingPong)
    TweenService:Create(MainBgGradient, TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.5, 0.5)}):Play()

    -- الإطار الخارجي المضيء
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.new(1,1,1)
    Stroke.Thickness = 1
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = self.MainFrame
    local StrokeGrad = ApplyGradient(Stroke)
    TweenService:Create(StrokeGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 65)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.ZIndex = 5
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 22)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 12)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.Font = Enum.Font.GothamBlack
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar
    ApplyGradient(self.TitleLabel)

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 36)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.ZIndex = 5
    self.DescLabel.Parent = self.TopBar

    -- أزرار التحكم (مع Gradient)
    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 22, 0, 22)
        btn.Position = UDim2.new(1, posOffset, 0.5, -11)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ZIndex = 5
        btn.Parent = self.TopBar
        
        -- التدرج الافتراضي رمادي، وعند التأشير يصبح برتقالي متدرج
        local iconGrad = Instance.new("UIGradient")
        iconGrad.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180))
        iconGrad.Parent = btn

        btn.MouseEnter:Connect(function()
            iconGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
                ColorSequenceKeypoint.new(1, THEME_ORANGE)
            })
        end)
        btn.MouseLeave:Connect(function()
            iconGrad.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180))
        end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- 4. نظام البحث (مستقل واحترافي)
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(0.4, 0, 0, 36)
    self.SearchFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.SearchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    self.SearchFrame.ZIndex = 10
    self.SearchFrame.Parent = self.TopBar
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = self.SearchFrame
    
    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = THEME_ORANGE
    SearchStroke.Thickness = 1
    SearchStroke.Transparency = 0.8
    SearchStroke.Parent = self.SearchFrame

    self.SearchIcon = Instance.new("ImageLabel")
    self.SearchIcon.Size = UDim2.new(0, 18, 0, 18)
    self.SearchIcon.Position = UDim2.new(0, 12, 0.5, -9)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Image = "rbxassetid://118685771787843"
    self.SearchIcon.ImageColor3 = THEME_ORANGE
    self.SearchIcon.ZIndex = 10
    self.SearchIcon.Parent = self.SearchFrame

    self.SearchBox = Instance.new("TextBox")
    self.SearchBox.Size = UDim2.new(1, -45, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 38, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search for anything..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SearchBox.Font = Enum.Font.Gotham
    self.SearchBox.TextSize = 14
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.ZIndex = 10
    self.SearchBox.Parent = self.SearchFrame

    -- القائمة المنسدلة للبحث (Dropdown Results)
    self.SearchResults = Instance.new("ScrollingFrame")
    self.SearchResults.Size = UDim2.new(1, 0, 0, 150)
    self.SearchResults.Position = UDim2.new(0, 0, 1, 5)
    self.SearchResults.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
    self.SearchResults.BorderSizePixel = 0
    self.SearchResults.ScrollBarThickness = 2
    self.SearchResults.ScrollBarImageColor3 = THEME_ORANGE
    self.SearchResults.Visible = false
    self.SearchResults.ZIndex = 15
    self.SearchResults.Parent = self.SearchFrame

    local ResultsCorner = Instance.new("UICorner")
    ResultsCorner.CornerRadius = UDim.new(0, 6)
    ResultsCorner.Parent = self.SearchResults

    local ResultsLayout = Instance.new("UIListLayout")
    ResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ResultsLayout.Padding = UDim.new(0, 2)
    ResultsLayout.Parent = self.SearchResults

    -- 5. الحاويات الرئيسية (Tabs & Elements)
    local TopDivider = Instance.new("Frame")
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 65)
    TopDivider.BackgroundColor3 = THEME_ORANGE
    TopDivider.BackgroundTransparency = 0.5
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = self.MainFrame

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Size = UDim2.new(0, 1, 1, -65)
    SidebarDivider.Position = UDim2.new(0, 180, 0, 65)
    SidebarDivider.BackgroundColor3 = THEME_ORANGE
    SidebarDivider.BackgroundTransparency = 0.7
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = self.MainFrame

    self.TabsMenu = Instance.new("ScrollingFrame")
    self.TabsMenu.Name = "TabsMenu"
    self.TabsMenu.Size = UDim2.new(0, 180, 1, -65)
    self.TabsMenu.Position = UDim2.new(0, 0, 0, 65)
    self.TabsMenu.BackgroundTransparency = 1
    self.TabsMenu.ScrollBarThickness = 0
    self.TabsMenu.Parent = self.MainFrame
    
    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.Parent = self.TabsMenu
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 5)
    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.Parent = self.TabsMenu
    TabsPadding.PaddingTop = UDim.new(0, 15)
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)

    self.ElementsMenu = Instance.new("ScrollingFrame")
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -181, 1, -65)
    self.ElementsMenu.Position = UDim2.new(0, 181, 0, 65)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.ScrollBarThickness = 2
    self.ElementsMenu.ScrollBarImageColor3 = THEME_ORANGE
    self.ElementsMenu.Parent = self.MainFrame

    -- ==========================================
    -- منطق البحث المتقدم والوميض (Smart Search Engine)
    -- ==========================================
    self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.SearchBox.Text:lower()
        
        -- تنظيف النتائج القديمة
        for _, child in ipairs(self.SearchResults:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        if text == "" then
            self.SearchResults.Visible = false
            TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
            return
        end

        self.SearchResults.Visible = true
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        
        local foundAnything = false

        -- البحث في جميع الـ Containers (جميع الخانات حتى لو مخفية)
        for _, container in ipairs(self.ElementsMenu:GetChildren()) do
            if container:IsA("ScrollingFrame") then
                for _, element in ipairs(container:GetChildren()) do
                    -- نفترض أن اسم العنصر ينتهي بـ _Btn وأن بداخله TextLabel يحتوي الاسم
                    if element:IsA("TextButton") or element:IsA("Frame") then
                        local elementName = element.Name:gsub("_Btn", ""):lower()
                        local titleLabel = element:FindFirstChildOfClass("TextLabel")
                        if titleLabel then elementName = titleLabel.Text:lower() end

                        -- إذا وجدنا تطابق (حتى لو جزء من الكلمة)
                        if elementName:find(text) then
                            foundAnything = true
                            
                            -- إنشاء زر في القائمة المنسدلة للبحث
                            local resultBtn = Instance.new("TextButton")
                            resultBtn.Size = UDim2.new(1, 0, 0, 30)
                            resultBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 15)
                            resultBtn.BackgroundTransparency = 1
                            resultBtn.Text = "  🔍 " .. (titleLabel and titleLabel.Text or element.Name)
                            resultBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                            resultBtn.Font = Enum.Font.Gotham
                            resultBtn.TextSize = 13
                            resultBtn.TextXAlignment = Enum.TextXAlignment.Left
                            resultBtn.ZIndex = 16
                            resultBtn.Parent = self.SearchResults

                            resultBtn.MouseEnter:Connect(function() resultBtn.BackgroundTransparency = 0 end)
                            resultBtn.MouseLeave:Connect(function() resultBtn.BackgroundTransparency = 1 end)

                            -- عند الضغط على النتيجة في البحث
                            resultBtn.MouseButton1Click:Connect(function()
                                self.SearchBox.Text = ""
                                self.SearchResults.Visible = false
                                
                                -- 1. فتح الخانة (Tab) التي تحتوي على هذا الزر
                                for _, otherContainer in ipairs(self.ElementsMenu:GetChildren()) do
                                    if otherContainer:IsA("ScrollingFrame") then
                                        otherContainer.Visible = false
                                    end
                                end
                                container.Visible = true
                                
                                -- إضاءة زر الـ Tab في القائمة الجانبية (للتزامن)
                                local tabBaseName = container.Name:gsub("_Container", "")
                                for _, tabBtn in ipairs(self.TabsMenu:GetChildren()) do
                                    if tabBtn:IsA("TextButton") then
                                        if tabBtn.Name == tabBaseName .. "_TabBtn" then
                                            tabBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 10)
                                            if tabBtn:FindFirstChild("UIStroke") then tabBtn.UIStroke.Transparency = 0 end
                                        else
                                            tabBtn.BackgroundColor3 = Color3.fromRGB(20, 15, 12)
                                            if tabBtn:FindFirstChild("UIStroke") then tabBtn.UIStroke.Transparency = 1 end
                                        end
                                    end
                                end

                                -- 2. النزول التلقائي لمكان الزر
                                -- 3. تشغيل تأثير الوميض 3 مرات
                                FlashElement(element)
                            end)
                        end
                    end
                end
            end
        end

        if not foundAnything then
            local noResult = Instance.new("TextLabel")
            noResult.Size = UDim2.new(1, 0, 0, 30)
            noResult.BackgroundTransparency = 1
            noResult.Text = "No results found."
            noResult.TextColor3 = Color3.fromRGB(100, 100, 100)
            noResult.Font = Enum.Font.Gotham
            noResult.TextSize = 12
            noResult.ZIndex = 16
            noResult.Parent = self.SearchResults
        end
    end)

    -- إخفاء قائمة البحث عند الضغط خارجها
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mx, my = input.Position.X, input.Position.Y
            local frame = self.SearchFrame
            if mx < frame.AbsolutePosition.X or mx > frame.AbsolutePosition.X + frame.AbsoluteSize.X or
               my < frame.AbsolutePosition.Y or my > frame.AbsolutePosition.Y + frame.AbsoluteSize.Y + (self.SearchResults.Visible and 150 or 0) then
                self.SearchResults.Visible = false
            end
        end
    end)

    -- منطق تصغير/تكبير النوافذ والزر العائم
    local isMaximized = false
    local normalSize = UDim2.new(0, 750, 0, 480)
    local maxSize = UDim2.new(0, 900, 0, 600)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
    end)

    -- الزر العائم
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 27) 
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui
    Instance.new("UICorner", self.FloatingBtn).CornerRadius = UDim.new(0, 12)
    
    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Size = UDim2.new(1, 0, 1, 0)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    FloatIcon.Parent = self.FloatingBtn
    Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(0, 12)
    
    local FloatStroke = Instance.new("UIStroke", self.FloatingBtn)
    FloatStroke.Thickness = 2
    FloatStroke.Color = Color3.new(1,1,1)
    ApplyGradient(FloatStroke)
    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    self.MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
    end)

    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStartPos = input.Position end
    end)
    
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 10 then
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)

    -- أنيميشن الدخول
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = normalSize}):Play()

    return self
end

return AxisUI