local gui = script.Parent.Parent

local module = {}

local CurrentHealth = gui:FindFirstChild("CurrentHealth", true)
local HealthLabel = gui:FindFirstChild("HealthLabel", true)

module.UpdateHealth = function(health, maxHealth)
    print("GUI health updated: " .. health .. "/" .. maxHealth)

    -- Ensure health is within bounds
    health = math.clamp(health, 0, maxHealth)
    -- Update the health bar
    if CurrentHealth then
        local percent = health / maxHealth
        CurrentHealth.Size = UDim2.new(percent, 0, 0.5, 0)
    end
end

module.UpdateHealthLabel = function(health, maxHealth)
    print("GUI health label updated: " .. health .. "/" .. maxHealth)

    -- Update the health label
    if HealthLabel then
        HealthLabel.Text = string.format("Base: %d/%d", health, maxHealth)
    end
end

return module
