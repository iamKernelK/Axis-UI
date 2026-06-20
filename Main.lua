local Main = {}

-- الروابط المحدثة
local URLS = {
    Window = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Window.lua",
    Button = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Button.lua",
    Tab    = "https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Tab.lua"
}

function Main.Load()
    local AxisUI = loadstring(game:HttpGet(URLS.Window))()
    local ButtonMod = loadstring(game:HttpGet(URLS.Button))()
    local TabMod = loadstring(game:HttpGet(URLS.Tab))()
    
    return {
        Window = AxisUI,
        Button = ButtonMod,
        Tab = TabMod
    }
end

return Main
