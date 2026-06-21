local AxisUI = {}

local function SafeLoad(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success and result then
        return result
    else
        warn("AxisUI Error: Failed to load -> " .. url)
        return {} -- إرجاع جدول فارغ بدلاً من nil لمنع انهيار السكربت
    end
end

AxisUI.Window   = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua")
AxisUI.Tab      = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua")
AxisUI.Button   = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua")
AxisUI.Toggle   = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua")
AxisUI.Textbox  = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Textbox.lua")
AxisUI.Section  = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Section.lua")
AxisUI.Dropdown = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Dropdown.lua")
AxisUI.Keybind  = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Keybind.lua")
AxisUI.Slider   = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Slider.lua")

-- إضافة الموديول الجديد
AxisUI.TabSection = SafeLoad("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab%20Section.lua")

return AxisUI
