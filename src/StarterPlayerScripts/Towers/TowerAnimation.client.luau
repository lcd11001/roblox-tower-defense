local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local AnimateTowerEvent: RemoteEvent = Events:WaitForChild("AnimateTowerEvent")

-- Load AnimationModule script
local AnimationModule: ModuleScript = require(script.Parent.Parent:WaitForChild("AnimationModule"))

local Towers: Folder = game.Workspace:WaitForChild("Towers")

Towers.ChildAdded:Connect(function(model: Model)
    AnimationModule.PlayAnimation(model, "Idle")
end)

AnimateTowerEvent.OnClientEvent:Connect(function(animationName: string, tower: Model, target: BasePart)
    AnimationModule.PlayAnimation(tower, animationName)
end)