local ServerStorage = game:GetService("ServerStorage")

local tower = workspace:WaitForChild("Tower")
local towerTestingScript = ServerStorage.Scripts.TowerDamage:Clone()
towerTestingScript.Parent = tower
