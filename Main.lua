-- تعريف المسارات (تأكد أن الموديولات في نفس المجلد أو عدل المسار)
local UI_Folder = script.Parent -- افترضت أن السكربتات كلها في نفس المجلد

local AxisUI = require(UI_Folder:WaitForChild("AxisUI")) -- النافذة الرئيسية
local ToggleMod = require(UI_Folder:WaitForChild("Toggle"))
local SliderMod = require(UI_Folder:WaitForChild("Slider"))
local DropdownMod = require(UI_Folder:WaitForChild("Dropdown"))
local TextBoxMod = require(UI_Folder:WaitForChild("Textbox"))
local ColorPickMod = require(UI_Folder:WaitForChild("Colorpicker"))
local KeybindMod = require(UI_Folder:WaitForChild("Keybind"))
local SectionMod = require(UI_Folder:WaitForChild("Section"))
local LabelMod = require(UI_Folder:WaitForChild("Label"))
local ProgressMod = require(UI_Folder:WaitForChild("Progressbar"))

-- 1. إنشاء النافذة
local Window = AxisUI.CreateWindow({
    Title = "Axis UI Framework",
    Description = "Modular System"
})

-- 2. إنشاء التاب (التبويب)
local MainTab = Window:CreateTab({ Name = "Main Settings" })
local Container = Window.ElementsMenu:WaitForChild("Main Settings_Container")

-- 3. استخدام الموديولات لبناء الواجهة
-- ملاحظة: كل موديول يرجع الـ Frame الخاص به، يتم إضافته تلقائياً للـ Container

SectionMod.Create(Container, { Name = "Movement Tools" })

ToggleMod.Create(Container, {
    Name = "Speed Hack",
    Type = "Default",
    Callback = function(v) print("Speed:", v) end
})

SliderMod.Create(Container, {
    Name = "WalkSpeed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(v) print("Speed Value:", v) end
})

SectionMod.Create(Container, { Name = "Visuals & Info" })

LabelMod.Create(Container, { Name = "Status: Online | Version: 1.0" })

local PB = ProgressMod.Create(Container, { Name = "Loading Assets", Progress = 50 })
-- يمكنك تحديث الـ Progress Bar لاحقاً عبر:
-- PB:SetProgress(100)

SectionMod.Create(Container, { Name = "Advanced" })

DropdownMod.Create(Container, {
    Name = "Select Weapon",
    Options = {"Sword", "Gun", "Rocket"},
    Callback = function(v) print("Weapon:", v) end
})

TextBoxMod.Create(Container, {
    Name = "Target Name",
    Placeholder = "Enter name...",
    Callback = function(text) print("Target:", text) end
})

ColorPickMod.Create(Container, {
    Name = "UI Color",
    Callback = function(c) print("Color changed:", c) end
})

KeybindMod.Create(Container, {
    Name = "Toggle Menu",
    Default = Enum.KeyCode.F,
    Callback = function(k) print("Key set to:", k.Name) end
})
