-- ملف Main.lua
local Main = {}

-- تعريف روابط المكتبة
local AXIS_UI_URL = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua"
local BUTTON_URL = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua"

-- دالة تحميل المكتبات
function Main.Load()
    local AxisUI = loadstring(game:HttpGet(AXIS_UI_URL))()
    local Button = loadstring(game:HttpGet(BUTTON_URL))()
    
    return {
        Window = AxisUI,
        Button = Button
    }
end

return Main
