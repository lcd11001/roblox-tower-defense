local Players = game:GetService("Players")
-- local PhysicsService = game:GetService("PhysicsService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local SetupHealthBillboardEvent: RemoteEvent = Events:WaitForChild("SetupHealthBillboardEvent")

local ServerScriptService = game:GetService("ServerScriptService")
local Base = require(ServerScriptService.Main.Base)

local function setupBaseHealthForPlayer(player: Player)
    -- Wait for the main script to set up the base model
    while not Base.Model do
        task.wait(0.5)
    end

    -- Send the base information to the player
    print("Server: Sending base setup info to player: " .. player.Name)
    SetupHealthBillboardEvent:FireClient(player, Base.Model, Base.CurrentHealth, Base.MaxHealth)
end

local function onCharacterAdded(character)
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
end

local function onPlayerAdded(player)
    print("Player added: " .. player.Name)

    task.spawn(setupBaseHealthForPlayer, player)

    player.CanLoadCharacterAppearance = false
    player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)
