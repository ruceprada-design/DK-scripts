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

-- ==========================================
-- AUDIO & ANIMATION HELPER FUNCTIONS
-- ==========================================
local function playModernSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6042053626" -- Super clean, modern UI pop
    sound.Volume = 1
    sound.Parent = game:GetService("SoundService")
    sound:Play()
    task.delay(2, function()
        sound:Destroy()
    end)
end

local function runRealisticLoading(barFill, callback)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    
    -- Stage 1: Fast surge to 40%
    local t1 = TweenService:Create(barFill, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.4, 0, 1, 0)})
    t1:Play()
    
    t1.Completed:Connect(function()
        task.wait(0.5) -- Realistic Freeze point
        
        -- Stage 2: Slow crawl from 40% to 65%
        local t2 = TweenService:Create(barFill, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {Size = UDim2.new(0.65, 0, 1, 0)})
        t2:Play()
        
        t2.Completed:Connect(function()
            task.wait(0.2) -- Micro-stutter
            
            -- Stage 3: High-speed completion blast to 100%
            local t3 = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, 0)})
            t3:Play()
            
            t3.Completed:Connect(function()
                playModernSound()
                if callback then callback() end
            end)
        end)
    end)
end

-- ==========================================
-- DRAGGING FUNCTION (OPTIMIZED)
-- ==========================================
local function makeDraggable(frame)
    local dragging = false
    local dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ==========================================
-- PATCH NOTES POPUP (NEW!)
-- ==========================================
local patchNotes = Instance.new("Frame")
patchNotes.Name = "PatchNotesPopup"
patchNotes.Size = UDim2.new(0, 320, 0, 240)
patchNotes.Position = UDim2.new(0.5, -160, 0.5, -120)
patchNotes.BackgroundColor3 = Color3.fromRGB(30, 25, 35) -- Dark sleek with a hint of purple
patchNotes.BorderSizePixel = 0
patchNotes.ZIndex = 50
patchNotes.Visible = false -- Hidden until loading is done
patchNotes.Parent = gui

local patchCorner = Instance.new("UICorner")
patchCorner.CornerRadius = UDim.new(0, 12)
patchCorner.Parent = patchNotes

local patchTitle = Instance.new("TextLabel", patchNotes)
patchTitle.Size = UDim2.new(1, 0, 0, 45)
patchTitle.Position = UDim2.new(0, 0, 0, 5)
patchTitle.BackgroundTransparency = 1
patchTitle.Text = "✨ UPDATE PATCH NOTES ✨"
patchTitle.TextColor3 = Color3.fromRGB(180, 100, 255) -- Vivid Purple
patchTitle.Font = Enum.Font.GothamBold
patchTitle.TextSize = 18
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
patchBody.Text = "• Added Developer Activity Status panel!\n\n• New dev network dots (Green/Blue/Red)\n\n• Upgraded Realistic Loading Animations\n\n• Integrated sleek Modern UI Audio cues\n\n• Fixed layout overlapping & stacking bugs\n\n• Restored Execute & Discord integration"
patchBody.TextColor3 = Color3.fromRGB(215, 175, 255) -- Soft readable purple
patchBody.Font = Enum.Font.Gotham
patchBody.TextSize = 13
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
main.Position = UDim2.new(0.5, -170, 0.5, -140)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

makeDraggable(main)

-- LOADING SCREEN
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
loadingScreen.Size = UDim2.new(0, 340, 0, 280)
loadingScreen.Position = UDim2.new(0.5, -170, 0.5, -140)
loadingScreen.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
loadingScreen.BorderSizePixel = 0
loadingScreen.Parent = gui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingScreen

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Name = "LoadingTitle"
loadingTitle.Size = UDim2.new(1, 0, 0, 50)
loadingTitle.Position = UDim2.new(0, 0, 0, 80)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "Loading DK-SCRIPTS..."
loadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingTitle.TextScaled = true
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loadingScreen

local barBg = Instance.new("Frame")
barBg.Name = "BarBackground"
barBg.Size = UDim2.new(0, 260, 0, 16)
barBg.Position = UDim2.new(0.5, -130, 0.5, 30)
barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
barBg.BorderSizePixel = 0
barBg.Parent = loadingScreen

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
barFill.BorderSizePixel = 0
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

runRealisticLoading(barFill, function()
    local fadeTween = TweenService:Create(loadingScreen, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    TweenService:Create(loadingTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    fadeTween:Play()
    fadeTween.Completed:Connect(function()
        loadingScreen.Visible = false
        main.Visible = true
        patchNotes.Visible = true -- TRIGGERS PATCH NOTES TO POP UP!
    end)
end)

-- ==========================================
-- MAIN UI ELEMENTS & NAVIGATION
-- ==========================================
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DK-SCRIPTS v1.2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = main

local backBtn = Instance.new("TextButton")
backBtn.Name = "BackButton"
backBtn.Size = UDim2.new(0, 32, 0, 32)
backBtn.Position = UDim2.new(0, 8, 0, 9)
backBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
backBtn.BorderSizePixel = 0
backBtn.Text = "←"
backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
backBtn.TextScaled = true
backBtn.Font = Enum.Font.GothamBold
backBtn.Visible = false
backBtn.Parent = main

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 8)
backCorner.Parent = backBtn

local startPage = Instance.new("Frame")
startPage.Name = "StartPage"
startPage.Size = UDim2.new(1, 0, 1, -50)
startPage.Position = UDim2.new(0, 0, 0, 50)
startPage.BackgroundTransparency = 1
startPage.Parent = main

local settingsPage = Instance.new("Frame")
settingsPage.Name = "SettingsPage"
settingsPage.Size = UDim2.new(1, 0, 1, -50)
settingsPage.Position = UDim2.new(0, 0, 0, 50)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = main

local gamePage = Instance.new("Frame")
gamePage.Name = "GamePage"
gamePage.Size = UDim2.new(1, 0, 1, -50)
gamePage.Position = UDim2.new(0, 0, 0, 50)
gamePage.BackgroundTransparency = 1
gamePage.Visible = false
gamePage.Parent = main

-- Main Menu Buttons
local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "SettingsButton"
settingsBtn.Size = UDim2.new(0, 260, 0, 45)
settingsBtn.Position = UDim2.new(0.5, -130, 0, 15)
settingsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "Open Settings"
settingsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsBtn.TextScaled = true
settingsBtn.Font = Enum.Font.Gotham
settingsBtn.Parent = startPage

local settingsBtnCorner = Instance.new("UICorner")
settingsBtnCorner.CornerRadius = UDim.new(0, 10)
settingsBtnCorner.Parent = settingsBtn

local startBtn = Instance.new("TextButton")
startBtn.Name = "StartButton"
startBtn.Size = UDim2.new(0, 260, 0, 45)
startBtn.Position = UDim2.new(0.5, -130, 0, 75)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
startBtn.BorderSizePixel = 0
startBtn.Text = "Start!"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = startPage

local startBtnCorner = Instance.new("UICorner")
startBtnCorner.CornerRadius = UDim.new(0, 10)
startBtnCorner.Parent = startBtn

local devBtn = Instance.new("TextButton")
devBtn.Name = "DevButton"
devBtn.Size = UDim2.new(0, 260, 0, 45)
devBtn.Position = UDim2.new(0.5, -130, 0, 135)
devBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
devBtn.BorderSizePixel = 0
devBtn.Text = "DEVELOPER Console"
devBtn.TextColor3 = Color3.fromRGB(25, 25, 25)
devBtn.TextScaled = true
devBtn.Font = Enum.Font.GothamBold
devBtn.Visible = isDev 
devBtn.Parent = startPage

local devBtnCorner = Instance.new("UICorner")
devBtnCorner.CornerRadius = UDim.new(0, 10)
devBtnCorner.Parent = devBtn

-- Settings System
local killBtn = Instance.new("TextButton")
killBtn.Name = "KillButton"
killBtn.Size = UDim2.new(0, 260, 0, 34)
killBtn.Position = UDim2.new(0.5, -130, 0, 14)
killBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
killBtn.BorderSizePixel = 0
killBtn.Text = "Kill Script"
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killBtn.TextScaled = true
killBtn.Font = Enum.Font.GothamBold
killBtn.Parent = settingsPage
local killCorner = Instance.new("UICorner")
killCorner.CornerRadius = UDim.new(0, 8)
killCorner.Parent = killBtn

local fpsBtn = Instance.new("TextButton")
fpsBtn.Name = "FpsButton"
fpsBtn.Size = UDim2.new(0, 260, 0, 34)
fpsBtn.Position = UDim2.new(0.5, -130, 0, 58)
fpsBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
fpsBtn.BorderSizePixel = 0
fpsBtn.Text = "Show FPS: OFF"
fpsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsBtn.TextScaled = true
fpsBtn.Font = Enum.Font.Gotham
fpsBtn.Parent = settingsPage
local fpsCorner = Instance.new("UICorner")
fpsCorner.CornerRadius = UDim.new(0, 8)
fpsCorner.Parent = fpsBtn

local pingBtn = Instance.new("TextButton")
pingBtn.Name = "PingButton"
pingBtn.Size = UDim2.new(0, 260, 0, 34)
pingBtn.Position = UDim2.new(0.5, -130, 0, 102)
pingBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
pingBtn.BorderSizePixel = 0
pingBtn.Text = "Show Ping: OFF"
pingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
pingBtn.TextScaled = true
pingBtn.Font = Enum.Font.Gotham
pingBtn.Parent = settingsPage
local pingCorner = Instance.new("UICorner")
pingCorner.CornerRadius = UDim.new(0, 8)
pingCorner.Parent = pingBtn

local gameLabel = Instance.new("TextLabel")
gameLabel.Name = "GameLabel"
gameLabel.Size = UDim2.new(0, 260, 0, 34)
gameLabel.Position = UDim2.new(0.5, -130, 0, 146)
gameLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
gameLabel.BorderSizePixel = 0
gameLabel.Text = "Game ID: " .. tostring(game.PlaceId)
gameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gameLabel.TextScaled = true
gameLabel.Font = Enum.Font.Gotham
gameLabel.Parent = settingsPage
local gameCorner = Instance.new("UICorner")
gameCorner.CornerRadius = UDim.new(0, 8)
gameCorner.Parent = gameLabel

-- HUD Overlays
local overlay = Instance.new("TextLabel")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(0, 220, 0, 50)
overlay.Position = UDim2.new(0, 10, 0, 10)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.35
overlay.TextColor3 = Color3.fromRGB(255, 255, 255)
overlay.TextScaled = true
overlay.Font = Enum.Font.GothamBold
overlay.Visible = false
overlay.Parent = gui
local overlayCorner = Instance.new("UICorner")
overlayCorner.CornerRadius = UDim.new(0, 8)
overlayCorner.Parent = overlay

local showFPS = false
local showPing = false
local fpsValue = 0
local lastUpdate = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastUpdate >= 1 then
        fpsValue = frames
        frames = 0
        lastUpdate = tick()
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

RunService.RenderStepped:Connect(function()
    local parts = {}
    if showFPS then table.insert(parts, "FPS: " .. tostring(fpsValue)) end
    if showPing then table.insert(parts, "Ping: " .. tostring(math.floor((player:GetNetworkPing() or 0) * 1000))) end
    overlay.Text = table.concat(parts, "  ")
end)

-- ==========================================
-- EXCLUSIVE DEV UI (CONSOLE)
-- ==========================================
local consoleMain = Instance.new("Frame")
consoleMain.Name = "DevConsole"
consoleMain.Size = UDim2.new(0, 480, 0, 340)
consoleMain.Position = UDim2.new(0.5, 190, 0.5, -170)
consoleMain.BackgroundColor3 = Color3.fromRGB(25, 20, 10) 
consoleMain.BorderSizePixel = 0
consoleMain.ClipsDescendants = true
consoleMain.Visible = false
consoleMain.Parent = gui

makeDraggable(consoleMain)

local consoleCorner = Instance.new("UICorner")
consoleCorner.CornerRadius = UDim.new(0, 12)
consoleCorner.Parent = consoleMain

local consoleTitle = Instance.new("TextLabel")
consoleTitle.Name = "Greeting"
consoleTitle.Size = UDim2.new(1, -40, 0, 50)
consoleTitle.Position = UDim2.new(0, 40, 0, 0)
consoleTitle.BackgroundTransparency = 1
consoleTitle.Text = "Welcome Developer!"
consoleTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
consoleTitle.TextScaled = true
consoleTitle.Font = Enum.Font.GothamBold
consoleTitle.Parent = consoleMain

local consoleBackBtn = Instance.new("TextButton")
consoleBackBtn.Name = "ConsoleBackButton"
consoleBackBtn.Size = UDim2.new(0, 32, 0, 32)
consoleBackBtn.Position = UDim2.new(0, 8, 0, 9)
consoleBackBtn.BackgroundColor3 = Color3.fromRGB(60, 45, 15)
consoleBackBtn.BorderSizePixel = 0
consoleBackBtn.Text = "←"
consoleBackBtn.TextColor3 = Color3.fromRGB(255, 180, 0)
consoleBackBtn.TextScaled = true
consoleBackBtn.Font = Enum.Font.GothamBold
consoleBackBtn.Visible = false
consoleBackBtn.Parent = consoleMain
local consoleBackCorner = Instance.new("UICorner")
consoleBackCorner.CornerRadius = UDim.new(0, 8)
consoleBackCorner.Parent = consoleBackBtn

local consoleStartPage = Instance.new("Frame")
consoleStartPage.Name = "ConsoleStartPage"
consoleStartPage.Size = UDim2.new(1, 0, 1, -50)
consoleStartPage.Position = UDim2.new(0, 0, 0, 50)
consoleStartPage.BackgroundTransparency = 1
consoleStartPage.Parent = consoleMain

-- Console Layout Subsections
local savedListFrame = Instance.new("Frame", consoleStartPage)
savedListFrame.Size = UDim2.new(0, 250, 1, -20)
savedListFrame.Position = UDim2.new(0, 10, 0, 10)
savedListFrame.BackgroundColor3 = Color3.fromRGB(35, 28, 14)
local slfCorner = Instance.new("UICorner")
slfCorner.CornerRadius = UDim.new(0, 8)
slfCorner.Parent = savedListFrame

local savedList = Instance.new("ScrollingFrame")
savedList.Name = "SavedScriptsList"
savedList.Size = UDim2.new(1, -10, 1, -10)
savedList.Position = UDim2.new(0, 5, 0, 5)
savedList.BackgroundTransparency = 1
savedList.ScrollBarThickness = 4
savedList.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
savedList.AutomaticCanvasSize = Enum.AutomaticSize.Y 
savedList.CanvasSize = UDim2.new(0, 0, 0, 0)
savedList.Parent = savedListFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = savedList

-- ACTIVITY WINDOW SECTION
local activityFrame = Instance.new("Frame", consoleStartPage)
activityFrame.Size = UDim2.new(0, 200, 1, -20)
activityFrame.Position = UDim2.new(0, 270, 0, 10)
activityFrame.BackgroundColor3 = Color3.fromRGB(35, 28, 14)
local afCorner = Instance.new("UICorner")
afCorner.CornerRadius = UDim.new(0, 8)
afCorner.Parent = activityFrame

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
activityList.CanvasSize = UDim2.new(0, 0, 0, 0)

local activityLayout = Instance.new("UIListLayout")
activityLayout.Padding = UDim.new(0, 6)
activityLayout.Parent = activityList

local function populateActivityWindow()
    for _, child in pairs(activityList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    for username, info in pairs(developerRegistry) do
        local row = Instance.new("Frame", activityList)
        row.Size = UDim2.new(1, 0, 0, 35)
        row.BackgroundColor3 = Color3.fromRGB(45, 36, 18)
        local rowCorner = Instance.new("UICorner", row)
        rowCorner.CornerRadius = UDim.new(0, 6)
        
        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0, 10, 0, 10)
        dot.Position = UDim2.new(0, 10, 0.5, -5)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        
        if game.Players:FindFirstChild(username) then
            dot.BackgroundColor3 = Color3.fromRGB(0, 255, 100) -- GREEN (In Game)
        else
            if username == "JJDA_ONE" then
                dot.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- BLUE (In Menu)
            elseif username == "DaSpeed321" then
                dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- RED (Offline)
            else
                dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            end
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

-- INTERNAL CONSOLE LOADING SCREEN
local devLoader = Instance.new("Frame", consoleMain)
devLoader.Size = UDim2.new(1, 0, 1, 0)
devLoader.BackgroundColor3 = Color3.fromRGB(25, 20, 10)
devLoader.ZIndex = 10
devLoader.Visible = false

local devLoaderTitle = Instance.new("TextLabel", devLoader)
devLoaderTitle.Size = UDim2.new(1, 0, 0, 40)
devLoaderTitle.Position = UDim2.new(0, 0, 0, 120)
devLoaderTitle.BackgroundTransparency = 1
devLoaderTitle.Text = "Syncing Dev Channel..."
devLoaderTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
devLoaderTitle.Font = Enum.Font.GothamBold
devLoaderTitle.TextSize = 18
devLoaderTitle.ZIndex = 10

local devBarBg = Instance.new("Frame", devLoader)
devBarBg.Size = UDim2.new(0, 240, 0, 12)
devBarBg.Position = UDim2.new(0.5, -120, 0.5, 10)
devBarBg.BackgroundColor3 = Color3.fromRGB(50, 40, 20)
devBarBg.ZIndex = 10
Instance.new("UICorner", devBarBg).CornerRadius = UDim.new(1, 0)

local devBarFill = Instance.new("Frame", devBarBg)
devBarFill.Size = UDim2.new(0, 0, 1, 0)
devBarFill.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
devBarFill.ZIndex = 10
Instance.new("UICorner", devBarFill).CornerRadius = UDim.new(1, 0)

-- DEV INTERACTION PANEL TOGGLE
devBtn.Activated:Connect(function()
    if not consoleMain.Visible then
        consoleMain.Size = UDim2.new(0, 480, 0, 340)
        consoleMain.Visible = true
        devLoader.Visible = true
        consoleStartPage.Visible = false
        
        populateActivityWindow()
        
        runRealisticLoading(devBarFill, function()
            devLoader.Visible = false
            consoleStartPage.Visible = true
        end)
    else
        consoleMain.Visible = false
    end
end)

local plusBtn = Instance.new("TextButton")
plusBtn.Name = "PlusButton"
plusBtn.Size = UDim2.new(0, 40, 0, 40)
plusBtn.Position = UDim2.new(1, -55, 1, -55) 
plusBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
plusBtn.BorderSizePixel = 0
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(25, 20, 10)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = consoleStartPage
local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(1, 0) 
plusCorner.Parent = plusBtn

local addScriptPage = Instance.new("Frame")
addScriptPage.Name = "AddScriptPage"
addScriptPage.Size = UDim2.new(1, 0, 1, -50)
addScriptPage.Position = UDim2.new(0, 0, 0, 50)
addScriptPage.BackgroundTransparency = 1
addScriptPage.Visible = false
addScriptPage.Parent = consoleMain

-- Title Form Input
local titleBox = Instance.new("TextBox")
titleBox.Name = "TitleBox"
titleBox.Size = UDim2.new(0, 400, 0, 40)
titleBox.Position = UDim2.new(0.5, -200, 0, 10)
titleBox.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
titleBox.BorderSizePixel = 0
titleBox.TextColor3 = Color3.fromRGB(255, 180, 0)
titleBox.PlaceholderText = "Save File Title..."
titleBox.PlaceholderColor3 = Color3.fromRGB(150, 110, 0)
titleBox.Text = ""
titleBox.ClearTextOnFocus = false
titleBox.Font = Enum.Font.GothamBold
titleBox.TextSize = 16
titleBox.Parent = addScriptPage
local titleBoxCorner = Instance.new("UICorner")
titleBoxCorner.CornerRadius = UDim.new(0, 8)
titleBoxCorner.Parent = titleBox

-- Code Engine Scroll Form
local scriptScroll = Instance.new("ScrollingFrame")
scriptScroll.Name = "ScriptScroll"
scriptScroll.Size = UDim2.new(0, 400, 0, 85)
scriptScroll.Position = UDim2.new(0.5, -200, 0, 60)
scriptScroll.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
scriptScroll.BorderSizePixel = 0
scriptScroll.ScrollBarThickness = 4
scriptScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
scriptScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scriptScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptScroll.Parent = addScriptPage
local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 8)
scrollCorner.Parent = scriptScroll

local scriptBox = Instance.new("TextBox")
scriptBox.Name = "ScriptBox"
scriptBox.Size = UDim2.new(1, -10, 0, 0)
scriptBox.Position = UDim2.new(0, 5, 0, 5)
scriptBox.BackgroundTransparency = 1
scriptBox.TextColor3 = Color3.fromRGB(255, 180, 0)
scriptBox.PlaceholderText = "Paste Script Here..."
scriptBox.PlaceholderColor3 = Color3.fromRGB(150, 110, 0)
scriptBox.Text = ""
scriptBox.TextWrapped = true
scriptBox.MultiLine = true
scriptBox.TextXAlignment = Enum.TextXAlignment.Left
scriptBox.TextYAlignment = Enum.TextYAlignment.Top
scriptBox.ClearTextOnFocus = false
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 14
scriptBox.AutomaticSize = Enum.AutomaticSize.Y 
scriptBox.Parent = scriptScroll

-- Deployment Place Configuration Box
local idBox = Instance.new("TextBox")
idBox.Name = "IdBox"
idBox.Size = UDim2.new(0, 400, 0, 40)
idBox.Position = UDim2.new(0.5, -200, 0, 155)
idBox.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
idBox.BorderSizePixel = 0
idBox.TextColor3 = Color3.fromRGB(255, 180, 0)
idBox.PlaceholderText = "Game ID..."
idBox.PlaceholderColor3 = Color3.fromRGB(150, 110, 0)
idBox.Text = ""
idBox.ClearTextOnFocus = false
idBox.Font = Enum.Font.Gotham
idBox.TextSize = 14
idBox.Parent = addScriptPage
local idBoxCorner = Instance.new("UICorner")
idBoxCorner.CornerRadius = UDim.new(0, 8)
idBoxCorner.Parent = idBox

-- Action Commits
local saveBtn = Instance.new("TextButton")
saveBtn.Name = "SaveButton"
saveBtn.Size = UDim2.new(0, 190, 0, 45)
saveBtn.Position = UDim2.new(0.5, -200, 0, 210)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
saveBtn.BorderSizePixel = 0
saveBtn.Text = "SAVE"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = addScriptPage
local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 8)
saveCorner.Parent = saveBtn

local discardBtn = Instance.new("TextButton")
discardBtn.Name = "DiscardButton"
discardBtn.Size = UDim2.new(0, 190, 0, 45)
discardBtn.Position = UDim2.new(0.5, 10, 0, 210)
discardBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40) 
discardBtn.BorderSizePixel = 0
discardBtn.Text = "DISCARD"
discardBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discardBtn.TextScaled = true
discardBtn.Font = Enum.Font.GothamBold
discardBtn.Parent = addScriptPage
local discardCorner = Instance.new("UICorner")
discardCorner.CornerRadius = UDim.new(0, 8)
discardCorner.Parent = discardBtn

local currentEditingCard = nil 

-- ==========================================
-- GAME DETECTION SYSTEM (RESTORED MAIN UI)
-- ==========================================
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

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 260, 0, 40)
    label.Position = UDim2.new(0.5, -130, 0, 15)
    label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    label.BorderSizePixel = 0
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    
    if foundScript then
        label.Text = "Game Supported!"
        label.TextColor3 = Color3.fromRGB(0, 255, 100)
    else
        label.Text = "Game Not Supported!"
        label.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    
    label.Parent = gamePage
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = label
    
    -- RESTORED EXECUTE BUTTON
    local executeBtn = Instance.new("TextButton")
    executeBtn.Name = "ExecuteButton"
    executeBtn.Size = UDim2.new(0, 260, 0, 40)
    executeBtn.Position = UDim2.new(0.5, -130, 0, 70)
    executeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    executeBtn.BorderSizePixel = 0
    executeBtn.Text = "EXECUTE"
    executeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeBtn.TextScaled = true
    executeBtn.Font = Enum.Font.GothamBold
    executeBtn.Parent = gamePage
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 8)
    execCorner.Parent = executeBtn
    
    executeBtn.Activated:Connect(function()
        if foundScript and foundScript ~= "" then
            local success, err = pcall(function()
                loadstring(foundScript)()
            end)
            if not success then
                warn("Error executing script: " .. tostring(err))
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

    -- RESTORED DISCORD BUTTON
    local discordBtn = Instance.new("TextButton")
    discordBtn.Name = "DiscordButton"
    discordBtn.Size = UDim2.new(0, 260, 0, 40)
    discordBtn.Position = UDim2.new(0.5, -130, 0, 125)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = "Join Discord"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 18
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.Parent = gamePage
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn
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
    startBtn.Text = "Started"
    task.wait(0.2)
    startBtn.Text = "Start!"
    showGameDetected()
end)

-- ==========================================
-- CLOUD ACCESS ARCHITECTURE (JSONBIN ENGAGEMENT)
-- ==========================================
local executorRequest = request or http_request or (syn and syn.request) or (http and http.request)

local function SaveData()
    if not executorRequest then 
        warn("HTTP requests are not supported on your executor!") 
        return 
    end
    
    local dataToSave = {}
    for _, child in pairs(savedList:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TitleLabel") then
            local cardTitleText = child.TitleLabel.Text
            local cardIdText = string.gsub(child.IdLabel.Text, "Game ID: ", "")
            local cardCodeText = child:GetAttribute("SavedScript") or ""
            table.insert(dataToSave, {Title = cardTitleText, ID = cardIdText, Code = cardCodeText})
        end
    end
    
    local payload = HttpService:JSONEncode({scripts = dataToSave})
    
    executorRequest({
        Url = "https://api.jsonbin.io/v3/b/" .. BIN_ID,
        Method = "PUT",
        Headers = {
            ["X-Master-Key"] = API_KEY, 
            ["Content-Type"] = "application/json"
        },
        Body = payload
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

-- ==========================================
-- SCRIPT CARD CREATION ENGINE
-- ==========================================
local function CreateScriptCard(t, id, scriptCode)
    local scriptCard = Instance.new("Frame")
    scriptCard.Size = UDim2.new(1, -10, 0, 60)
    scriptCard.BackgroundColor3 = Color3.fromRGB(48, 38, 20)
    scriptCard:SetAttribute("SavedScript", scriptCode) 
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = scriptCard

    local cardTitle = Instance.new("TextLabel")
    cardTitle.Name = "TitleLabel"
    cardTitle.Size = UDim2.new(1, -115, 0, 25) 
    cardTitle.Position = UDim2.new(0, 8, 0, 4)
    cardTitle.BackgroundTransparency = 1
    cardTitle.Text = t
    cardTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
    cardTitle.Font = Enum.Font.GothamBold
    cardTitle.TextSize = 14
    cardTitle.TextXAlignment = Enum.TextXAlignment.Left
    cardTitle.Parent = scriptCard

    local cardId = Instance.new("TextLabel")
    cardId.Name = "IdLabel"
    cardId.Size = UDim2.new(1, -115, 0, 20)
    cardId.Position = UDim2.new(0, 8, 0, 30)
    cardId.BackgroundTransparency = 1
    cardId.Text = "Game ID: " .. id
    cardId.TextColor3 = Color3.fromRGB(200, 150, 0)
    cardId.Font = Enum.Font.Gotham
    cardId.TextSize = 11
    cardId.TextXAlignment = Enum.TextXAlignment.Left
    cardId.Parent = scriptCard
    
    local editBtn = Instance.new("TextButton")
    editBtn.Name = "EditButton"
    editBtn.Size = UDim2.new(0, 45, 0, 34)
    editBtn.Position = UDim2.new(1, -100, 0.5, -17)
    editBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 220)
    editBtn.BorderSizePixel = 0
    editBtn.Text = "EDIT"
    editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    editBtn.Font = Enum.Font.GothamBold
    editBtn.TextSize = 11
    editBtn.Parent = scriptCard
    
    local editCorner = Instance.new("UICorner")
    editCorner.CornerRadius = UDim.new(0, 6)
    editCorner.Parent = editBtn
    
    local delBtn = Instance.new("TextButton")
    delBtn.Name = "DeleteButton"
    delBtn.Size = UDim2.new(0, 45, 0, 34)
    delBtn.Position = UDim2.new(1, -50, 0.5, -17)
    delBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    delBtn.BorderSizePixel = 0
    delBtn.Text = "DEL"
    delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    delBtn.Font = Enum.Font.GothamBold
    delBtn.TextSize = 11
    delBtn.Parent = scriptCard
    
    local delCorner = Instance.new("UICorner")
    delCorner.CornerRadius = UDim.new(0, 6)
    delCorner.Parent = delBtn
    
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

    scriptCard.Parent = savedList
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

-- ==========================================
-- COLD RUN INITIALIZATION
-- ==========================================
local savedData = LoadData()
if savedData then
    for _, item in pairs(savedData) do
        CreateScriptCard(item.Title, item.ID, item.Code)
    end
end
