-- Load AnimationModule script
local AnimationModule: ModuleScript = require(script.Parent.Parent:WaitForChild("AnimationModule"))

local Mobs: Folder = game.Workspace:WaitForChild("Mobs")

Mobs.ChildAdded:Connect(function(model: Model)
    AnimationModule.PlayAnimation(model, "Walk", true)
end)