local retaincharacter = game.ReplicatedStorage.CharacterSelectionEvents:WaitForChild("RetainingCharacter")
local player = game.Players.LocalPlayer
local updateClient = game.ReplicatedStorage.CharacterSelectionEvents:WaitForChild("UpdateClientHumanoid")


local cooldown = false
player.CharacterAdded:Connect(function()
	if cooldown == true then
		cooldown = false
		return
	end
	print("Player died firing server")
	task.wait(0.2)
	retaincharacter:FireServer()
	cooldown = true
end)