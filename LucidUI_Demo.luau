local LucidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/LucidUI.luau"))() 
    or loadstring(readfile("LucidUI.luau"))() 
    or require(script.Parent:WaitForChild("LucidUI"))

local Window = LucidUI:CreateWindow({
    Title = "LucidUI Hub",
    SubTitle = "v2.0.0 Pro",
    Size = UDim2.new(0, 700, 0, 480),
    ToggleKey = Enum.KeyCode.RightControl,
    Watermark = true
})

LucidUI:Notify({
    Title = "LucidUI Loaded",
    Text = "Press RightControl to hide or show the interface.",
    Duration = 5,
    Type = "Success"
})

local MainTab = Window:CreateTab("General", "⚡")
local CustomTab = Window:CreateTab("Controls", "🛠️")
local ThemeTab = Window:CreateTab("Themes", "🎨")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

local StatusWidget = LucidUI:CreateStatusWidget({Title = "Active Features"})
StatusWidget:SetItem("Auto Farm", "OFF")
StatusWidget:SetItem("WalkSpeed", "32")

local GeneralSection = MainTab:CreateSection("Player & Combat Utilities")

GeneralSection:AddToggle({
    Name = "Auto Farm Mobs",
    Default = false,
    Flag = "AutoFarm",
    Tooltip = "Automatically teleports to nearest mob and attacks.",
    Callback = function(enabled)
        StatusWidget:SetItem("Auto Farm", enabled and "ON" or "OFF")
        LucidUI:Notify({
            Title = "Auto Farm",
            Text = "Auto Farm set to " .. tostring(enabled),
            Type = enabled and "Success" or "Warning",
            Duration = 3
        })
    end
})

local PerformanceSection = MainTab:CreateSection("Live Performance Metrics")
local FpsGraph = PerformanceSection:AddGraph({
    Name = "FPS Visualizer (60 FPS Cap)",
    Min = 0,
    Max = 60,
    MaxPoints = 25
})

task.spawn(function()
    local lastTick = tick()
    local frameCount = 0
    game:GetService("RunService").RenderStepped:Connect(function()
        frameCount = frameCount + 1
        if tick() - lastTick >= 0.5 then
            local fps = math.clamp(frameCount * 2, 0, 60)
            frameCount = 0
            lastTick = tick()
            FpsGraph:AddPoint(fps)
        end
    end)
end)

GeneralSection:AddSlider({
    Name = "WalkSpeed Multiplier",
    Min = 16,
    Max = 250,
    Default = 32,
    Precision = 0,
    Suffix = " studs/s",
    Flag = "WalkSpeed",
    Tooltip = "Adjust your character's movement velocity.",
    Callback = function(val)
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

GeneralSection:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Precision = 0,
    Suffix = " power",
    Flag = "JumpPower",
    Callback = function(val)
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = val end
        end
    end
})

GeneralSection:AddButton({
    Name = "Teleport to Spawn",
    Description = "Instantly returns your avatar to spawn position.",
    Tooltip = "Click to execute teleport.",
    Callback = function()
        LucidUI:Prompt({
            Title = "Confirm Teleport",
            Text = "Are you sure you want to teleport back to spawn?",
            ConfirmText = "Teleport",
            CancelText = "Cancel",
            OnConfirm = function()
                LucidUI:Notify({Title = "Teleported", Text = "Teleported to spawn safely.", Type = "Info"})
            end
        })
    end
})

local InputsSection = CustomTab:CreateSection("Advanced Text Box & Padding Options")

InputsSection:AddTextBox({
    Name = "Standard Search Query",
    Placeholder = "Type target player name...",
    Default = "",
    Padding = {Left = 14, Right = 14, Top = 8, Bottom = 8}, 
    Flag = "TargetPlayer",
    Tooltip = "Text box with custom 14px horizontal & 8px vertical padding.",
    Callback = function(text, enterPressed)
        print("Search query updated:", text, "Enter Pressed:", enterPressed)
    end
})

InputsSection:AddTextBox({
    Name = "Numeric Delay Interval",
    Placeholder = "Enter seconds...",
    Default = "1.5",
    NumericOnly = true,
    Padding = {Left = 10, Right = 10, Top = 6, Bottom = 6},
    Flag = "DelayInterval",
    Tooltip = "Numbers only validation text box.",
    Callback = function(val)
        print("Numeric interval:", val)
    end
})

local SelectionSection = CustomTab:CreateSection("Dropdowns & Color Pickers")

SelectionSection:AddDropdown({
    Name = "Target Weapon (Single Select)",
    Options = {"Excalibur Sword", "Shadow Dagger", "Frost Staff", "Phoenix Bow", "Thunder Hammer"},
    Default = "Frost Staff",
    Flag = "SelectedWeapon",
    Tooltip = "Single item dropdown with live search filter.",
    Callback = function(choice)
        LucidUI:Notify({Title = "Weapon Selected", Text = "Equipped: " .. choice, Type = "Info"})
    end
})

SelectionSection:AddDropdown({
    Name = "Active Auras (Multi Select)",
    Options = {"Damage Aura", "Speed Aura", "Defense Aura", "Lifesteal Aura", "Exp Boost"},
    MultiSelect = true,
    Default = {["Damage Aura"] = true, ["Speed Aura"] = true},
    Flag = "ActiveAuras",
    Tooltip = "Select multiple items simultaneously.",
    Callback = function(selectedMap)
        print("Selected auras updated.")
    end
})

SelectionSection:AddColorPicker({
    Name = "Accent Highlight Color",
    Default = Color3.fromRGB(99, 102, 241),
    Flag = "HighlightColor",
    Tooltip = "Pick custom RGB / Hex color.",
    Callback = function(col)
        print("Color changed:", col:ToHex())
    end
})

SelectionSection:AddKeybind({
    Name = "Ability Trigger Keybind",
    Default = Enum.KeyCode.E,
    Flag = "AbilityKey",
    Tooltip = "Press button to rebind trigger key.",
    Callback = function(key)
        LucidUI:Notify({Title = "Key Triggered", Text = "Pressed ability key: " .. key.Name, Type = "Info"})
    end
})

local ThemeSection = ThemeTab:CreateSection("Dynamic Preset Themes")

ThemeSection:AddParagraph({
    Title = "Live Theme Switching Engine",
    Content = "LucidUI dynamically re-colors all active windows, buttons, strokes, text labels, and tabs seamlessly without recreating the interface."
})

local availableThemes = {"Dark Modern", "Midnight Neon", "Cyan Frost", "Synthwave", "Obsidian Gold", "Rose Pine", "Light Clean"}

for _, themeName in ipairs(availableThemes) do
    ThemeSection:AddButton({
        Name = "Apply Theme: " .. themeName,
        Description = "Instantly switch color palette to " .. themeName,
        Callback = function()
            LucidUI:SetTheme(themeName)
            LucidUI:Notify({
                Title = "Theme Changed",
                Text = "Current theme updated to " .. themeName,
                Type = "Success",
                Duration = 3
            })
        end
    })
end

local SettingsSection = SettingsTab:CreateSection("Configuration Manager")

SettingsSection:AddButton({
    Name = "Save Current Configuration",
    Description = "Saves all current toggle, slider, textbox, and color values.",
    Callback = function()
        Window:SaveConfig("user_profile")
    end
})

SettingsSection:AddButton({
    Name = "Load Saved Configuration",
    Description = "Restores saved parameters from user_profile.json",
    Callback = function()
        Window:LoadConfig("user_profile")
    end
})

SettingsSection:AddButton({
    Name = "Copy Script Loadstring",
    Description = "Copies Delta raw loadstring to device clipboard.",
    Callback = function()
        LucidUI:SetClipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/LucidUI_Demo.luau"))()')
    end
})

SettingsSection:AddDivider()

SettingsSection:AddParagraph({
    Title = "LucidUI Information",
    Content = "Version: 2.0.0\nDelta & Mobile Compatible\nDesigned for high execution efficiency and visual polish."
})
