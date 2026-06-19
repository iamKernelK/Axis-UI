local AxisUI = {}
AxisUI.__index = AxisUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- دالة مساعدة للسحب الناعم
local function MakeDraggable(dragPart, targetPart)
    local Dragging, DragInput, DragStart, StartPosition

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = targetPart.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
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

-- دالة خارقة لعمل أنيميشن UIStroke من فوق لتحت بلا نهاية
local function ApplyAnimatedStroke(parentObj, color1, color2, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = Color3.new(1, 1, 1) -- اللون الأساسي أبيض حتى يظهر الجراديانت
    stroke.Parent = parentObj
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(0.5, color2),
        ColorSequenceKeypoint.new(1, color1)
    })
    grad.Rotation = 90 -- عشان يكون من فوق لتحت
    grad.Parent = stroke
    
    -- تشغيل الأنيميشن بلا نهاية
    grad.Offset = Vector2.new(0, -1)
    local tween = TweenService:Create(grad, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Offset = Vector2.new(0, 1)})
    tween:Play()
    
    return stroke
end

function AxisUI.CreateWindow(Options)
    local self = setmetatable({}, AxisUI)
    
    local TitleText = Options.Title or "FluentModded dev"
    local DescText = Options.Description or "Advanced User"
    local FloatIconID = Options.Icon or "rbxassetid://103845371952278"
    local BgMenuID = Options.Menu or ""
    
    -- 1. ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "AxisFluent_Ultimate"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    pcall(function() self.ScreenGui.Parent = gethui() end)
    if not self.ScreenGui.Parent then pcall(function() self.ScreenGui.Parent = CoreGui end) end
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. الواجهة الرئيسية (MainFrame) مع AnchorPoint للتكبير/التصغير من المنتصف
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 700, 0, 450)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 5)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = self.MainFrame

    -- صورة الواجهة (Menu) شفافة
    if BgMenuID ~= "" then
        local BgImage = Instance.new("ImageLabel")
        BgImage.Size = UDim2.new(1, 0, 1, 0)
        BgImage.BackgroundTransparency = 1
        BgImage.Image = BgMenuID
        BgImage.ImageTransparency = 0.5
        BgImage.ScaleType = Enum.ScaleType.Crop
        BgImage.ZIndex = 0
        BgImage.Parent = self.MainFrame
    end

    -- UIGradient للخلفية (Blackhole + Orange)
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 15, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 8))
    })
    MainGradient.Rotation = 45
    MainGradient.Parent = self.MainFrame
    spawn(function()
        local t = TweenService:Create(MainGradient, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(0.3, 0.3)})
        MainGradient.Offset = Vector2.new(-0.3, -0.3)
        t:Play()
    end)

    -- UIStroke متحرك للواجهة (سُمك 1.5)
    ApplyAnimatedStroke(self.MainFrame, Color3.fromRGB(255, 120, 0), Color3.fromRGB(50, 10, 0), 1.5)

    -- 3. الزر العائم (أكبر قليلاً 55x55)
    self.FloatingBtn = Instance.new("ImageButton")
    self.FloatingBtn.Size = UDim2.new(0, 55, 0, 55)
    self.FloatingBtn.Position = UDim2.new(0.5, -27, 0.1, 0)
    self.FloatingBtn.BackgroundColor3 = Color3.fromRGB(20, 12, 5)
    self.FloatingBtn.BackgroundTransparency = 0.1
    self.FloatingBtn.AutoButtonColor = false
    self.FloatingBtn.Visible = false
    self.FloatingBtn.Parent = self.ScreenGui

    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 12)
    FloatCorner.Parent = self.FloatingBtn

    -- UIStroke متحرك للزر العائم
    ApplyAnimatedStroke(self.FloatingBtn, Color3.fromRGB(255, 140, 0), Color3.fromRGB(255, 255, 255), 1.5)
    
    local FloatIcon = Instance.new("ImageLabel")
    FloatIcon.Size = UDim2.new(0.6, 0, 0.6, 0)
    FloatIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
    FloatIcon.BackgroundTransparency = 1
    FloatIcon.Image = FloatIconID
    FloatIcon.Parent = self.FloatingBtn

    MakeDraggable(self.FloatingBtn, self.FloatingBtn)

    -- 4. TopBar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Size = UDim2.new(1, 0, 0, 50)
    self.TopBar.BackgroundTransparency = 1
    self.TopBar.Parent = self.MainFrame
    MakeDraggable(self.TopBar, self.MainFrame)

    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    self.TitleLabel.Position = UDim2.new(0, 20, 0, 10)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = TitleText
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TopBar

    self.DescLabel = Instance.new("TextLabel")
    self.DescLabel.Size = UDim2.new(0, 200, 0, 15)
    self.DescLabel.Position = UDim2.new(0, 20, 0, 28)
    self.DescLabel.BackgroundTransparency = 1
    self.DescLabel.Text = DescText
    self.DescLabel.TextColor3 = Color3.fromRGB(200, 100, 0)
    self.DescLabel.Font = Enum.Font.GothamMedium
    self.DescLabel.TextSize = 11
    self.DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.DescLabel.Parent = self.TopBar

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
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play() end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- برمجة تفاعلات الأزرار: التكبير/التصغير
    local isMaximized = false
    local normalSize = UDim2.new(0, 700, 0, 450)
    local maxSize = UDim2.new(0, 850, 0, 550)

    self.MaxBtn.MouseButton1Click:Connect(function()
        isMaximized = not isMaximized
        local targetSize = isMaximized and maxSize or normalSize
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    end)

    self.MinBtn.MouseButton1Click:Connect(function()
        -- أنيميشن اختفاء (يصغر وتزيد شفافيته)
        local t = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        self.MainFrame.Visible = false
        self.FloatingBtn.Visible = true
    end)

    -- فتح القائمة من الزر العائم (بأنيميشن مذهل)
    local dragStartPos = nil
    self.FloatingBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStartPos = input.Position
        end
    end)
    self.FloatingBtn.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and dragStartPos then
            if (input.Position - dragStartPos).Magnitude < 10 then -- إذا كانت ضغطة وليست سحب
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

    -- الخطوط الفاصلة
    local TopDivider = Instance.new("Frame")
    TopDivider.Size = UDim2.new(1, 0, 0, 1)
    TopDivider.Position = UDim2.new(0, 0, 0, 50)
    TopDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopDivider.BackgroundTransparency = 0.85
    TopDivider.BorderSizePixel = 0
    TopDivider.Parent = self.MainFrame

    local SidebarDivider = Instance.new("Frame")
    SidebarDivider.Size = UDim2.new(0, 1, 1, -50)
    SidebarDivider.Position = UDim2.new(0, 180, 0, 50)
    SidebarDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SidebarDivider.BackgroundTransparency = 0.85
    SidebarDivider.BorderSizePixel = 0
    SidebarDivider.Parent = self.MainFrame

    -- 5. إعداد حاويات المستقبل
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

    -- UIStroke متحرك لمربع البحث
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
