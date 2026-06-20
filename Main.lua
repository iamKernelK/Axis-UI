local AxisUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/AxisUI.lua"))()

local Main = {
    Toggle = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Toggle.lua"))(),
    Slider = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Slider.lua"))(),
    Dropdown = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Dropdown.lua"))(),
    Textbox = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Textbox.lua"))(),
    Colorpicker = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Colorpicker.lua"))(),
    Keybind = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Keybind.lua"))(),
    Section = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Section.lua"))(),
    Label = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Label.lua"))(),
    Progressbar = loadstring(game:HttpGet("https://raw.githubusercontent.com/iamKernelK/Axis-UI/refs/heads/main/Progressbar.lua"))()
}

-- دالة التهيئة
function Main:CreateWindow(Config)
    return AxisUI.CreateWindow(Config)
end

return Main
