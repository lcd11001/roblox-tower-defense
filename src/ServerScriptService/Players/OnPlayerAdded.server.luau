local Players = game:GetService("Players")
-- local PhysicsService = game:GetService("PhysicsService")

Players.PlayerAdded:Connect(function(player)
    print("Player added: " .. player.Name)

    player.CanLoadCharacterAppearance = false
    player.CharacterAdded:Connect(function(character)
        print("Character added: " .. character.Name)

        for _, object in ipairs(character:GetDescendants()) do
            if object:IsA("BasePart") then
                -- PhysicsService:SetPartCollisionGroup(object, "Player")
                object.CollisionGroup = "Player"
                object.Transparency = 1 -- Hide the character parts
            elseif object:IsA("Decal") then
                object.Transparency = 1 -- Hide decals
            end
        end

		character.Humanoid.JumpHeight = 0 -- Disable jumping
    end)
end)
