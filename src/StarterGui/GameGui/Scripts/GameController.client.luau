local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Prefabs = ReplicatedStorage:WaitForChild("Prefabs")

local TowerItem = require(script.Parent.TowerItem)

local gui = script.Parent.Parent
local slingerButton: TextButton = gui:FindFirstChild("SlingerButton", true)

local towerFolder: Folder = workspace:FindFirstChild("Towers")
local towerItem: Model = nil

local function SpawnTower(name: string): Model | nil
    local tower = Prefabs:FindFirstChild(name)
    if tower then
        local clonedTower = tower:Clone()
        clonedTower.Parent = towerFolder

        return clonedTower
    else
        warn("Tower " .. name .. " not found in ServerStorage.Towers")
    end
    return nil
end

local function AddPlaceholderTower(name: string)
    towerItem = SpawnTower(name)
    if towerItem then
        TowerItem.SetItem(towerItem)
    end
end

--[[
• button.Activated fires for both touch taps and mouse clicks on GUI buttons.
• button.InputBegan fires on every input event (e.g., mouse down, key pressed, etc.).
To handle both mobile touch and PC left click on a GUI button, simply connect to button.Activated.
]]
slingerButton.Activated:Connect(function()
    -- print("SlingerButton activated")
    AddPlaceholderTower("Slinger")
end)
