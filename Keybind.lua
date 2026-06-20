local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local THEME_ORANGE = Color3.fromRGB(255, 140, 0)
local ELEMENT_BG = Color3.fromRGB(20, 15, 12)
local TEXT_COLOR = Color3.fromRGB(230, 230, 230)

return {
    Create = function(Container, Config)
        local KName = Config.Name or "Keybind"
        local CurrentKey = Config.Default or Enum.KeyCode.RightShift
        local Callback = Config.Callback or function() end
        
        local IsListening = false
        local Connection = nil -- تخزين الاتصال لتجنب الـ Memory Leaks

        -- 1. الحاوية الأساسية
        local KeybindFrame = Instance.new("Frame")
        KeybindFrame.Name = KName .. "_Keybind"
        KeybindFrame.Size = UDim2.new(1, -24, 0, 42)
        KeybindFrame.BackgroundColor3 = ELEMENT_BG
        KeybindFrame.Parent = Container

        Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 5)
        
        local Stroke = Instance.new("UIStroke", KeybindFrame)
        Stroke.Color = THEME_ORANGE
        Stroke.Thickness = 1
        Stroke.Transparency = 0.8
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        -- 2. العنوان (اليسار)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(0.5, 0, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = KName
        Title.TextColor3 = TEXT_COLOR
        Title.Font = Enum.Font.GothamSemibold
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = KeybindFrame

        -- 3. مربع الزر (اليمين)
        local BindBox = Instance.new("TextButton")
        BindBox.Size = UDim2.new(0, 80, 0, 28)
        BindBox.Position = UDim2.new(1, -15, 0.5, 0)
        BindBox.AnchorPoint = Vector2.new(1, 0.5)
        BindBox.BackgroundColor3 = Color3.fromRGB(30, 20, 15)
        BindBox.Text = CurrentKey.Name
        BindBox.TextColor3 = THEME_ORANGE
        BindBox.Font = Enum.Font.GothamBold
        BindBox.TextSize = 12
        BindBox.Parent = KeybindFrame

        Instance.new("UICorner", BindBox).CornerRadius = UDim.new(0, 5)
        local BoxStroke = Instance.new("UIStroke", BindBox)
        BoxStroke.Color = THEME_ORANGE
        BoxStroke.Transparency = 1

        -- 4. منطق الاستماع وتعيين الزر
        local function StopListening()
            IsListening = false
            BindBox.Text = CurrentKey.Name -- إعادة الاسم القديم أو الجديد
            TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 20, 15)}):Play()
            if Connection then
                Connection:Disconnect() -- قطع الاتصال فوراً لمنع الـ Memory leaks
                Connection = nil
            end
        end

        BindBox.MouseButton1Click:Connect(function()
            if IsListening then return end
            IsListening = true
            
            -- تأثير وضع الاستماع
            BindBox.Text = "..."
            TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
            TweenService:Create(BindBox, TweenInfo.new(0.2), {BackgroundColor3 = ELEMENT_BG}):Play()

            -- انتظار المدخلات (Keys or Clicks)
            Connection = UserInputService.InputBegan:Connect(function(Input)
                -- إذا ضغط الماوس في أي مكان، يتم الإلغاء
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    StopListening()
                    return
                end

                -- إذا ضغط زر من الكيبورد
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = Input.KeyCode
                    
                    -- يمكنك إلغاء الزر بالضغط على Backspace
                    if key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Escape then
                        StopListening()
                    else
                        -- حفظ الزر الجديد
                        CurrentKey = key
                        StopListening()
                        Callback(CurrentKey)
                    end
                end
            end)
        end)

        return KeybindFrame
    end
}
