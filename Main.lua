Local Main = {}

local URLS = {
    Window   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua",
    Tab      = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua",
    Button   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua",
    Toggle   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua",
    Textbox  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Textbox.lua",
    Section  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Section.lua",
    Dropdown = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Dropdown.lua",
    Keybind  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Keybind.lua",
    Gradient = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/WindowGradient.lua",
    Slider   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Slider.lua" -- تم إضافة الرابط هنا
}

function Main.Load()
    -- تحميل الموديولات الأساسية والمطورة
    local WindowMod   = loadstring(game:HttpGet(URLS.Window))()
    local TabMod      = loadstring(game:HttpGet(URLS.Tab))()
    local ButtonMod   = loadstring(game:HttpGet(URLS.Button))()
    local ToggleMod   = loadstring(game:HttpGet(URLS.Toggle))()
    local TextboxMod  = loadstring(game:HttpGet(URLS.Textbox))()
    local SectionMod  = loadstring(game:HttpGet(URLS.Section))()
    local DropdownMod = loadstring(game:HttpGet(URLS.Dropdown))()
    local KeybindMod  = loadstring(game:HttpGet(URLS.Keybind))()
    local GradientMod = loadstring(game:HttpGet(URLS.Gradient))()
    local SliderMod   = loadstring(game:HttpGet(URLS.Slider))() -- تم تحميل الموديول هنا
    
    return {
        Window   = WindowMod,
        Tab      = TabMod,
        Button   = ButtonMod,
        Toggle   = ToggleMod,
        Textbox  = TextboxMod,
        Section  = SectionMod,
        Dropdown = DropdownMod,
        Keybind  = KeybindMod,
        Gradient = GradientMod,
        Slider   = SliderMod -- تم إضافة الموديول للجدول المرجع
    }
end

return Main
