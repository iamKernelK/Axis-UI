local Main = {}

local URLS = {
    Window   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua",
    Tab      = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua",
    Button   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua",
    Toggle   = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua",
    Gradient = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/WindowGradient.lua"
}

function Main.Load()
    -- تحميل الموديولات
    local WindowMod   = loadstring(game:HttpGet(URLS.Window))()
    local TabMod      = loadstring(game:HttpGet(URLS.Tab))()
    local ButtonMod   = loadstring(game:HttpGet(URLS.Button))()
    local ToggleMod   = loadstring(game:HttpGet(URLS.Toggle))()
    local GradientMod = loadstring(game:HttpGet(URLS.Gradient))()
    
    return {
        Window   = WindowMod,
        Tab      = TabMod,
        Button   = ButtonMod,
        Toggle   = ToggleMod,
        Gradient = GradientMod
    }
end

return Main
