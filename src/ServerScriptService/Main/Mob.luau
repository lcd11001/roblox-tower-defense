local Mob = {}
local totalMob = 0

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local BindableEvents = ServerStorage:WaitForChild("BindableEvents")
local BE_UpdateBaseHealth: BindableEvent = BindableEvents:WaitForChild("BE_UpdateBaseHealth")

local Prefabs = ReplicatedStorage:WaitForChild("Prefabs")
local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local MobConfig = require(ServerScriptService:WaitForChild("Configs"):WaitForChild("MobConfig"))

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

        local x, y, z = start.Position.X, start.Position.Y, start.Position.Z

        -- set model name in view
        local humanoid: Humanoid = mob:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayName = string.gsub(mob.Name, "_", " ")
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer

            -- y += humanoid.HipHeight
            -- if mob.PrimaryPart then
            --     y += mob.PrimaryPart.Size.Y * 0.5
            -- end

            local extents = mob:GetExtentsSize()
            y += (extents.Y * 0.5)
        end

        mob:PivotTo(CFrame.new(x, y, z))
        mob.Parent = mobParent ~= nil and mobParent or game.Workspace
        -- avoid glitches when player collides with the mob
        mob.HumanoidRootPart:SetNetworkOwner(nil)

        Helper.SetAttachment(mob.HumanoidRootPart, "MobAlignOrientationAttachment")
        Helper.SetColisionGroup(mob, "Mob")
        Mob.InitAttributes(mob, name, map)
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

function Mob.InitAttributes(mob: Model, name: string, map: Instance)
    local mapName: string = map.Name
    mob:SetAttribute("Map", mapName)
    
    local humanoid: Humanoid = mob:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = MobConfig[name].Health -- Set initial health
        humanoid.MaxHealth = MobConfig[name].Health -- Set max health
        humanoid.WalkSpeed = MobConfig[name].Speed -- Set walk speed
        humanoid:SetAttribute("Damage", MobConfig[name].Damage)
    else
        warn("Humanoid not found in model " .. mob.Name)
    end
end

function Mob.RegisterEvents(mob: Model)
    local humanoid: Humanoid = mob:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            Mob.OnMobDied(mob)
        end)

        humanoid.Destroying:Connect(function()
            if humanoid.Health > 0 then
                warn("mob damage to the base")
                -- simulate damage to the base
                BE_UpdateBaseHealth:Fire(humanoid:GetAttribute("Damage") or 0)
            end
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
