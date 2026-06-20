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
            -- استخدام Quint ليعطي نعومة فائقة في السحب
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

local function FlashElement(element)
    local originalBg = element.BackgroundColor3
    local flashColor = Color3.fromRGB(40, 25, 15) 
    
    local stroke = element:FindFirstChildOfClass("UIStroke")
    local originalStrokeColor = stroke and stroke.Color or Color3.new(1,1,1)
    
    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = flashColor}):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = THEME_ORANGE}):Play() end
            task.wait(0.35)
            TweenService:Create(element, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {BackgroundColor3 = originalBg}):Play()
            if stroke then TweenService:Create(stroke, TweenInfo.new(0.3), {Color = originalStrokeColor}):Play() end
            task.wait(0.35)
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

    pcall(function() self.ScreenGui.Parent = game:GetService("CoreGui") end)
    if not self.ScreenGui.Parent then self.ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    -- 2. النافذة الرئيسية
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Active = true 
    self.MainFrame.ClipsDescendants = true -- لمنع خروج العناصر أثناء الأنيميشن
    self.MainFrame.Parent = self.ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8) -- حواف أكثر عصرية
    MainCorner.Parent = self.MainFrame

    -- الظل الخارجي (Drop Shadow)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 5)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5028857472"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    Shadow.Parent = self.MainFrame

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
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 17
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.ZIndex = 5
    self.TitleLabel.Parent = self.TopBar
    ApplyGradient(self.TitleLabel)

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
        iconGrad.Color = ColorSequence.new(Color3.fromRGB(160, 160, 160))
        iconGrad.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 22, 0, 22)}):Play()
            iconGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, THEME_ORANGE_LIGHT),
                ColorSequenceKeypoint.new(1, THEME_ORANGE)
            })
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0, 20, 0, 20)}):Play()
            iconGrad.Color = ColorSequence.new(Color3.fromRGB(160, 160, 160))
        end)
        return btn
    end

    self.CloseBtn = CreateTopIconBtn("Close", "rbxassetid://4458805208", -40)
    self.MaxBtn = CreateTopIconBtn("Maximize", "rbxassetid://103845371952278", -75)
    self.MinBtn = CreateTopIconBtn("Minimize", "rbxassetid://78357418744409", -110)

    -- 4. نظام البحث
    self.SearchFrame = Instance.new("Frame")
    self.SearchFrame.Size = UDim2.new(0.35, 0, 0, 34)
    self.SearchFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.SearchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.SearchFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 8)
    self.SearchFrame.ZIndex = 10
    self.SearchFrame.Parent = self.TopBar
    
    Instance.new("UICorner", self.SearchFrame).CornerRadius = UDim.new(0, 6)
    
    local SearchStroke = Instance.new("UIStroke", self.SearchFrame)
    SearchStroke.Color = THEME_ORANGE
    SearchStroke.Thickness = 1
    SearchStroke.Transparency = 0.8

    self.SearchIcon = Instance.new("ImageLabel", self.SearchFrame)
    self.SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    self.SearchIcon.Position = UDim2.new(0, 12, 0.5, -8)
    self.SearchIcon.BackgroundTransparency = 1
    self.SearchIcon.Image = "rbxassetid://118685771787843"
    self.SearchIcon.ImageColor3 = THEME_ORANGE
    self.SearchIcon.ZIndex = 10

    self.SearchBox = Instance.new("TextBox", self.SearchFrame)
    self.SearchBox.Size = UDim2.new(1, -40, 1, 0)
    self.SearchBox.Position = UDim2.new(0, 36, 0, 0)
    self.SearchBox.BackgroundTransparency = 1
    self.SearchBox.Text = ""
    self.SearchBox.PlaceholderText = "Search features..."
    self.SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    self.SearchBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    self.SearchBox.Font = Enum.Font.GothamMedium
    self.SearchBox.TextSize = 13
    self.SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    self.SearchBox.ZIndex = 10

    self.SearchFrame.MouseEnter:Connect(function()
        TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
    end)
    self.SearchFrame.MouseLeave:Connect(function()
        if not self.SearchBox:IsFocused() then
            TweenService:Create(SearchStroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
        end
    end)

    self.SearchResults = Instance.new("ScrollingFrame")
    self.SearchResults.Size = UDim2.new(1, 0, 0, 0)
    self.SearchResults.Position = UDim2.new(0, 0, 1, 5)
    self.SearchResults.BackgroundColor3 = Color3.fromRGB(18, 12, 9)
    self.SearchResults.BorderSizePixel = 0
    self.SearchResults.ScrollBarThickness = 2
    self.SearchResults.ScrollBarImageColor3 = THEME_ORANGE
    self.SearchResults.ClipsDescendants = true
    self.SearchResults.ZIndex = 15
    self.SearchResults.Parent = self.SearchFrame

    Instance.new("UICorner", self.SearchResults).CornerRadius = UDim.new(0, 6)
    local ResultsLayout = Instance.new("UIListLayout", self.SearchResults)
    ResultsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ResultsLayout.Padding = UDim.new(0, 2)
    
    local ResultsStroke = Instance.new("UIStroke", self.SearchResults)
    ResultsStroke.Color = THEME_ORANGE
    ResultsStroke.Transparency = 0.6

    -- 5. الحاويات الرئيسية (Tabs & Elements)
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

    self.ElementsMenu = Instance.new("ScrollingFrame", self.MainFrame)
    self.ElementsMenu.Name = "ElementsMenu"
    self.ElementsMenu.Size = UDim2.new(1, -161, 1, -65)
    self.ElementsMenu.Position = UDim2.new(0, 161, 0, 65)
    self.ElementsMenu.BackgroundTransparency = 1
    self.ElementsMenu.ScrollBarThickness = 3
    self.ElementsMenu.ScrollBarImageColor3 = THEME_ORANGE

    -- منطق البحث المتقدم 
    self.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = self.SearchBox.Text:lower()
        
        for _, child in ipairs(self.SearchResults:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
        end

        if text == "" then
            TweenService:Create(self.SearchResults, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            return
        end

        local foundCount = 0

        for _, container in ipairs(self.ElementsMenu:GetChildren()) do
            if container:IsA("ScrollingFrame") then
                for _, element in ipairs(container:GetChildren()) do
                    if element:IsA("TextButton") or element:IsA("Frame") then
                        local elementName = element.Name:gsub("_Btn", ""):lower()
                        local titleLabel = element:FindFirstChild("Title") or element:FindFirstChildOfClass("TextLabel")
                        if titleLabel then elementName = titleLabel.Text:lower() end

                        if elementName:find(text) then
                            foundCount = foundCount + 1
                            
                            local resultBtn = Instance.new("TextButton")
                            resultBtn.Size = UDim2.new(1, 0, 0, 28)
                            resultBtn.BackgroundColor3 = Color3.fromRGB(35, 20, 10)
                            resultBtn.BackgroundTransparency = 1
                            resultBtn.Text = "  » " .. (titleLabel and titleLabel.Text or element.Name)
                            resultBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                            resultBtn.Font = Enum.Font.GothamMedium
                            resultBtn.TextSize = 12
                            resultBtn.TextXAlignment = Enum.TextXAlignment.Left
                            resultBtn.ZIndex = 16
                            resultBtn.Parent = self.SearchResults

                            resultBtn.MouseEnter:Connect(function() TweenService:Create(resultBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = THEME_ORANGE}):Play() end)
                            resultBtn.MouseLeave:Connect(function() TweenService:Create(resultBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(210, 210, 210)}):Play() end)

                            resultBtn.MouseButton1Click:Connect(function()
                                self.SearchBox.Text = ""
                                TweenService:Create(self.SearchResults, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                                
                                for _, otherContainer in ipairs(self.ElementsMenu:GetChildren()) do
                                    if otherContainer:IsA("ScrollingFrame") then otherContainer.Visible = false end
                                end
                                container.Visible = true
                                
                                local tabBaseName = container.Name:gsub("_Container", "")
                                for _, tabBtn in ipairs(self.TabsMenu:GetChildren()) do
                                    if tabBtn:IsA("TextButton") then
                                        if tabBtn.Name == tabBaseName .. "_TabBtn" then
                                            TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(45, 25, 10)}):Play()
                                            if tabBtn:FindFirstChild("UIStroke") then TweenService:Create(tabBtn.UIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play() end
                                        else
                                            TweenService:Create(tabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 15, 12)}):Play()
                                            if tabBtn:FindFirstChild("UIStroke") then TweenService:Create(tabBtn.UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play() end
                                        end
                                    end
                                end

                                FlashElement(element)
                            end)
                        end
                    end
                end
            end
        end

        if foundCount == 0 then
            local noResult = Instance.new("TextLabel", self.SearchResults)
            noResult.Size = UDim2.new(1, 0, 0, 30)
            noResult.BackgroundTransparency = 1
            noResult.Text = "No matches found"
            noResult.TextColor3 = Color3.fromRGB(120, 120, 120)
            noResult.Font = Enum.Font.Gotham
            noResult.TextSize = 12
            noResult.ZIndex = 16
        end

        local targetHeight = math.clamp((foundCount == 0 and 1 or foundCount) * 30, 0, 150)
        TweenService:Create(self.SearchResults, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mx, my = input.Position.X, input.Position.Y
            local frame = self.SearchFrame
            if mx < frame.AbsolutePosition.X or mx > frame.AbsolutePosition.X + frame.AbsoluteSize.X or
               my < frame.AbsolutePosition.Y or my > frame.AbsolutePosition.Y + frame.AbsoluteSize.Y + self.SearchResults.AbsoluteSize.Y then
                TweenService:Create(self.SearchResults, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            end
        end
    end)

    -- منطق النوافذ والزر العائم
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

    -- أنيميشن الدخول الأولي
    self.MainFrame.ClipsDescendants = false -- استعادة الطبيعة بعد الأنيميشن
    TweenService:Create(self.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = normalSize}):Play()

    return self
end

return AxisUI