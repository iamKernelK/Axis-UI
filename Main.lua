local AxisUI = {}

-- قائمة الروابط
local URLS = {
    Window   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua",
    Tab      = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua",
    Button   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua",
    Toggle   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua",
    Textbox  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Textbox.lua",
    Section  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Section.lua",
    Dropdown = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Dropdown.lua",
    Keybind  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Keybind.lua",
    Slider   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Slider.lua"
}

-- دالة أمان لجلب الموديولات
local function LoadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    else
        warn("AxisUI Error: Failed to load module -> " .. url)
        return nil -- يعيد nil بدلاً من التوقف عن العمل
    end
end

-- تحميل الموديولات
AxisUI.Window   = LoadModule(URLS.Window)
AxisUI.Tab      = LoadModule(URLS.Tab)
AxisUI.Button   = LoadModule(URLS.Button)
AxisUI.Toggle   = LoadModule(URLS.Toggle)
AxisUI.Textbox  = LoadModule(URLS.Textbox)
AxisUI.Section  = LoadModule(URLS.Section)
AxisUI.Dropdown = LoadModule(URLS.Dropdown)
AxisUI.Keybind  = LoadModule(URLS.Keybind)
AxisUI.Slider   = LoadModule(URLS.Slider)

return AxisUI
