local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local UpdateHealthEvent = Events:WaitForChild("UpdateHealthEvent")

local HealthHelper = require(script:WaitForChild("HealthHelper"))

local gui = script.Parent

UpdateHealthEvent.OnClientEvent:Connect(function(instance, health, maxHealth)
    if instance ~= gui.Adornee then
        warn("Received health update for a different instance than the one this GUI is attached to.")
        return
    end

    HealthHelper.UpdateHealth(health, maxHealth)
    HealthHelper.UpdateHealthLabel(health, maxHealth)
end)
