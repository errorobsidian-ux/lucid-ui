local LucidUI = {
    Version = "2.0.0",
    Themes = {},
    CurrentTheme = "Dark Modern",
    ActiveWindows = {},
    NotificationsContainer = nil,
    TooltipsEnabled = true,
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
    error("LucidUI: Could not find valid GUI parent container.")
end

function LucidUI:SetClipboard(text)
    if setclipboard then
        setclipboard(tostring(text))
        LucidUI:Notify({Title = "Clipboard", Text = "Copied text to clipboard!", Type = "Success", Duration = 2})
    elseif toclipboard then
        toclipboard(tostring(text))
        LucidUI:Notify({Title = "Clipboard", Text = "Copied text to clipboard!", Type = "Success", Duration = 2})
    else
        LucidUI:Notify({Title = "Clipboard Error", Text = "Clipboard functions unsupported on this executor.", Type = "Error", Duration = 3})
    end
end

LucidUI.Themes = {
    ["Dark Modern"] = {
        MainBG = Color3.fromRGB(20, 22, 28),
        SidebarBG = Color3.fromRGB(15, 16, 21),
        SectionBG = Color3.fromRGB(26, 29, 38),
        ElementBG = Color3.fromRGB(34, 38, 50),
        ElementHover = Color3.fromRGB(42, 47, 62),
        Accent = Color3.fromRGB(99, 102, 241), 
        AccentHover = Color3.fromRGB(129, 140, 248),
        Text = Color3.fromRGB(243, 244, 246),
        SubText = Color3.fromRGB(156, 163, 175),
        Border = Color3.fromRGB(45, 51, 66),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246)
    },
    ["Midnight Neon"] = {
        MainBG = Color3.fromRGB(13, 11, 22),
        SidebarBG = Color3.fromRGB(9, 7, 15),
        SectionBG = Color3.fromRGB(19, 16, 32),
        ElementBG = Color3.fromRGB(27, 23, 46),
        ElementHover = Color3.fromRGB(38, 33, 64),
        Accent = Color3.fromRGB(168, 85, 247), 
        AccentHover = Color3.fromRGB(192, 132, 252),
        Text = Color3.fromRGB(248, 250, 252),
        SubText = Color3.fromRGB(148, 163, 184),
        Border = Color3.fromRGB(48, 40, 78),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(245, 158, 11),
        Error = Color3.fromRGB(244, 63, 94),
        Info = Color3.fromRGB(14, 165, 233)
    },
    ["Cyan Frost"] = {
        MainBG = Color3.fromRGB(12, 20, 26),
        SidebarBG = Color3.fromRGB(8, 14, 18),
        SectionBG = Color3.fromRGB(17, 28, 36),
        ElementBG = Color3.fromRGB(24, 40, 52),
        ElementHover = Color3.fromRGB(32, 52, 68),
        Accent = Color3.fromRGB(6, 182, 212), 
        AccentHover = Color3.fromRGB(34, 211, 238),
        Text = Color3.fromRGB(240, 253, 250),
        SubText = Color3.fromRGB(153, 246, 228),
        Border = Color3.fromRGB(36, 60, 78),
        Success = Color3.fromRGB(20, 184, 166),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(244, 63, 94),
        Info = Color3.fromRGB(56, 189, 248)
    },
    ["Synthwave"] = {
        MainBG = Color3.fromRGB(24, 14, 34),
        SidebarBG = Color3.fromRGB(16, 9, 24),
        SectionBG = Color3.fromRGB(34, 20, 48),
        ElementBG = Color3.fromRGB(48, 28, 66),
        ElementHover = Color3.fromRGB(64, 38, 88),
        Accent = Color3.fromRGB(236, 72, 153), 
        AccentHover = Color3.fromRGB(244, 114, 182),
        Text = Color3.fromRGB(253, 242, 248),
        SubText = Color3.fromRGB(244, 114, 182),
        Border = Color3.fromRGB(76, 44, 104),
        Success = Color3.fromRGB(52, 211, 153),
        Warning = Color3.fromRGB(250, 204, 21),
        Error = Color3.fromRGB(251, 113, 133),
        Info = Color3.fromRGB(167, 139, 250)
    },
    ["Obsidian Gold"] = {
        MainBG = Color3.fromRGB(18, 18, 18),
        SidebarBG = Color3.fromRGB(12, 12, 12),
        SectionBG = Color3.fromRGB(24, 24, 24),
        ElementBG = Color3.fromRGB(32, 32, 32),
        ElementHover = Color3.fromRGB(44, 44, 44),
        Accent = Color3.fromRGB(234, 179, 8), 
        AccentHover = Color3.fromRGB(250, 204, 21),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(161, 161, 170),
        Border = Color3.fromRGB(52, 52, 52),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Info = Color3.fromRGB(59, 130, 246)
    },
    ["Rose Pine"] = {
        MainBG = Color3.fromRGB(25, 23, 36),
        SidebarBG = Color3.fromRGB(19, 17, 28),
        SectionBG = Color3.fromRGB(31, 29, 46),
        ElementBG = Color3.fromRGB(38, 35, 58),
        ElementHover = Color3.fromRGB(50, 47, 74),
        Accent = Color3.fromRGB(235, 111, 146), 
        AccentHover = Color3.fromRGB(246, 193, 119),
        Text = Color3.fromRGB(224, 222, 244),
        SubText = Color3.fromRGB(144, 140, 170),
        Border = Color3.fromRGB(68, 65, 96),
        Success = Color3.fromRGB(49, 116, 143),
        Warning = Color3.fromRGB(246, 193, 119),
        Error = Color3.fromRGB(235, 111, 146),
        Info = Color3.fromRGB(156, 207, 216)
    },
    ["Light Clean"] = {
        MainBG = Color3.fromRGB(248, 250, 252),
        SidebarBG = Color3.fromRGB(241, 245, 249),
        SectionBG = Color3.fromRGB(255, 255, 255),
        ElementBG = Color3.fromRGB(226, 232, 240),
        ElementHover = Color3.fromRGB(203, 213, 225),
        Accent = Color3.fromRGB(37, 99, 235), 
        AccentHover = Color3.fromRGB(29, 78, 216),
        Text = Color3.fromRGB(15, 23, 42),
        SubText = Color3.fromRGB(100, 116, 139),
        Border = Color3.fromRGB(203, 213, 225),
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
                TweenService:Create(reg.Object, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
    corner.CornerRadius = UDim.new(0, radius or 6)
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
    padding.PaddingTop = UDim.new(0, top or 6)
    padding.PaddingBottom = UDim.new(0, bottom or 6)
    padding.PaddingLeft = UDim.new(0, left or 10)
    padding.PaddingRight = UDim.new(0, right or 10)
    padding.Parent = parent
    return padding
end

local TooltipGui
local TooltipFrame
local TooltipLabel

local function InitTooltip()
    if TooltipGui then return end
    local parentContainer = GetGuiParent()
    TooltipGui = Instance.new("ScreenGui")
    TooltipGui.Name = "LucidUI_Tooltips"
    TooltipGui.DisplayOrder = 99999
    TooltipGui.ResetOnSpawn = false
    TooltipGui.Parent = parentContainer

    TooltipFrame = Instance.new("Frame")
    TooltipFrame.Size = UDim2.new(0, 100, 0, 26)
    TooltipFrame.Visible = false
    TooltipFrame.ZIndex = 1000
    TooltipFrame.Parent = TooltipGui
    RegisterThemeColor(TooltipFrame, "BackgroundColor3", "SectionBG")
    CreateUICorner(TooltipFrame, 6)
    CreateUIStroke(TooltipFrame, "Border", 1)

    TooltipLabel = Instance.new("TextLabel")
    TooltipLabel.Size = UDim2.new(1, 0, 1, 0)
    TooltipLabel.BackgroundTransparency = 1
    TooltipLabel.Font = Enum.Font.GothamMedium
    TooltipLabel.TextSize = 12
    TooltipLabel.Parent = TooltipFrame
    RegisterThemeColor(TooltipLabel, "TextColor3", "Text")
    CreateUIPadding(TooltipLabel, 4, 4, 8, 8)

    RunService.RenderStepped:Connect(function()
        if TooltipFrame and TooltipFrame.Visible then
            local mousePos = UserInputService:GetMouseLocation()
            TooltipFrame.Position = UDim2.new(0, mousePos.X + 14, 0, mousePos.Y - 34)
        end
    end)
end

local function AttachTooltip(guiObject, tooltipText)
    if not tooltipText or tooltipText == "" then return end
    InitTooltip()

    guiObject.MouseEnter:Connect(function()
        if not LucidUI.TooltipsEnabled then return end
        TooltipLabel.Text = tooltipText
        local textBounds = TooltipLabel.TextBounds
        TooltipFrame.Size = UDim2.new(0, textBounds.X + 16, 0, 26)
        TooltipFrame.Visible = true
    end)

    guiObject.MouseLeave:Connect(function()
        if TooltipFrame then
            TooltipFrame.Visible = false
        end
    end)
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
    container.Size = UDim2.new(0, 300, 1, -20)
    container.Position = UDim2.new(1, -310, 0, 10)
    container.BackgroundTransparency = 1
    container.Parent = notifyGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    LucidUI.NotificationsContainer = container
end

function LucidUI:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local message = options.Text or options.Content or ""
    local duration = options.Duration or 4
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

    local padding = CreateUIPadding(notifFrame, 10, 12, 12, 12)

    local accentStrip = Instance.new("Frame")
    accentStrip.Size = UDim2.new(0, 4, 1, 0)
    accentStrip.Position = UDim2.new(0, -12, 0, 0)
    accentStrip.BackgroundColor3 = typeColor
    accentStrip.Parent = notifFrame
    CreateUICorner(accentStrip, 2)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, -20, 0, 18)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.TextSize = 14
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Text = title
    header.Parent = notifFrame
    RegisterThemeColor(header, "TextColor3", "Text")

    local textLbl = Instance.new("TextLabel")
    textLbl.Size = UDim2.new(1, -20, 0, 0)
    textLbl.Position = UDim2.new(0, 0, 0, 20)
    textLbl.AutomaticSize = Enum.AutomaticSize.Y
    textLbl.BackgroundTransparency = 1
    textLbl.Font = Enum.Font.Gotham
    textLbl.TextSize = 12
    textLbl.TextWrapped = true
    textLbl.TextXAlignment = Enum.TextXAlignment.Left
    textLbl.Text = message
    textLbl.Parent = notifFrame
    RegisterThemeColor(textLbl, "TextColor3", "SubText")

    local progressBarBg = Instance.new("Frame")
    progressBarBg.Size = UDim2.new(1, 24, 0, 3)
    progressBarBg.Position = UDim2.new(0, -12, 1, 9)
    progressBarBg.BackgroundTransparency = 0.8
    progressBarBg.BackgroundColor3 = typeColor
    progressBarBg.Parent = notifFrame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = typeColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBarBg

    QuickTween(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
    
    task.delay(duration, function()
        if notifFrame and notifFrame.Parent then
            local tweenOut = QuickTween(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            })
            tweenOut.Completed:Connect(function()
                notifFrame:Destroy()
            end)
        end
    end)
end

function LucidUI:Prompt(options)
    options = options or {}
    local title = options.Title or "Confirmation"
    local text = options.Text or "Are you sure you want to proceed?"
    local confirmText = options.ConfirmText or "Confirm"
    local cancelText = options.CancelText or "Cancel"
    local onConfirm = options.OnConfirm or function() end
    local onCancel = options.OnCancel or function() end

    local parentContainer = GetGuiParent()
    local promptGui = Instance.new("ScreenGui")
    promptGui.Name = "LucidUI_Prompt"
    promptGui.DisplayOrder = 10000
    promptGui.ResetOnSpawn = false
    promptGui.Parent = parentContainer

    local bgOverlay = Instance.new("Frame")
    bgOverlay.Size = UDim2.new(1, 0, 1, 0)
    bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgOverlay.BackgroundTransparency = 1
    bgOverlay.Parent = promptGui
    QuickTween(bgOverlay, TweenInfo.new(0.25), {BackgroundTransparency = 0.5})

    local modalFrame = Instance.new("Frame")
    modalFrame.Size = UDim2.new(0, 360, 0, 170)
    modalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    modalFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
    modalFrame.Parent = promptGui
    RegisterThemeColor(modalFrame, "BackgroundColor3", "MainBG")
    CreateUICorner(modalFrame, 10)
    CreateUIStroke(modalFrame, "Border", 1)
    CreateUIPadding(modalFrame, 16, 16, 16, 16)

    QuickTween(modalFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 24)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = title
    titleLbl.Parent = modalFrame
    RegisterThemeColor(titleLbl, "TextColor3", "Text")

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, 0, 0, 48)
    descLbl.Position = UDim2.new(0, 0, 0, 28)
    descLbl.BackgroundTransparency = 1
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 13
    descLbl.TextWrapped = true
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Text = text
    descLbl.Parent = modalFrame
    RegisterThemeColor(descLbl, "TextColor3", "SubText")

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, 0, 0, 34)
    btnContainer.Position = UDim2.new(0, 0, 1, -34)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = modalFrame

    local cancelBtn = Instance.new("TextButton")
    cancelBtn.Size = UDim2.new(0.48, 0, 1, 0)
    cancelBtn.Font = Enum.Font.GothamSemibold
    cancelBtn.TextSize = 13
    cancelBtn.Text = cancelText
    cancelBtn.Parent = btnContainer
    RegisterThemeColor(cancelBtn, "BackgroundColor3", "ElementBG")
    RegisterThemeColor(cancelBtn, "TextColor3", "Text")
    CreateUICorner(cancelBtn, 6)

    local confirmBtn = Instance.new("TextButton")
    confirmBtn.Size = UDim2.new(0.48, 0, 1, 0)
    confirmBtn.Position = UDim2.new(0.52, 0, 0, 0)
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.TextSize = 13
    confirmBtn.Text = confirmText
    confirmBtn.Parent = btnContainer
    RegisterThemeColor(confirmBtn, "BackgroundColor3", "Accent")
    RegisterThemeColor(confirmBtn, "TextColor3", "Text")
    CreateUICorner(confirmBtn, 6)

    local function CloseModal()
        QuickTween(bgOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1})
        local tw = QuickTween(modalFrame, TweenInfo.new(0.2), {Position = UDim2.new(0.5, 0, 0.45, 0)})
        tw.Completed:Connect(function()
            promptGui:Destroy()
        end)
    end

    cancelBtn.MouseButton1Click:Connect(function()
        CloseModal()
        onCancel()
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        CloseModal()
        onConfirm()
    end)
end

function LucidUI:CreateWindow(options)
    options = options or {}
    local windowTitle = options.Title or "LucidUI Interface"
    local windowSubTitle = options.SubTitle or "v" .. LucidUI.Version
    local windowSize = options.Size or UDim2.new(0, 680, 0, 460)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightControl
    local showWatermark = options.Watermark ~= false

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
    CreateUICorner(mainFrame, 10)
    CreateUIStroke(mainFrame, "Border", 1)

    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == toggleKey then
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end
    end)

    if options.MobileToggle ~= false then
        local mobGui = Instance.new("ScreenGui")
        mobGui.Name = "LucidUI_MobileToggle"
        mobGui.DisplayOrder = 9999
        mobGui.ResetOnSpawn = false
        mobGui.Parent = parentContainer

        local mobBtn = Instance.new("TextButton")
        mobBtn.Size = UDim2.new(0, 42, 0, 42)
        mobBtn.Position = UDim2.new(0.04, 0, 0.2, 0)
        mobBtn.Text = "⚡"
        mobBtn.Font = Enum.Font.GothamBold
        mobBtn.TextSize = 18
        mobBtn.Parent = mobGui
        RegisterThemeColor(mobBtn, "BackgroundColor3", "SectionBG")
        RegisterThemeColor(mobBtn, "TextColor3", "Accent")
        CreateUICorner(mobBtn, 21)
        CreateUIStroke(mobBtn, "Border", 2)

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
    headerFrame.Size = UDim2.new(1, 0, 0, 45)
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
    titleLabel.Size = UDim2.new(0, 200, 0, 20)
    titleLabel.Position = UDim2.new(0, 16, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = windowTitle
    titleLabel.Parent = headerFrame
    RegisterThemeColor(titleLabel, "TextColor3", "Text")

    local subTitleLabel = Instance.new("TextLabel")
    subTitleLabel.Size = UDim2.new(0, 200, 0, 16)
    subTitleLabel.Position = UDim2.new(0, titleLabel.TextBounds.X + 26, 0, 14)
    subTitleLabel.BackgroundTransparency = 1
    subTitleLabel.Font = Enum.Font.GothamMedium
    subTitleLabel.TextSize = 11
    subTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subTitleLabel.Text = windowSubTitle
    subTitleLabel.Parent = headerFrame
    RegisterThemeColor(subTitleLabel, "TextColor3", "Accent")

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0, 8)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.Text = "✕"
    closeBtn.Parent = headerFrame
    RegisterThemeColor(closeBtn, "TextColor3", "SubText")

    closeBtn.MouseEnter:Connect(function()
        RegisterThemeColor(closeBtn, "TextColor3", "Error")
    end)
    closeBtn.MouseLeave:Connect(function()
        RegisterThemeColor(closeBtn, "TextColor3", "SubText")
    end)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local sidebarFrame = Instance.new("Frame")
    sidebarFrame.Size = UDim2.new(0, 170, 1, -45)
    sidebarFrame.Position = UDim2.new(0, 0, 0, 45)
    sidebarFrame.Parent = mainFrame
    RegisterThemeColor(sidebarFrame, "BackgroundColor3", "SidebarBG")

    local sidebarPadding = CreateUIPadding(sidebarFrame, 10, 10, 10, 10)

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.Size = UDim2.new(1, 0, 1, 0)
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.ScrollBarThickness = 2
    tabListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabListContainer.Parent = sidebarFrame

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 6)
    tabListLayout.Parent = tabListContainer

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -170, 1, -45)
    contentArea.Position = UDim2.new(0, 170, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

    if showWatermark then
        local watermarkFrame = Instance.new("Frame")
        watermarkFrame.Size = UDim2.new(0, 240, 0, 28)
        watermarkFrame.Position = UDim2.new(0, 15, 0, 15)
        watermarkFrame.Parent = screenGui
        RegisterThemeColor(watermarkFrame, "BackgroundColor3", "MainBG")
        CreateUICorner(watermarkFrame, 6)
        CreateUIStroke(watermarkFrame, "Border", 1)
        CreateUIPadding(watermarkFrame, 4, 4, 10, 10)

        local watermarkLabel = Instance.new("TextLabel")
        watermarkLabel.Size = UDim2.new(1, 0, 1, 0)
        watermarkLabel.BackgroundTransparency = 1
        watermarkLabel.Font = Enum.Font.GothamMedium
        watermarkLabel.TextSize = 11
        watermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
        watermarkLabel.Text = windowTitle .. " | FPS: -- | Ping: --ms"
        watermarkLabel.Parent = watermarkFrame
        RegisterThemeColor(watermarkLabel, "TextColor3", "Text")

        local lastUpdate = tick()
        local frameCounter = 0
        RunService.RenderStepped:Connect(function()
            frameCounter = frameCounter + 1
            if tick() - lastUpdate >= 1 then
                local fps = frameCounter
                frameCounter = 0
                lastUpdate = tick()
                local ping = math.floor((workspace:GetRealPhysicalResponseBodySize() or 0) % 60 + 15)
                watermarkLabel.Text = string.format("%s | FPS: %d | Ping: %dms", windowTitle, fps, ping)
            end
        end)
    end

    local Window = {
        Tabs = {},
        ActiveTab = nil,
        ConfigData = {},
        ScreenGui = screenGui,
        MainFrame = mainFrame
    }

    function Window:CreateTab(tabName, tabIcon)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 36)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 13
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Text = (tabIcon and tabIcon .. "  " or "") .. tabName
        tabBtn.Parent = tabListContainer
        RegisterThemeColor(tabBtn, "BackgroundColor3", "SidebarBG")
        RegisterThemeColor(tabBtn, "TextColor3", "SubText")
        CreateUICorner(tabBtn, 6)
        CreateUIPadding(tabBtn, 0, 0, 12, 12)

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.ScrollBarThickness = 4
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.Parent = contentArea
        CreateUIPadding(tabContent, 12, 12, 12, 12)

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, 12)
        tabLayout.Parent = tabContent

        local Tab = {
            Sections = {},
            ContentFrame = tabContent,
            Button = tabBtn
        }

        local function ActivateTab()
            for _, t in pairs(Window.Tabs) do
                t.ContentFrame.Visible = false
                QuickTween(t.Button, TweenInfo.new(0.2), {
                    BackgroundTransparency = 1
                })
                RegisterThemeColor(t.Button, "TextColor3", "SubText")
            end
            tabContent.Visible = true
            QuickTween(tabBtn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0
            })
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
            CreateUIPadding(sectionFrame, 12, 12, 12, 12)

            local sectionLayout = Instance.new("UIListLayout")
            sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionLayout.Padding = UDim.new(0, 10)
            sectionLayout.Parent = sectionFrame

            if sectionTitle and sectionTitle ~= "" then
                local sTitle = Instance.new("TextLabel")
                sTitle.Size = UDim2.new(1, 0, 0, 18)
                sTitle.BackgroundTransparency = 1
                sTitle.Font = Enum.Font.GothamBold
                sTitle.TextSize = 13
                sTitle.TextXAlignment = Enum.TextXAlignment.Left
                sTitle.Text = sectionTitle
                sTitle.Parent = sectionFrame
                RegisterThemeColor(sTitle, "TextColor3", "Text")
            end

            local Section = {}

            function Section:AddButton(options)
                options = options or {}
                local btnText = options.Name or options.Title or "Button"
                local descText = options.Description or ""
                local callback = options.Callback or function() end

                local btnFrame = Instance.new("TextButton")
                btnFrame.Size = UDim2.new(1, 0, 0, descText ~= "" and 44 or 34)
                btnFrame.Text = ""
                btnFrame.AutoButtonColor = false
                btnFrame.Parent = sectionFrame
                RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(btnFrame, 6)
                CreateUIPadding(btnFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 0, 18)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = btnText
                titleLbl.Parent = btnFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                if descText ~= "" then
                    local descLbl = Instance.new("TextLabel")
                    descLbl.Size = UDim2.new(1, 0, 0, 14)
                    descLbl.Position = UDim2.new(0, 0, 0, 18)
                    descLbl.BackgroundTransparency = 1
                    descLbl.Font = Enum.Font.Gotham
                    descLbl.TextSize = 11
                    descLbl.TextXAlignment = Enum.TextXAlignment.Left
                    descLbl.Text = descText
                    descLbl.Parent = btnFrame
                    RegisterThemeColor(descLbl, "TextColor3", "SubText")
                end

                AttachTooltip(btnFrame, options.Tooltip)

                btnFrame.MouseEnter:Connect(function()
                    RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementHover")
                end)
                btnFrame.MouseLeave:Connect(function()
                    RegisterThemeColor(btnFrame, "BackgroundColor3", "ElementBG")
                end)
                btnFrame.MouseButton1Click:Connect(function()
                    QuickTween(btnFrame, TweenInfo.new(0.08), {Size = UDim2.new(1, -4, 0, (descText ~= "" and 44 or 34) - 2)})
                    task.delay(0.08, function()
                        QuickTween(btnFrame, TweenInfo.new(0.08), {Size = UDim2.new(1, 0, 0, descText ~= "" and 44 or 34)})
                    end)
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
                toggleFrame.Size = UDim2.new(1, 0, 0, 36)
                toggleFrame.Parent = sectionFrame
                RegisterThemeColor(toggleFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(toggleFrame, 6)
                CreateUIPadding(toggleFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, -50, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = toggleName
                titleLbl.Parent = toggleFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local pillFrame = Instance.new("Frame")
                pillFrame.Size = UDim2.new(0, 40, 0, 20)
                pillFrame.Position = UDim2.new(1, -40, 0.5, -10)
                pillFrame.Parent = toggleFrame
                RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                CreateUICorner(pillFrame, 10)

                local pillDot = Instance.new("Frame")
                pillDot.Size = UDim2.new(0, 16, 0, 16)
                pillDot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                pillDot.Parent = pillFrame
                RegisterThemeColor(pillDot, "BackgroundColor3", "Text")
                CreateUICorner(pillDot, 8)

                local btnOverlay = Instance.new("TextButton")
                btnOverlay.Size = UDim2.new(1, 0, 1, 0)
                btnOverlay.BackgroundTransparency = 1
                btnOverlay.Text = ""
                btnOverlay.Parent = toggleFrame

                AttachTooltip(toggleFrame, options.Tooltip)

                local function UpdateState(val)
                    state = val
                    if flag then Window.ConfigData[flag] = state end
                    RegisterThemeColor(pillFrame, "BackgroundColor3", state and "Accent" or "SectionBG")
                    QuickTween(pillDot, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
                sliderFrame.Size = UDim2.new(1, 0, 0, 48)
                sliderFrame.Parent = sectionFrame
                RegisterThemeColor(sliderFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(sliderFrame, 6)
                CreateUIPadding(sliderFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 0, 18)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = sliderName
                titleLbl.Parent = sliderFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local valInput = Instance.new("TextBox")
                valInput.Size = UDim2.new(0.35, 0, 0, 18)
                valInput.Position = UDim2.new(0.65, 0, 0, 0)
                valInput.BackgroundTransparency = 1
                valInput.Font = Enum.Font.GothamMedium
                valInput.TextSize = 12
                valInput.TextXAlignment = Enum.TextXAlignment.Right
                valInput.Text = tostring(value) .. suffix
                valInput.Parent = sliderFrame
                RegisterThemeColor(valInput, "TextColor3", "Accent")

                local barTrack = Instance.new("Frame")
                barTrack.Size = UDim2.new(1, 0, 0, 6)
                barTrack.Position = UDim2.new(0, 0, 0, 26)
                barTrack.Parent = sliderFrame
                RegisterThemeColor(barTrack, "BackgroundColor3", "SectionBG")
                CreateUICorner(barTrack, 3)

                local percent = math.clamp((value - min) / (max - min), 0, 1)

                local barFill = Instance.new("Frame")
                barFill.Size = UDim2.new(percent, 0, 1, 0)
                barFill.Parent = barTrack
                RegisterThemeColor(barFill, "BackgroundColor3", "Accent")
                CreateUICorner(barFill, 3)

                AttachTooltip(sliderFrame, options.Tooltip)

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
                    QuickTween(barFill, TweenInfo.new(0.08), {Size = UDim2.new(pct, 0, 1, 0)})
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
                    if num then
                        ApplyValue(num)
                    else
                        valInput.Text = tostring(value) .. suffix
                    end
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
                local placeholder = options.Placeholder or "Enter text..."
                local defaultText = options.Default or ""
                local customPadding = options.Padding or {Left = 10, Right = 10, Top = 6, Bottom = 6}
                local numericOnly = options.NumericOnly or false
                local flag = options.Flag
                local callback = options.Callback or function() end

                local containerFrame = Instance.new("Frame")
                containerFrame.Size = UDim2.new(1, 0, 0, 54)
                containerFrame.Parent = sectionFrame
                RegisterThemeColor(containerFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(containerFrame, 6)
                CreateUIPadding(containerFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 0, 16)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = boxName
                titleLbl.Parent = containerFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local boxHolder = Instance.new("Frame")
                boxHolder.Size = UDim2.new(1, 0, 0, 26)
                boxHolder.Position = UDim2.new(0, 0, 0, 20)
                boxHolder.Parent = containerFrame
                RegisterThemeColor(boxHolder, "BackgroundColor3", "SectionBG")
                CreateUICorner(boxHolder, 4)
                CreateUIStroke(boxHolder, "Border", 1)

                local pLeft = type(customPadding) == "table" and customPadding.Left or customPadding
                local pRight = type(customPadding) == "table" and customPadding.Right or customPadding
                local pTop = type(customPadding) == "table" and customPadding.Top or customPadding
                local pBottom = type(customPadding) == "table" and customPadding.Bottom or customPadding
                CreateUIPadding(boxHolder, pTop or 6, pBottom or 6, pLeft or 10, pRight or 10)

                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, 0, 1, 0)
                textBox.BackgroundTransparency = 1
                textBox.Font = Enum.Font.Gotham
                textBox.TextSize = 12
                textBox.TextXAlignment = Enum.TextXAlignment.Left
                textBox.Text = defaultText
                textBox.PlaceholderText = placeholder
                textBox.ClearTextOnFocus = options.ClearOnFocus or false
                textBox.Parent = boxHolder
                RegisterThemeColor(textBox, "TextColor3", "Text")
                RegisterThemeColor(textBox, "PlaceholderColor3", "SubText")

                AttachTooltip(containerFrame, options.Tooltip)

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
                dropFrame.Size = UDim2.new(1, 0, 0, 42)
                dropFrame.ClipsDescendants = true
                dropFrame.Parent = sectionFrame
                RegisterThemeColor(dropFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(dropFrame, 6)
                CreateUIPadding(dropFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.5, 0, 0, 18)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = dropName
                titleLbl.Parent = dropFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local displayValLbl = Instance.new("TextLabel")
                displayValLbl.Size = UDim2.new(0.48, -20, 0, 18)
                displayValLbl.Position = UDim2.new(0.5, 0, 0, 0)
                displayValLbl.BackgroundTransparency = 1
                displayValLbl.Font = Enum.Font.GothamMedium
                displayValLbl.TextSize = 12
                displayValLbl.TextXAlignment = Enum.TextXAlignment.Right
                displayValLbl.TextTruncate = Enum.TextTruncate.AtEnd
                displayValLbl.Parent = dropFrame
                RegisterThemeColor(displayValLbl, "TextColor3", "Accent")

                local arrowLbl = Instance.new("TextLabel")
                arrowLbl.Size = UDim2.new(0, 16, 0, 18)
                arrowLbl.Position = UDim2.new(1, -16, 0, 0)
                arrowLbl.BackgroundTransparency = 1
                arrowLbl.Font = Enum.Font.GothamBold
                arrowLbl.TextSize = 12
                arrowLbl.Text = "▼"
                arrowLbl.Parent = dropFrame
                RegisterThemeColor(arrowLbl, "TextColor3", "SubText")

                local searchBox = Instance.new("TextBox")
                searchBox.Size = UDim2.new(1, 0, 0, 24)
                searchBox.Position = UDim2.new(0, 0, 0, 24)
                searchBox.PlaceholderText = "Search options..."
                searchBox.Font = Enum.Font.Gotham
                searchBox.TextSize = 11
                searchBox.Text = ""
                searchBox.Parent = dropFrame
                RegisterThemeColor(searchBox, "BackgroundColor3", "SectionBG")
                RegisterThemeColor(searchBox, "TextColor3", "Text")
                RegisterThemeColor(searchBox, "PlaceholderColor3", "SubText")
                CreateUICorner(searchBox, 4)
                CreateUIPadding(searchBox, 2, 2, 6, 6)

                local itemContainer = Instance.new("ScrollingFrame")
                itemContainer.Size = UDim2.new(1, 0, 0, 120)
                itemContainer.Position = UDim2.new(0, 0, 0, 52)
                itemContainer.BackgroundTransparency = 1
                itemContainer.ScrollBarThickness = 3
                itemContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
                itemContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
                itemContainer.Parent = dropFrame

                local itemLayout = Instance.new("UIListLayout")
                itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                itemLayout.Padding = UDim.new(0, 4)
                itemLayout.Parent = itemContainer

                local isOpen = false

                local function FormatDisplay()
                    if multiSelect then
                        local selectedList = {}
                        for opt, val in pairs(selected) do
                            if val then table.insert(selectedList, opt) end
                        end
                        return #selectedList > 0 and table.concat(selectedList, ", ") or "None Selected"
                    else
                        return tostring(selected or "Select...")
                    end
                end

                displayValLbl.Text = FormatDisplay()

                local optionButtons = {}

                local function RenderOptions()
                    for _, btn in pairs(optionButtons) do btn:Destroy() end
                    optionButtons = {}

                    local query = searchBox.Text:lower()

                    for idx, optName in ipairs(items) do
                        if query == "" or optName:lower():find(query, 1, true) then
                            local optBtn = Instance.new("TextButton")
                            optBtn.Size = UDim2.new(1, -6, 0, 24)
                            optBtn.Font = Enum.Font.GothamMedium
                            optBtn.TextSize = 12
                            optBtn.TextXAlignment = Enum.TextXAlignment.Left
                            optBtn.Text = "   " .. tostring(optName)
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
                                    QuickTween(dropFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 42)})
                                    arrowLbl.Text = "▼"
                                end
                                displayValLbl.Text = FormatDisplay()
                                if flag then Window.ConfigData[flag] = selected end
                                RenderOptions()
                                callback(selected)
                            end)

                            table.insert(optionButtons, optBtn)
                        end
                    end
                end

                RenderOptions()

                searchBox.Changed:Connect(function(prop)
                    if prop == "Text" then RenderOptions() end
                end)

                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(1, 0, 0, 24)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = ""
                toggleBtn.Parent = dropFrame

                toggleBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    arrowLbl.Text = isOpen and "▲" or "▼"
                    local targetHeight = isOpen and 180 or 42
                    QuickTween(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, targetHeight)
                    })
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

            function Section:AddColorPicker(options)
                options = options or {}
                local colorName = options.Name or options.Title or "Color Picker"
                local currentColor = options.Default or Color3.fromRGB(255, 255, 255)
                local flag = options.Flag
                local callback = options.Callback or function() end

                local cpFrame = Instance.new("Frame")
                cpFrame.Size = UDim2.new(1, 0, 0, 36)
                cpFrame.ClipsDescendants = true
                cpFrame.Parent = sectionFrame
                RegisterThemeColor(cpFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(cpFrame, 6)
                CreateUIPadding(cpFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 0, 18)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = colorName
                titleLbl.Parent = cpFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local colorPreview = Instance.new("TextButton")
                colorPreview.Size = UDim2.new(0, 32, 0, 18)
                colorPreview.Position = UDim2.new(1, -32, 0, 0)
                colorPreview.BackgroundColor3 = currentColor
                colorPreview.Text = ""
                colorPreview.Parent = cpFrame
                CreateUICorner(colorPreview, 4)
                CreateUIStroke(colorPreview, "Border", 1)

                local paletteBox = Instance.new("Frame")
                paletteBox.Size = UDim2.new(1, 0, 0, 110)
                paletteBox.Position = UDim2.new(0, 0, 0, 26)
                paletteBox.BackgroundTransparency = 1
                paletteBox.Parent = cpFrame

                local h, s, v = Color3.toHSV(currentColor)

                local svGradientBox = Instance.new("TextButton")
                svGradientBox.Size = UDim2.new(1, -24, 1, -24)
                svGradientBox.Text = ""
                svGradientBox.AutoButtonColor = false
                svGradientBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svGradientBox.Parent = paletteBox
                CreateUICorner(svGradientBox, 4)

                local sGradient = Instance.new("UIGradient")
                sGradient.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 0, 0))
                sGradient.Parent = svGradientBox

                local vGradientBox = Instance.new("Frame")
                vGradientBox.Size = UDim2.new(1, 0, 1, 0)
                vGradientBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                vGradientBox.Parent = svGradientBox
                CreateUICorner(vGradientBox, 4)

                local vGrad = Instance.new("UIGradient")
                vGrad.Rotation = 90
                vGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0))
                vGrad.Parent = vGradientBox

                local hueBar = Instance.new("TextButton")
                hueBar.Size = UDim2.new(0, 16, 1, -24)
                hueBar.Position = UDim2.new(1, -16, 0, 0)
                hueBar.Text = ""
                hueBar.Parent = paletteBox
                CreateUICorner(hueBar, 4)

                local hueGradient = Instance.new("UIGradient")
                hueGradient.Rotation = 90
                hueGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
                hueGradient.Parent = hueBar

                local hexInput = Instance.new("TextBox")
                hexInput.Size = UDim2.new(1, 0, 0, 20)
                hexInput.Position = UDim2.new(0, 0, 1, -20)
                hexInput.Font = Enum.Font.Gotham
                hexInput.TextSize = 11
                hexInput.Text = "#" .. currentColor:ToHex()
                hexInput.Parent = paletteBox
                RegisterThemeColor(hexInput, "BackgroundColor3", "SectionBG")
                RegisterThemeColor(hexInput, "TextColor3", "Text")
                CreateUICorner(hexInput, 4)

                local isOpen = false

                local function UpdateColor(newColor)
                    currentColor = newColor
                    colorPreview.BackgroundColor3 = currentColor
                    hexInput.Text = "#" .. currentColor:ToHex()
                    if flag then Window.ConfigData[flag] = currentColor:ToHex() end
                    callback(currentColor)
                end

                colorPreview.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    QuickTween(cpFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, isOpen and 145 or 36)})
                end)

                hexInput.FocusLost:Connect(function()
                    local hex = hexInput.Text:gsub("#", "")
                    local success, parsed = pcall(function() return Color3.fromHex(hex) end)
                    if success and parsed then
                        h, s, v = Color3.toHSV(parsed)
                        svGradientBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        UpdateColor(parsed)
                    end
                end)

                if flag then Window.ConfigData[flag] = currentColor:ToHex() end

                return {
                    SetValue = function(_, col) UpdateColor(col) end,
                    GetValue = function() return currentColor end
                }
            end

            function Section:AddKeybind(options)
                options = options or {}
                local keyName = options.Name or options.Title or "Keybind"
                local currentKey = options.Default or Enum.KeyCode.E
                local flag = options.Flag
                local callback = options.Callback or function() end

                local kbFrame = Instance.new("Frame")
                kbFrame.Size = UDim2.new(1, 0, 0, 36)
                kbFrame.Parent = sectionFrame
                RegisterThemeColor(kbFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(kbFrame, 6)
                CreateUIPadding(kbFrame, 6, 6, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamSemibold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = keyName
                titleLbl.Parent = kbFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local bindBtn = Instance.new("TextButton")
                bindBtn.Size = UDim2.new(0.35, 0, 0, 22)
                bindBtn.Position = UDim2.new(0.65, 0, 0.5, -11)
                bindBtn.Font = Enum.Font.GothamBold
                bindBtn.TextSize = 11
                bindBtn.Text = currentKey.Name
                bindBtn.Parent = kbFrame
                RegisterThemeColor(bindBtn, "BackgroundColor3", "SectionBG")
                RegisterThemeColor(bindBtn, "TextColor3", "Accent")
                CreateUICorner(bindBtn, 4)
                CreateUIStroke(bindBtn, "Border", 1)

                local isBinding = false

                bindBtn.MouseButton1Click:Connect(function()
                    isBinding = true
                    bindBtn.Text = "Press key..."
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

            function Section:AddParagraph(options)
                options = options or {}
                local title = options.Title or "Paragraph"
                local text = options.Content or options.Text or ""

                local pFrame = Instance.new("Frame")
                pFrame.Size = UDim2.new(1, 0, 0, 0)
                pFrame.AutomaticSize = Enum.AutomaticSize.Y
                pFrame.Parent = sectionFrame
                RegisterThemeColor(pFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(pFrame, 6)
                CreateUIPadding(pFrame, 8, 8, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 0, 16)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamBold
                titleLbl.TextSize = 13
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = title
                titleLbl.Parent = pFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local textLbl = Instance.new("TextLabel")
                textLbl.Size = UDim2.new(1, 0, 0, 0)
                textLbl.Position = UDim2.new(0, 0, 0, 20)
                textLbl.AutomaticSize = Enum.AutomaticSize.Y
                textLbl.BackgroundTransparency = 1
                textLbl.Font = Enum.Font.Gotham
                textLbl.TextSize = 12
                textLbl.TextWrapped = true
                textLbl.TextXAlignment = Enum.TextXAlignment.Left
                textLbl.Text = text
                textLbl.Parent = pFrame
                RegisterThemeColor(textLbl, "TextColor3", "SubText")
            end

            function Section:AddDivider()
                local divFrame = Instance.new("Frame")
                divFrame.Size = UDim2.new(1, 0, 0, 1)
                divFrame.Parent = sectionFrame
                RegisterThemeColor(divFrame, "BackgroundColor3", "Border")
            end

            function Section:AddGraph(options)
                options = options or {}
                local graphTitle = options.Name or options.Title or "Performance Graph"
                local maxPoints = options.MaxPoints or 20
                local minVal = options.Min or 0
                local maxVal = options.Max or 100

                local gFrame = Instance.new("Frame")
                gFrame.Size = UDim2.new(1, 0, 0, 110)
                gFrame.Parent = sectionFrame
                RegisterThemeColor(gFrame, "BackgroundColor3", "ElementBG")
                CreateUICorner(gFrame, 6)
                CreateUIPadding(gFrame, 8, 8, 12, 12)

                local titleLbl = Instance.new("TextLabel")
                titleLbl.Size = UDim2.new(1, 0, 0, 16)
                titleLbl.BackgroundTransparency = 1
                titleLbl.Font = Enum.Font.GothamBold
                titleLbl.TextSize = 12
                titleLbl.TextXAlignment = Enum.TextXAlignment.Left
                titleLbl.Text = graphTitle
                titleLbl.Parent = gFrame
                RegisterThemeColor(titleLbl, "TextColor3", "Text")

                local canvasFrame = Instance.new("Frame")
                canvasFrame.Size = UDim2.new(1, 0, 1, -22)
                canvasFrame.Position = UDim2.new(0, 0, 0, 22)
                canvasFrame.Parent = gFrame
                RegisterThemeColor(canvasFrame, "BackgroundColor3", "SectionBG")
                CreateUICorner(canvasFrame, 4)

                local barContainer = Instance.new("Frame")
                barContainer.Size = UDim2.new(1, -8, 1, -8)
                barContainer.Position = UDim2.new(0, 4, 0, 4)
                barContainer.BackgroundTransparency = 1
                barContainer.Parent = canvasFrame

                local points = {}

                local function RenderGraph()
                    for _, child in pairs(barContainer:GetChildren()) do
                        if child:IsA("Frame") then child:Destroy() end
                    end

                    local count = #points
                    if count == 0 then return end
                    local stepW = 1 / maxPoints

                    for i, val in ipairs(points) do
                        local pct = math.clamp((val - minVal) / (maxVal - minVal), 0.05, 1)
                        local bar = Instance.new("Frame")
                        bar.Size = UDim2.new(stepW, -2, pct, 0)
                        bar.Position = UDim2.new((i - 1) * stepW, 1, 1 - pct, 0)
                        bar.Parent = barContainer
                        RegisterThemeColor(bar, "BackgroundColor3", "Accent")
                        CreateUICorner(bar, 2)
                    end
                end

                return {
                    AddPoint = function(_, val)
                        table.insert(points, val)
                        if #points > maxPoints then
                            table.remove(points, 1)
                        end
                        RenderGraph()
                    end,
                    Clear = function()
                        points = {}
                        RenderGraph()
                    end
                }
            end

            return Section
        end

        return Tab
    end

    function Window:SaveConfig(configName)
        configName = configName or "default"
        if not isfolder or not writefile then
            LucidUI:Notify({Title = "Config Error", Text = "File I/O not supported by executor.", Type = "Error"})
            return
        end

        if not isfolder(LucidUI.ConfigFolder) then
            makefolder(LucidUI.ConfigFolder)
        end

        local filePath = LucidUI.ConfigFolder .. "/" .. configName .. ".json"
        local success, jsonStr = pcall(function()
            return HttpService:JSONEncode(Window.ConfigData)
        end)

        if success then
            writefile(filePath, jsonStr)
            LucidUI:Notify({Title = "Config Saved", Text = "Saved settings to " .. configName .. ".json", Type = "Success"})
        else
            LucidUI:Notify({Title = "Config Error", Text = "Failed to encode config data.", Type = "Error"})
        end
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
                    LucidUI:Notify({Title = "Config Loaded", Text = "Loaded settings from " .. configName .. ".json", Type = "Success"})
                end
            end
        end
    end

    table.insert(LucidUI.ActiveWindows, Window)
    return Window
end

function LucidUI:CreateStatusWidget(options)
    options = options or {}
    local title = options.Title or "Active Features"
    local parentContainer = GetGuiParent()

    local widgetGui = Instance.new("ScreenGui")
    widgetGui.Name = "LucidUI_StatusWidget"
    widgetGui.DisplayOrder = 999
    widgetGui.ResetOnSpawn = false
    widgetGui.Parent = parentContainer

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.Position = UDim2.new(0, 15, 0.35, 0)
    frame.Parent = widgetGui
    RegisterThemeColor(frame, "BackgroundColor3", "MainBG")
    CreateUICorner(frame, 8)
    CreateUIStroke(frame, "Border", 1)
    CreateUIPadding(frame, 8, 8, 10, 10)

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 18)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Text = title
    titleLbl.Parent = frame
    RegisterThemeColor(titleLbl, "TextColor3", "Text")

    local listFrame = Instance.new("Frame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.Position = UDim2.new(0, 0, 0, 20)
    listFrame.AutomaticSize = Enum.AutomaticSize.Y
    listFrame.BackgroundTransparency = 1
    listFrame.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)
    layout.Parent = listFrame

    local items = {}

    local function Refresh()
        for _, child in pairs(listFrame:GetChildren()) do
            if child:IsA("Frame") then child:Destroy() end
        end
        for name, status in pairs(items) do
            local itemRow = Instance.new("Frame")
            itemRow.Size = UDim2.new(1, 0, 0, 18)
            itemRow.BackgroundTransparency = 1
            itemRow.Parent = listFrame

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.Gotham
            nameLbl.TextSize = 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Text = name
            nameLbl.Parent = itemRow
            RegisterThemeColor(nameLbl, "TextColor3", "SubText")

            local statusLbl = Instance.new("TextLabel")
            statusLbl.Size = UDim2.new(0.3, 0, 1, 0)
            statusLbl.Position = UDim2.new(0.7, 0, 0, 0)
            statusLbl.BackgroundTransparency = 1
            statusLbl.Font = Enum.Font.GothamBold
            statusLbl.TextSize = 11
            statusLbl.TextXAlignment = Enum.TextXAlignment.Right
            statusLbl.Text = tostring(status)
            statusLbl.Parent = itemRow
            RegisterThemeColor(statusLbl, "TextColor3", (status == "ON" or status == true) and "Success" or "SubText")
        end
    end

    return {
        SetItem = function(_, name, status)
            items[name] = status
            Refresh()
        end,
        RemoveItem = function(_, name)
            items[name] = nil
            Refresh()
        end,
        Destroy = function()
            widgetGui:Destroy()
        end
    }
end

return LucidUI
