local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local orientationGui = player:WaitForChild("PlayerGui"):WaitForChild("OrientationGui")

-- Helper function to check if current orientation is portrait
local function isPortrait()
    local size = workspace.CurrentCamera.ViewportSize
    return size.Y > size.X
end

-- Update visibility based on orientation
local function updateOrientationGui()
    orientationGui.Enabled = isPortrait()
end

-- Initial check
updateOrientationGui()

-- Listen for changes every frame (or you could use a debounce timer)
RunService.RenderStepped:Connect(updateOrientationGui)
