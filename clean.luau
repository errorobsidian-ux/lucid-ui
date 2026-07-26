local LucidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/LucidUI_Clean.luau"))()

local Window = LucidUI:CreateWindow({
    Title = "LucidUI Minimal",
    Size = UDim2.new(0, 480, 0, 310),
    ToggleKey = Enum.KeyCode.RightControl
})

local MainTab = Window:CreateTab("Main", "⚡")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

local MainSection = MainTab:CreateSection("Features")

MainSection:AddToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        LucidUI:Notify({Title = "Auto Farm", Text = state and "ON" or "OFF"})
    end
})

MainSection:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 32,
    Suffix = " sps",
    Callback = function(val)
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

MainSection:AddDropdown({
    Name = "Weapon",
    Options = {"Sword", "Staff", "Bow"},
    Default = "Sword",
    Callback = function(val)
        print("Equipped:", val)
    end
})

local SettingsSection = SettingsTab:CreateSection("Themes & Utility")

SettingsSection:AddDropdown({
    Name = "Theme",
    Options = {"Dark", "Midnight", "Light"},
    Default = "Dark",
    Callback = function(theme)
        LucidUI:SetTheme(theme)
    end
})

SettingsSection:AddKeybind({
    Name = "Toggle Key",
    Default = Enum.KeyCode.RightControl
})

SettingsSection:AddButton({
    Name = "Copy Script Link",
    Callback = function()
        LucidUI:SetClipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/clean.luau"))()')
    end
})
