 local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService") 

-- ==========================================
-- CLOUD SAVE CREDENTIALS & DEV HUB CONFIG
-- ==========================================
local BIN_ID = "6a5a2d41da38895dfe6aed03"
local API_KEY = "$2a$10$I2M8tTxCkGSEj6ZXLzEp1.8hIKCwOYigbE5NFC4QqqiTLkNj5.MJO"

local developerRegistry = {
    ["THEMYSTICALONE_DJ"] = {Nick = "Kapitan"},
    ["DaSpeed321"] = {Nick = "Xottic"},
    ["JJDA_ONE"] = {Nick = "Josh"},
    ["youreconfusedimpro"] = {Nick = "Josh"}
}

local isDev = false
for devName, _ in pairs(developerRegistry) do
    if player.Name == devName then
        isDev = true
        break
    end
end
-- isDev = true -- Uncomment this line ONLY if testing in Roblox Studio!

local gui = Instance.new("ScreenGui")
gui.Name = "DKScriptsGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local toggleKey = Enum.KeyCode.K -- Moved up so the notification can read it dynamically

-- ==========================================
-- AUDIO & ANIMATION HELPER FUNCTIONS
-- ==========================================
local function playModernSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6042053626"
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    task.delay(2, function() sound:Destroy() end)
end

local function runRealisticLoading(barFill, callback)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    
    local t1 = TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.4, 0, 1, 0)})
    t1:Play()
    
    t1.Completed:Connect(function()
        task.wait(0.5)
        local t2 = TweenService:Create(barFill, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {Size = UDim2.new(0.65, 0, 1, 0)})
        t2:Play()
        
        t2.Completed:Connect(function()
            task.wait(0.2)
            local t3 = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, 0)})
            t3:Play()
            
            t3.Completed:Connect(function()
                playModernSound()
                if callback then callback() end
            end)
        end)
    end)
end

local function makeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==========================================
-- CUSTOM PURPLE CLOSE NOTIFICATION
-- ==========================================
local notifFrame = Instance.new("Frame", gui)
notifFrame.Name = "CloseNotification"
notifFrame.Size = UDim2.new(0, 280, 0, 70)
notifFrame.Position = UDim2.new(1, 50, 0.7, 0)
notifFrame.BackgroundColor3 = Color3.fromRGB(35, 15, 55) 
notifFrame.BorderSizePixel = 0
notifFrame.ZIndex = 100
Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 8)

local notifStroke = Instance.new("UIStroke", notifFrame)
notifStroke.Color = Color3.fromRGB(180, 100, 255) 
notifStroke.Thickness = 2

local notifText = Instance.new("TextLabel", notifFrame)
notifText.Size = UDim2.new(1, -20, 1, 0)
notifText.Position = UDim2.new(0, 10, 0, 0)
notifText.BackgroundTransparency = 1
notifText.TextColor3 = Color3.fromRGB(230, 200, 255)
notifText.Font = Enum.Font.GothamBold
notifText.TextSize = 13
notifText.TextWrapped = true
notifText.ZIndex = 101

local isNotifShowing = false
local function showCloseNotification()
    if isNotifShowing then return end
    isNotifShowing = true
    
    notifText.Text = "Press " .. toggleKey.Name .. " to open Or tap the menu button to open up the lua again."
    
    local slideIn = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 0.7, 0)})
    slideIn:Play()
    
    task.delay(4, function()
        local slideOut = TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 0.7, 0)})
        slideOut:Play()
        slideOut.Completed:Connect(function()
            isNotifShowing = false
        end)
    end)
end

-- ==========================================
-- MOBILE MOD MENU TOGGLE 
-- ==========================================
local dkToggle = Instance.new("TextButton")
dkToggle.Name = "DKToggleButton"
dkToggle.Size = UDim2.new(0, 50, 0, 50)
dkToggle.Position = UDim2.new(0, 20, 0.5, -25)
dkToggle.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
dkToggle.Text = "DK"
dkToggle.TextColor3 = Color3.fromRGB(180, 100, 255)
dkToggle.Font = Enum.Font.GothamBold
dkToggle.TextSize = 22
dkToggle.Visible = false
dkToggle.ZIndex = 50
dkToggle.Parent = gui
Instance.new("UICorner", dkToggle).CornerRadius = UDim.new(1, 0)
makeDraggable(dkToggle)

-- ==========================================
-- PATCH NOTES POPUP
-- ==========================================
local patchNotes = Instance.new("Frame")
patchNotes.Name = "PatchNotesPopup"
patchNotes.Size = UDim2.new(0, 320, 0, 240)
patchNotes.Position = UDim2.new(0.5, 20, 0.5, -120) 
patchNotes.BackgroundColor3 = Color3.fromRGB(30, 25, 35)
patchNotes.BorderSizePixel = 0
patchNotes.ZIndex = 50
patchNotes.Visible = false
patchNotes.Parent = gui

local patchCorner = Instance.new("UICorner")
patchCorner.CornerRadius = UDim.new(0, 12)
patchCorner.Parent = patchNotes

local patchTitle = Instance.new("TextLabel", patchNotes)
patchTitle.Size = UDim2.new(1, -40, 0, 45)
patchTitle.Position = UDim2.new(0, 20, 0, 5)
patchTitle.BackgroundTransparency = 1
patchTitle.Text = "[ UPDATE PATCH NOTES ]"
patchTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
patchTitle.Font = Enum.Font.GothamBold
patchTitle.TextScaled = true
patchTitle.ZIndex = 51

local patchCloseBtn = Instance.new("TextButton", patchNotes)
patchCloseBtn.Size = UDim2.new(0, 30, 0, 30)
patchCloseBtn.Position = UDim2.new(1, -35, 0, 12)
patchCloseBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
patchCloseBtn.Text = "X"
patchCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
patchCloseBtn.Font = Enum.Font.GothamBold
patchCloseBtn.TextSize = 14
patchCloseBtn.ZIndex = 51
Instance.new("UICorner", patchCloseBtn).CornerRadius = UDim.new(0, 6)

local patchBody = Instance.new("TextLabel", patchNotes)
patchBody.Size = UDim2.new(1, -30, 1, -60)
patchBody.Position = UDim2.new(0, 15, 0, 50)
patchBody.BackgroundTransparency = 1
patchBody.Text = "- Mod Menu Toggle (Black DK Circle)!\n\n- Custom Keybinds to toggle UI\n\n- Top-Left 'X' close button added\n\n- Animated Dev Console Startup\n\n- Auto-hides UI after executing script\n\n- Developer Status Network active!"
patchBody.TextColor3 = Color3.fromRGB(215, 175, 255)
patchBody.Font = Enum.Font.GothamBold
patchBody.TextSize = 13
patchBody.TextWrapped = true
patchBody.TextXAlignment = Enum.TextXAlignment.Left
patchBody.TextYAlignment = Enum.TextYAlignment.Top
patchBody.ZIndex = 51

patchCloseBtn.Activated:Connect(function()
    patchNotes.Visible = false
end)
makeDraggable(patchNotes)

-- ==========================================
-- MAIN UI FRAMES
-- ==========================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 340, 0, 280)
main.Position = UDim2.new(0.5, -340, 0.5, -140) 
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main
makeDraggable(main)

-- TOP LEFT X BUTTON
local closeMainBtn = Instance.new("TextButton", main)
closeMainBtn.Size = UDim2.new(0, 32, 0, 32)
closeMainBtn.Position = UDim2.new(0, 8, 0, 9)
closeMainBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeMainBtn.Text = "X"
closeMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeMainBtn.Font = Enum.Font.GothamBold
closeMainBtn.TextSize = 14
Instance.new("UICorner", closeMainBtn).CornerRadius = UDim.new(0, 8)

closeMainBtn.Activated:Connect(function()
    main.Visible = false
    patchNotes.Visible = false
    dkToggle.Visible = true
    showCloseNotification() 
end)

dkToggle.Activated:Connect(function()
    main.Visible = true
    dkToggle.Visible = false
end)

-- LOADING SCREEN
local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(0, 340, 0, 280)
loadingScreen.Position = UDim2.new(0.5, -170, 0.5, -140) 
loadingScreen.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingScreen.Parent = gui
Instance.new("UICorner", loadingScreen).CornerRadius = UDim.new(0, 12)

local loadingTitle = Instance.new("TextLabel", loadingScreen)
loadingTitle.Size = UDim2.new(1, 0, 0, 50)
loadingTitle.Position = UDim2.new(0, 0, 0, 80)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "Loading DK-SCRIPTS..."
loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.TextScaled = true
loadingTitle.Font = Enum.Font.GothamBold

local barBg = Instance.new("Frame", loadingScreen)
barBg.Size = UDim2.new(0, 260, 0, 16)
barBg.Position = UDim2.new(0.5, -130, 0.5, 30)
barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

runRealisticLoading(barFill, function()
    local fadeTween = TweenService:Create(loadingScreen, TweenInfo.new(0.4), {BackgroundTransparency = 1})
    TweenService:Create(loadingTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        loadingScreen.Visible = false
        main.Visible = true
        patchNotes.Visible = true 
    end)
end)

-- ==========================================
-- NAVIGATION ELEMENTS
-- ==========================================
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -90, 0, 50)
title.Position = UDim2.new(0, 85, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DK-SCRIPTS v1.2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local backBtn = Instance.new("TextButton", main)
backBtn.Size = UDim2.new(0, 32, 0, 32)
backBtn.Position = UDim2.new(0, 45, 0, 9) 
backBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
backBtn.Text = "<"
backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backBtn.TextScaled = true
backBtn.Font = Enum.Font.GothamBold
backBtn.Visible = false
Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0, 8)

local startPage = Instance.new("Frame", main)
startPage.Size = UDim2.new(1, 0, 1, -50)
startPage.Position = UDim2.new(0, 0, 0, 50)
startPage.BackgroundTransparency = 1

local settingsPage = Instance.new("Frame", main)
settingsPage.Size = UDim2.new(1, 0, 1, -50)
settingsPage.Position = UDim2.new(0, 0, 0, 50)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false

local gamePage = Instance.new("Frame", main)
gamePage.Size = UDim2.new(1, 0, 1, -50)
gamePage.Position = UDim2.new(0, 0, 0, 50)
gamePage.BackgroundTransparency = 1
gamePage.Visible = false

local settingsBtn = Instance.new("TextButton", startPage)
settingsBtn.Size = UDim2.new(0, 260, 0, 45)
settingsBtn.Position = UDim2.new(0.5, -130, 0, 15)
settingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
settingsBtn.Text = "Open Settings"
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.TextScaled = true
settingsBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, 10)

local startBtn = Instance.new("TextButton", startPage)
startBtn.Size = UDim2.new(0, 260, 0, 45)
startBtn.Position = UDim2.new(0.5, -130, 0, 75)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
startBtn.Text = "Start!"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 10)

local devBtn = Instance.new("TextButton", startPage)
devBtn.Size = UDim2.new(0, 260, 0, 45)
devBtn.Position = UDim2.new(0.5, -130, 0, 135)
devBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
devBtn.Text = "DEVELOPER Console"
devBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
devBtn.TextScaled = true
devBtn.Font = Enum.Font.GothamBold
devBtn.Visible = isDev 
Instance.new("UICorner", devBtn).CornerRadius = UDim.new(0, 10)

-- ==========================================
-- SETTINGS SYSTEM & KEYBIND
-- ==========================================
local killBtn = Instance.new("TextButton", settingsPage)
killBtn.Size = UDim2.new(0, 260, 0, 32)
killBtn.Position = UDim2.new(0.5, -130, 0, 10)
killBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
killBtn.Text = "Kill Script"
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killBtn.Font = Enum.Font.GothamBold
killBtn.TextSize = 16
Instance.new("UICorner", killBtn).CornerRadius = UDim.new(0, 8)

local fpsBtn = Instance.new("TextButton", settingsPage)
fpsBtn.Size = UDim2.new(0, 260, 0, 32)
fpsBtn.Position = UDim2.new(0.5, -130, 0, 52)
fpsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fpsBtn.Text = "Show FPS: OFF"
fpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsBtn.Font = Enum.Font.Gotham
fpsBtn.TextSize = 14
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0, 8)

local pingBtn = Instance.new("TextButton", settingsPage)
pingBtn.Size = UDim2.new(0, 260, 0, 32)
pingBtn.Position = UDim2.new(0.5, -130, 0, 94)
pingBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
pingBtn.Text = "Show Ping: OFF"
pingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pingBtn.Font = Enum.Font.Gotham
pingBtn.TextSize = 14
Instance.new("UICorner", pingBtn).CornerRadius = UDim.new(0, 8)

local gameLabel = Instance.new("TextLabel", settingsPage)
gameLabel.Size = UDim2.new(0, 260, 0, 32)
gameLabel.Position = UDim2.new(0.5, -130, 0, 136)
gameLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
gameLabel.Text = "Game ID: " .. tostring(game.PlaceId)
gameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gameLabel.Font = Enum.Font.Gotham
gameLabel.TextSize = 14
Instance.new("UICorner", gameLabel).CornerRadius = UDim.new(0, 8)

local keybindBtn = Instance.new("TextButton", settingsPage)
keybindBtn.Size = UDim2.new(0, 260, 0, 32)
keybindBtn.Position = UDim2.new(0.5, -130, 0, 178)
keybindBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 180)
keybindBtn.Text = "Toggle Key: " .. toggleKey.Name
keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.TextSize = 14
Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 8)

local listeningForKey = false
keybindBtn.Activated:Connect(function()
    listeningForKey = true
    keybindBtn.Text = "Press any key..."
end)

UIS.InputBegan:Connect(function(input, gpe)
    if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleKey = input.KeyCode
        keybindBtn.Text = "Toggle Key: " .. toggleKey.Name
        listeningForKey = false
        return
    end
    
    if not gpe and input.KeyCode == toggleKey then
        main.Visible = not main.Visible
        dkToggle.Visible = not main.Visible
        patchNotes.Visible = false 
        
        if not main.Visible then
            showCloseNotification()
        end
    end
end)

local overlay = Instance.new("TextLabel", gui)
overlay.Size = UDim2.new(0, 220, 0, 50)
overlay.Position = UDim2.new(0, 10, 0, 10)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.35
overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
overlay.TextScaled = true
overlay.Font = Enum.Font.GothamBold
overlay.Visible = false
Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 8)

local showFPS, showPing, fpsValue, frames, lastUpdate = false, false, 0, 0, tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastUpdate >= 1 then
        fpsValue = frames
        frames = 0
        lastUpdate = tick()
    end
    
    if showFPS or showPing then
        local parts = {}
        if showFPS then table.insert(parts, "FPS: " .. tostring(fpsValue)) end
        if showPing then table.insert(parts, "Ping: " .. tostring(math.floor((player:GetNetworkPing() or 0) * 1000))) end
        overlay.Text = table.concat(parts, "  ")
    end
end)

fpsBtn.Activated:Connect(function()
    showFPS = not showFPS
    fpsBtn.Text = "Show FPS: " .. (showFPS and "ON" or "OFF")
    overlay.Visible = showFPS or showPing
end)

pingBtn.Activated:Connect(function()
    showPing = not showPing
    pingBtn.Text = "Show Ping: " .. (showPing and "ON" or "OFF")
    overlay.Visible = showFPS or showPing
end)

-- ==========================================
-- DEV CONSOLE
-- ==========================================
local consoleMain = Instance.new("Frame", gui)
consoleMain.Size = UDim2.new(0, 480, 0, 340)
consoleMain.Position = UDim2.new(0.5, 190, 0.5, -170)
consoleMain.BackgroundColor3 = Color3.fromRGB(25, 20, 10) 
consoleMain.Visible = false
consoleMain.ClipsDescendants = true
Instance.new("UICorner", consoleMain).CornerRadius = UDim.new(0, 12)
makeDraggable(consoleMain)

local consoleTitle = Instance.new("TextLabel", consoleMain)
consoleTitle.Size = UDim2.new(1, -40, 0, 50)
consoleTitle.Position = UDim2.new(0, 40, 0, 0)
consoleTitle.BackgroundTransparency = 1
consoleTitle.Text = "Welcome Developer!"
consoleTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
consoleTitle.TextScaled = true
consoleTitle.Font = Enum.Font.GothamBold

local consoleBackBtn = Instance.new("TextButton", consoleMain)
consoleBackBtn.Size = UDim2.new(0, 32, 0, 32)
consoleBackBtn.Position = UDim2.new(0, 8, 0, 9)
consoleBackBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 15)
consoleBackBtn.Text = "<"
consoleBackBtn.TextColor3 = Color3.fromRGB(255, 180, 0)
consoleBackBtn.TextScaled = true
consoleBackBtn.Font = Enum.Font.GothamBold
consoleBackBtn.Visible = false
Instance.new("UICorner", consoleBackBtn).CornerRadius = UDim.new(0, 8)

-- DEV CONSOLE LOADING SCREEN
local devLoadingScreen = Instance.new("Frame", consoleMain)
devLoadingScreen.Size = UDim2.new(1, 0, 1, 0)
devLoadingScreen.BackgroundColor3 = Color3.fromRGB(25, 20, 10)
devLoadingScreen.ZIndex = 20
devLoadingScreen.Visible = false

local devLoadingTitle = Instance.new("TextLabel", devLoadingScreen)
devLoadingTitle.Size = UDim2.new(1, 0, 0, 40)
devLoadingTitle.Position = UDim2.new(0, 0, 0.5, -30)
devLoadingTitle.BackgroundTransparency = 1
devLoadingTitle.Text = "Connecting to JSONbin.."
devLoadingTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
devLoadingTitle.Font = Enum.Font.GothamBold
devLoadingTitle.TextSize = 20
devLoadingTitle.ZIndex = 21

local devBarBg = Instance.new("Frame", devLoadingScreen)
devBarBg.Size = UDim2.new(0, 260, 0, 12)
devBarBg.Position = UDim2.new(0.5, -130, 0.5, 20)
devBarBg.BackgroundColor3 = Color3.fromRGB(45, 35, 20)
devBarBg.ZIndex = 21
Instance.new("UICorner", devBarBg).CornerRadius = UDim.new(1, 0)

local devBarFill = Instance.new("Frame", devBarBg)
devBarFill.Size = UDim2.new(0, 0, 1, 0)
devBarFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
devBarFill.ZIndex = 21
Instance.new("UICorner", devBarFill).CornerRadius = UDim.new(1, 0)

local consoleStartPage = Instance.new("Frame", consoleMain)
consoleStartPage.Size = UDim2.new(1, 0, 1, -50)
consoleStartPage.Position = UDim2.new(0, 0, 0, 50)
consoleStartPage.BackgroundTransparency = 1
consoleStartPage.Visible = false

local savedListFrame = Instance.new("Frame", consoleStartPage)
savedListFrame.Size = UDim2.new(0, 250, 1, -20)
savedListFrame.Position = UDim2.new(0, 10, 0, 10)
savedListFrame.BackgroundColor3 = Color3.fromRGB(35, 28, 14)
Instance.new("UICorner", savedListFrame).CornerRadius = UDim.new(0, 8)

local savedList = Instance.new("ScrollingFrame", savedListFrame)
savedList.Size = UDim2.new(1, -10, 1, -10)
savedList.Position = UDim2.new(0, 5, 0, 5)
savedList.BackgroundTransparency = 1
savedList.ScrollBarThickness = 4
savedList.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
savedList.AutomaticCanvasSize = Enum.AutomaticSize.Y 

local listLayout = Instance.new("UIListLayout", savedList)
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local activityFrame = Instance.new("Frame", consoleStartPage)
activityFrame.Size = UDim2.new(0, 200, 1, -20)
activityFrame.Position = UDim2.new(0, 270, 0, 10)
activityFrame.BackgroundColor3 = Color3.fromRGB(35, 28, 14)
Instance.new("UICorner", activityFrame).CornerRadius = UDim.new(0, 8)

local activityTitle = Instance.new("TextLabel", activityFrame)
activityTitle.Size = UDim2.new(1, 0, 0, 25)
activityTitle.BackgroundTransparency = 1
activityTitle.Text = "Developer Activity"
activityTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
activityTitle.Font = Enum.Font.GothamBold
activityTitle.TextSize = 14

local activityList = Instance.new("ScrollingFrame", activityFrame)
activityList.Size = UDim2.new(1, -10, 1, -35)
activityList.Position = UDim2.new(0, 5, 0, 30)
activityList.BackgroundTransparency = 1
activityList.ScrollBarThickness = 2
activityList.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
activityList.AutomaticCanvasSize = Enum.AutomaticSize.Y

local activityLayout = Instance.new("UIListLayout", activityList)
activityLayout.Padding = UDim.new(0, 6)

local function populateActivityWindow()
    for _, child in pairs(activityList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for username, info in pairs(developerRegistry) do
        local row = Instance.new("Frame", activityList)
        row.Size = UDim2.new(1, 0, 0, 35)
        row.BackgroundColor3 = Color3.fromRGB(45, 36, 18)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        
        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0, 10, 0, 10)
        dot.Position = UDim2.new(0, 10, 0.5, -5)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        
        if game.Players:FindFirstChild(username) then
            dot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        else
            if username == "JJDA_ONE" then dot.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            else dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50) end
        end
        
        local nameLabel = Instance.new("TextLabel", row)
        nameLabel.Size = UDim2.new(1, -30, 0, 18)
        nameLabel.Position = UDim2.new(0, 26, 0, 2)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = info.Nick
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local userLabel = Instance.new("TextLabel", row)
        userLabel.Size = UDim2.new(1, -30, 0, 12)
        userLabel.Position = UDim2.new(0, 26, 0, 18)
        userLabel.BackgroundTransparency = 1
        userLabel.Text = "@" .. username
        userLabel.TextColor3 = Color3.fromRGB(180, 140, 60)
        userLabel.Font = Enum.Font.Gotham
        userLabel.TextSize = 10
        userLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
end

-- ADD/EDIT SCRIPT UI
local addScriptPage = Instance.new("Frame", consoleMain)
addScriptPage.Size = UDim2.new(1, 0, 1, -50)
addScriptPage.Position = UDim2.new(0, 0, 0, 50)
addScriptPage.BackgroundTransparency = 1
addScriptPage.Visible = false

-- ANIMATED CONSOLE OPEN
devBtn.Activated:Connect(function()
    if not consoleMain.Visible then
        consoleMain.Size = UDim2.new(0, 0, 0, 0)
        consoleMain.Position = UDim2.new(0.5, 430, 0.5, 0)
        consoleMain.Visible = true
        
        consoleStartPage.Visible = false
        addScriptPage.Visible = false
        devLoadingScreen.Visible = true
        
        devLoadingScreen.BackgroundTransparency = 0
        devLoadingTitle.TextTransparency = 0
        devBarBg.BackgroundTransparency = 0
        devBarFill.BackgroundTransparency = 0
        
        local openTween = TweenService:Create(consoleMain, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 480, 0, 340),
            Position = UDim2.new(0.5, 190, 0.5, -170)
        })
        openTween:Play()
        populateActivityWindow()
        
        openTween.Completed:Connect(function()
            runRealisticLoading(devBarFill, function()
                local fadeOut = TweenService:Create(devLoadingScreen, TweenInfo.new(0.4), {BackgroundTransparency = 1})
                TweenService:Create(devLoadingTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
                TweenService:Create(devBarBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                TweenService:Create(devBarFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    devLoadingScreen.Visible = false
                    consoleStartPage.Visible = true
                end)
            end)
        end)
    else
        local closeTween = TweenService:Create(consoleMain, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 430, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            consoleMain.Visible = false
        end)
    end
end)

local plusBtn = Instance.new("TextButton", consoleStartPage)
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(1, -55, 1, -55) 
plusBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(25, 20, 10)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(1, 0) 

local titleBox = Instance.new("TextBox", addScriptPage)
titleBox.Size = UDim2.new(0, 400, 0, 40)
titleBox.Position = UDim2.new(0.5, -200, 0, 10)
titleBox.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
titleBox.TextColor3 = Color3.fromRGB(255, 180, 0)
titleBox.PlaceholderText = "Save File Title..."
titleBox.Font = Enum.Font.GothamBold
titleBox.TextSize = 16
Instance.new("UICorner", titleBox).CornerRadius = UDim.new(0, 8)

local scriptScroll = Instance.new("ScrollingFrame", addScriptPage)
scriptScroll.Size = UDim2.new(0, 400, 0, 85)
scriptScroll.Position = UDim2.new(0.5, -200, 0, 60)
scriptScroll.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
scriptScroll.ScrollBarThickness = 4
scriptScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", scriptScroll).CornerRadius = UDim.new(0, 8)

local scriptBox = Instance.new("TextBox", scriptScroll)
scriptBox.Size = UDim2.new(1, -10, 0, 0)
scriptBox.Position = UDim2.new(0, 5, 0, 5)
scriptBox.BackgroundTransparency = 1
scriptBox.TextColor3 = Color3.fromRGB(255, 180, 0)
scriptBox.PlaceholderText = "Paste Script Here..."
scriptBox.TextWrapped = true
scriptBox.MultiLine = true
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 14
scriptBox.AutomaticSize = Enum.AutomaticSize.Y 

local idBox = Instance.new("TextBox", addScriptPage)
idBox.Size = UDim2.new(0, 400, 0, 40)
idBox.Position = UDim2.new(0.5, -200, 0, 155)
idBox.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
idBox.TextColor3 = Color3.fromRGB(255, 180, 0)
idBox.PlaceholderText = "Game ID..."
idBox.Font = Enum.Font.Gotham
idBox.TextSize = 14
Instance.new("UICorner", idBox).CornerRadius = UDim.new(0, 8)

local saveBtn = Instance.new("TextButton", addScriptPage)
saveBtn.Size = UDim2.new(0, 190, 0, 45)
saveBtn.Position = UDim2.new(0.5, -200, 0, 210)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
saveBtn.Text = "SAVE"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)

local discardBtn = Instance.new("TextButton", addScriptPage)
discardBtn.Size = UDim2.new(0, 190, 0, 45)
discardBtn.Position = UDim2.new(0.5, 10, 0, 210)
discardBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40) 
discardBtn.Text = "DISCARD"
discardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discardBtn.TextScaled = true
discardBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", discardBtn).CornerRadius = UDim.new(0, 8)

local currentEditingCard = nil 

-- ==========================================
-- GAME DETECTION & EXECUTION
-- ==========================================
local executorRequest = request or http_request or (syn and syn.request) or (http and http.request)

local function CheckForSupportedGame()
    local currentId = tostring(game.PlaceId)
    for _, child in pairs(savedList:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("IdLabel") then
            local savedId = string.gsub(child.IdLabel.Text, "Game ID: ", "")
            if savedId == currentId then
                return child:GetAttribute("SavedScript")
            end
        end
    end
    return nil
end

local function showGameDetected()
    startPage.Visible = false
    settingsPage.Visible = false
    gamePage.Visible = true
    backBtn.Visible = true
    gamePage:ClearAllChildren()
    
    local foundScript = CheckForSupportedGame()

    local label = Instance.new("TextLabel", gamePage)
    label.Size = UDim2.new(0, 260, 0, 40)
    label.Position = UDim2.new(0.5, -130, 0, 15)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    
    if foundScript then
        label.Text = "Game Supported!"
        label.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        label.Text = "Game Not Supported!"
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    local executeBtn = Instance.new("TextButton", gamePage)
    executeBtn.Size = UDim2.new(0, 260, 0, 40)
    executeBtn.Position = UDim2.new(0.5, -130, 0, 70)
    executeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    executeBtn.Text = "EXECUTE"
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.TextScaled = true
    executeBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", executeBtn).CornerRadius = UDim.new(0, 8)
    
    executeBtn.Activated:Connect(function()
        if foundScript and foundScript ~= "" then
            local success, err = pcall(function() loadstring(foundScript)() end)
            if success then
                main.Visible = false
                dkToggle.Visible = true
            else
                executeBtn.Text = "Execution Error"
                task.wait(2)
                executeBtn.Text = "EXECUTE"
            end
        else
            executeBtn.Text = "No Script Found"
            task.wait(2)
            executeBtn.Text = "EXECUTE"
        end
    end)

    local discordBtn = Instance.new("TextButton", gamePage)
    discordBtn.Size = UDim2.new(0, 260, 0, 40)
    discordBtn.Position = UDim2.new(0.5, -130, 0, 125)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "Join Discord"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 18
    discordBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

    discordBtn.Activated:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/8Dfnrt88J8")
            local originalText = discordBtn.Text
            local originalColor = discordBtn.BackgroundColor3
            discordBtn.Text = "Copied to clipboard!"
            discordBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90) 
            task.delay(2, function()
                discordBtn.Text = originalText
                discordBtn.BackgroundColor3 = originalColor
            end)
        else
            local originalText = discordBtn.Text
            discordBtn.Text = "Clipboard not supported!"
            task.delay(2, function()
                discordBtn.Text = originalText
            end)
        end
    end)
end

settingsBtn.Activated:Connect(function()
    startPage.Visible = false
    settingsPage.Visible = true
    backBtn.Visible = true
end)

backBtn.Activated:Connect(function()
    gamePage.Visible = false
    settingsPage.Visible = false
    startPage.Visible = true
    backBtn.Visible = false
end)

killBtn.Activated:Connect(function()
    gui:Destroy()
end)

startBtn.Activated:Connect(function()
    showGameDetected()
end)

-- ==========================================
-- CLOUD ACCESS ARCHITECTURE (JSONBIN)
-- ==========================================
local function SaveData()
    if not executorRequest then return end
    local dataToSave = {}
    for _, child in pairs(savedList:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TitleLabel") then
            table.insert(dataToSave, {
                Title = child.TitleLabel.Text,
                ID = string.gsub(child.IdLabel.Text, "Game ID: ", ""),
                Code = child:GetAttribute("SavedScript") or ""
            })
        end
    end
    executorRequest({
        Url = "https://api.jsonbin.io/v3/b/" .. BIN_ID,
        Method = "PUT",
        Headers = {["X-Master-Key"] = API_KEY, ["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode({scripts = dataToSave})
    })
end

local function LoadData()
    if not executorRequest then return nil end
    local success, response = pcall(function()
        return executorRequest({
            Url = "https://api.jsonbin.io/v3/b/" .. BIN_ID .. "/latest",
            Method = "GET",
            Headers = {["X-Master-Key"] = API_KEY}
        })
    end)
    if success and response and response.StatusCode == 200 then
        local decoded = HttpService:JSONDecode(response.Body)
        if decoded and decoded.record and decoded.record.scripts then
            return decoded.record.scripts
        end
    end
    return nil
end

local function CreateScriptCard(t, id, scriptCode)
    local scriptCard = Instance.new("Frame", savedList)
    scriptCard.Size = UDim2.new(1, -10, 0, 60)
    scriptCard.BackgroundColor3 = Color3.fromRGB(48, 38, 20)
    scriptCard:SetAttribute("SavedScript", scriptCode) 
    Instance.new("UICorner", scriptCard).CornerRadius = UDim.new(0, 8)

    local cardTitle = Instance.new("TextLabel", scriptCard)
    cardTitle.Name = "TitleLabel"
    cardTitle.Size = UDim2.new(1, -115, 0, 25) 
    cardTitle.Position = UDim2.new(0, 8, 0, 4)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = t
    cardTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextSize = 14
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left

    local cardId = Instance.new("TextLabel", scriptCard)
    cardId.Name = "IdLabel"
    cardId.Size = UDim2.new(1, -115, 0, 20)
    cardId.Position = UDim2.new(0, 8, 0, 30)
    cardId.BackgroundTransparency = 1
    cardId.Text = "Game ID: " .. id
    cardId.TextColor3 = Color3.fromRGB(200, 150, 0)
    cardId.Font = Enum.Font.Gotham
    cardId.TextSize = 11
    cardId.TextXAlignment = Enum.TextXAlignment.Left
    
    local editBtn = Instance.new("TextButton", scriptCard)
    editBtn.Size = UDim2.new(0, 45, 0, 34)
    editBtn.Position = UDim2.new(1, -100, 0.5, -17)
    editBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 220)
    editBtn.Text = "EDIT"
    editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    editBtn.Font = Enum.Font.GothamBold
    editBtn.TextSize = 11
    Instance.new("UICorner", editBtn).CornerRadius = UDim.new(0, 6)
    
    local delBtn = Instance.new("TextButton", scriptCard)
    delBtn.Size = UDim2.new(0, 45, 0, 34)
    delBtn.Position = UDim2.new(1, -50, 0.5, -17)
    delBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    delBtn.Text = "DEL"
    delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    delBtn.Font = Enum.Font.GothamBold
    delBtn.TextSize = 11
    Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
    
    editBtn.Activated:Connect(function()
        currentEditingCard = scriptCard
        titleBox.Text = cardTitle.Text
        idBox.Text = string.gsub(cardId.Text, "Game ID: ", "")
        scriptBox.Text = scriptCard:GetAttribute("SavedScript")
        consoleStartPage.Visible = false
        addScriptPage.Visible = true
        consoleBackBtn.Visible = true
    end)
    
    delBtn.Activated:Connect(function()
        scriptCard:Destroy()
        SaveData() 
    end)
end

plusBtn.Activated:Connect(function()
    currentEditingCard = nil 
    titleBox.Text = ""
    scriptBox.Text = ""
    idBox.Text = ""
    consoleStartPage.Visible = false
    addScriptPage.Visible = true
    consoleBackBtn.Visible = true
end)

consoleBackBtn.Activated:Connect(function()
    addScriptPage.Visible = false
    consoleStartPage.Visible = true
    consoleBackBtn.Visible = false
end)

discardBtn.Activated:Connect(function()
    addScriptPage.Visible = false
    consoleStartPage.Visible = true
    consoleBackBtn.Visible = false
end)

saveBtn.Activated:Connect(function()
    local t = titleBox.Text ~= "" and titleBox.Text or "Untitled Game"
    local id = idBox.Text ~= "" and idBox.Text or "No ID"
    local scriptCode = scriptBox.Text

    if currentEditingCard then
        currentEditingCard.TitleLabel.Text = t
        currentEditingCard.IdLabel.Text = "Game ID: " .. id
        currentEditingCard:SetAttribute("SavedScript", scriptCode)
    else
        CreateScriptCard(t, id, scriptCode)
    end
    SaveData()
    addScriptPage.Visible = false
    consoleStartPage.Visible = true
    consoleBackBtn.Visible = false
end)

local savedData = LoadData()
if savedData then
    for _, item in pairs(savedData) do
        CreateScriptCard(item.Title, item.ID, item.Code)
    end
end
