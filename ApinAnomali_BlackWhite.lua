-- =========================================================
-- APIN ANOMALI NEW TAB SYSTEM
-- Replace old tab system from "local tabNames" until
-- BEFORE "-- Floating reopen button"
-- =========================================================

local tabNames = {
    "All",
    "Movement",
    "Visual",
    "Player",
    "Teleport",
    "Settings",
    "Theme",
    "Save"
}

local tabButtons = {}
local activeTab = "All"

-- Mobile horizontal tab scrolling
tabs.ScrollingDirection = Enum.ScrollingDirection.X
tabs.ScrollingEnabled = true
tabs.ScrollBarThickness = 2
tabs.CanvasSize = UDim2.new(0, 0, 0, 0)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 6)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabs

local function updateTabCanvas()
    tabs.CanvasSize = UDim2.new(
        0,
        tabLayout.AbsoluteContentSize.X + 12,
        0,
        0
    )
end

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)

-- =========================================================
-- SAFE HUMANOID HELPERS
-- =========================================================

local function applyMovement()
    local h = getHumanoid()

    if not h then
        return
    end

    h.WalkSpeed = speedValue
    h.UseJumpPower = true
    h.JumpPower = jumpValue
end

local function resetMovement()
    speedValue = 16
    jumpValue = 50
    applyMovement()

    status.Text = "● Movement reset"
end

-- =========================================================
-- TELEPORT HELPERS
-- =========================================================

local function teleportToSpawn()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        status.Text = "● Character not ready"
        return
    end

    local nearestSpawn
    local nearestDistance

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            local distance = (obj.Position - root.Position).Magnitude

            if nearestDistance == nil or distance < nearestDistance then
                nearestDistance = distance
                nearestSpawn = obj
            end
        end
    end

    if nearestSpawn then
        root.CFrame = nearestSpawn.CFrame + Vector3.new(0, 4, 0)
        status.Text = "● Teleported to spawn"
    else
        status.Text = "● SpawnLocation not found"
    end
end

local function teleportToOrigin()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        status.Text = "● Character not ready"
        return
    end

    root.CFrame = CFrame.new(0, 10, 0)
    status.Text = "● Teleported to origin"
end

-- =========================================================
-- CLEAR CONTENT
-- =========================================================

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child ~= list then
            child:Destroy()
        end
    end

    content.CanvasPosition = Vector2.new(0, 0)
end

-- =========================================================
-- TAB BUTTON APPEARANCE
-- =========================================================

local function updateTabButtons()
    local theme = themes[themeIndex]

    for name, button in pairs(tabButtons) do
        if name == activeTab then
            button.BackgroundColor3 = theme.accent
            button.TextColor3 = Color3.fromRGB(20, 20, 20)
        else
            button.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            button.TextColor3 = Color3.fromRGB(240, 240, 240)
        end
    end
end

-- =========================================================
-- BUILD TAB
-- =========================================================

local function buildTab(tab)
    activeTab = tab

    clearContent()
    updateTabButtons()

    -- =====================================================
    -- ALL
    -- =====================================================

    if tab == "All" then

        addSection("MOVEMENT")

        addSlider(
            "WalkSpeed",
            8,
            60,
            speedValue,
            function(value)
                speedValue = value

                local h = getHumanoid()
                if h then
                    h.WalkSpeed = value
                end
            end
        )

        addSlider(
            "JumpPower",
            20,
            120,
            jumpValue,
            function(value)
                jumpValue = value

                local h = getHumanoid()
                if h then
                    h.UseJumpPower = true
                    h.JumpPower = value
                end
            end
        )

        addButton(
            "Reset Movement",
            function()
                resetMovement()
                buildTab("All")
            end
        )

        addSection("PLAYER")

        addToggle(
            "Fly Mode",
            featureState.fly,
            function(on)
                if on then
                    if not startFly() then
                        featureState.fly = false
                    end
                else
                    stopFly()
                end
            end
        )

        addToggle(
            "Noclip",
            featureState.noclip,
            function(on)
                setNoclip(on)
                status.Text = on and "● Noclip ON" or "● Noclip OFF"
            end
        )

        addSection("VISUAL")

        addToggle(
            "Player Highlight",
            featureState.esp,
            function(on)
                setESP(on)
                status.Text = on and "● Highlight ON" or "● Highlight OFF"
            end
        )

        addSection("TELEPORT")

        addButton(
            "Teleport to Spawn",
            teleportToSpawn
        )

        addButton(
            "Teleport to Origin",
            teleportToOrigin
        )

    -- =====================================================
    -- MOVEMENT
    -- =====================================================

    elseif tab == "Movement" then

        addSection("MOVEMENT SETTINGS")

        addSlider(
            "WalkSpeed",
            8,
            100,
            speedValue,
            function(value)
                speedValue = value

                local h = getHumanoid()
                if h then
                    h.WalkSpeed = value
                end

                status.Text = "● WalkSpeed: " .. tostring(value)
            end
        )

        addSlider(
            "JumpPower",
            20,
            150,
            jumpValue,
            function(value)
                jumpValue = value

                local h = getHumanoid()
                if h then
                    h.UseJumpPower = true
                    h.JumpPower = value
                end

                status.Text = "● JumpPower: " .. tostring(value)
            end
        )

        addSection("SPEED PRESETS")

        addButton(
            "Speed 16 — Default",
            function()
                speedValue = 16
                applyMovement()
                status.Text = "● Speed 16"
                buildTab("Movement")
            end
        )

        addButton(
            "Speed 24",
            function()
                speedValue = 24
                applyMovement()
                status.Text = "● Speed 24"
                buildTab("Movement")
            end
        )

        addButton(
            "Speed 32",
            function()
                speedValue = 32
                applyMovement()
                status.Text = "● Speed 32"
                buildTab("Movement")
            end
        )

        addButton(
            "Speed 50",
            function()
                speedValue = 50
                applyMovement()
                status.Text = "● Speed 50"
                buildTab("Movement")
            end
        )

        addButton(
            "Reset Movement",
            function()
                resetMovement()
                buildTab("Movement")
            end
        )

    -- =====================================================
    -- VISUAL
    -- =====================================================

    elseif tab == "Visual" then

        addSection("PLAYER VISUAL")

        addToggle(
            "Player Highlight / ESP",
            featureState.esp,
            function(on)
                setESP(on)

                if on then
                    status.Text = "● Player Highlight ON"
                else
                    status.Text = "● Player Highlight OFF"
                end
            end
        )

        addButton(
            "Refresh Highlights",
            function()
                if featureState.esp then
                    setESP(true)
                    status.Text = "● Highlights refreshed"
                else
                    status.Text = "● Highlight is OFF"
                end
            end
        )

        addSection("DISPLAY")

        addToggle(
            "Show Ready Status",
            true,
            function(on)
                status.Visible = on
            end
        )

        addToggle(
            "Transparent Panel",
            true,
            function(on)
                panel.BackgroundTransparency = on and 0.12 or 0
            end
        )

    -- =====================================================
    -- PLAYER
    -- =====================================================

    elseif tab == "Player" then

        addSection("PLAYER FEATURES")

        addToggle(
            "Fly Mode",
            featureState.fly,
            function(on)
                if on then
                    if not startFly() then
                        featureState.fly = false
                    end
                else
                    stopFly()
                    status.Text = "● Fly OFF"
                end
            end
        )

        addToggle(
            "Noclip",
            featureState.noclip,
            function(on)
                setNoclip(on)

                if on then
                    status.Text = "● Noclip ON"
                else
                    status.Text = "● Noclip OFF"
                end
            end
        )

        addSection("PLAYER RESET")

        addButton(
            "Reset Movement",
            function()
                resetMovement()
                buildTab("Player")
            end
        )

        addButton(
            "Stop Fly",
            function()
                stopFly()
                status.Text = "● Fly stopped"
                buildTab("Player")
            end
        )

        addButton(
            "Disable Noclip",
            function()
                setNoclip(false)
                status.Text = "● Noclip disabled"
                buildTab("Player")
            end
        )

    -- =====================================================
    -- TELEPORT
    -- =====================================================

    elseif tab == "Teleport" then

        addSection("TELEPORT")

        addButton(
            "Teleport to Nearest Spawn",
            teleportToSpawn
        )

        addButton(
            "Teleport to Origin",
            teleportToOrigin
        )

        addSection("INFO")

        local info = makeText(
            content,
            "Teleport buttons work with SpawnLocation objects available in your own Roblox experience.",
            UDim2.new(1, -8, 0, 60),
            UDim2.new(),
            12,
            Color3.fromRGB(205, 205, 205)
        )

        info.TextWrapped = true
        info.LayoutOrder = #content:GetChildren()

    -- =====================================================
    -- SETTINGS
    -- =====================================================

    elseif tab == "Settings" then

        addSection("PANEL SETTINGS")

        addSlider(
            "Panel Width",
            300,
            520,
            math.clamp(panel.AbsoluteSize.X, 300, 520),
            function(value)
                panel.Size = UDim2.new(
                    0,
                    value,
                    panel.Size.Y.Scale,
                    panel.Size.Y.Offset
                )

                panel.Position = UDim2.new(
                    0.5,
                    -value / 2,
                    panel.Position.Y.Scale,
                    panel.Position.Y.Offset
                )

                status.Text = "● Panel width: " .. tostring(value)
            end
        )

        addButton(
            "Reset Panel Size",
            function()
                panel.Size = UDim2.new(0.92, 0, 0.72, 0)
                panel.Position = UDim2.new(0.04, 0, 0.14, 0)

                status.Text = "● Panel size reset"
                buildTab("Settings")
            end
        )

        addSection("STATUS")

        addToggle(
            "Show Status Text",
            true,
            function(on)
                status.Visible = on
            end
        )

    -- =====================================================
    -- THEME
    -- =====================================================

    elseif tab == "Theme" then

        addSection("THEME")

        addButton(
            "Theme: " .. themes[themeIndex].name,
            function()
                themeIndex = themeIndex % #themes + 1

                applyTheme()

                status.Text =
                    "● Theme: " ..
                    themes[themeIndex].name

                buildTab("Theme")
            end
        )

        addButton(
            "Refresh Theme",
            function()
                applyTheme()

                status.Text =
                    "● Theme refreshed"

                buildTab("Theme")
            end
        )

        addSection("AVAILABLE THEMES")

        for _, theme in ipairs(themes) do
            addButton(
                theme.name,
                function()
                    for index, value in ipairs(themes) do
                        if value.name == theme.name then
                            themeIndex = index
                            break
                        end
                    end

                    applyTheme()

                    status.Text =
                        "● Theme: " ..
                        theme.name

                    buildTab("Theme")
                end
            )
        end

    -- =====================================================
    -- SAVE
    -- =====================================================

    elseif tab == "Save" then

        addSection("SESSION SAVE")

        addButton(
            "Save Current Settings",
            function()
                local h = getHumanoid()

                savedSettings.speed =
                    h and h.WalkSpeed or speedValue

                savedSettings.jump =
                    h and h.JumpPower or jumpValue

                savedSettings.theme =
                    themeIndex

                savedSettings.fly =
                    featureState.fly

                savedSettings.noclip =
                    featureState.noclip

                savedSettings.esp =
                    featureState.esp

                status.Text =
                    "● Settings saved"
            end
        )

        addButton(
            "Load Saved Settings",
            function()
                speedValue = savedSettings.speed or 16
                jumpValue = savedSettings.jump or 50
                themeIndex = savedSettings.theme or 1

                if savedSettings.fly then
                    if not featureState.fly then
                        startFly()
                    end
                else
                    stopFly()
                end

                setNoclip(
                    savedSettings.noclip == true
                )

                setESP(
                    savedSettings.esp == true
                )

                applyMovement()
                applyTheme()

                status.Text =
                    "● Settings loaded"

                buildTab("Save")
            end
        )

        addButton(
            "Reset Everything",
            function()
                speedValue = 16
                jumpValue = 50
                themeIndex = 1

                stopFly()
                setNoclip(false)
                setESP(false)

                applyMovement()
                applyTheme()

                status.Text =
                    "● Everything reset"

                buildTab("Save")
            end
        )

        addSection("INFORMATION")

        local note = makeText(
            content,
            "Save/Load berlaku selama sesi UI/server. Penyimpanan permanen membutuhkan DataStoreService pada experience milikmu.",
            UDim2.new(1, -8, 0, 65),
            UDim2.new(),
            12,
            Color3.fromRGB(205, 205, 205)
        )

        note.TextWrapped = true
        note.LayoutOrder = #content:GetChildren()
    end

    -- Update content scrolling size
    task.defer(function()
        content.CanvasSize = UDim2.new(
            0,
            0,
            0,
            list.AbsoluteContentSize.Y + 16
        )
    end)
end

-- =========================================================
-- CREATE TAB BUTTONS
-- =========================================================

for index, name in ipairs(tabNames) do

    local button = Instance.new("TextButton")

    button.Name = "Tab_" .. name
    button.Size = UDim2.new(0, 88, 1, -8)

    button.BackgroundColor3 =
        Color3.fromRGB(32, 32, 36)

    button.Text = name
    button.TextColor3 =
        Color3.fromRGB(240, 240, 240)

    button.TextSize = 13
    button.Font = Enum.Font.GothamMedium
    button.AutoButtonColor = false
    button.LayoutOrder = index

    button.Parent = tabs

    round(button, 15)

    tabButtons[name] = button

    button.Activated:Connect(function()
        buildTab(name)
    end)
end

-- =========================================================
-- FINAL TAB INITIALIZATION
-- =========================================================

updateTabCanvas()
updateTabButtons()
buildTab("All")

-- =========================================================
-- END NEW TAB SYSTEM
-- =========================================================
