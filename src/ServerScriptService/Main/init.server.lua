-- https://rojo.space/docs/v7/sync-details/#scripts
-- init.server.lua will change its parent directory into a Script instance.

local ServerScriptService = game:GetService("ServerScriptService")
local WaveConfig = require(ServerScriptService.Configs.WaveConfig)

-- Validate Configuration (Basic Check)
if not WaveConfig or not WaveConfig.Waves or #WaveConfig.Waves == 0 then
    error("WaveConfig is missing, invalid, or has no waves defined!")
end

if not WaveConfig.GlobalSettings then
    warn("WaveConfig.GlobalSettings not found, using defaults where applicable.")
    WaveConfig.GlobalSettings = {
        TimeBetweenWaves = 3,
        TimeBetweenMobs = 0.5,
        DefaultScripts = { "ZombieMovement" },
    }
end

local Mob = require(script.Mob)

local mapName: string = "Grassland Map"
local Map = workspace:WaitForChild(mapName)

-- local Mobs = Map:WaitForChild("Mobs")
local Mobs = workspace:WaitForChild("Mobs")
local MobWaveTime = WaveConfig.GlobalSettings.TimeBetweenWaves
local MobDelayTime = WaveConfig.GlobalSettings.TimeBetweenMobs
local MobWaveTotal = #WaveConfig.Waves

-- spawn waves of zombies
for wave = 1, MobWaveTotal do
    local waveData = WaveConfig.Waves[wave]

    if waveData.Message then
        print(waveData.Message)
    else
        print("Wave " .. wave)
    end

    local sequence = waveData.SpawnSequence or {}
    local scripts = waveData.Scripts or WaveConfig.GlobalSettings.DefaultScripts

    -- Check if dictionary exists and is not empty
    if type(sequence) ~= "table" or next(sequence) == nil then
        warn("SpawnSequence is not a valid table or is empty for wave " .. wave)
        continue
    end

    -- use ipairs to iterate over the dictionary in order (instead of pairs)
    for i, batch in ipairs(sequence) do
        -- print("batch", i)
        for mobName, count in pairs(batch) do
            print("Spawning " .. count .. " " .. mobName)
            for _ = 1, count do
                Mob.Spawn(mobName, Map, scripts)
                if MobDelayTime > 0 then
                    task.wait(MobDelayTime)
                end
            end
        end
    end

    if #Mobs:GetChildren() > 0 then
        repeat
            task.wait(1)
        -- print("Waiting for zombies have been destroyed")
        until #Mobs:GetChildren() == 0
        print("Wave " .. wave .. " cleared")
    end

    task.wait(MobWaveTime)
end

print("All waves completed!")
