local Module = {}

function Module.IsFrontView(tower: PVInstance, target: PVInstance, startAngleDeg: number, endAngleDeg: number): boolean
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

function Module.IsValidTarget(target: PVInstance): boolean
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

function Module.FindNearestTarget(tower: PVInstance, maxDistance: number, targets: { PVInstance }): PVInstance | nil
    local nearestTarget = nil

    for _, target in ipairs(targets) do
        if not Module.IsFrontView(tower, target, -90, 90) then
            -- print(target.Name .. " is not in front of the tower.")
            continue
        end

        if not Module.IsValidTarget(target) then
            -- print(target.Name .. " is not a valid target.")
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

return Module
