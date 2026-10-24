-- APIN ANOMALI BLACK & WHITE | Mobile-friendly Roblox GUI
-- Use as a LocalScript in your own Roblox Studio experience.
-- This is a local character-settings UI, not a universal admin tool.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ApinAnomaliGUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "ApinAnomaliGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 16)
    c.Parent = obj
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(90, 190, 110)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.35
    s.Parent = obj
end

local function makeText(parent, text, size, pos, fontSize, color)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = size
    label.Position = pos
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(245,245,245)
    label.TextSize = fontSize or 16
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0.92, 0, 0.72, 0)
panel.Position = UDim2.new(0.04, 0, 0.14, 0)
panel.BackgroundColor3 = Color3.fromRGB(12, 15, 17)
panel.BackgroundTransparency = 0.12
panel.Parent = gui
round(panel, 24)
stroke(panel, Color3.fromRGB(110, 120, 125), 1.2, 0.25)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(300, 360)
sizeLimit.MaxSize = Vector2.new(520, 650)
sizeLimit.Parent = panel

-- Drag by the header (mobile + mouse)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -20, 0, 66)
header.Position = UDim2.new(0, 10, 0, 8)
header.BackgroundColor3 = Color3.fromRGB(25, 28, 31)
header.BackgroundTransparency = 0.12
header.Parent = panel
round(header, 18)

local title = makeText(header, "APIN ANOMALI", UDim2.new(0.58, 0, 0, 28), UDim2.new(0, 16, 0, 7), 20)
title.Font = Enum.Font.GothamBold
local status = makeText(header, "● Ready", UDim2.new(0.4, 0, 0, 20), UDim2.new(0, 16, 0, 37), 13, Color3.fromRGB(225, 225, 225))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 15)
closeBtn.BackgroundColor3 = Color3.fromRGB(55, 58, 62)
closeBtn.Text = "—"
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
round(closeBtn, 18)

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 72, 0, 34)
toggleBtn.Position = UDim2.new(1, -128, 0, 16)
toggleBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
toggleBtn.Text = "OFF"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = header
round(toggleBtn, 18)

local tabs = Instance.new("ScrollingFrame")
tabs.Name = "Tabs"
tabs.Size = UDim2.new(1, -24, 0, 44)
tabs.Position = UDim2.new(0, 12, 0, 84)
tabs.BackgroundColor3 = Color3.fromRGB(35, 38, 42)
tabs.BackgroundTransparency = 0.18
tabs.BorderSizePixel = 0
tabs.ScrollBarThickness = 2
tabs.ScrollingDirection = Enum.ScrollingDirection.X
tabs.CanvasSize = UDim2.new(0, 850, 0, 0)
tabs.Parent = panel
round(tabs, 20)

local tabNames = {"All", "Favs", "Binds", "Custom", "States", "Size", "Others", "Tools", "Theme", "Save"}
local tabButtons = {}
local activeTab = "All"

local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -24, 1, -150)
content.Position = UDim2.new(0, 12, 0, 138)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 420)
content.Parent = panel

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.SortOrder = Enum.SortOrder.LayoutOrder
list.Parent = content

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= list then child:Destroy() end
    end
end

local function addSection(text)
    local label = makeText(content, text, UDim2.new(1, -8, 0, 25), UDim2.new(), 13, Color3.fromRGB(175, 180, 185))
    label.Font = Enum.Font.GothamBold
    label.LayoutOrder = #content:GetChildren()
end

local function addToggle(text, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 58)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    row.BackgroundTransparency = 0.12
    row.LayoutOrder = #content:GetChildren()
    row.Parent = content
    round(row, 17)

    local label = makeText(row, text, UDim2.new(0.72, -12, 1, 0), UDim2.new(0, 14, 0, 0), 14)
    label.TextWrapped = true

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 62, 0, 30)
    btn.Position = UDim2.new(1, -74, 0.5, -15)
    btn.BackgroundColor3 = initial and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(70, 70, 75)
    btn.Text = initial and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = row
    round(btn, 16)

    local state = initial
    btn.Activated:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(70, 70, 75)
        if callback then callback(state) end
    end)
end

local function addSlider(text, minValue, maxValue, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 82)
    row.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    row.BackgroundTransparency = 0.12
    row.LayoutOrder = #content:GetChildren()
    row.Parent = content
    round(row, 17)

    local label = makeText(row, text, UDim2.new(0.7, 0, 0, 24), UDim2.new(0, 14, 0, 9), 14)
    local valueLabel = makeText(row, tostring(defaultValue), UDim2.new(0.25, -8, 0, 24), UDim2.new(0.75, 0, 0, 9), 14, Color3.fromRGB(180, 190, 190))
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(1, -28, 0, 10)
    bar.Position = UDim2.new(0, 14, 0, 51)
    bar.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = row
    round(bar, 8)

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    fill.Size = UDim2.new((defaultValue-minValue)/(maxValue-minValue), 0, 1, 0)
    fill.Parent = bar
    round(fill, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 22, 0, 22)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultValue-minValue)/(maxValue-minValue), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
    knob.Parent = bar
    round(knob, 12)

    local function update(inputX)
        local alpha = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minValue + (maxValue-minValue)*alpha + 0.5)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end
    bar.Activated:Connect(function()
        update(UserInputService:GetMouseLocation().X)
    end)
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(input.Position.X)
        end
    end)
end

local function addButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 46)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = #content:GetChildren()
    btn.Parent = content
    round(btn, 14)
    btn.Activated:Connect(function() if callback then callback(btn) end end)
    return btn
end

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local speedValue, jumpValue = 16, 50
-- These tools are intended for development/testing in your own experience.
local featureState = {fly=false, noclip=false, esp=false}
local savedSettings = {speed=16, jump=50, theme=1, fly=false, noclip=false, esp=false}
local themeIndex = 1
-- Forward-declare because applyTheme() is defined before the floating launcher.
local floatingButton
local themes = {
    {name="Black", panel=Color3.fromRGB(10,10,12), accent=Color3.fromRGB(245,245,245)},
    {name="Graphite", panel=Color3.fromRGB(20,20,23), accent=Color3.fromRGB(220,220,220)},
    {name="Silver", panel=Color3.fromRGB(28,28,32), accent=Color3.fromRGB(200,200,200)},
    {name="White", panel=Color3.fromRGB(35,35,38), accent=Color3.fromRGB(255,255,255)},
}
local flyVelocity, flyGyro, flyAttachment
local flyVerticalInput = 0
local flyControls
local highlights = {}
local originalCollision = {}
local featureConnections = {}

local function stopFly()
    featureState.fly = false
    if flyVelocity then flyVelocity:Destroy(); flyVelocity=nil end
    if flyGyro then flyGyro:Destroy(); flyGyro=nil end
    if flyAttachment then flyAttachment:Destroy(); flyAttachment=nil end
    local h = getHumanoid()
    if h then h.PlatformStand = false end
    if flyControls then flyControls.Visible = false end
end

local function startFly()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local h = getHumanoid()
    if not root or not h then status.Text = "● Character not ready"; return false end
    stopFly()
    featureState.fly = true
    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "ApinFlyAttachment"
    flyAttachment.Parent = root
    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "ApinFlyVelocity"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.MaxForce = 100000
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    flyVelocity.Parent = root
    flyGyro = Instance.new("AlignOrientation")
    flyGyro.Name = "ApinFlyOrientation"
    flyGyro.Attachment0 = flyAttachment
    flyGyro.MaxTorque = 100000
    flyGyro.Responsiveness = 15
    flyGyro.Parent = root
    h:ChangeState(Enum.HumanoidStateType.Freefall)
    -- On-screen vertical controls for touch devices.
    if UserInputService.TouchEnabled then
        if not flyControls then
            flyControls = Instance.new("Frame")
            flyControls.Name = "FlyTouchControls"
            flyControls.Size = UDim2.new(0, 148, 0, 52)
            flyControls.Position = UDim2.new(1, -164, 1, -180)
            flyControls.BackgroundTransparency = 1
            flyControls.Parent = gui
            local function makeFlyButton(label, x, direction)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 68, 0, 48)
                b.Position = UDim2.new(0, x, 0, 0)
                b.BackgroundColor3 = themes[themeIndex].accent
                b.BackgroundTransparency = 0.08
                b.Text = label
                b.TextColor3 = Color3.new(1,1,1)
                b.TextSize = 18
                b.Font = Enum.Font.GothamBold
                b.Parent = flyControls
                round(b, 15)
                b.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then flyVerticalInput = direction end
                end)
                b.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then flyVerticalInput = 0 end
                end)
            end
            makeFlyButton("▲", 0, 1)
            makeFlyButton("▼", 78, -1)
        end
        flyControls.Visible = true
    end
    status.Text = UserInputService.TouchEnabled and "● Fly ON: use ▲/▼ + move stick" or "● Fly ON: move + Space/Ctrl"
    return true
end

local function setNoclip(on)
    featureState.noclip = on
    if not on then
        for part, canCollide in pairs(originalCollision) do
            if part and part.Parent then part.CanCollide = canCollide end
        end
        table.clear(originalCollision)
    end
end

local function clearHighlights()
    for target, highlight in pairs(highlights) do
        if highlight then highlight:Destroy() end
        highlights[target] = nil
    end
end

local function setESP(on)
    featureState.esp = on
    clearHighlights()
    if not on then return end
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            local hl = Instance.new("Highlight")
            hl.Name = "ApinPlayerHighlight"
            hl.FillColor = themes[themeIndex].accent
            hl.OutlineColor = Color3.new(1,1,1)
            hl.FillTransparency = 0.65
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = target.Character
            hl.Parent = gui
            highlights[target] = hl
        end
    end
end

local function applyTheme()
    local t = themes[themeIndex]
    panel.BackgroundColor3 = t.panel
    toggleBtn.BackgroundColor3 = t.accent
    if floatingButton then floatingButton.BackgroundColor3 = t.panel end
    for name, b in pairs(tabButtons) do
        b.BackgroundColor3 = (name == activeTab) and t.accent or Color3.fromRGB(32,32,36)
    end
    if flyControls then
        for _, child in ipairs(flyControls:GetChildren()) do if child:IsA("TextButton") then child.BackgroundColor3 = t.accent end end
    end
    if featureState.esp then setESP(true) end
end

-- Character movement updates; server-side validation should be used in production.
RunService.Heartbeat:Connect(function()
    local character = player.Character
    if featureState.noclip and character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollision[part] == nil then originalCollision[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    end
    if featureState.fly and flyVelocity and character then
        local root = character:FindFirstChild("HumanoidRootPart")
        local h = getHumanoid()
        if root and h then
            local camera = Workspace.CurrentCamera
            local move = h.MoveDirection
            local vertical = flyVerticalInput
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or h.Jump then vertical = 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then vertical = -1 end
            local forward = camera and camera.CFrame.LookVector or root.CFrame.LookVector
            local right = camera and camera.CFrame.RightVector or root.CFrame.RightVector
            local horizontal = Vector3.new(move.X, 0, move.Z)
            flyVelocity.VectorVelocity = horizontal * 38 + Vector3.new(0, vertical * 32, 0)
            if camera then flyGyro.CFrame = CFrame.lookAt(root.Position, root.Position + forward) end
        else
            stopFly()
        end
    end
end)

Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        task.wait(1)
        if featureState.esp and target ~= player then setESP(true) end
    end)
end)
Players.PlayerRemoving:Connect(function(target)
    if highlights[target] then highlights[target]:Destroy(); highlights[target]=nil end
end)

local function buildTab(tab)
    activeTab = tab
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = (name == tab) and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(32, 32, 36)
        button.TextColor3 = Color3.fromRGB(245,245,245)
    end
    clearContent()
    if tab == "All" or tab == "Custom" or tab == "States" then
        addSection("MOVEMENT")
        addSlider("WalkSpeed", 8, 60, speedValue, function(value)
            speedValue = value
            local h = getHumanoid()
            if h then h.WalkSpeed = value end
        end)
        addSlider("JumpPower", 20, 120, jumpValue, function(value)
            jumpValue = value
            local h = getHumanoid()
            if h then h.UseJumpPower = true; h.JumpPower = value end
        end)
        addToggle("Reset movement settings", false, function(on)
            if on then
                speedValue, jumpValue = 16, 50
                local h = getHumanoid()
                if h then h.WalkSpeed = 16; h.UseJumpPower = true; h.JumpPower = 50 end
                task.delay(0.15, function()
                    if activeTab == tab then buildTab(tab) end
                end)
            end
        end)
    elseif tab == "Favs" then
        addSection("FAVORITES")
        addToggle("Keep movement settings visible", true, function() end)
    elseif tab == "Binds" then
        addSection("CONTROLS")
        addToggle("Show keyboard-bind info", false, function(on)
            status.Text = on and "● Keyboard: RightShift" or "● Ready"
        end)
    elseif tab == "Size" then
        addSection("PANEL SIZE")
        addSlider("Panel width", 300, 520, 420, function(value)
            panel.Size = UDim2.new(0, value, panel.Size.Y.Scale, panel.Size.Y.Offset)
            panel.Position = UDim2.new(0.5, -value/2, panel.Position.Y.Scale, panel.Position.Y.Offset)
        end)
    elseif tab == "Tools" then
        addSection("DEVELOPMENT TOOLS — YOUR OWN EXPERIENCE")
        addToggle("Fly Mode (WASD / move stick, Space to rise, Ctrl/C to descend)", featureState.fly, function(on)
            if on then if not startFly() then featureState.fly=false end else stopFly() end
        end)
        addToggle("Noclip (disable character collisions)", featureState.noclip, function(on) setNoclip(on) end)
        addToggle("Player ESP / Highlight", featureState.esp, function(on) setESP(on) end)
        addButton("Teleport to nearest SpawnLocation", function()
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local spawn, bestDistance
            if root then
                for _, item in ipairs(Workspace:GetDescendants()) do
                    if item:IsA("SpawnLocation") then
                        local distance = (item.Position - root.Position).Magnitude
                        if not bestDistance or distance < bestDistance then spawn, bestDistance = item, distance end
                    end
                end
            end
            if root and spawn then root.CFrame = spawn.CFrame + Vector3.new(0, 4, 0); status.Text = "● Teleported to nearest spawn"
            else status.Text = "● No SpawnLocation found" end
        end)
        addSection("SPEED PRESETS")
        addButton("WalkSpeed: 16 (Default)", function() speedValue=16; local h=getHumanoid(); if h then h.WalkSpeed=16 end; status.Text="● Speed 16"; buildTab("Tools") end)
        addButton("WalkSpeed: 24", function() speedValue=24; local h=getHumanoid(); if h then h.WalkSpeed=24 end; status.Text="● Speed 24"; buildTab("Tools") end)
        addButton("WalkSpeed: 32", function() speedValue=32; local h=getHumanoid(); if h then h.WalkSpeed=32 end; status.Text="● Speed 32"; buildTab("Tools") end)
    elseif tab == "Theme" then
        addSection("APPEARANCE")
        addButton("Current theme: " .. themes[themeIndex].name .. " — tap to cycle", function()
            themeIndex = themeIndex % #themes + 1
            applyTheme()
            status.Text = "● Theme: " .. themes[themeIndex].name
            buildTab("Theme")
        end)
        addButton("Refresh player highlights", function() if featureState.esp then setESP(true) end; status.Text="● Highlights refreshed" end)
    elseif tab == "Save" then
        addSection("SESSION SETTINGS")
        addButton("Save current settings (this session)", function()
            local h = getHumanoid()
            savedSettings.speed = h and h.WalkSpeed or speedValue
            savedSettings.jump = h and h.JumpPower or jumpValue
            savedSettings.theme = themeIndex
            savedSettings.fly = featureState.fly
            savedSettings.noclip = featureState.noclip
            savedSettings.esp = featureState.esp
            status.Text = "● Saved until this UI/server session ends"
        end)
        addButton("Load saved settings", function()
            speedValue, jumpValue, themeIndex = savedSettings.speed, savedSettings.jump, savedSettings.theme
            if savedSettings.fly and not featureState.fly then startFly() elseif not savedSettings.fly then stopFly() end
            setNoclip(savedSettings.noclip)
            setESP(savedSettings.esp)
            local h = getHumanoid()
            if h then h.WalkSpeed=speedValue; h.UseJumpPower=true; h.JumpPower=jumpValue end
            applyTheme()
            status.Text = "● Session settings loaded"
            buildTab("Save")
        end)
        addButton("Reset settings", function()
            speedValue, jumpValue, themeIndex = 16, 50, 1
            stopFly(); setNoclip(false); setESP(false)
            local h = getHumanoid()
            if h then h.WalkSpeed=16; h.UseJumpPower=true; h.JumpPower=50 end
            applyTheme(); status.Text="● Settings reset"; buildTab("Save")
        end)
        addSection("NOTE")
        local note = makeText(content, "Save/Load menyimpan pengaturan selama sesi UI ini saja. Penyimpanan permanen lintas server perlu Script server + DataStoreService di experience milikmu.", UDim2.new(1, -8, 0, 62), UDim2.new(), 12, Color3.fromRGB(205,205,205))
        note.TextWrapped = true
        note.LayoutOrder = #content:GetChildren()
    elseif tab == "Others" then
        addSection("OTHER OPTIONS")
        addToggle("Show ready status", true, function(on)
            status.Visible = on
        end)
        addToggle("Dark translucent panel", true, function(on)
            panel.BackgroundTransparency = on and 0.12 or 0
        end)
    end
    task.defer(function()
        content.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 12)
    end)
end

for i, name in ipairs(tabNames) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, (name == "Custom" or name == "States" or name == "Others") and 88 or 70, 1, -8)
    b.Position = UDim2.new(0, 5, 0, 4)
    b.BackgroundColor3 = name == "All" and Color3.fromRGB(235,235,235) or Color3.fromRGB(32,32,36)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 13
    b.Font = Enum.Font.GothamMedium
    b.Parent = tabs
    round(b, 15)
    local x = 5
    for j = 1, i-1 do
        x = x + ((tabNames[j] == "Custom" or tabNames[j] == "States" or tabNames[j] == "Others") and 88 or 70) + 6
    end
    b.Position = UDim2.new(0, x, 0, 4)
    tabButtons[name] = b
    b.Activated:Connect(function() buildTab(name) end)
end

-- Floating reopen button (Delta-style launcher)
floatingButton = Instance.new("ImageButton")
floatingButton.Name = "ApinAnomaliFloatingButton"
floatingButton.Size = UDim2.new(0, 44, 0, 44)
floatingButton.Position = UDim2.new(1, -82, 0.5, -29)
floatingButton.BackgroundColor3 = Color3.fromRGB(18, 20, 23)
floatingButton.BackgroundTransparency = 0.05
floatingButton.Image = ""
floatingButton.Visible = false
floatingButton.Parent = gui
round(floatingButton, 30)
stroke(floatingButton, Color3.fromRGB(235, 235, 235), 2, 0.08)

-- Upload the APIN ANOMALI logo to Roblox and replace YOUR_ROBLOX_IMAGE_ID.
-- Roblox GUI images use Roblox asset IDs, not external raw URLs.
local logoMark = Instance.new("ImageLabel")
logoMark.Name = "LogoImage"
logoMark.BackgroundTransparency = 1
logoMark.Size = UDim2.new(1, -4, 1, -4)
logoMark.Position = UDim2.new(0, 2, 0, 2)
logoMark.Image = "rbxassetid://84770670507707"
logoMark.ScaleType = Enum.ScaleType.Crop
logoMark.Parent = floatingButton
round(logoMark, 28)

local minimized = false
closeBtn.Activated:Connect(function()
    minimized = true
    panel.Visible = false
    floatingButton.Visible = true
end)

floatingButton.Activated:Connect(function()
    minimized = false
    panel.Visible = true
    floatingButton.Visible = false
end)

-- Allow the floating launcher to be moved around the screen.
local floatDragging, floatStart, floatPos
floatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        floatDragging = true
        floatStart = input.Position
        floatPos = floatingButton.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if floatDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - floatStart
        floatingButton.Position = UDim2.new(floatPos.X.Scale, floatPos.X.Offset + delta.X, floatPos.Y.Scale, floatPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        floatDragging = false
        floatStart = nil
        floatPos = nil
    end
end)

local enabled = false
toggleBtn.Activated:Connect(function()
    enabled = not enabled
    toggleBtn.Text = enabled and "ON" or "OFF"
    toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(245,245,245) or Color3.fromRGB(55,55,60)
    status.Text = enabled and "● Enabled" or "● Ready"
end)

-- Drag panel using header
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = dragStart or input.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragStart = nil
        startPos = nil
    end
end)

local keyConn = UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
    end
end)

player.CharacterRemoving:Connect(function()
    stopFly()
    setNoclip(false)
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    local h = getHumanoid()
    if h then
        h.WalkSpeed = speedValue
        h.UseJumpPower = true
        h.JumpPower = jumpValue
    end
    if featureState.esp then task.wait(0.5); setESP(true) end
end)

buildTab("All")
