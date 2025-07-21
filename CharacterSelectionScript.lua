local characterChangeRequest = game:WaitForChild("ReplicatedStorage"):WaitForChild("CharacterSelectionEvents"):WaitForChild("CharacterSelectFromButton")
local retainingCharacter = game:WaitForChild("ReplicatedStorage"):WaitForChild("CharacterSelectionEvents"):WaitForChild("RetainingCharacter")
local serverStorageCharacterFolder = game:GetService("ServerStorage"):WaitForChild("Characters")
local playerModel = {} -- This is used to keep track of which players are using what models
local sendingCharacterToClient = game:WaitForChild("ReplicatedStorage"):WaitForChild("CharacterSelectionEvents"):WaitForChild("Sending Character Client")
local Camera = game.Workspace.CurrentCamera
local player = game:GetService("Players")
local clientUpdate = game:WaitForChild("ReplicatedStorage"):WaitForChild("CharacterSelectionEvents"):WaitForChild("UpdateClientHumanoid")

if player then
	local function getCharacterFromServerStorage(CharacterID) 
		for _, child in pairs(serverStorageCharacterFolder:GetChildren()) do
			if child and CharacterID then
				if child.Name == CharacterID then
					print("FOUND IT" .. " " .. child.Name)
					return child
				end
			end
		end
	end

	local function changeCharacter(player, character)
		local success, oldCamPos = pcall(function()
			return Camera.CFrame
		end)
		if success == false then
			print("Could not get cameras old position, setting to default")
			oldCamPos = CFrame(0, 0, 0)
		end
		local success, oldpos = pcall(function()
			return player.Character.HumanoidRootPart.CFrame
		end)
		if success == false then
			print("Could not get players old position, setting to default")
			oldpos = CFrame(0, 0, 0)
		end
		if player.Character then player.Character:Destroy() end
		player.Character = character:Clone()
		player.Character.Parent = workspace
		player.Character.HumanoidRootPart.CFrame = oldpos
		Camera.CFrame = oldCamPos
		playerModel[player] = character
		--local newHumanoid = player.Character:WaitForChild("Humanoid")
		--clientUpdate:FireClient(player, newHumanoid)
		print("Characterchange function complete")
	end

	characterChangeRequest.OnServerEvent:Connect(function(player, CharacterID)
		local character = getCharacterFromServerStorage(CharacterID)
		if character:IsA("Model") then
			changeCharacter(player, character)
		elseif not character:IsA("Model") then
			print("SELECTED CHARACTER IS NOT A MODEL!")
		else
			print("Error: CharacterSelection, line: 38")
		end
	end)

	player.PlayerRemoving:Connect(function(player)
		playerModel[player] = nil
	end)

	retainingCharacter.OnServerEvent:Connect(function(player)
		print("RETAINING FIRED")
		if playerModel[player] ~= nil then
			local playersCharacter = playerModel[player]
			print("Already a player model. changing...")
			changeCharacter(player, playersCharacter)
		elseif playerModel[player] == nil then
			local defaultModel = getCharacterFromServerStorage("Ichigo")
			changeCharacter(player, defaultModel)
			playerModel[player] = defaultModel
		else
			print("Error: CharacterSelection, line: 64")
		end
	end)

	game.Players.PlayerAdded:Connect(function(player)
		local defaultModel = getCharacterFromServerStorage("Ichigo")
		if playerModel[player] == nil then
			changeCharacter(player, defaultModel)
			playerModel[player] = defaultModel
		elseif playerModel[player] ~= nil then
			local playerCharacter = playerModel[player]
			changeCharacter(player, playerCharacter)
		else
			print("Error: CharacterSelection Line: 84")
		end
	end)
end