local Main = {}

local URLS = {
    Window   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua",
    Tab      = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua",
    Button   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua",
    Toggle   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua",
    Textbox  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Textbox.lua",
    Section  = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Section.lua", -- الموديول الجديد
    Gradient = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/WindowGradient.lua"
}

function Main.Load()
    -- تحميل جميع الموديولات بما في ذلك Section
    local WindowMod   = loadstring(game:HttpGet(URLS.Window))()
    local TabMod      = loadstring(game:HttpGet(URLS.Tab))()
    local ButtonMod   = loadstring(game:HttpGet(URLS.Button))()
    local ToggleMod   = loadstring(game:HttpGet(URLS.Toggle))()
    local TextboxMod  = loadstring(game:HttpGet(URLS.Textbox))()
    local SectionMod  = loadstring(game:HttpGet(URLS.Section))() -- تحميل الـ Section
    local GradientMod = loadstring(game:HttpGet(URLS.Gradient))()
    
    return {
        Window   = WindowMod,
        Tab      = TabMod,
        Button   = ButtonMod,
        Toggle   = ToggleMod,
        Textbox  = TextboxMod,
        Section  = SectionMod, -- إضافة Section للـ Return
        Gradient = GradientMod
    }
end

return Main
