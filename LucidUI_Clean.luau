local LucidUI = {
    Version = "3.1.0",
    Themes = {},
    CurrentTheme = "Dark",
    ActiveWindows = {},
    ConfigFolder = "LucidUI_Configs"
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function GetGuiParent()
    local success, result = pcall(function()
        if gethui then
            return gethui()
        elseif cloneref and CoreGui then
            return cloneref(CoreGui)
        elseif CoreGui then
            return CoreGui
        end
    end)
    if success and result then return result end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    end
    error("LucidUI: Could not locate parent container.")
end

function LucidUI:SetClipboard(text)
    if setclipboard then setclipboard(tostring(text))
    elseif toclipboard then toclipboard(tostring(text)) end
end

LucidUI.Themes = {
    ["Dark"] = {
        MainBG = Color3.fromRGB(15, 16, 20),
        SidebarBG = Color3.fromRGB(12, 13, 16),
        SectionBG = Color3.fromRGB(20, 22, 28),
        ElementBG = Color3.fromRGB(26, 28, 36),
        ElementHover = Color3.fromRGB(34, 37, 48),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(240, 242, 245),
        SubText = Color3.fromRGB(140, 145, 158),
        Border = Color3.fromRGB(32, 35, 45)
    },
    ["Midnight"] = {
        MainBG = Color3.fromRGB(10, 12, 18),
        SidebarBG = Color3.fromRGB(7, 8, 13),
        SectionBG = Color3.fromRGB(15, 18, 26),
        ElementBG = Color3.fromRGB(20, 25, 36),
        ElementHover = Color3.fromRGB(28, 35, 50),
        Accent = Color3.fromRGB(14, 165, 233),
        Text = Color3.fromRGB(240, 245, 250),
        SubText = Color3.fromRGB(130, 145, 165),
        Border = Color3.fromRGB(28, 35, 50)
    },
    ["Light"] = {
        MainBG = Color3.fromRGB(248, 249, 251),
        SidebarBG = Color3.fromRGB(240, 242, 245),
        SectionBG = Color3.fromRGB(255, 255, 255),
        ElementBG = Color3.fromRGB(232, 235, 240),
        ElementHover = Color3.fromRGB(215, 220, 228),
        Accent = Color3.fromRGB(37, 99, 235),
        Text = Color3.fromRGB(20, 24, 33),
        SubText = Color3.fromRGB(110, 118, 132),
        Border = Color3.fromRGB(220, 225, 232)
    }
}

local ThemeRegistry = {}

local function RegisterThemeColor(guiObject, propertyName, themeColorKey)
    table.insert(ThemeRegistry, {Object = guiObject, Property = propertyName, Key = themeColorKey})
    local colors = LucidUI.Themes[LucidUI.CurrentTheme]
    if colors and colors[themeColorKey] then
        guiObject[propertyName] = colors[themeColorKey]
    end
end

function LucidUI:SetTheme(themeName)
    if not LucidUI.Themes[themeName] then return end
    LucidUI.CurrentTheme = themeName
    local colors = LucidUI.Themes[themeName]
    for i = #ThemeRegistry, 1, -1 do
        local reg = ThemeRegistry[i]
        if reg.Object and reg.Object.Parent then
            if colors[reg.Key] then
                TweenService:Create(reg.Object, TweenInfo.new(0.15), {[reg.Property] = colors[reg.Key]}):Play()
            end
        else
            table.remove(ThemeRegistry, i)
        end
    end
end

local function QuickTween(object, tweenInfo, properties)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function CreateUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateUIStroke(parent, colorKey)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    RegisterThemeColor(stroke, "Color", colorKey or "Border")
    return stroke
end

local function CreateUIPadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 6)
    padding.PaddingBottom = UDim.new(0, bottom or 6)
    padding.PaddingLeft = UDim.new(0, left or 10)
    padding.PaddingRight = UDim.new(0, right or 10)
    padding.Parent = parent
    return padding
end

function LucidUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notice"
    local message = options.Text or ""
    local duration = options.Duration or 3

    if not LucidUI.NotificationsContainer then
        local parentContainer = GetGuiParent()
        local notifyGui = Instance.new("ScreenGui")
        notifyGui.Name = "LucidUI_Notify"
        notifyGui.ResetOnSpawn = false
        notifyGui.Parent = parentContainer

        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, 220, 1, -20)
        container.Position = UDim2.new(1, -230, 0, 10)
        container.BackgroundTransparency = 1
        container.Parent = notifyGui

        local layout = Instance.new("UIListLayout")
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 6)
        layout.Parent = container

        LucidUI.NotificationsContainer = container
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.AutomaticSize = Enum.AutomaticSize.Y
    notifFrame.Parent = LucidUI.NotificationsContainer
    RegisterThemeColor(notifFrame, "BackgroundColor3", "SectionBG")
    CreateUICorner(notifFrame, 6)
    CreateUIStroke(notifFrame, "Border")
    CreateUIPadding(notifFrame, 6, 8, 8, 8)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 14)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.TextSize = 11
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = title
    header.Parent = notifFrame
    RegisterThemeColor(header, "TextColor3", "Text")

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, 0, 0, 0)
    textLbl.Position = UDim2.new(0, 0, 0, 15)
    textLbl.AutomaticSize = Enum.AutomaticSize.Y
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 10
    textLbl.TextWrapped = true
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Text = message
    textLbl.Parent = notifFrame
    RegisterThemeColor(textLbl, "TextColor3", "SubText")

    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            notifFrame:Destroy()
        end
    end)
end

function LucidUI:CreateWindow(options)
    options = options or {}
    local windowTitle = options.Title or "LucidUI"
    local windowSize = options.Size or UDim2.new(0, 500, 0, 330)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl

    local parentContainer = GetGuiParent()

    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize then
        local targetW = math.min(windowSize.X.Offset, camera.ViewportSize.X - 16)
        local targetH = math.min(windowSize.Y.Offset, camera.ViewportSize.Y - 16)
        windowSize = UDim2.new(0, targetW, 0, targetH)
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LucidUI_Win"
    screenGui.DisplayOrder = 100
    screenGui.ResetOnSpawn = false
    screenGui.Parent = parentContainer

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = windowSize
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    RegisterThemeColor(mainFrame, "BackgroundColor3", "MainBG")
    CreateUICorner(mainFrame, 8)
    CreateUIStroke(mainFrame, "Border")

    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end
    end)

    if options.MobileToggle then
        local mobGui = Instance.new("ScreenGui")
        mobGui.Name = "LucidUI_Mob"
        mobGui.ResetOnSpawn = false
        mobGui.Parent = parentContainer

        local mobBtn = Instance.new("TextButton")
        mobBtn.Size = UDim2.new(0, 32, 0, 32)
        mobBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
        mobBtn.Text = "⚡"
        mobBtn.Font = Enum.Font.GothamBold
        mobBtn.TextSize = 14
        mobBtn.Parent = mobGui
        RegisterThemeColor(mobBtn, "BackgroundColor3", "SectionBG")
        RegisterThemeColor(mobBtn, "TextColor3", "Accent")
        CreateUICorner(mobBtn, 16)
        CreateUIStroke(mobBtn, "Border")

        mobBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end)
    end

    local dragging = false
    local dragInput, dragStart, startPos

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 32)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = mainFrame

    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    headerFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 160, 0, 16)
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = windowTitle
    titleLabel.Parent = headerFrame
    RegisterThemeColor(titleLabel, "TextColor3", "Text")

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -26, 0, 6)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.Text = "✕"
    closeBtn.Parent = headerFrame
    RegisterThemeColor(closeBtn, "TextColor3", "SubText")
    CreateUICorner(closeBtn, 10)

    closeBtn.MouseEnter:Connect(function()
        QuickTween(closeBtn, TweenInfo.new(0.12), {
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(239, 68, 68),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })
    end)

    closeBtn.MouseLeave:Connect(function()
        QuickTween(closeBtn, TweenInfo.new(0.12), {
            BackgroundTransparency = 1,
            TextColor3 = LucidUI.Themes[LucidUI.CurrentTheme].SubText
        })
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Size = UDim2.new(0, 120, 1, -32)
    sidebarFrame.Position = UDim2.new(0, 0, 0, 32)
    sidebarFrame.Parent = mainFrame
    RegisterThemeColor(sidebarFrame, "BackgroundColor3", "SidebarBG")
    CreateUIPadding(sidebarFrame, 6, 6, 6, 6)

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.Size = UDim2.new(1, 0, 1, 0)
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.ScrollBarThickness = 0
    tabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabListContainer.Parent = sidebarFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 3)
    tabListLayout.Parent = tabListContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -120, 1, -32)
    contentArea.Position = UDim2.new(0, 120, 0, 32)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    local Window = {
        Tabs = {},
        ActiveTab = nil,
        ConfigData = {},
        ScreenGui = screenGui,
        MainFrame = mainFrame
    }

    function Window:CreateTab(tabName, tabIcon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 28)
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 11
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Text = (tabIcon and tabIcon .. " " or "") .. tabName
        tabBtn.Parent = tabListContainer
        RegisterThemeColor(tabBtn, "BackgroundColor3", "SidebarBG")
        RegisterThemeColor(tabBtn, "TextColor3", "SubText")
        CreateUICorner(tabBtn, 4)
        CreateUIPadding(tabBtn, 0, 0, 8, 8)

        local activeIndicator = Instance.new("Frame")
        activeIndicator.Size = UDim2.new(0, 3, 0, 16)
        activeIndicator.Position = UDim2.new(0, -6, 0.5, -8)
        activeIndicator.Visible = false
        activeIndicator.Parent = tabBtn
        RegisterThemeColor(activeIndicator, "BackgroundColor3", "Accent")
        CreateUICorner(activeIndicator, 2)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.ScrollBarThickness = 2
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = contentArea
        CreateUIPadding(tabContent, 8, 8, 8, 8)

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 6)
        tabLayout.Parent = tabContent

        local Tab = {Sections = {}, ContentFrame = tabContent, Button = tabBtn}

        local function ActivateTab()
            for _, t in pairs(Window.Tabs) do
                t.ContentFrame.Visible = false
                QuickTween(t.Button, TweenInfo.new(0.1), {BackgroundTransparency = 1})
                RegisterThemeColor(t.Button, "TextColor3", "SubText")
                if t.Indicator then t.Indicator.Visible = false end
            end
            tabContent.Visible = true
            activeIndicator.Visible = true
            QuickTween(tabBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0})
            RegisterThemeColor(tabBtn, "BackgroundColor3", "SectionBG")
            RegisterThemeColor(tabBtn, "TextColor3", "Accent")
            Window.ActiveTab = Tab
        end

        Tab.Indicator = activeIndicator
        tabBtn.MouseButton1Click:Connect(ActivateTab)

        if #Window.Tabs == 0 then ActivateTab() end
        table.insert(Window.Tabs, Tab)

        function Tab:CreateSection(sectionTitle)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            RegisterThemeColor(sectionFrame, "BackgroundColor3", "SectionBG")
            CreateUICorner(sectionFrame, 6)
            CreateUIStroke(sectionFrame, "Border")
            CreateUIPadding(sectionFrame, 8, 8, 8, 8)

            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 6)
            sectionLayout.Parent = sectionFrame

            if sectionTitle and sectionTitle ~= "" then
                local sTitle = Instance.new("TextLabel")
                sTitle.Size = UDim2.new(1, 0, 0, 14)
                sTitle.BackgroundTransparency = 1
                sTitle.Font = Enum.Font.GothamBold
                sTitle.TextSize = 11
                sTitle.TextXAlignment = Enum.TextXAlignment.Left
                sTitle.Text = sectionTitle
                sTitle.Parent = sectionFrame
                RegisterThemeColor(sTitle, "TextColor3", "Text")
            end

            local Section = {}

            function Section:AddButton(options)
                options = options or {}
                local btnText = options.Name or options.Title or "Button"
                local callback = options.Callback or function() end

                local btnFrame = Instance.new("TextButton")
                btnFrame.Size = UDim2.new(1, 0, 0, 26)
                btnFrame.Text = ""
                btnFrame.AutoButtonColor = false
                btnFrame.Parent = sectionFrame
                RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(btnFrame, 4)
                CreateUIPadding(btnFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = btnText
                titleLbl.Parent = btnFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                btnFrame.MouseEnter:Connect(function() RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementHover") end)
                btnFrame.MouseLeave:Connect(function() RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG") end)
                btnFrame.MouseButton1Click:Connect(function() callback() end)

                return {
                    SetText = function(_, newText) titleLbl.Text = newText end,
                    SetCallback = function(_, newCb) callback = newCb end
                }
            end

            function Section:AddToggle(options)
                options = options or {}
                local toggleName = options.Name or options.Title or "Toggle"
                local state = options.Default or false
                local flag = options.Flag
                local callback = options.Callback or function() end

                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, 0, 0, 26)
                toggleFrame.Parent = sectionFrame
                RegisterThemeColor(toggleFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(toggleFrame, 4)
                CreateUIPadding(toggleFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -35, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = toggleName
                titleLbl.Parent = toggleFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local pillFrame = Instance.new("Frame")
                pillFrame.Size = UDim2.new(0, 28, 0, 14)
                pillFrame.Position = UDim2.new(1, -28, 0.5, -7)
                pillFrame.Parent = toggleFrame
                RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                CreateUICorner(pillFrame, 7)

                local pillDot = Instance.new("Frame")
                pillDot.Size = UDim2.new(0, 10, 0, 10)
                pillDot.Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                pillDot.Parent = pillFrame
                RegisterThemeColor(pillDot, "BackgroundColor3", "Text")
                CreateUICorner(pillDot, 5)

                local btnOverlay = Instance.new("TextButton")
                btnOverlay.Size = UDim2.new(1, 0, 1, 0)
                btnOverlay.BackgroundTransparency = 1
                btnOverlay.Text = ""
                btnOverlay.Parent = toggleFrame

                local function UpdateState(val)
                    state = val
                    if flag then Window.ConfigData[flag] = state end
                    RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                    QuickTween(pillDot, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                    })
                    callback(state)
                end

                btnOverlay.MouseButton1Click:Connect(function() UpdateState(not state) end)
                if flag then Window.ConfigData[flag] = state end

                return {
                    SetValue = function(_, val) UpdateState(val) end,
                    GetValue = function() return state end
                }
            end

            function Section:AddSlider(options)
                options = options or {}
                local sliderName = options.Name or options.Title or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local value = options.Default or min
                local precision = options.Precision or 0
                local suffix = options.Suffix or ""
                local flag = options.Flag
                local callback = options.Callback or function() end

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 32)
                sliderFrame.Parent = sectionFrame
                RegisterThemeColor(sliderFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(sliderFrame, 4)
                CreateUIPadding(sliderFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 0, 14)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = sliderName
                titleLbl.Parent = sliderFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local valInput = Instance.new("TextBox")
                valInput.Size = UDim2.new(0.35, 0, 0, 14)
                valInput.Position = UDim2.new(0.65, 0, 0, 0)
                valInput.BackgroundTransparency = 1
                valInput.Font = Enum.Font.GothamMedium
                valInput.TextSize = 10
                valInput.TextXAlignment = Enum.TextXAlignment.Right
                valInput.Text = tostring(value) .. suffix
                valInput.Parent = sliderFrame
                RegisterThemeColor(valInput, "TextColor3", "Accent")

                local barTrack = Instance.new("Frame")
                barTrack.Size = UDim2.new(1, 0, 0, 3)
                barTrack.Position = UDim2.new(0, 0, 0, 18)
                barTrack.Parent = sliderFrame
                RegisterThemeColor(barTrack, "BackgroundColor3", "SectionBG")
                CreateUICorner(barTrack, 2)

                local percent = math.clamp((value - min) / (max - min), 0, 1)

                local barFill = Instance.new("Frame")
                barFill.Size = UDim2.new(percent, 0, 1, 0)
                barFill.Parent = barTrack
                RegisterThemeColor(barFill, "BackgroundColor3", "Accent")
                CreateUICorner(barFill, 2)

                local function ApplyValue(newVal)
                    newVal = math.clamp(newVal, min, max)
                    if precision == 0 then newVal = math.floor(newVal + 0.5)
                    else local mult = 10 ^ precision; newVal = math.floor(newVal * mult + 0.5) / mult end
                    value = newVal
                    if flag then Window.ConfigData[flag] = value end
                    local pct = math.clamp((value - min) / (max - min), 0, 1)
                    QuickTween(barFill, TweenInfo.new(0.04), {Size = UDim2.new(pct, 0, 1, 0)})
                    valInput.Text = tostring(value) .. suffix
                    callback(value)
                end

                local isDragging = false
                local function UpdateFromMouse()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local trackAbsPos = barTrack.AbsolutePosition.X
                    local trackAbsSize = barTrack.AbsoluteSize.X
                    local pct = math.clamp((mousePos - trackAbsPos) / trackAbsSize, 0, 1)
                    ApplyValue(min + (max - min) * pct)
                end

                barTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        UpdateFromMouse()
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateFromMouse()
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = false
                    end
                end)

                valInput.FocusLost:Connect(function()
                    local cleanStr = valInput.Text:gsub("[^%d%.%-]", "")
                    local num = tonumber(cleanStr)
                    if num then ApplyValue(num) else valInput.Text = tostring(value) .. suffix end
                end)

                if flag then Window.ConfigData[flag] = value end

                return {
                    SetValue = function(_, val) ApplyValue(val) end,
                    GetValue = function() return value end
                }
            end

            function Section:AddTextBox(options)
                options = options or {}
                local boxName = options.Name or options.Title or "Text Box"
                local placeholder = options.Placeholder or "Type..."
                local defaultText = options.Default or ""
                local flag = options.Flag
                local callback = options.Callback or function() end

                local containerFrame = Instance.new("Frame")
                containerFrame.Size = UDim2.new(1, 0, 0, 34)
                containerFrame.Parent = sectionFrame
                RegisterThemeColor(containerFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(containerFrame, 4)
                CreateUIPadding(containerFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.45, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = boxName
                titleLbl.Parent = containerFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local boxHolder = Instance.new("Frame")
                boxHolder.Size = UDim2.new(0.5, 0, 0, 20)
                boxHolder.Position = UDim2.new(0.5, 0, 0.5, -10)
                boxHolder.Parent = containerFrame
                RegisterThemeColor(boxHolder, "BackgroundColor3", "SectionBG")
                CreateUICorner(boxHolder, 4)
                CreateUIStroke(boxHolder, "Border")
                CreateUIPadding(boxHolder, 2, 2, 6, 6)

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, 0, 1, 0)
                textBox.BackgroundTransparency = 1
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 10
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Text = defaultText
                textBox.PlaceholderText = placeholder
                textBox.Parent = boxHolder
                RegisterThemeColor(textBox, "TextColor3", "Text")
                RegisterThemeColor(textBox, "PlaceholderColor3", "SubText")

                textBox.FocusLost:Connect(function(enterPressed)
                    if flag then Window.ConfigData[flag] = textBox.Text end
                    callback(textBox.Text, enterPressed)
                end)

                if flag then Window.ConfigData[flag] = defaultText end

                return {
                    SetValue = function(_, val)
                        textBox.Text = tostring(val)
                        if flag then Window.ConfigData[flag] = textBox.Text end
                        callback(textBox.Text, false)
                    end,
                    GetValue = function() return textBox.Text end
                }
            end

            function Section:AddDropdown(options)
                options = options or {}
                local dropName = options.Name or options.Title or "Dropdown"
                local items = options.Options or {}
                local defaultSelected = options.Default or items[1]
                local flag = options.Flag
                local callback = options.Callback or function() end

                local selected = defaultSelected

                local dropFrame = Instance.new("Frame")
                dropFrame.Size = UDim2.new(1, 0, 0, 26)
                dropFrame.ClipsDescendants = true
                dropFrame.Parent = sectionFrame
                RegisterThemeColor(dropFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(dropFrame, 4)
                CreateUIPadding(dropFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.5, 0, 0, 20)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = dropName
                titleLbl.Parent = dropFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local displayValLbl = Instance.new("TextLabel")
                displayValLbl.Size = UDim2.new(0.45, -12, 0, 20)
                displayValLbl.Position = UDim2.new(0.5, 0, 0, 0)
                displayValLbl.BackgroundTransparency = 1
                displayValLbl.Font = Enum.Font.Gotham
                displayValLbl.TextSize = 10
                displayValLbl.TextXAlignment = Enum.TextXAlignment.Right
                displayValLbl.Text = tostring(selected or "")
                displayValLbl.Parent = dropFrame
                RegisterThemeColor(displayValLbl, "TextColor3", "Accent")

                local itemContainer = Instance.new("ScrollingFrame")
                itemContainer.Size = UDim2.new(1, 0, 0, 80)
                itemContainer.Position = UDim2.new(0, 0, 0, 26)
                itemContainer.BackgroundTransparency = 1
                itemContainer.ScrollBarThickness = 0
                itemContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
                itemContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                itemContainer.Visible = false
                itemContainer.Parent = dropFrame

                local itemLayout = Instance.new("UIListLayout")
                itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                itemLayout.Padding = UDim.new(0, 2)
                itemLayout.Parent = itemContainer

                local isOpen = false

                local function RenderOptions()
                    for _, child in pairs(itemContainer:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, optName in ipairs(items) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, 0, 0, 18)
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.TextSize = 10
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Text = "  " .. tostring(optName)
                        optBtn.Parent = itemContainer
                        CreateUICorner(optBtn, 3)

                        local isSel = (selected == optName)
                        RegisterThemeColor(optBtn, "BackgroundColor3", isSel and "Accent" or "SectionBG")
                        RegisterThemeColor(optBtn, "TextColor3", "Text")

                        optBtn.MouseButton1Click:Connect(function()
                            selected = optName
                            isOpen = false
                            itemContainer.Visible = false
                            QuickTween(dropFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 26)})
                            displayValLbl.Text = tostring(selected)
                            if flag then Window.ConfigData[flag] = selected end
                            RenderOptions()
                            callback(selected)
                        end)
                    end
                end

                RenderOptions()

                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(1, 0, 0, 20)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = ""
                toggleBtn.Parent = dropFrame

                toggleBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        itemContainer.Visible = true
                        QuickTween(dropFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 106)})
                    else
                        local tw = QuickTween(dropFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 26)})
                        tw.Completed:Connect(function()
                            if not isOpen then itemContainer.Visible = false end
                        end)
                    end
                end)

                if flag then Window.ConfigData[flag] = selected end

                return {
                    GetValue = function() return selected end
                }
            end

            function Section:AddKeybind(options)
                options = options or {}
                local keyName = options.Name or options.Title or "Keybind"
                local currentKey = options.Default or Enum.KeyCode.E
                local flag = options.Flag
                local callback = options.Callback or function() end

                local kbFrame = Instance.new("Frame")
                kbFrame.Size = UDim2.new(1, 0, 0, 26)
                kbFrame.Parent = sectionFrame
                RegisterThemeColor(kbFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(kbFrame, 4)
                CreateUIPadding(kbFrame, 3, 3, 8, 8)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = keyName
                titleLbl.Parent = kbFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local bindBtn = Instance.new("TextButton")
                bindBtn.Size = UDim2.new(0.25, 0, 0, 16)
                bindBtn.Position = UDim2.new(0.75, 0, 0.5, -8)
                bindBtn.Font = Enum.Font.GothamBold
                bindBtn.TextSize = 9
                bindBtn.Text = currentKey.Name
                bindBtn.Parent = kbFrame
                RegisterThemeColor(bindBtn, "BackgroundColor3", "SectionBG")
                RegisterThemeColor(bindBtn, "TextColor3", "Accent")
                CreateUICorner(bindBtn, 3)

                local isBinding = false
                bindBtn.MouseButton1Click:Connect(function() isBinding = true; bindBtn.Text = "..." end)

                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if isBinding and not gameProcessed then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            bindBtn.Text = currentKey.Name
                            isBinding = false
                            if flag then Window.ConfigData[flag] = currentKey.Name end
                        end
                    elseif not isBinding and not gameProcessed then
                        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey then
                            callback(currentKey)
                        end
                    end
                end)

                if flag then Window.ConfigData[flag] = currentKey.Name end

                return {
                    SetValue = function(_, key) currentKey = key; bindBtn.Text = currentKey.Name end,
                    GetValue = function() return currentKey end
                }
            end

            return Section
        end

        return Tab
    end

    table.insert(LucidUI.ActiveWindows, Window)
    return Window
end

return LucidUI
