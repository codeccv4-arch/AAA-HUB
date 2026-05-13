-- AAA HUB EXECUTOR VERSION

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- 🔗 GitHub
local BASE = "https://raw.githubusercontent.com/codeccv4-arch/AAA-HUB/refs/heads/main/Modules/"
local LIST = "https://raw.githubusercontent.com/codeccv4-arch/AAA-HUB/refs/heads/main/modules.json"

-- 📥 โหลด module list
local function getModules()
	local data = game:HttpGet(LIST)
	return HttpService:JSONDecode(data).modules
end

-- 📦 โหลด module
local function loadModule(name)
	local url = BASE .. name .. ".lua"

	local success, err = pcall(function()
		local code = game:HttpGet(url)
		local func = loadstring(code)

		if func then
			local module = func()
			if module.Init then
				module.Init(player)
			end
		end
	end)

	if not success then
		warn("Module failed:", name)
	end
end
-

--// AAA NEON HUB FINAL FIXED VERSION
--// No button lag + Smooth UI + Rainbow border + Blur + Drag

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AAA_FIXED_HUB"
gui.ResetOnSpawn = false
gui.Parent = guiParent

--// BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

--// COLORS
local BG = Color3.fromRGB(18,18,28)
local PANEL = Color3.fromRGB(28,28,42)
local TEXT = Color3.fromRGB(235,235,255)

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,120,0,40)
toggle.Position = UDim2.new(0,15,0.5,-20)
toggle.Text = "MENU"
toggle.BackgroundColor3 = PANEL
toggle.TextColor3 = TEXT
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = gui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,10)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.4
toggleStroke.Parent = toggle

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,0,0,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = BG
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

--// TOPBAR
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1,0,0,40)
topbar.BackgroundColor3 = PANEL
topbar.Parent = frame
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0,14)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "AAA NEON HUB"
title.TextColor3 = TEXT
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = topbar

--// BUTTON
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,220,0,40)
btn.Position = UDim2.new(0.5,-110,0.5,-20)
btn.Text = "TEST BUTTON"
btn.BackgroundColor3 = PANEL
btn.TextColor3 = TEXT
btn.Font = Enum.Font.Gotham
btn.TextSize = 14
btn.Parent = frame
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

--// STROKES
local frameStroke = Instance.new("UIStroke")
frameStroke.Thickness = 2
frameStroke.Transparency = 0.2
frameStroke.Parent = frame

local btnStroke = Instance.new("UIStroke")
btnStroke.Thickness = 1
btnStroke.Transparency = 0.5
btnStroke.Parent = btn

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1
toggleStroke.Transparency = 0.4
toggleStroke.Parent = toggle

--// RAINBOW BORDER
local function rainbow(stroke)
	local hue = 0
	RunService.RenderStepped:Connect(function(dt)
		hue = (hue + dt * 0.25) % 1
		stroke.Color = Color3.fromHSV(hue, 1, 1)
	end)
end

rainbow(frameStroke)
rainbow(btnStroke)
rainbow(toggleStroke)

--// STATE
local opened = false

local tweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local titleTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

--// INTERACT CONTROL (FIX LAG ISSUE)
local function setInteractable(state)
	btn.Active = state
	btn.AutoButtonColor = state
end

--// OPEN MENU
local function openMenu()
	frame.Visible = true
	opened = true

	setInteractable(true)

	blur.Size = 0
	TweenService:Create(blur, TweenInfo.new(0.3), {Size = 20}):Play()

	-- reset UI
	title.Position = UDim2.new(0,0,0,0)
	title.TextTransparency = 0

	btn.BackgroundTransparency = 0
	btn.TextTransparency = 0

	frame.Size = UDim2.new(0,0,0,0)

	TweenService:Create(frame, tweenInfo, {
		Size = UDim2.new(0,360,0,240)
	}):Play()
end

--// CLOSE MENU (FIX BUTTON LAG)
local function closeMenu()
	opened = false

	setInteractable(false)

	TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()

	-- title animation (down + fade)
	TweenService:Create(title, titleTweenInfo, {
		Position = UDim2.new(0,0,0,20),
		TextTransparency = 1
	}):Play()

	-- button fade instantly (fix lag)
	TweenService:Create(btn, TweenInfo.new(0.15), {
		TextTransparency = 1,
		BackgroundTransparency = 1
	}):Play()

	local t = TweenService:Create(frame, tweenInfo, {
		Size = UDim2.new(0,0,0,0)
	})

	t:Play()
	t.Completed:Connect(function()
		frame.Visible = false

		-- reset button state
		btn.BackgroundTransparency = 0
		btn.TextTransparency = 0
	end)
end

--// TOGGLE
toggle.MouseButton1Click:Connect(function()
	if opened then
		closeMenu()
	else
		openMenu()
	end
end)

--// DRAG (TOPBAR ONLY)
local dragging = false
local dragStart, startPos

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

topbar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
