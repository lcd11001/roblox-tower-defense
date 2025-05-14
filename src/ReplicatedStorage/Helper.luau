local Helper = {}

-- Roblox doesn't have a built-in global variable like 'workspace', so we need to define it
local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")
local starterGui = game:GetService("StarterGui")
local starterPack = game:GetService("StarterPack")
local userInputService = game:GetService("UserInputService")
-- local physicsService = game:GetService("PhysicsService")

local function DetectRoot(root: string)
    if root == "Workspace" then
        return workspace -- built-in Roblox global variable
    elseif root == "ReplicatedStorage" then
        return replicatedStorage
    elseif root == "ServerStorage" then
        return serverStorage
    elseif root == "StarterGui" then
        return starterGui
    elseif root == "StarterPack" then
        return starterPack
    end

    return nil
end

function Helper.AttachScriptFromStorage(part: Instance, scriptName: string, storage: Instance)
    local script = storage:FindFirstChild(scriptName)
    if not script then
        warn("Script " .. scriptName .. " not found in " .. storage.Name)
        return
    end
    Helper.AttachScript(part, script)
end

function Helper.AttachScript(part: Instance, script: Script)
    if part and script then
        local newScript = script:Clone()
        newScript.Parent = part
        -- print(script.Name .. " attached to " .. part.Name .. "!")
    elseif not part then
        warn("invalid part!")
    elseif not script then
        warn("invalid script!")
    else
        warn(part.Name .. " or " .. script.Name .. " not found!")
    end
end

function Helper.FindObjectByPath(path: string): Instance | nil
    local rootPath = string.match(path, "([^/]+)")
    local current = DetectRoot(rootPath)
    if current == nil then
        return nil
    end

    local objectPath = string.match(path, "/(.*)")
    for name in string.gmatch(objectPath, "[^/]+") do
        current = current:FindFirstChild(name)
        if not current then
            return nil -- Return nil if any part of the path is not found
        end
    end
    return current -- Return the final object if found
end

function Helper.WaitObjectByPath(path: string): Instance | nil
    local rootPath = string.match(path, "([^/]+)")
    local current = DetectRoot(rootPath)
    if current == nil then
        return nil
    end

    local objectPath = string.match(path, "/(.*)")
    for name in string.gmatch(objectPath, "[^/]+") do
        current = current:WaitForChild(name)
    end
    return current
end

function Helper.AttachScriptFromPath(partPath: string, scriptPath: string)
    -- find the part
    local part = Helper.FindObjectByPath(partPath)
    if part == nil then
        warn(partPath .. " not found")
        return
    end

    -- find the script
    local script = Helper.FindObjectByPath(scriptPath)
    if script == nil then
        warn(scriptPath .. " not found")
        return
    end

    -- attach the script into the part
    Helper.AttachScript(part, script)
end

function Helper.SetColisionGroup(model: Model, groupName: string, forceField: boolean?)
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("BasePart") then
            -- physicsService:SetPartCollisionGroup(object, groupName)
            object.CollisionGroup = groupName

            if forceField == true then
                object.Material = Enum.Material.ForceField
            end
        end
    end
end

function Helper.SetColor(model: Model, color: Color3)
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Color = color
        end
    end
end

function Helper.IsMobile(): boolean
    return userInputService.TouchEnabled and not userInputService.MouseEnabled
end

return Helper
