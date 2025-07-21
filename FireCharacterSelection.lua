local characterselect = game.ReplicatedStorage.CharacterSelectionEvents.CharacterSelectFromButton

script.Parent.MouseButton1Click:Connect(function()
	characterselect:FireServer("TestingRig")
end)