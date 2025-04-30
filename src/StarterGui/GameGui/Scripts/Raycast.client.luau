local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Helper: Script = require(ReplicatedStorage:WaitForChild("Helper"))

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent: RemoteEvent = Events:WaitForChild("SpawnTowerEvent")

local camera = workspace.CurrentCamera
local highlightingItems = {}

local TowerItem = require(script.Parent.TowerItem)
local canPlaceTower = false
local rotationPlaceTower = 0

local function MouseRaycast(blacklist: { Instance }): RaycastResult
    local mousePosition: Vector2 = UserInputService:GetMouseLocation()
    -- print("Mouse position:", mousePosition)

    local ray: Ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    -- print("Ray:", ray)

    if blacklist == nil then
        blacklist = {}
    end
    local raycastParams: RaycastParams = RaycastParams.new()
    -- raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = blacklist

    local result: RaycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
    return result
end

local function HighlightPart(part: BasePart)
    if highlightingItems[part] then
        -- avoid part keep red color after double click
        return
    end

    highlightingItems[part] = true

    local originalColor = part.Color
    part.Color = Color3.new(1, 0, 0)
    task.delay(0.5, function()
        if part.Parent then
            part.Color = originalColor
        end

        highlightingItems[part] = nil
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        -- if input.UserInputType == Enum.UserInputType.MouseButton1 then
        --     local result: RaycastResult = MouseRaycast({ TowerItem.GetSpawnItem() })
        --     if result and result.Instance then
        --         local item = result.Instance
        --         print("Hit object:", item.Name)
        --         if item:IsA("BasePart") then
        --             HighlightPart(item)
        --         end
        --     end
        -- end

        local item: Model = TowerItem.GetSpawnItem()
        if item == nil then
            -- print("No item to spawn")
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if canPlaceTower then
                spawnTowerEvent:FireServer(item.Name, item:GetPivot())
                -- destroy the placeholder item
                item:Destroy()
                TowerItem.SetSpawnItem(nil)
            end
        end
    end
end)

-- Connect the function to the RenderStepped event
RunService.RenderStepped:Connect(function()
    local item: Model = TowerItem.GetSpawnItem()
    if not item then
        return
    end

    local result: RaycastResult = MouseRaycast({ item })
    if result and result.Instance then
        -- print("Hit object:", result.Instance.Name)
        local x = result.Position.X
        local y = result.Position.Y
        local z = result.Position.Z
        if result.Instance.Parent.Name == "TowerArea" then
            if not canPlaceTower then
                Helper.SetColor(item, Color3.fromRGB(0, 255, 0))
                canPlaceTower = true
            end
        else
            if canPlaceTower then
                canPlaceTower = false
                Helper.SetColor(item, Color3.fromRGB(255, 0, 0))
            end
        end

        local humanoid: Humanoid = item:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Option 1: Using Humanoid.HipHeight
            y += humanoid.HipHeight

            if item.PrimaryPart then
                y += item.PrimaryPart.Size.Y * 0.5
            end
        else
            -- Option 2: Using bounding box (if no Humanoid)
            local extents = item:GetExtentsSize()
            y += (extents.Y * 0.5)
        end

        TowerItem.Perpendicular(Vector3.new(x, y, z))
    end
end)
