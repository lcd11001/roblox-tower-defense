print("ZombieMovement script loaded")

local zombie: Model = script.Parent
local humanoid: Humanoid = zombie:WaitForChild("Humanoid")
local waitpoints: {Part} = game.Workspace:WaitForChild("Waypoints"):GetChildren()

-- sort waitpoints by name
table.sort(waitpoints, function(a: Part, b: Part)
    return a.Name < b.Name
end)

-- move to each waitpoint
for index=1, #waitpoints do
    local waitpoint: Part = waitpoints[index]
    if waitpoint:IsA("Part") then
        -- print("Moving to waitpoint: " .. waitpoint.Name)
        humanoid:MoveTo(waitpoint.Position)
        humanoid.MoveToFinished:Wait()
    end
end
