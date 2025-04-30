local Mob = {}
local totalMob = 0

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")

local Prefabs = ReplicatedStorage:WaitForChild("Prefabs")
local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

-- local mobParent: Folder = map:FindFirstChild("Mobs")
local mobParent: Folder = workspace:FindFirstChild("Mobs")

function Mob.SpawnMultiple(names: { string }, map: Instance, quantity: number, scripts: { string }?)
    -- print("Spawning " .. quantity .. " " .. name .. " on map " .. map.Name)
    for _ = 1, quantity do
        local name: string = names[math.random(1, #names)]
        Mob.Spawn(name, map, scripts)
        task.wait(0.5)
    end
end

function Mob.Spawn(name: string, map: Instance, scripts: { string }?)
    -- print("Spawning " .. name .. " on map " .. map.Name)
    local start: Part = map:FindFirstChild("Start")
    if not start then
        warn("Start part not found in map " .. map.Name)
        return
    end

    local prefabExists = Prefabs:FindFirstChild(name)
    if prefabExists then
        local mob: Model = prefabExists:Clone()
        totalMob += 1
        -- set model name in workspace
        mob.Name = mob.Name .. "_" .. tostring(totalMob)

        -- set model name in view
        local humanoid: Humanoid = mob:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayName = string.gsub(mob.Name, "_", " ")
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end

        local startPos: Vector3 = start.Position
        mob:PivotTo(CFrame.new(startPos))
        mob.Parent = mobParent ~= nil and mobParent or game.Workspace
        -- avoid glitches when player collides with the mob
        mob.HumanoidRootPart:SetNetworkOwner(nil)

        Helper.SetColisionGroup(mob, "Mob")
        Mob.InitAttributes(mob, map)
        Mob.AttachScripts(mob, scripts)
        Mob.RegisterEvents(mob)
    else
        warn("Prefab " .. name .. " does not exist in ServerStorage.Prefabs")
    end
end

function Mob.AttachScripts(mob: Model, scripts: { string }?)
    if not scripts then
        return
    end

    for _, scriptName in ipairs(scripts) do
        -- local script: Instance = ServerStorage.Mob:FindFirstChild(scriptName)
        -- if script then
        --     local newScript: Instance = script:Clone()
        --     newScript.Parent = mob
        -- else
        --     warn("Script " .. scriptName .. " does not exist in ServerStorage.Scripts")
        -- end
        Helper.AttachScriptFromStorage(mob, scriptName, ServerStorage.Mob)
    end
end

function Mob.InitAttributes(mob: Model, map: Instance)
    local mapName: string = map.Name
    mob:SetAttribute("Map", mapName)
end

function Mob.RegisterEvents(mob: Model)
    local humanoid: Humanoid = mob:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            Mob.OnMobDied(mob)
        end)
    else
        warn("Humanoid not found in model " .. mob.Name)
    end
end

function Mob.OnMobDied(mob: Model)
    task.wait(1) -- Wait for the death animation to play
    mob:Destroy()
end

return Mob
