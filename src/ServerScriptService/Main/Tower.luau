local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local Events: Folder = ReplicatedStorage:WaitForChild("Events")
local spawnTowerEvent: RemoteEvent = Events:WaitForChild("SpawnTowerEvent")

local Prefabs: Folder = ReplicatedStorage:WaitForChild("Prefabs")

local Tower = {}

local towerFolder: Folder = workspace:FindFirstChild("Towers")

function Tower.Spawn(player: Player, name: string, pivot: CFrame): Model | nil
    local tower = Prefabs:FindFirstChild(name)
    if tower then
        local clonedTower: Model = tower:Clone()
        clonedTower.Parent = towerFolder
        clonedTower.HumanoidRootPart:SetNetworkOwner(nil)
        clonedTower:PivotTo(pivot)

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
