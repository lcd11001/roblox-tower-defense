-- Load AnimationModule script
local AnimationModule: ModuleScript = require(script.Parent.Parent:WaitForChild("AnimationModule"))

local Mobs: Folder = game.Workspace:WaitForChild("Mobs")

local function onMobAdded(model: Model)
    -- print("Mob added: " .. model.Name)
    AnimationModule.PlayAnimation(model, "Walk", true)
end

Mobs.ChildAdded:Connect(function(model: Model)
    onMobAdded(model)
end)

-- Animate existing mobs that were added before this script ran
-- Note: should be called after registering the ChildAdded event
for _, mob in ipairs(Mobs:GetChildren()) do
    -- print("Animating existing mob: " .. mob.Name)
    onMobAdded(mob)
end
