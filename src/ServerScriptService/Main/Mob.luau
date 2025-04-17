local Mob = {}

local ServerStorage = game:GetService("ServerStorage")

function Mob.Spawn(name: string, map: Instance, scripts: {string}?)
    -- print("Spawning " .. name .. " on map " .. map.Name)
    local start: Part = map:FindFirstChild("Start")
    if not start then
        warn("Start part not found in map " .. map.Name)
        return
    end

    local prefabExists = ServerStorage.Prefabs:FindFirstChild(name)
    if prefabExists then
        local mob: Model = prefabExists:Clone()
        local startPos: Vector3 = start.Position
        mob:PivotTo(CFrame.new(startPos))
        mob.Parent = game.Workspace

        Mob.InitAttributes(mob, map)
        Mob.AttachScripts(mob, scripts)
    else
        warn("Prefab " .. name .. " does not exist in ServerStorage.Prefabs")
    end
end

function Mob.AttachScripts(mob: Model, scripts: {string}?)
    if not scripts then
        return
    end

    for _, scriptName in ipairs(scripts) do
        local script: Instance = ServerStorage.Scripts:FindFirstChild(scriptName)
        if script then
            local newScript: Instance = script:Clone()
            newScript.Parent = mob
        else
            warn("Script " .. scriptName .. " does not exist in ServerStorage.Scripts")
        end
    end
end

function Mob.InitAttributes(mob: Model, map: Instance)
    local mapName: string = map.Name
    mob:SetAttribute("Map", mapName)
end

return Mob