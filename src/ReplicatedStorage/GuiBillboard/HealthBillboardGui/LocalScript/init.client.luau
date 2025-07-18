print("Loading Health Billboard GUI...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local UpdateHealthEvent = Events:WaitForChild("UpdateHealthEvent")

local HealthHelper = require(script:WaitForChild("HealthHelper"))

local gui = script.Parent
local model = gui:FindFirstAncestorOfClass("Model")

UpdateHealthEvent.OnClientEvent:Connect(function(instance, health, maxHealth)
    if not instance or not instance:IsA("Model") then
        warn("Invalid instance received for health update.")
        return
    end

    if instance ~= model then
        warn("Received health update for a different instance than the one this GUI is attached to.")
        return
    end

    HealthHelper.UpdateHealth(health, maxHealth)
    HealthHelper.UpdateHealthLabel(health, maxHealth)
end)
