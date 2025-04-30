print("Tower init script running")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Helper = require(ReplicatedStorage:WaitForChild("Helper"))

local tower = script.Parent
Helper.AttachScriptFromStorage(tower, "TowerDamage", ServerStorage.Tower)
