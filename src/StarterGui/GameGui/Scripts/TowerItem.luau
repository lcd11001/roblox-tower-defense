local TowerItem = {}
local spawnItem: Model = nil

local mapName: string = "Grassland Map"
local Map = workspace:WaitForChild(mapName)
local Paths: Folder = Map:WaitForChild("Paths")

function TowerItem.SetSpawnItem(newItem: Model | nil)
    spawnItem = newItem
end

function TowerItem.GetSpawnItem(): Model | nil
    return spawnItem
end

local function GetClosestPointOnPath(spawnPos: Vector3, path: BasePart): Vector3
    local pathPos = path.Position
    local size = path.Size
    local cframe = path.CFrame

    local forward
    local halfLength
    if size.X > size.Z then
        forward = cframe.RightVector
        halfLength = size.X / 2
    else
        forward = cframe.LookVector
        halfLength = size.Z / 2
    end

    local toSpawn = spawnPos - pathPos
    local dot = math.clamp(toSpawn:Dot(forward), -halfLength, halfLength)
    return pathPos + forward * dot
end

local function FindClosetPath(): BasePart | nil
    if spawnItem then
        local spawnItemPos = spawnItem:GetPivot().Position

        local closestPath: BasePart = nil
        local closestDistance: number = math.huge
        -- local Paths: { BasePart } = SnappingParts:GetChildren()
        local paths: { BasePart } = Paths:GetChildren()
        for _, path in pairs(paths) do
            -- This fails for long rail segments, because the part's .Position is its center, not the closest point on the rail's surface or axis
            -- local distance: number = (spawnItem:GetPivot().Position - path.Position).Magnitude

            local closestPoint = GetClosestPointOnPath(spawnItemPos, path)

            -- measure distance from spawnItem to closest point on path
            local distance = (spawnItemPos - closestPoint).Magnitude

            if distance < closestDistance then
                closestDistance = distance
                closestPath = path
            end
        end
        -- print("Closest path found:", closestPath.Name)
        return closestPath
    end
    return nil
end

function TowerItem.Perpendicular(itemPosition: Vector3): Vector3 | nil
    if spawnItem then
        local closestPath: BasePart | nil = FindClosetPath()
        if closestPath then
            local pathPosition = closestPath.Position
            local pathSize = closestPath.Size
            local forward = Vector3.new(0, 0, 0)
            --Get the forward (look) vector of the part
            if pathSize.X > pathSize.Z then
                forward = closestPath.CFrame.RightVector
            else
                forward = closestPath.CFrame.LookVector
            end

            -- compute a perpendicular vector using cross product
            -- cross with up vector to get perpendicular horizontal vector
            local up = Vector3.yAxis
            local perpendicular = forward:Cross(up).Unit

            -- compute direction vector from item to path
            local direction = (pathPosition - itemPosition).Unit

            -- Flip direction if necessary, depending on which side the model is on
            if direction:Dot(perpendicular) < 0 then
                perpendicular = -perpendicular
            end

            -- make a model look perpendicular to a closet long part
            local newCFrame = CFrame.lookAt(itemPosition, itemPosition + perpendicular, up)
            -- spawnItem:SetPrimaryPartCFrame(newCFrame)
            spawnItem:PivotTo(newCFrame)

            return perpendicular
        else
            warn("No path found for rotation")
        end
    end

    return nil
end

return TowerItem
