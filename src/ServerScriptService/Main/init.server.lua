-- https://rojo.space/docs/v7/sync-details/#scripts
-- init.server.lua will change its parent directory into a Script instance.

local Mob = require(script.Mob)
local Map = workspace:WaitForChild("Grassland Map")
local Mobs = Map:WaitForChild("Mobs")
local MobWaveTime = 3
local MobWaveTotal = 5
local MobNames = { "Zombie", "Noob", "Mech", "Dracula" }

-- spawn waves of zombies
for wave = 1, MobWaveTotal do
	-- local mobName = wave ~= MobWaveTotal and MobNames[math.random(1, #MobNames - 1)] or MobNames[#MobNames]
    local mobName = MobNames[1]
	print("Spawning wave " .. wave .. " : " .. mobName)
	-- print("Mob name: " .. mobName)
	-- Mob.SpawnMultiple(mobName, Map, 3 * wave, { "ZombieMovement" })
    Mob.Spawn(mobName, Map, { "ZombieMovement", "ZombieAnimation" })

	repeat
		task.wait(1)
	-- print("Waiting for zombies have been destroyed")
	until #Mobs:GetChildren() == 0
	print("Wave " .. wave .. " cleared")
	task.wait(MobWaveTime)
end
