local AxisUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة السحب
local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
        TweenService:Create(object, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = pos}):Play()
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPosition = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

function AxisUI.CreateWindow(Options)
    local Window = {}
    
    local TitleText = Options.Title or "AxisUI"
    local DescText = Options.Description or "by Developer"
    local IconId = Options.Icon or "rbxassetid://15016713781"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MatrixV_PremiumHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    pcall(function() ScreenGui.Parent = gethui() end)
    if not ScreenGui.Parent then pcall(function() ScreenGui.Parent = CoreGui end) end
    if not ScreenGui.Parent then ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- النافذة الرئيسية
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Color3.fromRGB(45, 45, 45)
    MainStroke.Thickness = 1

    -- الشريط العلوي
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 1
    TopBar.Parent = MainFrame
    MakeDraggable(TopBar, MainFrame)

    local TopIcon = Instance.new("ImageLabel", TopBar)
    TopIcon.Size = UDim2.new(0, 24, 0, 24)
    TopIcon.Position = UDim2.new(0, 15, 0.5, -12)
    TopIcon.BackgroundTransparency = 1
    TopIcon.Image = IconId

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(0, 200, 0, 18)
    TitleLabel.Position = UDim2.new(0, 48, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = TitleText
    TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local DescLabel = Instance.new("TextLabel", TopBar)
    DescLabel.Size = UDim2.new(0, 200, 0, 14)
    DescLabel.Position = UDim2.new(0, 48, 0, 28)
    DescLabel.BackgroundTransparency = 1
    DescLabel.Text = DescText
    DescLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
    DescLabel.Font = Enum.Font.GothamMedium
    DescLabel.TextSize = 11
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- أزرار التحكم
    local Controls = Instance.new("Frame", TopBar)
    Controls.Size = UDim2.new(0, 100, 1, 0)
    Controls.Position = UDim2.new(1, -100, 0, 0)
    Controls.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Controls)
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 12)
    Instance.new("UIPadding", Controls).PaddingRight = UDim.new(0, 15)

    local function CreateTopBtn(img, hoverColor)
        local btn = Instance.new("ImageButton", Controls)
        btn.Size = UDim2.new(0, 16, 0, 16)
        btn.BackgroundTransparency = 1
        btn.Image = img
        btn.ImageColor3 = Color3.fromRGB(140, 140, 140)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = hoverColor}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(140, 140, 140)}):Play() end)
        return btn
    end

    local MinBtn = CreateTopBtn("rbxassetid://118026365011536", Color3.fromRGB(255, 255, 255))
    local CloseBtn = CreateTopBtn("rbxassetid://110786993356448", Color3.fromRGB(255, 85, 85))

    local Sep = Instance.new("Frame", TopBar)
    Sep.Size = UDim2.new(1, 0, 0, 1)
    Sep.Position = UDim2.new(0, 0, 1, 0)
    Sep.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Sep.BorderSizePixel = 0

    -- الحاوية السفلية (الخانات يمين، والأزرار يسار)
    local Container = Instance.new("Frame", MainFrame)
    Container.Size = UDim2.new(1, 0, 1, -51)
    Container.Position = UDim2.new(0, 0, 0, 51)
    Container.BackgroundTransparency = 1

    local Sidebar = Instance.new("ScrollingFrame", Container)
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
    Instance.new("UIPadding", Sidebar).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", Sidebar).PaddingRight = UDim.new(0, 10)

    local SidebarLine = Instance.new("Frame", Sidebar)
    SidebarLine.Size = UDim2.new(0, 1, 1, 0)
    SidebarLine.Position = UDim2.new(1, -1, 0, 0)
    SidebarLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SidebarLine.BorderSizePixel = 0

    local ElementsArea = Instance.new("Frame", Container)
    ElementsArea.Size = UDim2.new(1, -150, 1, 0)
    ElementsArea.Position = UDim2.new(0, 150, 0, 0)
    ElementsArea.BackgroundTransparency = 1

    -- أنيميشن الدخول والتحكم
    TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(0, 700, 0, 450)}):Play()
    
    local isMin = false
    MinBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = isMin and UDim2.new(0, 700, 0, 50) or UDim2.new(0, 700, 0, 450)}):Play()
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        local t = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play() t.Completed:Wait() ScreenGui:Destroy()
    end)

    -- نظام الخانات (Tabs)
    Window.CurrentTab = nil
    
    function Window:CreateTab(TabName)
        local Tab = {}
        
        -- زر الخانة في القائمة الجانبية
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.BackgroundTransparency = 1 -- شفاف افتراضياً
        TabBtn.Text = "  " .. TabName
        TabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        -- الصفحة الخاصة بالخانة
        local TabPage = Instance.new("ScrollingFrame", ElementsArea)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 2
        TabPage.Visible = false
        local PageLayout = Instance.new("UIListLayout", TabPage)
        PageLayout.Padding = UDim.new(0, 8)
        Instance.new("UIPadding", TabPage).PaddingTop = UDim.new(0, 15)
        Instance.new("UIPadding", TabPage).PaddingLeft = UDim.new(0, 15)
        Instance.new("UIPadding", TabPage).PaddingRight = UDim.new(0, 20)

        -- برمجة التبديل بين الخانات
        TabBtn.MouseButton1Click:Connect(function()
            for _, child in pairs(Sidebar:GetChildren()) do
                if child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                end
            end
            for _, child in pairs(ElementsArea:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TabPage.Visible = true
        end)

        -- تفعيل أول خانة تلقائياً
        if not Window.CurrentTab then
            Window.CurrentTab = TabName
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabPage.Visible = true
        end

        -- نظام إنشاء الأزرار داخل الخانة
        function Tab:CreateButton(BtnOptions)
            local BtnName = BtnOptions.Name or "Button"
            local Callback = BtnOptions.Callback or function() end

            local Button = Instance.new("TextButton", TabPage)
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Button.Text = "   " .. BtnName
            Button.TextColor3 = Color3.fromRGB(220, 220, 220)
            Button.Font = Enum.Font.GothamMedium
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            
            local BtnStroke = Instance.new("UIStroke", Button)
            BtnStroke.Color = Color3.fromRGB(40, 40, 40)
            BtnStroke.Thickness = 1

            local ClickIcon = Instance.new("ImageLabel", Button)
            ClickIcon.Size = UDim2.new(0, 16, 0, 16)
            ClickIcon.Position = UDim2.new(1, -25, 0.5, -8)
            ClickIcon.BackgroundTransparency = 1
            ClickIcon.Image = "rbxassetid://15034633364" -- أيقونة الماوس
            ClickIcon.ImageColor3 = Color3.fromRGB(150, 150, 150)

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(ClickIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)}):Play()
                TweenService:Create(ClickIcon, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                -- تأثير النقر السريع (Ripple Effect خفيف)
                local t1 = TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
                local t2 = TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
                t1:Play() t1.Completed:Wait() t2:Play()
                Callback()
            end)
        end

        return Tab
    end

    return Window
end

return AxisUI
