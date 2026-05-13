local module = {}

function module.Init(player)
	local char = player.Character
	if not char then return end

	local hum = char:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = 50
	end
end

return module
