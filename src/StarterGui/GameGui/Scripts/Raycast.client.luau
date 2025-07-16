local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local Player: Player = Players.LocalPlayer
local Character: Model = Player.Character or Player.CharacterAdded:Wait()

local Helper: Script = require(ReplicatedStorage:WaitForChild("Helper"))

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent: RemoteEvent = Events:WaitForChild("SpawnTowerEvent")

local camera = workspace.CurrentCamera

local TowerItem = require(script.Parent.TowerItem)
local canPlaceTower = false

local function GetRaycastResult(
    origin: Vector3,
    direction: Vector3,
    blacklist: { Instance },
    distance: number
): RaycastResult
    local raycastParams: RaycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = blacklist or {}

    local result: RaycastResult = workspace:Raycast(origin, direction * (distance or 1000), raycastParams)
    return result
end

local function PlaceTower()
    local item: Model = TowerItem.GetSpawnItem()
    if item == nil then
        -- print("No item to spawn")
        return
    end

    if canPlaceTower then
        spawnTowerEvent:FireServer(item.Name, item:GetPivot(), item:GetAttribute("Perpendicular"))
        -- destroy the placeholder item
        item:Destroy()
        TowerItem.SetSpawnItem(nil)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            PlaceTower()
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    -- print("JumpRequest")
    if Helper.IsMobile() then
        PlaceTower()
    end
end)

-- Connect the function to the RenderStepped event
RunService.RenderStepped:Connect(function()
    local item: Model = TowerItem.GetSpawnItem()
    if not item then
        return
    end

    -- Raycast from the mouse on PC, or the center of the screen on mobile
    local result: RaycastResult
    if Helper.IsMobile() then
        local viewportSize = camera.ViewportSize
        local centerRay = camera:ViewportPointToRay(viewportSize.X / 2, viewportSize.Y / 2)
        result = GetRaycastResult(centerRay.Origin, centerRay.Direction, { item, Character }, 1000)
    else
        local mousePosition = UserInputService:GetMouseLocation()
        local mouseRay = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
        result = GetRaycastResult(mouseRay.Origin, mouseRay.Direction, { item, Character }, 1000)
    end

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

        -- item:PivotTo(CFrame.new(x, y, z))
        local perpendicular = TowerItem.Perpendicular(item, Vector3.new(x, y, z))
        if perpendicular then
            item:SetAttribute("Perpendicular", perpendicular)
        end
    end
end)
