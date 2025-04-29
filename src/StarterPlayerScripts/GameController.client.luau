-- print("GameController script loaded")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

local function MouseRaycast(): RaycastResult
    local mousePosition: Vector2 = UserInputService:GetMouseLocation()
    -- print("Mouse position:", mousePosition)

    local ray: Ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    -- print("Ray:", ray)

    local result: RaycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000)
    return result
end

-- Connect the function to the RenderStepped event
RunService.RenderStepped:Connect(function()
    local result: RaycastResult = MouseRaycast()
    if result and result.Instance then
        print("Hit object:", result.Instance.Name)
    end
end)
