local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiBillboard = ReplicatedStorage:WaitForChild("GuiBillboard")
local HealthBillboardGui = GuiBillboard:WaitForChild("HealthBillboardGui")

local Events = ReplicatedStorage:WaitForChild("Events")
local UpdateHealthEvent: RemoteEvent = Events:WaitForChild("UpdateHealthEvent")

local Base = {
    Model = nil, -- This will be set when the base is set up
    MaxHealth = 1000, -- Default health, can be overridden
    CurrentHealth = 1000, -- Default health, can be overridden
}

function Base.CreateHealthBillboard(parent: Instance)
    local billboard = HealthBillboardGui:Clone()
    billboard.Parent = parent
    return billboard
end

function Base.Setup(Map: Instance, health: number)
    Base.Model = Map:FindFirstChild("Base")
    Base.MaxHealth = health
    Base.CurrentHealth = health / 2
end

function Base.UpdateHealth(damage: number)
    Base.CurrentHealth = math.clamp(Base.CurrentHealth - damage, 0, Base.MaxHealth)
    print("Base health updated: " .. Base.CurrentHealth .. "/" .. Base.MaxHealth)

    UpdateHealthEvent:FireAllClients(Base.Model, Base.CurrentHealth, Base.MaxHealth)
end

return Base
