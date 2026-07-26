local LucidUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/LucidUI.luau"))() 
    or loadstring(readfile("LucidUI.luau"))()

local Window = LucidUI:CreateWindow({
    Title = "LucidUI",
    SubTitle = "v2.5",
    Size = UDim2.new(0, 540, 0, 360),
    ToggleKey = Enum.KeyCode.RightControl
})

local MainTab = Window:CreateTab("Main", "⚡")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

local CombatSection = MainTab:CreateSection("Combat Utility")

CombatSection:AddToggle({
    Name = "Auto Farm Mobs",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(enabled)
        LucidUI:Notify({Title = "Auto Farm", Text = enabled and "Enabled" or "Disabled", Type = enabled and "Success" or "Warning"})
    end
})

CombatSection:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 32,
    Suffix = " sps",
    Flag = "WalkSpeed",
    Callback = function(val)
        if game.Players.LocalPlayer and game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = val end
        end
    end
})

CombatSection:AddDropdown({
    Name = "Target Weapon",
    Options = {"Sword", "Staff", "Bow", "Dagger"},
    Default = "Sword",
    Flag = "Weapon",
    Callback = function(choice)
        print("Equipped:", choice)
    end
})

local ConfigSection = SettingsTab:CreateSection("Appearance & Settings")

ConfigSection:AddDropdown({
    Name = "Color Theme",
    Options = {"Obsidian Dark", "Midnight Teal", "Nordic Slate", "Pure Light"},
    Default = "Obsidian Dark",
    Callback = function(theme)
        LucidUI:SetTheme(theme)
    end
})

ConfigSection:AddKeybind({
    Name = "Toggle Interface Key",
    Default = Enum.KeyCode.RightControl,
    Callback = function(key)
        print("Rebound toggle key to:", key.Name)
    end
})

ConfigSection:AddButton({
    Name = "Copy Script Loadstring",
    Callback = function()
        LucidUI:SetClipboard('loadstring(game:HttpGet("https://raw.githubusercontent.com/errorobsidian-ux/lucid-ui/main/LucidUI_Demo.luau"))()')
    end
})
