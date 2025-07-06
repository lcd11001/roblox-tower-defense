local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent: RemoteEvent = Events:WaitForChild("SpawnTowerEvent")

local Prefabs: Folder = ReplicatedStorage:WaitForChild("Prefabs")

local Tower = {}

local towerFolder: Folder = workspace:FindFirstChild("Towers")

function Tower.Spawn(player: Player, name: string, pivot: CFrame, perpendicular: Vector3): Model | nil
    local tower = Prefabs:FindFirstChild(name)
    if tower then
        local clonedTower: Model = tower:Clone()
        clonedTower.Parent = towerFolder
        clonedTower.HumanoidRootPart:SetNetworkOwner(nil)
        clonedTower:PivotTo(pivot)

        clonedTower:SetAttribute("Perpendicular", perpendicular)

        -- BodyGyro is deprecated and should not be used for new work. Use AlignOrientation instead
        --[[
        local bodyGyro: BodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 0
        bodyGyro.CFrame = clonedTower.HumanoidRootPart.CFrame
        bodyGyro.Parent = clonedTower.HumanoidRootPart
        ]]

        Helper.SetAlignOrientation(clonedTower.HumanoidRootPart, "TowerAlignOrientation", nil)
        Helper.SetColisionGroup(clonedTower, "Tower", false)
        Helper.AttachScriptFromStorage(clonedTower, "Damage", ServerStorage.Tower)

        return clonedTower
    else
        warn("Tower " .. name .. " not found in ReplicatedStorage.Prefabs")
    end
    return nil
end

spawnTowerEvent.OnServerEvent:Connect(Tower.Spawn)

return Tower
