local TowerConfig = {
    Levels = {
        ["1"] = {
            MaxRange = 10,
            Damage = 20,
            AttackSpeed = 1,
            Cost = 100,
            UpgradeCost = 50,
            UpgradeLevel = 1,
        },
    },
}

function  TowerConfig.GetConfig(level: string): table
    local config = TowerConfig.Levels[level]
    if not config then
        error("Invalid tower level: " .. level)
    end
    return config
    
end

return TowerConfig