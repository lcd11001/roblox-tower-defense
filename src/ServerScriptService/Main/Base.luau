local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiBillboard = ReplicatedStorage:WaitForChild("GuiBillboard")
local HealthBillboardGui = GuiBillboard:WaitForChild("HealthBillboardGui")

local Events = ReplicatedStorage:WaitForChild("Events")
local UpdateHealthEvent: RemoteEvent = Events:WaitForChild("UpdateHealthEvent")

local ServerStorage = game:GetService("ServerStorage")
local BindableEvents = ServerStorage:WaitForChild("BindableEvents")
local BE_UpdateBaseHealth: BindableEvent = BindableEvents:WaitForChild("BE_UpdateBaseHealth")
local BE_GameOver: BindableEvent = BindableEvents:WaitForChild("BE_GameOver")

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
    Base.CurrentHealth = health
end

function Base.UpdateHealth(damage: number)
    Base.CurrentHealth = math.clamp(Base.CurrentHealth - damage, 0, Base.MaxHealth)
    UpdateHealthEvent:FireAllClients(Base.Model, Base.CurrentHealth, Base.MaxHealth)

    if Base.CurrentHealth == 0 then
        print("Base destroyed! Game Over!")
        BE_GameOver:Fire()
        -- Optionally, you can destroy the base model or perform other actions
        if Base.Model then
            Base.Model:Destroy()
        end
    end
end

BE_UpdateBaseHealth.Event:Connect(function(damage: number)
    Base.UpdateHealth(damage)
end)

return Base
