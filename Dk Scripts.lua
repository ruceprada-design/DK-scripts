local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService") 

-- ==========================================
-- DEVELOPER ALLOWLIST
-- ==========================================
local allowedDevelopers = {
	"THEMYSTICALONE_DJ", 
	"Daspeed321",
	"JJDA_ONE",
}

local isDev = false
for _, devName in pairs(allowedDevelopers) do
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
-- MAIN UI (DK-SCRIPTS)
-- ==========================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 260)
main.Position = UDim2.new(0.5, -170, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 40, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DK-SCRIPTS (v1.1)" -- Updated to version v1.1
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
settingsBtn.Position = UDim2.new(0.5, -130, 0, 10)
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
startBtn.Position = UDim2.new(0.5, -130, 0, 65)
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
devBtn.Position = UDim2.new(0.5, -130, 0, 120)
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

-- Settings Page Elements
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

-- Overlay
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

-- Logic Overlays
local showFPS = false
local showPing = false
local fpsValue = 0

task.spawn(function()
	while true do
		fpsValue = 0
		local start = tick()
		while tick() - start < 1 do
			fpsValue += 1
			RunService.RenderStepped:Wait()
		end
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

local function updateOverlay()
	local parts = {}
	if showFPS then
		table.insert(parts, "FPS: " .. tostring(fpsValue))
	end
	if showPing then
		table.insert(parts, "Ping: " .. tostring(math.floor((player:GetNetworkPing() or 0) * 1000)))
	end
	overlay.Text = table.concat(parts, "  ")
end
RunService.RenderStepped:Connect(updateOverlay)


-- ==========================================
-- EXCLUSIVE DEV UI (CONSOLE)
-- ==========================================
local consoleMain = Instance.new("Frame")
consoleMain.Name = "DevConsole"
consoleMain.Size = UDim2.new(0, 0, 0, 0)
consoleMain.Position = UDim2.new(0.5, 170, 0.5, -160)
consoleMain.BackgroundColor3 = Color3.fromRGB(25, 20, 10) 
consoleMain.BorderSizePixel = 0
consoleMain.ClipsDescendants = true
consoleMain.Visible = false
consoleMain.Parent = gui

local consoleStartPage = Instance.new("Frame")
consoleStartPage.Name = "ConsoleStartPage"
consoleStartPage.Size = UDim2.new(1, 0, 1, -50)
consoleStartPage.Position = UDim2.new(0, 0, 0, 50)
consoleStartPage.BackgroundTransparency = 1
consoleStartPage.Parent = consoleMain

local savedList = Instance.new("ScrollingFrame")
savedList.Name = "SavedScriptsList"
savedList.Size = UDim2.new(1, -40, 1, -80)
savedList.Position = UDim2.new(0, 20, 0, 10)
savedList.BackgroundTransparency = 1
savedList.ScrollBarThickness = 4
savedList.ScrollBarImageColor3 = Color3.fromRGB(255, 180, 0)
savedList.AutomaticCanvasSize = Enum.AutomaticSize.Y 
savedList.CanvasSize = UDim2.new(0, 0, 0, 0)
savedList.Parent = consoleStartPage

-- ==========================================
-- GAME DETECTION LOGIC
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
	label.Position = UDim2.new(0.5, -130, 0, 20)
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

	local discordBtn = Instance.new("TextButton")
	discordBtn.Name = "DiscordButton"
	discordBtn.Size = UDim2.new(0, 260, 0, 40)
	discordBtn.Position = UDim2.new(0.5, -130, 0, 120)
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

local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


-- ==========================================
-- FINISHING DEV CONSOLE UI SETUP
-- ==========================================
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

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 10)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Parent = savedList

local plusBtn = Instance.new("TextButton")
plusBtn.Name = "PlusButton"
plusBtn.Size = UDim2.new(0, 50, 0, 50)
plusBtn.Position = UDim2.new(1, -70, 1, -70) 
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

-- Title Box
local titleBox = Instance.new("TextBox")
titleBox.Name = "TitleBox"
titleBox.Size = UDim2.new(0, 360, 0, 40)
titleBox.Position = UDim2.new(0.5, -180, 0, 10)
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

-- SCROLLING Script Box
local scriptScroll = Instance.new("ScrollingFrame")
scriptScroll.Name = "ScriptScroll"
scriptScroll.Size = UDim2.new(0, 360, 0, 75)
scriptScroll.Position = UDim2.new(0.5, -180, 0, 60)
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

-- ID Box
local idBox = Instance.new("TextBox")
idBox.Name = "IdBox"
idBox.Size = UDim2.new(0, 360, 0, 40)
idBox.Position = UDim2.new(0.5, -180, 0, 145)
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

-- Save & Discard Buttons
local saveBtn = Instance.new("TextButton")
saveBtn.Name = "SaveButton"
saveBtn.Size = UDim2.new(0, 170, 0, 45)
saveBtn.Position = UDim2.new(0.5, -180, 0, 200)
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
discardBtn.Size = UDim2.new(0, 170, 0, 45)
discardBtn.Position = UDim2.new(0.5, 10, 0, 200)
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
local SAVE_FILE_NAME = "DKScripts_SavedData.json"

-- ==========================================
-- SAVING & LOADING LOGIC
-- ==========================================
local function SaveData()
	if writefile then
		local dataToSave = {}
		for _, child in pairs(savedList:GetChildren()) do
			if child:IsA("Frame") then
				local cardTitleText = child.TitleLabel.Text
				local cardIdText = string.gsub(child.IdLabel.Text, "Game ID: ", "")
				local cardCodeText = child:GetAttribute("SavedScript") or ""
				table.insert(dataToSave, {Title = cardTitleText, ID = cardIdText, Code = cardCodeText})
			end
		end
		
		local success, json = pcall(function()
			return HttpService:JSONEncode(dataToSave)
		end)
		
		if success then
			writefile(SAVE_FILE_NAME, json)
		else
			warn("Failed to encode JSON data.")
		end
	end
end

local function LoadData()
	if isfile and isfile(SAVE_FILE_NAME) and readfile then
		local success, result = pcall(function()
			return HttpService:JSONDecode(readfile(SAVE_FILE_NAME))
		end)
		if success and type(result) == "table" then
			return result
		end
	end
	return nil
end

-- ==========================================
-- SCRIPT CARD CREATION LOGIC
-- ==========================================
local function CreateScriptCard(t, id, scriptCode)
	local scriptCard = Instance.new("Frame")
	scriptCard.Size = UDim2.new(1, -10, 0, 60)
	scriptCard.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
	scriptCard:SetAttribute("SavedScript", scriptCode) 
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = scriptCard

	local cardTitle = Instance.new("TextLabel")
	cardTitle.Name = "TitleLabel"
	cardTitle.Size = UDim2.new(1, -135, 0, 30) 
	cardTitle.Position = UDim2.new(0, 10, 0, 5)
	cardTitle.BackgroundTransparency = 1
	cardTitle.Text = t
	cardTitle.TextColor3 = Color3.fromRGB(255, 180, 0)
	cardTitle.Font = Enum.Font.GothamBold
	cardTitle.TextSize = 18
	cardTitle.TextXAlignment = Enum.TextXAlignment.Left
	cardTitle.Parent = scriptCard

	local cardId = Instance.new("TextLabel")
	cardId.Name = "IdLabel"
	cardId.Size = UDim2.new(1, -135, 0, 20)
	cardId.Position = UDim2.new(0, 10, 0, 35)
	cardId.BackgroundTransparency = 1
	cardId.Text = "Game ID: " .. id
	cardId.TextColor3 = Color3.fromRGB(200, 150, 0)
	cardId.Font = Enum.Font.Gotham
	cardId.TextSize = 12
	cardId.TextXAlignment = Enum.TextXAlignment.Left
	cardId.Parent = scriptCard
	
	-- EDIT BUTTON
	local editBtn = Instance.new("TextButton")
	editBtn.Name = "EditButton"
	editBtn.Size = UDim2.new(0, 55, 0, 40)
	editBtn.Position = UDim2.new(1, -120, 0.5, -20)
	editBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
	editBtn.BorderSizePixel = 0
	editBtn.Text = "EDIT"
	editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	editBtn.Font = Enum.Font.GothamBold
	editBtn.TextSize = 13
	editBtn.Parent = scriptCard
	
	local editCorner = Instance.new("UICorner")
	editCorner.CornerRadius = UDim.new(0, 6)
	editCorner.Parent = editBtn
	
	-- DELETE BUTTON
	local delBtn = Instance.new("TextButton")
	delBtn.Name = "DeleteButton"
	delBtn.Size = UDim2.new(0, 55, 0, 40)
	delBtn.Position = UDim2.new(1, -60, 0.5, -20)
	delBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
	delBtn.BorderSizePixel = 0
	delBtn.Text = "DEL"
	delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	delBtn.Font = Enum.Font.GothamBold
	delBtn.TextSize = 13
	delBtn.Parent = scriptCard
	
	local delCorner = Instance.new("UICorner")
	delCorner.CornerRadius = UDim.new(0, 6)
	delCorner.Parent = delBtn
	
	-- Connections
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

-- Dev Console Toggle Animation
local targetDevConsoleSize = UDim2.new(0, 420, 0, 320)

devBtn.Activated:Connect(function()
	if not consoleMain.Visible then
		consoleMain.Size = UDim2.new(0, 0, 0, 0)
		consoleMain.Visible = true
		TweenService:Create(consoleMain, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetDevConsoleSize}):Play()
	else
		local closeTween = TweenService:Create(consoleMain, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
		closeTween:Play()
		closeTween.Completed:Wait()
		consoleMain.Visible = false
	end
end)

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

local cDragging, cDragStart, cStartPos
consoleMain.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		cDragging = true
		cDragStart = input.Position
		cStartPos = consoleMain.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				cDragging = false
			end
		end)
	end
end)
UIS.InputChanged:Connect(function(input)
	if cDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - cDragStart
		consoleMain.Position = UDim2.new(cStartPos.X.Scale, cStartPos.X.Offset + delta.X, cStartPos.Y.Scale, cStartPos.Y.Offset + delta.Y)
	end
end)

-- ==========================================
-- LOAD SAVED DATA ON STARTUP
-- ==========================================
local savedData = LoadData()
if savedData then
	for _, item in pairs(savedData) do
		CreateScriptCard(item.Title, item.ID, item.Code)
	end
end
