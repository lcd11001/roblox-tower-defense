-- print("GameController script loaded")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera
-- local item = nil
local highlightingItems = {}

local function MouseRaycast(): RaycastResult
    local mousePosition: Vector2 = UserInputService:GetMouseLocation()
    -- print("Mouse position:", mousePosition)

    local ray: Ray = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)
    -- print("Ray:", ray)

    local result: RaycastResult = workspace:Raycast(ray.Origin, ray.Direction * 1000)
    return result
end

local function HighlightPart(part: BasePart)
    if highlightingItems[part] then
        -- avoid part keep red color after double click
        return
    end

    highlightingItems[part] = true

    local originalColor = part.Color
    part.Color = Color3.new(1, 0, 0)
    task.delay(0.5, function()
        if part.Parent then
            part.Color = originalColor
        end

        highlightingItems[part] = nil
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local result: RaycastResult = MouseRaycast()
            if result and result.Instance then
                local item = result.Instance
                print("Hit object:", item.Name)
                if item:IsA("BasePart") then
                    HighlightPart(item)
                end
            end
        end
    end
end)

-- Connect the function to the RenderStepped event
-- RunService.RenderStepped:Connect(function()
--     local result: RaycastResult = MouseRaycast()
--     if result and result.Instance then
--         print("Hit object:", result.Instance.Name)
--     end
-- end)
