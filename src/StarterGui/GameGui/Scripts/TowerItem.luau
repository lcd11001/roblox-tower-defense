local TowerItem = {}
local spawnItem: Model = nil

function TowerItem.SetSpawnItem(newItem: Model | nil)
    spawnItem = newItem
end

function TowerItem.GetSpawnItem(): Model | nil
    return spawnItem
end

return TowerItem
