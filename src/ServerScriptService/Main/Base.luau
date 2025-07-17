local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiBillboard = ReplicatedStorage:WaitForChild("GuiBillboard")
local HealthBillboardGui = GuiBillboard:WaitForChild("HealthBillboardGui")

local Base = {}

local mapName: string = "Grassland Map"
local Map = workspace:WaitForChild(mapName)
local Decor: Folder = Map:WaitForChild("Decor")
local self = Decor:FindFirstChild("Base")

function Base.createHealthBillboard()
    local billboard = HealthBillboardGui:Clone()
    billboard.Parent = self
    return billboard
end

function Base.Setup()
    Base.createHealthBillboard()
end

return Base