local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة سحب احترافية فائقة النعومة
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        local Tween = TweenService:Create(object, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos})
        Tween:Play()
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "AxisUI Hub"
    local DescText = Options.Description or "Premium Interface"
    local IconId = Options.Icon or "rbxassetid://15016713781" -- أيقونة افتراضية في حال لم تضع واحدة
    
    -- 1. إعداد ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "MatrixV_PremiumHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.ScreenGui.IgnoreGuiInset = true

    local success = pcall(function() self.ScreenGui.Parent = gethui() end)
    if not success then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الإطار الرئيسي (Main Frame) - تصميم داكن جداً وصلب (Clean & Sharp)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0) -- للأنيميشن الأولي
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- رمادي/أسود احترافي
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true -- مهم جداً لإخفاء المحتوى عند التصغير
    self.MainFrame.Parent = self.ScreenGui

    -- إضافة الـ UICorner بناءً على طلبك
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6) -- حواف دائرية ناعمة جداً وغير مبالغ فيها
    MainCorner.Parent = self.MainFrame

    -- إطار نحيف جداً يعطي لمسة فخامة بدون ألوان مزعجة
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1
    MainStroke.Parent = self.MainFrame

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Size = UDim2.new(1, 0, 0, 48)
    self.TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    self.TopBar.BorderSizePixel = 0
    self.TopBar.Parent = self.MainFrame

    -- زوايا للشريط العلوي ليتناسب مع الـ MainFrame
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 6)
    TopBarCorner.Parent = self.TopBar

    -- إخفاء الزوايا السفلية للشريط العلوي ليدمج مع القائمة
    local TopBarHideCorner = Instance.new("Frame")
    TopBarHideCorner.Size = UDim2.new(1, 0, 0, 6)
    TopBarHideCorner.Position = UDim2.new(0, 0, 1, -6)
    TopBarHideCorner.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TopBarHideCorner.BorderSizePixel = 0
    TopBarHideCorner.Parent = self.TopBar

    MakeDraggable(self.TopBar, self.MainFrame)

    -- 4. أيقونة السكربت (Icon)
    self.HubIcon = Instance.new("ImageLabel")
    self.HubIcon.Name = "HubIcon"
    self.HubIcon.Size = UDim2.new(0, 24, 0, 24)
    self.HubIcon.Position = UDim2.new(0, 15, 0.5, -12)
    self.HubIcon.BackgroundTransparency = 1
    self.HubIcon.Image = IconId
    self.HubIcon.Parent = self.TopBar

    -- 5. حاوية النصوص (تم تعديل موقعها لتناسب الأيقونة)
    local TextContainer = Instance.new("Frame")
    TextContainer.Name = "TextContainer"
    TextContainer.Size = UDim2.new(0, 300, 1, 0)
    TextContainer.Position = UDim2.new(0, 48, 0, 0) -- إزاحة لليمين بسبب الأيقونة
    TextContainer.BackgroundTransparency = 1
    TextContainer.Parent = self.TopBar

    local UIListLayout_Text = Instance.new("UIListLayout")
    UIListLayout_Text.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_Text.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout_Text.Padding = UDim.new(0, 0)
    UIListLayout_Text.Parent = TextContainer

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, 0, 0, 18)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    self.TitleLabel.TextSize = 14
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = TextContainer

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Name = "Description"
    self.DescLabel.Size = UDim2.new(1, 0, 0, 14)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(110, 110, 110)
    self.DescLabel.TextSize = 11
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = TextContainer

    -- 6. أزرار التحكم
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Name = "Controls"
    ControlsContainer.Size = UDim2.new(0, 120, 1, 0)
    ControlsContainer.Position = UDim2.new(1, -120, 0, 0)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = self.TopBar

    local ControlsLayout = Instance.new("UIListLayout")
    ControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    ControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ControlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ControlsLayout.Padding = UDim.new(0, 10)
    ControlsLayout.Parent = ControlsContainer

    local ControlsPadding = Instance.new("UIPadding")
    ControlsPadding.PaddingRight = UDim.new(0, 15)
    ControlsPadding.Parent = ControlsContainer

    -- دالة إنشاء الأزرار
    local function CreateIconButton(name, assetId, layoutOrder, hoverColor)
        local Btn = Instance.new("ImageButton")
        Btn.Name = name
        Btn.Size = UDim2.new(0, 16, 0, 16)
        Btn.BackgroundTransparency = 1
        Btn.Image = assetId
        Btn.ImageColor3 = Color3.fromRGB(140, 140, 140)
        Btn.ScaleType = Enum.ScaleType.Fit
        Btn.LayoutOrder = layoutOrder
        Btn.Parent = ControlsContainer

        Btn.MouseEnter:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = hoverColor}):Play()
        end)
        Btn.MouseLeave:Connect(function()
            TweenService:Create(Btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {ImageColor3 = Color3.fromRGB(140, 140, 140)}):Play()
        end)

        return Btn
    end

    self.MinBtn = CreateIconButton("Minimize", "rbxassetid://118026365011536", 1, Color3.fromRGB(255, 255, 255))
    self.MaxBtn = CreateIconButton("Maximize", "rbxassetid://76045941763188", 2, Color3.fromRGB(255, 255, 255))
    self.CloseBtn = CreateIconButton("Close", "rbxassetid://110786993356448", 3, Color3.fromRGB(255, 85, 85))

    -- خط فاصل ناعم جداً تحت الشريط العلوي (Clean Separator)
    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.Position = UDim2.new(0, 0, 1, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Separator.BorderSizePixel = 0
    Separator.Parent = self.TopBar

    -- =====================================
    -- 7. الأنيميشن وبرمجة الأزرار (Logic)
    -- =====================================

    -- أنيميشن الدخول الأولي الفخم (Quint Easing)
    TweenService:Create(self.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 420)}):Play()

    -- نظام الـ Minimize الجديد (Roll-up احترافي بدلاً من الاختفاء التام)
    local isMinimized = false
    local preMinSize = UDim2.new(0, 650, 0, 420)

    self.MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            -- حفظ الحجم الحالي قبل التصغير
            preMinSize = self.MainFrame.Size
            -- طي الشاشة لتصبح بحجم الشريط العلوي فقط
            TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, self.MainFrame.Size.X.Offset, 0, 48)}):Play()
            -- تغيير لون الأيقونة لتوضيح الحالة
            TweenService:Create(self.MinBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(100, 255, 100)}):Play()
        else
            -- إرجاع الشاشة لحجمها السابق
            TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = preMinSize}):Play()
            TweenService:Create(self.MinBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(140, 140, 140)}):Play()
        end
    end)

    -- نظام الـ Maximize
    local isMaximized = false
    self.MaxBtn.MouseButton1Click:Connect(function()
        if isMinimized then return end -- منع التكبير إذا كانت القائمة مطوية
        
        isMaximized = not isMaximized
        local targetSize = isMaximized and UDim2.new(0, 800, 0, 500) or UDim2.new(0, 650, 0, 420)
        
        -- تحديث المتغير حتى يعمل الـ Minimize بشكل صحيح بعد التكبير
        preMinSize = targetSize 
        
        TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    -- نظام الـ Close (حذف القائمة)
    self.CloseBtn.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1})
        closeTween:Play()
        closeTween.Completed:Wait()
        self.ScreenGui:Destroy()
    end)

    return self
end

return AxisUI
