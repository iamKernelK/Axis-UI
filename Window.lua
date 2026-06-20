local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- ثوابت الألوان (Premium Dark Orange Theme)
-- ==========================================
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)       -- برتقالي ساطع
local THEME_ORANGE_DARK = Color3.fromRGB(180, 80, 0)   -- برتقالي غامق
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)

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

-- تدرج لوني للحدود والأيقونات
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

-- نظام تطبيق التدرج البرتقالي للنصوص (يحل مشكلة اللون الأسود)
local function ApplyOrangeTextGradient(textObj, animate)
    -- السر هنا: يجب أن يكون لون النص الأصلي أبيض لكي يظهر التدرج بشكله الحقيقي
    textObj.TextColor3 = Color3.fromRGB(255, 255, 255) 
    
    -- مسح أي تدرج قديم لتجنب التكرار
    for _, child in ipairs(textObj:GetChildren()) do
        if child:IsA("UIGradient") then child:Destroy() end
    end

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE),      -- يبدأ برتقالي
        ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)  -- ينتهي برتقالي غامق
    })
    grad.Rotation = 0
    grad.Parent = textObj
    
    -- إضافة حركة لمعان مستمرة إذا كان العنوان الرئيسي
    if animate then
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME_ORANGE_DARK),
            ColorSequenceKeypoint.new(0.5, THEME_ORANGE_LIGHT),
            ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)
        })
        TweenService:Create(grad, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(1, 0)}):Play()
    end
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

    -- 2. النافذة الرئيسية (CanvasGroup للتحكم الاحترافي بالشفافية الكلية)
    self.MainFrame = Instance.new("CanvasGroup")
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

    -- تدرج الخلفية الفخم (يتحرك بهدوء)
    local MainBgGradient = Instance.new("UIGradient")
    MainBgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 4, 2)),      
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 9, 4)),   
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 4, 2))       
    })
    MainBgGradient.Rotation = 45
    MainBgGradient.Parent = self.MainFrame

    TweenService:Create(MainBgGradient, TweenInfo.new(8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.5, 0.5)}):Play()

    -- الإطار الخارجي المضيء
    self.MainStroke = Instance.new("UIStroke")
    self.MainStroke.Color = Color3.new(1,1,1)
    self.MainStroke.Thickness = 1
    self.MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    self.MainStroke.Parent = self.MainFrame
    local StrokeGrad = ApplyGradient(self.MainStroke)
    TweenService:Create(StrokeGrad, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 65)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.ZIndex = 5
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    -- اسم السكربت (مع لمعة برتقالية متحركة)
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 300, 0, 22)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 12)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.Font = Enum.Font.GothamBlack
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar
    ApplyOrangeTextGradient(self.TitleLabel, true)

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 300, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 36)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.ZIndex = 5
    self.DescLabel.Parent = self.TopBar
    ApplyOrangeTextGradient(self.DescLabel, false)

    -- أزرار التحكم في الـ TopBar
    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 22, 0, 22)
        btn.Position = UDim2.new(1, posOffset, 0.5, -11)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ZIndex = 5
        btn.Parent = self.TopBar
        
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
    
    -- زر الشفافية الجديد
    self.TransBtn = CreateTopIconBtn("Transparent", "rbxassetid://101356891567422", -145)

    -- 4. الحاويات الرئيسية (Tabs & Elements)
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

    local ElementsLayout = Instance.new("UIListLayout")
    ElementsLayout.Parent = self.ElementsMenu
    ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElementsLayout.Padding = UDim.new(0, 8) 
    local ElementsPadding = Instance.new("UIPadding")
    ElementsPadding.Parent = self.ElementsMenu
    ElementsPadding.PaddingTop = UDim.new(0, 15)
    ElementsPadding.PaddingBottom = UDim.new(0, 15)
    ElementsPadding.PaddingLeft = UDim.new(0, 15)
    ElementsPadding.PaddingRight = UDim.new(0, 15)

    -- ==========================================
    -- ⭐ السحر هنا: مراقب النصوص التلقائي ⭐
    -- ==========================================
    -- هذا الكود يراقب أي شيء يتم إضافته داخل النافذة (سواء كان Tab أو Button)
    -- ويقوم بتحويل لون النص إلى التدرج البرتقالي تلقائياً!
    self.MainFrame.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            -- نستثني أي عنصر اسمه Icon عشان ما نخرب أيقونات الخطوط
            if not descendant.Name:lower():match("icon") then
                ApplyOrangeTextGradient(descendant, false)
            end
        end
    end)

    -- ==========================================
    -- منطق الأزرار العلوية (Controls)
    -- ==========================================
    local isMaximized = false
    local normalSize = UDim2.new(0, 750, 0, 480)
    local maxSize = UDim2.new(0, 900, 0, 600)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
    end)

    -- منطق زر الشفافية (يخلي كل القائمة شفافة بنسبة 50% أو يرجعها طبيعية)
    local isTransparent = false
    self.TransBtn.MouseButton1Click:Connect(function()
        isTransparent = not isTransparent
        local targetAlpha = isTransparent and 0.5 or 0 
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {GroupTransparency = targetAlpha}):Play()
        TweenService:Create(self.MainStroke, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Transparency = targetAlpha}):Play()
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
