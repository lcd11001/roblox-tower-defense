-- Load AnimationModule script
local AnimationModule: ModuleScript = require(script.Parent.Parent:WaitForChild("AnimationModule"))

local Towers: Folder = game.Workspace:WaitForChild("Towers")

Towers.ChildAdded:Connect(function(model: Model)
    AnimationModule.PlayAnimation(model, "Idle")
end)