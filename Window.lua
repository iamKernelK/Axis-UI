local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- ثوابت الألوان (Premium Orange Theme)
-- ==========================================
local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local THEME_ORANGE_DARK = Color3.fromRGB(130, 60, 0)
local THEME_ORANGE_LIGHT = Color3.fromRGB(255, 180, 80)
local DARK_GLASS_BG = Color3.fromRGB(15, 10, 8)

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

-- الإطار المضيء والمتحرك
local function ApplyAnimatedStroke(parentObj, thickness, cornerRadius)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = parentObj
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE_DARK),
        ColorSequenceKeypoint.new(0.5, THEME_ORANGE_LIGHT),
        ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)
    })
    grad.Rotation = 45
    grad.Parent = stroke
    
    grad.Offset = Vector2.new(-1, -1)
    local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local tween = TweenService:Create(grad, tweenInfo, {Offset = Vector2.new(1, 1)})
    tween:Play()
    
    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = cornerRadius
        corner.Parent = parentObj
    end
    
    return stroke
end

-- تدرج لوني للنصوص
local function ApplyTextGradient(textLabel)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE),
        ColorSequenceKeypoint.new(1, THEME_ORANGE_LIGHT)
    })
    grad.Rotation = 0
    grad.Parent = textLabel
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

    -- 2. النافذة الرئيسية (بتأثير تدرج الخلفية الاحترافي)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- يجب أن يكون أبيض لكي يعمل التدرج اللوني بشكل نقي
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Active = true 
    self.MainFrame.Parent = self.ScreenGui

    ApplyAnimatedStroke(self.MainFrame, 1.5, UDim.new(0, 12))

    -- تدرج الخلفية (يحاكي واجهة Fluent ولكن بلون برتقالي داكن وزجاجي)
    local MainBgGradient = Instance.new("UIGradient")
    MainBgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 5, 5)),      -- أسود داكن جداً
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 12, 5)),   -- برتقالي/بني خافت في المنتصف
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 8, 5))       -- أسود مائل للبرتقالي
    })
    MainBgGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.25) -- تأثير زجاجي (Glassmorphism)
    })
    MainBgGradient.Rotation = 45
    MainBgGradient.Parent = self.MainFrame

    -- حركة بطيئة لتدرج الخلفية ليعطي شعور بالحياة
    TweenService:Create(MainBgGradient, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Rotation = -45}):Play()

    -- 3. الزر العائم (الاحترافي مع الأنيميشن وقص الحواف الدقيق)
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Name = "FloatingBtn"
    self.FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 27) 
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(10, 5, 5)
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Active = true
    self.FloatingBtn.Parent = self.ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12)
    FloatCorner.Parent = self.FloatingBtn

    -- الأيقونة (مع حل مشكلة خروج الحواف)
    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Name = "FloatIcon"
    FloatIcon.Size = UDim2.new(1, 0, 1, 0)
    FloatIcon.Position = UDim2.new(0, 0, 0, 0)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    FloatIcon.Parent = self.FloatingBtn

    -- إضافة الزاوية الدائرية للصورة نفسها لضمان عدم بروزها أبداً
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = FloatIcon

    ApplyAnimatedStroke(self.FloatingBtn, 2, UDim.new(0, 12))

    -- تأثيرات الزر العائم (Hover & Pressed)
    self.FloatingBtn.MouseEnter:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
        TweenService:Create(FloatIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
    end)

    self.FloatingBtn.MouseLeave:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 55, 0, 55)}):Play()
        TweenService:Create(FloatIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    self.FloatingBtn.MouseButton1Down:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 48, 0, 48)}):Play()
    end)

    self.FloatingBtn.MouseButton1Up:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    end)

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- 4. الشريط العلوي
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 65)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 22)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 12)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.Font = Enum.Font.GothamBlack
    self.TitleLabel.TextSize = 18
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar
    ApplyTextGradient(self.TitleLabel)

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 36)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar

    -- 5. شريط البحث
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(0.45, 0, 0, 36)
    self.SearchFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.SearchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    self.SearchFrame.BackgroundTransparency = 0.6
    self.SearchFrame.Parent = self.TopBar

    ApplyAnimatedStroke(self.SearchFrame, 1, UDim.new(0, 6))

    self.SearchIcon = Instance.new("ImageLabel")
    self.SearchIcon.Size = UDim2.new(0, 18, 0, 18)
    self.SearchIcon.Position = UDim2.new(0, 12, 0.5, -9)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Image = "rbxassetid://118685771787843"
    self.SearchIcon.ImageColor3 = THEME_ORANGE
    self.SearchIcon.Parent = self.SearchFrame

    self.SearchBox = Instance.new("TextBox")
    self.SearchBox.Size = UDim2.new(1, -45, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 38, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search elements..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SearchBox.Font = Enum.Font.Gotham
    self.SearchBox.TextSize = 14
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.Parent = self.SearchFrame

    -- أزرار التحكم
    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 22, 0, 22)
        btn.Position = UDim2.new(1, posOffset, 0.5, -11)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ImageColor3 = Color3.fromRGB(180, 180, 180)
        btn.Parent = self.TopBar
        
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = THEME_ORANGE}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(180, 180, 180)}):Play() end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- منطق النوافذ
    local isMaximized = false
    local normalSize = UDim2.new(0, 750, 0, 480)
    local maxSize = UDim2.new(0, 900, 0, 600)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        local targetSize = isMaximized and maxSize or normalSize
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    self.MinBtn.MouseButton1Click:Connect(function()
        local t = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
    end)

    -- منطق فتح النافذة من الزر العائم (مع تجاهل السحب)
    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = input.Position
        end
    end)
    
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 10 then -- إذا لم يتم سحب الزر بل النقر عليه
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
                local targetSize = isMaximized and maxSize or normalSize
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        local t = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        self.ScreenGui:Destroy()
    end)

    -- 6. الفواصل والحاويات
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
    self.TabsMenu.ClipsDescendants = true
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
    self.ElementsMenu.ClipsDescendants = true
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

    -- أنيميشن الدخول
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = normalSize}):Play()

    return self
end

return AxisUI
