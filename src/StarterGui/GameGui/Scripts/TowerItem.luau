local TowerItem = {}
local item: Model = nil

function TowerItem.SetItem(newItem: Model)
    item = newItem
end

function TowerItem.GetItem(): Model
    return item
end

return TowerItem
