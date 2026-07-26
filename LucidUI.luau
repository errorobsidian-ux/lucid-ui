local LucidUI = {
    Version = "2.5.0",
    Themes = {},
    CurrentTheme = "Obsidian Dark",
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
    if success and result then
        return result
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    end
    error("LucidUI: Could not locate valid GUI container.")
end

function LucidUI:SetClipboard(text)
    if setclipboard then
        setclipboard(tostring(text))
        LucidUI:Notify({Title = "Copied", Text = "Copied to clipboard", Type = "Success", Duration = 2})
    elseif toclipboard then
        toclipboard(tostring(text))
        LucidUI:Notify({Title = "Copied", Text = "Copied to clipboard", Type = "Success", Duration = 2})
    end
end

LucidUI.Themes = {
    ["Obsidian Dark"] = {
        MainBG = Color3.fromRGB(18, 19, 24),
        SidebarBG = Color3.fromRGB(14, 15, 19),
        SectionBG = Color3.fromRGB(24, 26, 33),
        ElementBG = Color3.fromRGB(31, 34, 43),
        ElementHover = Color3.fromRGB(39, 43, 54),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(243, 244, 246),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(42, 45, 57),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246)
    },
    ["Midnight Teal"] = {
        MainBG = Color3.fromRGB(13, 19, 24),
        SidebarBG = Color3.fromRGB(9, 13, 17),
        SectionBG = Color3.fromRGB(18, 26, 33),
        ElementBG = Color3.fromRGB(25, 36, 46),
        ElementHover = Color3.fromRGB(33, 47, 60),
        Accent = Color3.fromRGB(20, 184, 166),
        Text = Color3.fromRGB(240, 253, 250),
        SubText = Color3.fromRGB(153, 246, 228),
        Border = Color3.fromRGB(35, 50, 64),
        Success = Color3.fromRGB(20, 184, 166),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(244, 63, 94),
        Info = Color3.fromRGB(56, 189, 248)
    },
    ["Nordic Slate"] = {
        MainBG = Color3.fromRGB(24, 27, 34),
        SidebarBG = Color3.fromRGB(18, 20, 26),
        SectionBG = Color3.fromRGB(32, 36, 45),
        ElementBG = Color3.fromRGB(42, 47, 59),
        ElementHover = Color3.fromRGB(52, 58, 73),
        Accent = Color3.fromRGB(59, 130, 246),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(55, 62, 78),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246)
    },
    ["Pure Light"] = {
        MainBG = Color3.fromRGB(250, 250, 250),
        SidebarBG = Color3.fromRGB(243, 244, 246),
        SectionBG = Color3.fromRGB(255, 255, 255),
        ElementBG = Color3.fromRGB(229, 231, 235),
        ElementHover = Color3.fromRGB(209, 213, 219),
        Accent = Color3.fromRGB(37, 99, 235),
        Text = Color3.fromRGB(17, 24, 39),
        SubText = Color3.fromRGB(107, 114, 128),
        Border = Color3.fromRGB(229, 231, 235),
        Success = Color3.fromRGB(22, 163, 74),
        Warning = Color3.fromRGB(202, 138, 4),
        Error = Color3.fromRGB(220, 38, 38),
        Info = Color3.fromRGB(37, 99, 235)
    }
}

local ThemeRegistry = {}

local function RegisterThemeColor(guiObject, propertyName, themeColorKey)
    table.insert(ThemeRegistry, {
        Object = guiObject,
        Property = propertyName,
        Key = themeColorKey
    })
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
                TweenService:Create(reg.Object, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    [reg.Property] = colors[reg.Key]
                }):Play()
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
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateUIStroke(parent, colorKey, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    RegisterThemeColor(stroke, "Color", colorKey or "Border")
    return stroke
end

local function CreateUIPadding(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, top or 8)
    padding.PaddingBottom = UDim.new(0, bottom or 8)
    padding.PaddingLeft = UDim.new(0, left or 12)
    padding.PaddingRight = UDim.new(0, right or 12)
    padding.Parent = parent
    return padding
end

function LucidUI:InitNotifications()
    if LucidUI.NotificationsContainer then return end
    local parentContainer = GetGuiParent()
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "LucidUI_Notifications"
    notifyGui.DisplayOrder = 9999
    notifyGui.ResetOnSpawn = false
    notifyGui.Parent = parentContainer

    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 260, 1, -20)
    container.Position = UDim2.new(1, -270, 0, 10)
    container.BackgroundTransparency = 1
    container.Parent = notifyGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 6)
    layout.Parent = container

    LucidUI.NotificationsContainer = container
end

function LucidUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notice"
    local message = options.Text or options.Content or ""
    local duration = options.Duration or 3.5
    local notifyType = options.Type or "Info"

    LucidUI:InitNotifications()

    local colors = LucidUI.Themes[LucidUI.CurrentTheme]
    local typeColor = colors.Info
    if notifyType == "Success" then typeColor = colors.Success
    elseif notifyType == "Warning" then typeColor = colors.Warning
    elseif notifyType == "Error" then typeColor = colors.Error end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 0)
    notifFrame.AutomaticSize = Enum.AutomaticSize.Y
    notifFrame.ClipsDescendants = true
    notifFrame.Parent = LucidUI.NotificationsContainer
    RegisterThemeColor(notifFrame, "BackgroundColor3", "SectionBG")
    CreateUICorner(notifFrame, 8)
    CreateUIStroke(notifFrame, "Border", 1)
    CreateUIPadding(notifFrame, 8, 10, 10, 10)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 16)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.TextSize = 13
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = title
    header.Parent = notifFrame
    RegisterThemeColor(header, "TextColor3", "Text")

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, 0, 0, 0)
    textLbl.Position = UDim2.new(0, 0, 0, 18)
    textLbl.AutomaticSize = Enum.AutomaticSize.Y
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 11
    textLbl.TextWrapped = true
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Text = message
    textLbl.Parent = notifFrame
    RegisterThemeColor(textLbl, "TextColor3", "SubText")

    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            local tweenOut = QuickTween(notifFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            })
            tweenOut.Completed:Connect(function()
                notifFrame:Destroy()
            end)
        end
    end)
end

function LucidUI:CreateWindow(options)
    options = options or {}
    local windowTitle = options.Title or "LucidUI"
    local windowSubTitle = options.SubTitle or ""
    local windowSize = options.Size or UDim2.new(0, 540, 0, 360)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl

    local parentContainer = GetGuiParent()

    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize then
        local targetW = math.min(windowSize.X.Offset, camera.ViewportSize.X - 20)
        local targetH = math.min(windowSize.Y.Offset, camera.ViewportSize.Y - 20)
        windowSize = UDim2.new(0, targetW, 0, targetH)
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LucidUI_" .. windowTitle:gsub("%s+", "")
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
    CreateUICorner(mainFrame, 12)
    CreateUIStroke(mainFrame, "Border", 1)

    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end
    end)

    if options.MobileToggle then
        local mobGui = Instance.new("ScreenGui")
        mobGui.Name = "LucidUI_MobileToggle"
        mobGui.DisplayOrder = 9999
        mobGui.ResetOnSpawn = false
        mobGui.Parent = parentContainer

        local mobBtn = Instance.new("TextButton")
        mobBtn.Size = UDim2.new(0, 36, 0, 36)
        mobBtn.Position = UDim2.new(0.04, 0, 0.2, 0)
        mobBtn.Text = "⚡"
        mobBtn.Font = Enum.Font.GothamBold
        mobBtn.TextSize = 16
        mobBtn.Parent = mobGui
        RegisterThemeColor(mobBtn, "BackgroundColor3", "SectionBG")
        RegisterThemeColor(mobBtn, "TextColor3", "Accent")
        CreateUICorner(mobBtn, 18)
        CreateUIStroke(mobBtn, "Border", 1)

        local mobDragging = false
        local mobDragStart, mobStartPos

        mobBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mobDragging = true
                mobDragStart = input.Position
                mobStartPos = mobBtn.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if mobDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - mobDragStart
                mobBtn.Position = UDim2.new(mobStartPos.X.Scale, mobStartPos.X.Offset + delta.X, mobStartPos.Y.Scale, mobStartPos.Y.Offset + delta.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                mobDragging = false
            end
        end)

        mobBtn.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end)
    end

    local dragging = false
    local dragInput, dragStart, startPos

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 40)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = mainFrame

    headerFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 180, 0, 20)
    titleLabel.Position = UDim2.new(0, 14, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = windowTitle
    titleLabel.Parent = headerFrame
    RegisterThemeColor(titleLabel, "TextColor3", "Text")

    if windowSubTitle ~= "" then
        local subTitleLabel = Instance.new("TextLabel")
        subTitleLabel.Size = UDim2.new(0, 160, 0, 16)
        subTitleLabel.Position = UDim2.new(0, titleLabel.TextBounds.X + 22, 0, 12)
        subTitleLabel.BackgroundTransparency = 1
        subTitleLabel.Font = Enum.Font.GothamMedium
        subTitleLabel.TextSize = 11
        subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        subTitleLabel.Text = windowSubTitle
        subTitleLabel.Parent = headerFrame
        RegisterThemeColor(subTitleLabel, "TextColor3", "Accent")
    end

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -32, 0, 8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.Text = "✕"
    closeBtn.Parent = headerFrame
    RegisterThemeColor(closeBtn, "TextColor3", "SubText")

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Size = UDim2.new(0, 140, 1, -40)
    sidebarFrame.Position = UDim2.new(0, 0, 0, 40)
    sidebarFrame.Parent = mainFrame
    RegisterThemeColor(sidebarFrame, "BackgroundColor3", "SidebarBG")
    CreateUIPadding(sidebarFrame, 8, 8, 8, 8)

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.Size = UDim2.new(1, 0, 1, 0)
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.ScrollBarThickness = 0
    tabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabListContainer.Parent = sidebarFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 4)
    tabListLayout.Parent = tabListContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -140, 1, -40)
    contentArea.Position = UDim2.new(0, 140, 0, 40)
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
        tabBtn.Size = UDim2.new(1, 0, 0, 32)
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 12
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Text = (tabIcon and tabIcon .. "  " or "") .. tabName
        tabBtn.Parent = tabListContainer
        RegisterThemeColor(tabBtn, "BackgroundColor3", "SidebarBG")
        RegisterThemeColor(tabBtn, "TextColor3", "SubText")
        CreateUICorner(tabBtn, 6)
        CreateUIPadding(tabBtn, 0, 0, 10, 10)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.ScrollBarThickness = 2
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = contentArea
        CreateUIPadding(tabContent, 10, 10, 10, 10)

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout.Parent = tabContent

        local Tab = {
            Sections = {},
            ContentFrame = tabContent,
            Button = tabBtn
        }

        local function ActivateTab()
            for _, t in pairs(Window.Tabs) do
                t.ContentFrame.Visible = false
                QuickTween(t.Button, TweenInfo.new(0.15), {BackgroundTransparency = 1})
                RegisterThemeColor(t.Button, "TextColor3", "SubText")
            end
            tabContent.Visible = true
            QuickTween(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0})
            RegisterThemeColor(tabBtn, "BackgroundColor3", "SectionBG")
            RegisterThemeColor(tabBtn, "TextColor3", "Accent")
            Window.ActiveTab = Tab
        end

        tabBtn.MouseButton1Click:Connect(ActivateTab)

        if #Window.Tabs == 0 then
            ActivateTab()
        end

        table.insert(Window.Tabs, Tab)

        function Tab:CreateSection(sectionTitle)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            RegisterThemeColor(sectionFrame, "BackgroundColor3", "SectionBG")
            CreateUICorner(sectionFrame, 8)
            CreateUIStroke(sectionFrame, "Border", 1)
            CreateUIPadding(sectionFrame, 10, 10, 10, 10)

            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 8)
            sectionLayout.Parent = sectionFrame

            if sectionTitle and sectionTitle ~= "" then
                local sTitle = Instance.new("TextLabel")
                sTitle.Size = UDim2.new(1, 0, 0, 16)
                sTitle.BackgroundTransparency = 1
                sTitle.Font = Enum.Font.GothamBold
                sTitle.TextSize = 12
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
                btnFrame.Size = UDim2.new(1, 0, 0, 32)
                btnFrame.Text = ""
                btnFrame.AutoButtonColor = false
                btnFrame.Parent = sectionFrame
                RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(btnFrame, 6)
                CreateUIPadding(btnFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = btnText
                titleLbl.Parent = btnFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                btnFrame.MouseEnter:Connect(function()
                    RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementHover")
                end)
                btnFrame.MouseLeave:Connect(function()
                    RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG")
                end)
                btnFrame.MouseButton1Click:Connect(function()
                    callback()
                end)

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
                toggleFrame.Size = UDim2.new(1, 0, 0, 32)
                toggleFrame.Parent = sectionFrame
                RegisterThemeColor(toggleFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(toggleFrame, 6)
                CreateUIPadding(toggleFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -45, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = toggleName
                titleLbl.Parent = toggleFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local pillFrame = Instance.new("Frame")
                pillFrame.Size = UDim2.new(0, 34, 0, 18)
                pillFrame.Position = UDim2.new(1, -34, 0.5, -9)
                pillFrame.Parent = toggleFrame
                RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                CreateUICorner(pillFrame, 9)

                local pillDot = Instance.new("Frame")
                pillDot.Size = UDim2.new(0, 14, 0, 14)
                pillDot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                pillDot.Parent = pillFrame
                RegisterThemeColor(pillDot, "BackgroundColor3", "Text")
                CreateUICorner(pillDot, 7)

                local btnOverlay = Instance.new("TextButton")
                btnOverlay.Size = UDim2.new(1, 0, 1, 0)
                btnOverlay.BackgroundTransparency = 1
                btnOverlay.Text = ""
                btnOverlay.Parent = toggleFrame

                local function UpdateState(val)
                    state = val
                    if flag then Window.ConfigData[flag] = state end
                    RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                    QuickTween(pillDot, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    })
                    callback(state)
                end

                btnOverlay.MouseButton1Click:Connect(function()
                    UpdateState(not state)
                end)

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
                sliderFrame.Size = UDim2.new(1, 0, 0, 40)
                sliderFrame.Parent = sectionFrame
                RegisterThemeColor(sliderFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(sliderFrame, 6)
                CreateUIPadding(sliderFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 0, 16)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = sliderName
                titleLbl.Parent = sliderFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local valInput = Instance.new("TextBox")
                valInput.Size = UDim2.new(0.35, 0, 0, 16)
                valInput.Position = UDim2.new(0.65, 0, 0, 0)
                valInput.BackgroundTransparency = 1
                valInput.Font = Enum.Font.GothamMedium
                valInput.TextSize = 11
                valInput.TextXAlignment = Enum.TextXAlignment.Right
                valInput.Text = tostring(value) .. suffix
                valInput.Parent = sliderFrame
                RegisterThemeColor(valInput, "TextColor3", "Accent")

                local barTrack = Instance.new("Frame")
                barTrack.Size = UDim2.new(1, 0, 0, 4)
                barTrack.Position = UDim2.new(0, 0, 0, 22)
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
                    if precision == 0 then
                        newVal = math.floor(newVal + 0.5)
                    else
                        local mult = 10 ^ precision
                        newVal = math.floor(newVal * mult + 0.5) / mult
                    end
                    value = newVal
                    if flag then Window.ConfigData[flag] = value end
                    local pct = math.clamp((value - min) / (max - min), 0, 1)
                    QuickTween(barFill, TweenInfo.new(0.06), {Size = UDim2.new(pct, 0, 1, 0)})
                    valInput.Text = tostring(value) .. suffix
                    callback(value)
                end

                local isDragging = false
                local function UpdateFromMouse()
                    local mousePos = UserInputService:GetMouseLocation().X
                    local trackAbsPos = barTrack.AbsolutePosition.X
                    local trackAbsSize = barTrack.AbsoluteSize.X
                    local pct = math.clamp((mousePos - trackAbsPos) / trackAbsSize, 0, 1)
                    local calculatedVal = min + (max - min) * pct
                    ApplyValue(calculatedVal)
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
                local placeholder = options.Placeholder or "Type here..."
                local defaultText = options.Default or ""
                local customPadding = options.Padding or {Left = 8, Right = 8, Top = 4, Bottom = 4}
                local numericOnly = options.NumericOnly or false
                local flag = options.Flag
                local callback = options.Callback or function() end

                local containerFrame = Instance.new("Frame")
                containerFrame.Size = UDim2.new(1, 0, 0, 44)
                containerFrame.Parent = sectionFrame
                RegisterThemeColor(containerFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(containerFrame, 6)
                CreateUIPadding(containerFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 0, 14)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 11
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = boxName
                titleLbl.Parent = containerFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local boxHolder = Instance.new("Frame")
                boxHolder.Size = UDim2.new(1, 0, 0, 22)
                boxHolder.Position = UDim2.new(0, 0, 0, 16)
                boxHolder.Parent = containerFrame
                RegisterThemeColor(boxHolder, "BackgroundColor3", "SectionBG")
                CreateUICorner(boxHolder, 4)
                CreateUIStroke(boxHolder, "Border", 1)

                local pLeft = type(customPadding) == "table" and customPadding.Left or customPadding
                local pRight = type(customPadding) == "table" and customPadding.Right or customPadding
                local pTop = type(customPadding) == "table" and customPadding.Top or customPadding
                local pBottom = type(customPadding) == "table" and customPadding.Bottom or customPadding
                CreateUIPadding(boxHolder, pTop or 4, pBottom or 4, pLeft or 8, pRight or 8)

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, 0, 1, 0)
                textBox.BackgroundTransparency = 1
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 11
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Text = defaultText
                textBox.PlaceholderText = placeholder
                textBox.ClearTextOnFocus = false
                textBox.Parent = boxHolder
                RegisterThemeColor(textBox, "TextColor3", "Text")
                RegisterThemeColor(textBox, "PlaceholderColor3", "SubText")

                textBox.Changed:Connect(function(prop)
                    if prop == "Text" and numericOnly then
                        textBox.Text = textBox.Text:gsub("[^%d%.%-]", "")
                    end
                end)

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
                local multiSelect = options.MultiSelect or false
                local defaultSelected = options.Default or (multiSelect and {} or items[1])
                local flag = options.Flag
                local callback = options.Callback or function() end

                local selected = multiSelect and (type(defaultSelected) == "table" and defaultSelected or {}) or defaultSelected

                local dropFrame = Instance.new("Frame")
                dropFrame.Size = UDim2.new(1, 0, 0, 34)
                dropFrame.ClipsDescendants = true
                dropFrame.Parent = sectionFrame
                RegisterThemeColor(dropFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(dropFrame, 6)
                CreateUIPadding(dropFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.5, 0, 0, 16)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = dropName
                titleLbl.Parent = dropFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local displayValLbl = Instance.new("TextLabel")
                displayValLbl.Size = UDim2.new(0.48, -16, 0, 16)
                displayValLbl.Position = UDim2.new(0.5, 0, 0, 0)
                displayValLbl.BackgroundTransparency = 1
                displayValLbl.Font = Enum.Font.Gotham
                displayValLbl.TextSize = 11
                displayValLbl.TextXAlignment = Enum.TextXAlignment.Right
                displayValLbl.TextTruncate = Enum.TextTruncate.AtEnd
                displayValLbl.Parent = dropFrame
                RegisterThemeColor(displayValLbl, "TextColor3", "Accent")

                local arrowLbl = Instance.new("TextLabel")
                arrowLbl.Size = UDim2.new(0, 14, 0, 16)
                arrowLbl.Position = UDim2.new(1, -14, 0, 0)
                arrowLbl.BackgroundTransparency = 1
                arrowLbl.Font = Enum.Font.GothamBold
                arrowLbl.TextSize = 11
                arrowLbl.Text = "▾"
                arrowLbl.Parent = dropFrame
                RegisterThemeColor(arrowLbl, "TextColor3", "SubText")

                local itemContainer = Instance.new("ScrollingFrame")
                itemContainer.Size = UDim2.new(1, 0, 0, 100)
                itemContainer.Position = UDim2.new(0, 0, 0, 24)
                itemContainer.BackgroundTransparency = 1
                itemContainer.ScrollBarThickness = 2
                itemContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
                itemContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                itemContainer.Parent = dropFrame

                local itemLayout = Instance.new("UIListLayout")
                itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                itemLayout.Padding = UDim.new(0, 3)
                itemLayout.Parent = itemContainer

                local isOpen = false

                local function FormatDisplay()
                    if multiSelect then
                        local selectedList = {}
                        for opt, val in pairs(selected) do
                            if val then table.insert(selectedList, opt) end
                        end
                        return #selectedList > 0 and table.concat(selectedList, ", ") or "None"
                    else
                        return tostring(selected or "Select...")
                    end
                end

                displayValLbl.Text = FormatDisplay()

                local optionButtons = {}

                local function RenderOptions()
                    for _, btn in pairs(optionButtons) do btn:Destroy() end
                    optionButtons = {}

                    for idx, optName in ipairs(items) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, -4, 0, 22)
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.TextSize = 11
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Text = "  " .. tostring(optName)
                        optBtn.Parent = itemContainer
                        CreateUICorner(optBtn, 4)

                        local isSel = multiSelect and selected[optName] or (selected == optName)
                        RegisterThemeColor(optBtn, "BackgroundColor3", isSel and "Accent" or "SectionBG")
                        RegisterThemeColor(optBtn, "TextColor3", "Text")

                        optBtn.MouseButton1Click:Connect(function()
                            if multiSelect then
                                selected[optName] = not selected[optName]
                            else
                                selected = optName
                                isOpen = false
                                QuickTween(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 34)})
                                arrowLbl.Text = "▾"
                            end
                            displayValLbl.Text = FormatDisplay()
                            if flag then Window.ConfigData[flag] = selected end
                            RenderOptions()
                            callback(selected)
                        end)

                        table.insert(optionButtons, optBtn)
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
                    arrowLbl.Text = isOpen and "▴" or "▾"
                    QuickTween(dropFrame, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, isOpen and 130 or 34)})
                end)

                if flag then Window.ConfigData[flag] = selected end

                return {
                    SetOptions = function(_, newOptions, newDefault)
                        items = newOptions or {}
                        selected = newDefault or (multiSelect and {} or items[1])
                        displayValLbl.Text = FormatDisplay()
                        RenderOptions()
                    end,
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
                kbFrame.Size = UDim2.new(1, 0, 0, 32)
                kbFrame.Parent = sectionFrame
                RegisterThemeColor(kbFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(kbFrame, 6)
                CreateUIPadding(kbFrame, 4, 4, 10, 10)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamMedium
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = keyName
                titleLbl.Parent = kbFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local bindBtn = Instance.new("TextButton")
                bindBtn.Size = UDim2.new(0.3, 0, 0, 18)
                bindBtn.Position = UDim2.new(0.7, 0, 0.5, -9)
                bindBtn.Font = Enum.Font.GothamBold
                bindBtn.TextSize = 10
                bindBtn.Text = currentKey.Name
                bindBtn.Parent = kbFrame
                RegisterThemeColor(bindBtn, "BackgroundColor3", "SectionBG")
                RegisterThemeColor(bindBtn, "TextColor3", "Accent")
                CreateUICorner(bindBtn, 4)

                local isBinding = false

                bindBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    bindBtn.Text = "..."
                end)

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
                    SetValue = function(_, key)
                        currentKey = key
                        bindBtn.Text = currentKey.Name
                        if flag then Window.ConfigData[flag] = currentKey.Name end
                    end,
                    GetValue = function() return currentKey end
                }
            end

            return Section
        end

        return Tab
    end

    function Window:SaveConfig(configName)
        configName = configName or "default"
        if not isfolder or not writefile then return end
        if not isfolder(LucidUI.ConfigFolder) then makefolder(LucidUI.ConfigFolder) end

        local filePath = LucidUI.ConfigFolder .. "/" .. configName .. ".json"
        local success, jsonStr = pcall(function() return HttpService:JSONEncode(Window.ConfigData) end)
        if success then writefile(filePath, jsonStr) end
    end

    function Window:LoadConfig(configName)
        configName = configName or "default"
        if not isfolder or not readfile then return end

        local filePath = LucidUI.ConfigFolder .. "/" .. configName .. ".json"
        if isfile and isfile(filePath) then
            local success, jsonStr = pcall(function() return readfile(filePath) end)
            if success then
                local decodeSuccess, decodedData = pcall(function() return HttpService:JSONDecode(jsonStr) end)
                if decodeSuccess and type(decodedData) == "table" then
                    Window.ConfigData = decodedData
                end
            end
        end
    end

    table.insert(LucidUI.ActiveWindows, Window)
    return Window
end

return LucidUI
