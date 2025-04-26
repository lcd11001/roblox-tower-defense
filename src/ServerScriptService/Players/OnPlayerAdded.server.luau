local Players = game:GetService("Players")
-- local PhysicsService = game:GetService("PhysicsService")

Players.PlayerAdded:Connect(function(player)
	print("Player added: " .. player.Name)

	player.CharacterAdded:Connect(function(character)
		print("Character added: " .. character.Name)

		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				-- PhysicsService:SetPartCollisionGroup(object, "Player")
				object.CollisionGroup = "Player"
			end
		end
	end)
end)
