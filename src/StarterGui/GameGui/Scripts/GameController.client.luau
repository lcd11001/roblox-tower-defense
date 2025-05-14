local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer

local Prefabs: Folder = ReplicatedStorage:WaitForChild("Prefabs")

local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local TowerItem = require(script.Parent.TowerItem)


local gui = script.Parent.Parent
local slingerButton: TextButton = gui:FindFirstChild("SlingerButton", true)

local SLINGER_BUTTON_TITLE = "Slinger"
local PLACE_HOLDER_BUTTON_TITLE = "Place Tower"

local isMobilePlacementModeActive = false

local towerFolder: Folder = workspace:FindFirstChild("Towers")

local function SpawnTower(name: string): Model | nil
    local tower = Prefabs:FindFirstChild(name)
    if tower then
        local clonedTower = tower:Clone()
        -- clonedTower.Parent = towerFolder
        clonedTower.Parent = workspace

        return clonedTower
    else
        warn("Tower " .. name .. " not found in ReplicatedStorage.Prefabs")
    end
    return nil
end

local function AddPlaceholderTower(name: string)
    if TowerItem.GetSpawnItem() ~= nil then
        -- avoid duplicate placeholder towers
        -- print("placeholder tower already exists")
        return
    end

    local towerItem: Model = SpawnTower(name)
    if towerItem then
        Helper.SetColisionGroup(towerItem, "Tower", true)
        TowerItem.SetSpawnItem(towerItem)
    end
end

local function ToggleMobilePlacementMode(activate: boolean)
    isMobilePlacementModeActive = activate
    if activate then
        -- disable movement of the player
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        character.HumanoidRootPart.Anchored = true

        slingerButton.Text = PLACE_HOLDER_BUTTON_TITLE
    else
        -- enable movement of the player
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        character.HumanoidRootPart.Anchored = false
        
        slingerButton.Text = SLINGER_BUTTON_TITLE
    end
end

--[[
• button.Activated fires for both touch taps and mouse clicks on GUI buttons.
• button.InputBegan fires on every input event (e.g., mouse down, key pressed, etc.).
To handle both mobile touch and PC left click on a GUI button, simply connect to button.Activated.
]]
slingerButton.Activated:Connect(function()
    -- print("SlingerButton activated")
    if Helper.IsMobile() then
        -- print("Mobile placement mode activated")
        ToggleMobilePlacementMode(not isMobilePlacementModeActive)
    end

    AddPlaceholderTower("Slinger")
end)
