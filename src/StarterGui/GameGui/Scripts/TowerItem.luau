local TowerItem = {}
local spawnItem: Model = nil

function TowerItem.SetSpawnItem(newItem: Model)
    spawnItem = newItem
end

function TowerItem.GetSpawnItem(): Model
    return spawnItem
end

return TowerItem
