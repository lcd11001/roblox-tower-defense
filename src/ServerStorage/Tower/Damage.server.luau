local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local AnimateTowerEvent: RemoteEvent = Events:WaitForChild("AnimateTowerEvent")

local ServerScriptService = game:GetService("ServerScriptService")
local TowerConfig = require(ServerScriptService.Configs.TowerConfig)

local config = TowerConfig.GetConfig("1")

local self: Model = script.Parent

local mobs = workspace:WaitForChild("Mobs")

-- Calculate the angle between the two vectors
--  https://www.youtube.com/watch?v=88_qHWcXUIs

local function IsFrontView(tower: Model, target: BasePart, startAngleDeg: number, endAngleDeg: number): boolean
    local towerPosition = tower:GetPivot().Position
    local targetPosition = target:GetPivot().Position

    local tower2DPosition = Vector3.new(towerPosition.X, 0, towerPosition.Z)
    local target2DPosition = Vector3.new(targetPosition.X, 0, targetPosition.Z)

    -- Calculate the direction from the tower to the target
    local direction = (target2DPosition - tower2DPosition).Unit

    -- Get the forward vector of the tower
    local look2DVector = Vector3.new(tower:GetPivot().LookVector.X, 0, tower:GetPivot().LookVector.Z)
    local forwardVector = look2DVector.Unit

    -- Calculate the dot product (cosine of the angle) between the forward vector and the direction vector
    local dotProduct = forwardVector:Dot(direction)
    if dotProduct < 0 then
        -- The target is behind the tower
        return false
    end

    -- Clamp the dot product to the range [0, 1] to avoid NaN issues
    dotProduct = math.clamp(dotProduct, 0, 1)

    -- Calculate the angle in radians (0 to pi)
    local angleRad = math.acos(dotProduct)
    local angleDeg = math.deg(angleRad)

    -- determine the sign of the angle using the cross product
    local crossProduct = forwardVector:Cross(direction)
    -- print("Cross product: " .. tostring(crossProduct))
    local sign = math.sign(crossProduct.Y)

    -- If crossProduct.Y is very close to 0, the target is directly in front or behind.
    -- In this case, the sign doesn't matter much unless start/end angles are exactly 0.
    -- If sign is 0, we can default it to 1 (or handle it based on dot product if needed).
    if sign == 0 then
        sign = 1
    end

    local signedAngleDeg = angleDeg * sign
    -- print("Angle between tower and target: " .. target.Name .. " is " .. signedAngleDeg .. " degrees")

    -- Check if the signed angle is within the specified range
    return startAngleDeg <= signedAngleDeg and signedAngleDeg <= endAngleDeg
end

local function IsValidTarget(target: PVInstance): boolean
    -- A PVInstance ("Position Velocity Instance") is a base class for many Roblox objects, including BasePart and Model.
    if not target or not target:IsA("PVInstance") then
        return false
    end

    -- Check if the target is a humanoid or has a humanoid
    local humanoid = target:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end

    return false
end

local function FindNearestTarget(tower: Model): BasePart | nil
    local maxDistance = config.MaxRange
    local nearestTarget = nil

    for _, target in ipairs(mobs:GetChildren()) do
        if not IsFrontView(tower, target, -75, 75) then
            -- print(target.Name .. " is not in front of the tower.")
            continue
        end

        if not IsValidTarget(target) then
            print(target.Name .. " is not a valid target.")
            continue
        end

        local distance = (tower:GetPivot().Position - target:GetPivot().Position).Magnitude
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

local function Attack(tower: Model)
    local target = FindNearestTarget(tower)
    if target then
        -- print("Target found: " .. target.Name)
        -- Add your attack logic here
        TakeDamage(target)
        AnimateTowerEvent:FireAllClients("Attack", tower, target)
    else
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
