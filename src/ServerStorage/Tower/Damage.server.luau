local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local AnimateTowerEvent: RemoteEvent = Events:WaitForChild("AnimateTowerEvent")
local TargetModule = require(ReplicatedStorage:WaitForChild("TargetModule"))

local ServerScriptService = game:GetService("ServerScriptService")
local TowerConfig = require(ServerScriptService.Configs.TowerConfig)

local config = TowerConfig.GetConfig("1")

local self: Model = script.Parent

local mobs = workspace:WaitForChild("Mobs")

-- Calculate the angle between the two vectors
--  https://www.youtube.com/watch?v=88_qHWcXUIs

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

local function Attack(tower: Model)
    local target = TargetModule.FindNearestTarget(tower, config.MaxRange, mobs:GetChildren())

    local alignOrientation = tower.HumanoidRootPart:FindFirstChild("TowerAlignOrientation")

    if target then
        -- print("Target found: " .. target.Name)
        -- Add your attack logic here

        local targetCFrame = CFrame.lookAt(tower:GetPivot().Position, target:GetPivot().Position)

        -- BodyGyro is deprecated and should not be used for new work. Use AlignOrientation instead
        -- tower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame

        if alignOrientation then
            alignOrientation.CFrame = targetCFrame
        end

        TakeDamage(target)
        AnimateTowerEvent:FireAllClients("Attack", tower, target)
    else
        local Perpendicular = tower:GetAttribute("Perpendicular")
        if Perpendicular then
            -- Rotate the tower to face the perpendicular direction
            local towerPosition = tower:GetPivot().Position
            local targetCFrame = CFrame.lookAt(towerPosition, towerPosition + Perpendicular)

            -- BodyGyro is deprecated and should not be used for new work. Use AlignOrientation instead
            -- tower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame

            if alignOrientation then
                alignOrientation.CFrame = targetCFrame
            end
        end

        AnimateTowerEvent:FireAllClients("Idle", tower)
    end

    task.wait(config.AttackSpeed) -- Adjust the wait time as needed

    -- recursively call the function to keep attacking
    Attack(tower)
end

-- while true do
--     Attack(self)
-- end

-- Use a coroutine to avoid blocking the main thread
coroutine.wrap(Attack)(self)
