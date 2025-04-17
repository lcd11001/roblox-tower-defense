-- spawn a zombie from prefabs
local function spawnZombie()
    local zombie: Model = game.ServerStorage.Prefabs.Zombie:Clone()
    local movementScript:Script = game.ServerStorage.Scripts.ZombieMovement:Clone()

    -- attach the movement script to the zombie
    movementScript.Parent = zombie

    local spawnLocation: Part = game.Workspace.SpawnLocation
    zombie:PivotTo(CFrame.new(spawnLocation.Position))

    zombie.Parent = game.Workspace
end

-- spawn a zombie every 5 seconds
while true do
    spawnZombie()
    task.wait(5)
end