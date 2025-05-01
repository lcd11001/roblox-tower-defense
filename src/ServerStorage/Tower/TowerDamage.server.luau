local ServerScriptService = game:GetService("ServerScriptService")
local TowerConfig = require(ServerScriptService.Configs.TowerConfig)

local config = TowerConfig.GetConfig("1")

local tower: Model = script.Parent

local mobs = workspace:WaitForChild("Mobs")

local function FindNearestTarget(newTower: Model): BasePart | nil
    local maxDistance = config.MaxRange
    local nearestTarget = nil

    -- if tower has no humanoid root part, use the pivot
    local towerPosition = newTower:FindFirstChildWhichIsA("HumanoidRootPart") ~= nil and newTower.HumanoidRootPart.Position or newTower:GetPivot().Position

    for _, target in ipairs(mobs:GetChildren()) do
        local distance = (towerPosition - target.HumanoidRootPart.Position).Magnitude
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

local function Attack(newTower: Model)
    local target = FindNearestTarget(newTower)
    if target then
        -- print("Target found: " .. target.Name)
        -- Add your attack logic here
        TakeDamage(target)
    end

    task.wait(config.AttackSpeed) -- Adjust the wait time as needed

    -- recursively call the function to keep attacking
    Attack(newTower)
end

-- while true do
--     Attack(tower)
-- end

-- Use a coroutine to avoid blocking the main thread
coroutine.wrap(Attack)(tower)
