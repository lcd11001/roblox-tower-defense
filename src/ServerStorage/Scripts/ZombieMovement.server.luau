-- print("ZombieMovement script loaded")

local model: Model = script.Parent

local humanoid: Humanoid = model:FindFirstChildOfClass("Humanoid")
if not humanoid then
    error("Humanoid not found in model ".. model.Name)
end

local mapName: string = model:GetAttribute("Map")
if not mapName then
    error("Map attribute not found in model " .. model.Name)
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

--[[
https://youtu.be/R3AREWh14iQ?si=sRqXVPcvaXQogAsC&t=733
another way to do coroutine.wrap
]]

-- destroy the zombie after it reaches the last waitpoint
model:Destroy()
