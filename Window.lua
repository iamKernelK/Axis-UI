local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

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

-- أنيميشن لا نهائي للـ UIStroke (من أعلى لأسفل)
local function ApplyAnimatedStroke(parentObj, color1, color2, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = Color3.new(1, 1, 1)
    stroke.Parent = parentObj
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color1)
    })
    grad.Rotation = 90
    grad.Parent = stroke
    
    grad.Offset = Vector2.new(0, -1)
    local tween = TweenService:Create(grad, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Offset = Vector2.new(0, 1)})
    tween:Play()
    
    return stroke
end

-- دالة لتطبيق تأثير تدرج لوني خرافي على النصوص
local function ApplyTextGradient(textLabel)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 150, 0)),  -- برتقالي ساطع
        ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 40, 0))    -- برتقالي/بني داكن
    })
    grad.Rotation = 0
    grad.Parent = textLabel
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "Axis Future"
    local DescText = Options.Description or "Ultimate UI"
    -- استخدام متغير واحد للصورة يطبق على الخلفية والزر العائم
    local ThemeImage = Options.ThemeImage or "rbxassetid://103845371952278" 
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisUI_Future"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function() self.ScreenGui.Parent = gethui() end)
    if not self.ScreenGui.Parent then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. MainFrame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 700, 0, 450)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(10, 7, 5)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = self.MainFrame

    -- دمج الصورة كخلفية شفافة للواجهة
    local BgImage = Instance.new("ImageLabel")
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.Image = ThemeImage
    BgImage.ImageTransparency = 0.85 -- شفافية قوية لتكون خلفية هادئة
    BgImage.ScaleType = Enum.ScaleType.Crop
    BgImage.ZIndex = 0
    BgImage.Parent = self.MainFrame

    ApplyAnimatedStroke(self.MainFrame, Color3.fromRGB(255, 120, 0), Color3.fromRGB(50, 10, 0), 1.5)

    -- 3. الزر العائم (مطور لقص الحواف بتأثيرات احترافية)
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Name = "FloatingBtn"
    self.FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
    -- وضعنا AnchorPoint في المنتصف لضمان أن الأنيميشن (التكبير/التصغير) يحدث من المركز
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 27) 
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.ClipsDescendants = true
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12) -- زاوية دائرية احترافية
    FloatCorner.Parent = self.FloatingBtn

    -- الأيقونة (الصورة)
    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Name = "FloatIcon"
    FloatIcon.Size = UDim2.new(1, 0, 1, 0) -- تملأ الزر بالكامل
    FloatIcon.Position = UDim2.new(0, 0, 0, 0)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop -- تملأ المساحة بدون تشويه
    FloatIcon.Parent = self.FloatingBtn

    -- السر لقص حواف الصورة فعلياً: إعطاء الصورة UICorner خاص بها مطابق للأب
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = FloatIcon

    ApplyAnimatedStroke(self.FloatingBtn, Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 255, 255), 1.5)

    -- تأثيرات احترافية (Hover & Pressed) للهواتف والحاسوب
    self.FloatingBtn.MouseEnter:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 58, 0, 58)}):Play()
        TweenService:Create(FloatIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
    end)

    self.FloatingBtn.MouseLeave:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 55, 0, 55)}):Play()
        TweenService:Create(FloatIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    self.FloatingBtn.MouseButton1Down:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 48, 0, 48)}):Play()
    end)

    self.FloatingBtn.MouseButton1Up:Connect(function()
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 58, 0, 58)}):Play()
    end)

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- 4. TopBar & Gradient Text
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 22)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 8)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- أبيض حتى يظهر الـ Gradient
    self.TitleLabel.Font = Enum.Font.GothamBlack
    self.TitleLabel.TextSize = 16
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar
    ApplyTextGradient(self.TitleLabel) -- تطبيق التدرج اللوني الخرافي

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 30)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar
    ApplyTextGradient(self.DescLabel) -- تطبيق التدرج اللوني الخرافي

    -- أزرار TopBar
    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 20, 0, 20)
        btn.Position = UDim2.new(1, posOffset, 0, 15)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ImageColor3 = Color3.fromRGB(150, 150, 150)
        btn.Parent = self.TopBar
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 150, 0)}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- الأنيميشن والبرمجة للأزرار
    local isMaximized = false
    local normalSize = UDim2.new(0, 700, 0, 450)
    local maxSize = UDim2.new(0, 850, 0, 550)

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

    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = input.Position
        end
    end)
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 10 then
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
                local targetSize = isMaximized and maxSize or normalSize
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)

    -- 5. الخطوط الفاصلة وحاويات المستقبل
    local TopDivider = Instance.new("Frame")
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 50)
    TopDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopDivider.BackgroundTransparency = 0.9
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = self.MainFrame

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Size = UDim2.new(0, 1, 1, -50)
    SidebarDivider.Position = UDim2.new(0, 180, 0, 50)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarDivider.BackgroundTransparency = 0.9
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = self.MainFrame

    self.TabsMenu = Instance.new("Frame")
    self.TabsMenu.Name = "TabsMenu"
    self.TabsMenu.Size = UDim2.new(0, 180, 1, -50)
    self.TabsMenu.Position = UDim2.new(0, 0, 0, 50)
    self.TabsMenu.BackgroundTransparency = 1
    self.TabsMenu.Parent = self.MainFrame

    self.ElementsMenu = Instance.new("Frame")
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -181, 1, -50)
    self.ElementsMenu.Position = UDim2.new(0, 181, 0, 50)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.Parent = self.MainFrame

    -- 6. مربع البحث
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(1, -30, 0, 32)
    self.SearchFrame.Position = UDim2.new(0, 15, 0, 15)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.SearchFrame.BackgroundTransparency = 0.6
    self.SearchFrame.Parent = self.TabsMenu

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = self.SearchFrame

    ApplyAnimatedStroke(self.SearchFrame, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 140, 0), 1)

    self.SearchIcon = Instance.new("ImageLabel")
    self.SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    self.SearchIcon.Position = UDim2.new(0, 10, 0.5, -8)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Image = "rbxassetid://118685771787843"
    self.SearchIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchIcon.Parent = self.SearchFrame

    self.SearchBox = Instance.new("TextBox")
    self.SearchBox.Size = UDim2.new(1, -40, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 32, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    self.SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SearchBox.Font = Enum.Font.Gotham
    self.SearchBox.TextSize = 13
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.Parent = self.SearchFrame

    return self
end

return AxisUI
