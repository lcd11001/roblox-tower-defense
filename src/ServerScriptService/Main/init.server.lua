-- https://rojo.space/docs/v7/sync-details/#scripts
-- init.server.lua will change its parent directory into a Script instance.

local Mob = require(script.Mob)
local Map = workspace:WaitForChild("Grassland Map")

for _ = 1, 3 do
    Mob.Spawn("Zombie", Map, {"ZombieMovement"})
    task.wait(3)
end

