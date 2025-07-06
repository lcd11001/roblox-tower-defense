local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Prefabs: Folder = ReplicatedStorage:WaitForChild("Prefabs")

local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local TowerItem = require(script.Parent.TowerItem)

local gui = script.Parent.Parent
local slingerButton: TextButton = gui:FindFirstChild("SlingerButton", true)

local function SpawnPlaceholderTower(name: string): Model | nil
    local towerPrefab = Prefabs:FindFirstChild(name)
    if towerPrefab then
        local placeholder = towerPrefab:Clone()
        placeholder.Parent = workspace
        return placeholder
    else
        warn("Tower " .. name .. " not found in ReplicatedStorage.Prefabs")
    end
    return nil
end

local function onSlingerButtonActivated()
    if TowerItem.GetSpawnItem() ~= nil then
        -- A placeholder already exists, do nothing.
        return
    end

    local placeholder = SpawnPlaceholderTower("Slinger")
    if placeholder then
        Helper.SetColisionGroup(placeholder, "Tower", true)
        TowerItem.SetSpawnItem(placeholder)
    end
end

slingerButton.Activated:Connect(onSlingerButtonActivated)
