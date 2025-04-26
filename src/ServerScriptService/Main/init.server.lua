-- https://rojo.space/docs/v7/sync-details/#scripts
-- init.server.lua will change its parent directory into a Script instance.

local Mob = require(script.Mob)

local mapName: string = "Grassland Map"
local Map = workspace:WaitForChild(mapName)

-- local Mobs = Map:WaitForChild("Mobs")
local Mobs = workspace:WaitForChild("Mobs")
local MobWaveTime = 3
local MobWaveTotal = 5
local MobNames = { "Zombie", "Noob", "MechCannon", "Dracula" }

-- spawn waves of zombies
for wave = 1, MobWaveTotal do
	print("Spawning wave " .. wave)
	-- print("Mob name: " .. mobName)
	Mob.SpawnMultiple(MobNames, Map, 3 * wave, { "ZombieMovement" })
	-- Mob.SpawnMultiple(MobNames, Map, 3 * wave, { "ZombieMovement", "ZombieAnimation" })

	-- local mobName = MobNames[math.random(1, #MobNames)]
	-- Mob.Spawn(mobName, Map, { "ZombieMovement", "ZombieAnimation" })

	repeat
		task.wait(1)
	-- print("Waiting for zombies have been destroyed")
	until #Mobs:GetChildren() == 0
	print("Wave " .. wave .. " cleared")
	task.wait(MobWaveTime)
end
