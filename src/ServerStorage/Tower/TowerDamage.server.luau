local ServerScriptService = game:GetService("ServerScriptService")
local TowerConfig = require(ServerScriptService.Configs.TowerConfig)

local config = TowerConfig.GetConfig("1")

local tower: Model = script.Parent

local mobs = workspace:WaitForChild("Mobs")

local function FindNearestTarget(): BasePart | nil
    local maxDistance = config.MaxRange
    local nearestTarget = nil

    for _, target in ipairs(mobs:GetChildren()) do
        local distance = (tower:GetPivot().Position - target.HumanoidRootPart.Position).Magnitude
        -- print("Distance between tower and mob: " .. target.Name .. " is " .. distance)
        if distance < maxDistance then
            -- print(target.Name .. " is within range of the tower.")
            nearestTarget = target
            maxDistance = distance
        end
    end
    return nearestTarget
end

local function TakeDamage(target: BasePart): number
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:TakeDamage(config.Damage)
        -- print(target.Name .. " took " .. config.Damage .. " damage. Current health is " .. humanoid.Health)
        return config.Damage
    else
        warn("No humanoid found in target: " .. target.Name)
    end
    return 0
end

while true do
    local target = FindNearestTarget()
    if target then
        -- print("Target found: " .. target.Name)
        -- Add your attack logic here
        TakeDamage(target)
    end

    task.wait(config.AttackSpeed) -- Adjust the wait time as needed
end
