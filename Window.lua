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
local DARK_GLASS_BG = Color3.fromRGB(12, 8, 5) 

-- ==========================================
-- دوال المساعدة (Utility Functions)
-- ==========================================

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
            TweenService:Create(targetPart, TweenInfo.new(0.06, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

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
    self.MainFrame.BackgroundColor3 = DARK_GLASS_BG
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true 
    self.MainFrame.ClipsDescendants = true 
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8) 
    MainCorner.Parent = self.MainFrame

    local MainBgGradient = Instance.new("UIGradient")
    MainBgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, DARK_GLASS_BG),      
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 10, 6)), 
        ColorSequenceKeypoint.new(1, DARK_GLASS_BG)       
    })
    MainBgGradient.Rotation = 45
    MainBgGradient.Parent = self.MainFrame

    TweenService:Create(MainBgGradient, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.3, 0.3)}):Play()

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.new(1,1,1)
    Stroke.Thickness = 1.2
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = self.MainFrame
    local StrokeGrad = ApplyGradient(Stroke)
    TweenService:Create(StrokeGrad, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

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
    self.TitleLabel.TextColor3 = Color3.new(1, 1, 1) -- مهم جداً لكي يظهر التدرج!
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 17
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar
    
    -- تدرج النص من برتقالي إلى برتقالي غامق
    local TitleGrad = Instance.new("UIGradient")
    TitleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME_ORANGE),
        ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)
    })
    TitleGrad.Rotation = 0
    TitleGrad.Parent = self.TitleLabel

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 36)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 12
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.ZIndex = 5
    self.DescLabel.Parent = self.TopBar

    local function CreateTopIconBtn(name, iconId, posOffset)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 20, 0, 20)
        btn.Position = UDim2.new(1, posOffset, 0.5, -10)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ZIndex = 5
        btn.Parent = self.TopBar
        
        local iconGrad = Instance.new("UIGradient")
        iconGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
            ColorSequenceKeypoint.new(0.5, THEME_ORANGE),
            ColorSequenceKeypoint.new(1, THEME_ORANGE_DARK)
        })
        iconGrad.Rotation = 45
        iconGrad.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 23, 0, 23)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 20, 0, 20)}):Play()
        end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)
    self.TransBtn = CreateTopIconBtn("Transparency", "rbxassetid://101356891567422", -145)

    -- 4. الحاويات الرئيسية (Tabs & Elements)
    local TopDivider = Instance.new("Frame", self.MainFrame)
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 65)
    TopDivider.BackgroundColor3 = THEME_ORANGE
    TopDivider.BackgroundTransparency = 0.7
    TopDivider.BorderSizePixel = 0

    local SidebarDivider = Instance.new("Frame", self.MainFrame)
    SidebarDivider.Size = UDim2.new(0, 1, 1, -65)
    SidebarDivider.Position = UDim2.new(0, 160, 0, 65)
    SidebarDivider.BackgroundColor3 = THEME_ORANGE
    SidebarDivider.BackgroundTransparency = 0.8
    SidebarDivider.BorderSizePixel = 0

    self.TabsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.TabsMenu.Name = "TabsMenu"
    self.TabsMenu.Size = UDim2.new(0, 160, 1, -65)
    self.TabsMenu.Position = UDim2.new(0, 0, 0, 65)
    self.TabsMenu.BackgroundTransparency = 1
    self.TabsMenu.ScrollBarThickness = 0
    
    local TabsLayout = Instance.new("UIListLayout", self.TabsMenu)
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 6)
    local TabsPadding = Instance.new("UIPadding", self.TabsMenu)
    TabsPadding.PaddingTop = UDim.new(0, 15)
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)

    -- إصلاح ElementsMenu لمنع القص وضبط السكرول
    self.ElementsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -161, 1, -65)
    self.ElementsMenu.Position = UDim2.new(0, 161, 0, 65)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.ScrollBarThickness = 3
    self.ElementsMenu.ScrollBarImageColor3 = THEME_ORANGE
    self.ElementsMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ElementsMenu.AutomaticCanvasSize = Enum.AutomaticSize.Y

    -- كود ذكي: يطبق البادينغ على أي تبويب (Tab) يضاف داخله ليمنع قص الأزرار السفلية
    self.ElementsMenu.ChildAdded:Connect(function(child)
        if child:IsA("ScrollingFrame") or child:IsA("Frame") then
            if child:IsA("ScrollingFrame") then
                child.AutomaticCanvasSize = Enum.AutomaticSize.Y
                child.CanvasSize = UDim2.new(0, 0, 0, 0)
            end
            local padding = child:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding", child)
            padding.PaddingBottom = UDim.new(0, 40) -- هذه المسافة تمنع قص العنصر الأخير نهائياً!
            padding.PaddingTop = UDim.new(0, 15)
            padding.PaddingLeft = UDim.new(0, 10)
            padding.PaddingRight = UDim.new(0, 15)
        end
    end)

    -- ==========================================
    -- تفاعلات الأزرار العلوية (TopBar Logic)
    -- ==========================================

    local isTransparent = false
    self.TransBtn.MouseButton1Click:Connect(function()
        isTransparent = not isTransparent
        local targetTransparency = isTransparent and 0.4 or 0
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundTransparency = targetTransparency}):Play()
    end)

    local isMaximized = false
    local normalSize = UDim2.new(0, 720, 0, 450)
    local maxSize = UDim2.new(0, 850, 0, 550)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
    end)

    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 30) 
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(15, 8, 5)
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui
    Instance.new("UICorner", self.FloatingBtn).CornerRadius = UDim.new(0, 10)
    
    local FloatIcon = Instance.new("ImageLabel", self.FloatingBtn)
    FloatIcon.Size = UDim2.new(1, -6, 1, -6)
    FloatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(0, 8)
    
    local FloatStroke = Instance.new("UIStroke", self.FloatingBtn)
    FloatStroke.Thickness = 1.5
    FloatStroke.Color = Color3.new(1,1,1)
    ApplyGradient(FloatStroke)
    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    self.MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
        self.FloatingBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    end)

    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStartPos = input.Position end
    end)
    
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 5 then
                TweenService:Create(self.FloatingBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.wait(0.3)
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = isMaximized and maxSize or normalSize}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        self.ScreenGui:Destroy()
    end)

    self.MainFrame.ClipsDescendants = false 
    TweenService:Create(self.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = normalSize}):Play()

    return self
end

return AxisUI