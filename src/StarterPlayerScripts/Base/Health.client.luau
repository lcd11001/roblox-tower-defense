print("Client: Initializing Base Health...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Events = ReplicatedStorage:WaitForChild("Events")
local SetupHealthBillboardEvent = Events:WaitForChild("SetupHealthBillboardEvent")

local GuiBillboard = ReplicatedStorage:WaitForChild("GuiBillboard")
local HealthBillboardGui = GuiBillboard:WaitForChild("HealthBillboardGui")

-- A table to keep track of which objects have health bars
local healthBars = {}

local function onSetupHealthBillboard(instance, health, maxHealth)
    print("Setting up health billboard for: " .. instance.Name .. " with health: " .. health .. "/" .. maxHealth)

    -- Check if we already created a health bar for this instance
    local billboard = healthBars[instance]

    -- If not, and the instance still exists, create one
    if not billboard and instance and instance.Parent then
        billboard = HealthBillboardGui:Clone()
        -- The HealthHelper module can be required by the script inside the cloned GUI
        billboard.Adornee = instance
        -- LocalScripts do not run automatically when they are descendants of parts in the Workspace. 
        -- They only run when they are located in specific containers tied to the player, such as PlayerGui, StarterPlayerScripts, or the player's character.
        billboard.Parent = LocalPlayer:WaitForChild("PlayerGui") -- Parent to PlayerGui
        healthBars[instance] = billboard

        local healthHelper = require(billboard:WaitForChild("LocalScript"):WaitForChild("HealthHelper"))
        healthHelper.UpdateHealth(health, maxHealth)
        healthHelper.UpdateHealthLabel(health, maxHealth)
    end
end

SetupHealthBillboardEvent.OnClientEvent:Connect(onSetupHealthBillboard)
