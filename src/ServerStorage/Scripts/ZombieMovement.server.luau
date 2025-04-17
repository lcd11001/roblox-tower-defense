-- print("ZombieMovement script loaded")

local zombie: Model = script.Parent
local humanoid: Humanoid = zombie:WaitForChild("Humanoid")

local mapName: string = zombie:GetAttribute("Map")
if not mapName then
    error("Map attribute not found in zombie model")
end

local waitpoints: {Part} = game.Workspace:WaitForChild(mapName):WaitForChild("Waypoints"):GetChildren()

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
