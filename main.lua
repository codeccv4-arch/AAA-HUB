-- AAA HUB EXECUTOR VERSION

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- 🔗 GitHub
local BASE = "https://raw.githubusercontent.com/codeccv4-arch/AAA-HUB/refs/heads/main/Modules/"
local LIST = "https://raw.githubusercontent.com/USERNAME/AAA-HUB/main/modules.json"

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

-- 🎮 UI (สร้างผ่าน executor)
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,300,0,200)
frame.Position = UDim2.new(0.5,-150,0.5,-100)
frame.Parent = gui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0,200,0,50)
btn.Position = UDim2.new(0.5,-100,0.5,-25)
btn.Text = "LOAD HUB"
btn.Parent = frame

-- 🚀 CLICK LOAD
btn.MouseButton1Click:Connect(function()
	local modules = getModules()

	for _, name in ipairs(modules) do
		loadModule(name)
	end
end)
