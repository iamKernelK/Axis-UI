local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- ==========================================
-- ثوابت الألوان (Speed Hub Style - Dark Glass)
-- ==========================================
local MAIN_BG = Color3.fromRGB(15, 12, 12) -- لون داكن احترافي يميل للأسود/البني
local SIDEBAR_BG = Color3.fromRGB(10, 8, 8) -- أغمق قليلاً للقائمة الجانبية
local BORDER_COLOR = Color3.fromRGB(35, 30, 30)
local TEXT_WHITE = Color3.fromRGB(240, 240, 240)
local TEXT_GRAY = Color3.fromRGB(150, 150, 150)
local ACCENT_COLOR = Color3.fromRGB(255, 100, 100) -- يمكن تغييره لبرتقالي أو أحمر حسب رغبتك

-- ==========================================
-- دوال المساعدة (Utility)
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
            TweenService:Create(targetPart, TweenInfo.new(0.08, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = pos}):Play()
        end
    end)
end

-- ==========================================
-- بناء الواجهة الأساسية
-- ==========================================
function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "Axis UI | Version 1.0.0 | discord.gg/axisui"
    local ThemeImage = Options.ThemeImage or "rbxassetid://103845371952278" 
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisUI_Modern"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function() self.ScreenGui.Parent = gethui() end)
    if not self.ScreenGui.Parent then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. النافذة الرئيسية (شفافة احترافية)
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 650, 0, 400)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = MAIN_BG
    self.MainFrame.BackgroundTransparency = 0.15 -- الشفافية المطلوبة (ليست قوية جداً)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true 
    self.MainFrame.ClipsDescendants = true 
    self.MainFrame.Parent = self.ScreenGui

    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    
    -- إطار نحيف وأنيق حول النافذة
    local MainStroke = Instance.new("UIStroke", self.MainFrame)
    MainStroke.Color = BORDER_COLOR
    MainStroke.Thickness = 1
    MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- 3. الشريط العلوي (TopBar)
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 40)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.ZIndex = 5
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    -- اسم النافذة والوصف في سطر واحد كما في الصورة
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = TEXT_WHITE
    self.TitleLabel.Font = Enum.Font.GothamMedium
    self.TitleLabel.TextSize = 13
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar
    
    -- خط فاصل خفيف جداً تحت الـ TopBar
    local TopDivider = Instance.new("Frame", self.MainFrame)
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 40)
    TopDivider.BackgroundColor3 = BORDER_COLOR
    TopDivider.BorderSizePixel = 0

    -- ==========================================
    -- أزرار التحكم (إغلاق وتصغير فقط)
    -- ==========================================
    local function CreateControlBtn(name, iconId, posOffset, hoverColor)
        local btn = Instance.new("ImageButton")
        btn.Name = name
        btn.Size = UDim2.new(0, 16, 0, 16)
        btn.Position = UDim2.new(1, posOffset, 0.5, -8)
        btn.BackgroundTransparency = 1
        btn.Image = iconId
        btn.ImageColor3 = TEXT_GRAY
        btn.ZIndex = 5
        btn.Parent = self.TopBar
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = hoverColor}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = TEXT_GRAY}):Play()
        end)
        return btn
    end

    self.CloseBtn = CreateControlBtn("Close", "rbxassetid://10137559074", -30, Color3.fromRGB(255, 75, 75))
    self.MinBtn = CreateControlBtn("Minimize", "rbxassetid://10137279268", -55, TEXT_WHITE)

    -- ==========================================
    -- تخطيط القوائم (Sidebar & Main Content)
    -- ==========================================
    
    -- خلفية القائمة الجانبية (أغمق قليلاً لتمييزها)
    local SidebarBg = Instance.new("Frame", self.MainFrame)
    SidebarBg.Size = UDim2.new(0, 170, 1, -41)
    SidebarBg.Position = UDim2.new(0, 0, 0, 41)
    SidebarBg.BackgroundColor3 = SIDEBAR_BG
    SidebarBg.BackgroundTransparency = 0.5
    SidebarBg.BorderSizePixel = 0
    
    -- خط فاصل عمودي
    local SidebarDivider = Instance.new("Frame", self.MainFrame)
    SidebarDivider.Size = UDim2.new(0, 1, 1, -41)
    SidebarDivider.Position = UDim2.new(0, 170, 0, 41)
    SidebarDivider.BackgroundColor3 = BORDER_COLOR
    SidebarDivider.BorderSizePixel = 0

    -- [إضافة شريط البحث الوهمي في القائمة الجانبية ليتطابق مع الصورة]
    local SearchBox = Instance.new("TextBox", SidebarBg)
    SearchBox.Size = UDim2.new(1, -20, 0, 28)
    SearchBox.Position = UDim2.new(0, 10, 0, 10)
    SearchBox.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
    SearchBox.BackgroundTransparency = 0.3
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search..."
    SearchBox.TextColor3 = TEXT_WHITE
    SearchBox.PlaceholderColor3 = TEXT_GRAY
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextSize = 12
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
    local SearchStroke = Instance.new("UIStroke", SearchBox)
    SearchStroke.Color = BORDER_COLOR
    SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local SearchIcon = Instance.new("ImageLabel", SearchBox)
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://10137265036"
    SearchIcon.ImageColor3 = TEXT_GRAY

    local SearchPadding = Instance.new("UIPadding", SearchBox)
    SearchPadding.PaddingLeft = UDim.new(0, 28)

    -- حاوية التبويبات (تحت شريط البحث)
    self.TabsMenu = Instance.new("ScrollingFrame", SidebarBg)
    self.TabsMenu.Name = "TabsMenu"
    self.TabsMenu.Size = UDim2.new(1, 0, 1, -50)
    self.TabsMenu.Position = UDim2.new(0, 0, 0, 45)
    self.TabsMenu.BackgroundTransparency = 1
    self.TabsMenu.ScrollBarThickness = 0
    
    local TabsLayout = Instance.new("UIListLayout", self.TabsMenu)
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 4)
    local TabsPadding = Instance.new("UIPadding", self.TabsMenu)
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)

    -- حاوية العناصر (اليمين)
    self.ElementsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -171, 1, -41)
    self.ElementsMenu.Position = UDim2.new(0, 171, 0, 41)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.ScrollBarThickness = 2
    self.ElementsMenu.ScrollBarImageColor3 = TEXT_GRAY
    self.ElementsMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ElementsMenu.AutomaticCanvasSize = Enum.AutomaticSize.Y

    self.ElementsMenu.ChildAdded:Connect(function(child)
        if child:IsA("Frame") or child:IsA("ScrollingFrame") then
            local padding = child:FindFirstChildOfClass("UIPadding") or Instance.new("UIPadding", child)
            padding.PaddingBottom = UDim.new(0, 30) 
            padding.PaddingTop = UDim.new(0, 15)
            padding.PaddingLeft = UDim.new(0, 15)
            padding.PaddingRight = UDim.new(0, 15)
        end
    end)

    -- ==========================================
    -- نظام التصغير (Minimize to Floating Icon)
    -- ==========================================
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Size = UDim2.new(0, 45, 0, 45)
    self.FloatingBtn.AnchorPoint = Vector2.new(0.5, 0.5) 
    self.FloatingBtn.Position = UDim2.new(0.5, 0, 0.1, 30) 
    self.FloatingBtn.BackgroundColor3 = MAIN_BG
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui
    Instance.new("UICorner", self.FloatingBtn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", self.FloatingBtn).Color = BORDER_COLOR
    
    local FloatIcon = Instance.new("ImageLabel", self.FloatingBtn)
    FloatIcon.Size = UDim2.new(1, -10, 1, -10)
    FloatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = ThemeImage
    FloatIcon.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", FloatIcon).CornerRadius = UDim.new(0, 6)
    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    self.MinBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
        self.FloatingBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(self.FloatingBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 45, 0, 45)}):Play()
    end)

    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragStartPos = input.Position end
    end)
    
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 5 then
                TweenService:Create(self.FloatingBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.wait(0.2)
                self.FloatingBtn.Visible = false
                self.MainFrame.Visible = true
                TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 400)}):Play()
            end
        end
    end)

    self.CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)

    -- أنيميشن الدخول الأنيق
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(self.MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 650, 0, 400)}):Play()

    return self
end

return AxisUI