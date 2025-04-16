-- spawn a zombie from prefabs
local function spawnZombie()
    local zombiePrefab: Model = game.ServerStorage.Prefabs.DroolingZombie:Clone()
    local movementScript = game.ServerStorage.Scripts.ZombieMovement:Clone()

    -- attach the movement script to the zombie
    movementScript.Parent = zombiePrefab

    local spawnLocation: Part = game.Workspace.SpawnLocation
    zombiePrefab:MoveTo(spawnLocation.Position)

    zombiePrefab.Parent = game.Workspace
end

-- spawn a zombie every 5 seconds
while true do
    spawnZombie()
    task.wait(5)
end