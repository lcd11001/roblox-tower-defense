local Mobs: Folder = game.Workspace:WaitForChild("Mobs")

local function CreateAnimationMob(model)
	local humanoid: Humanoid = model:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		error("Humanoid not found in model " .. model.Name)
		return
	end

	local animator: Animator = humanoid:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Name = "Animator"
		animator.Parent = humanoid
	end

	local animations: Configuration = model:FindFirstChild("Animations")
	if not animations then
		error("Animations not found in model " .. model.Name)
		return
	end

	local walkAnimation: Animation = animations:FindFirstChild("Walk")
	if not walkAnimation then
		error("Walk animation not found in model " .. model.Name)
		return
	end

    task.wait(0.1) -- Wait for the model to be fully loaded

	local walkTrack: AnimationTrack = animator:LoadAnimation(walkAnimation)
    walkTrack.Looped = true
    walkTrack.Priority = Enum.AnimationPriority.Movement
    walkTrack:Play()
end

Mobs.ChildAdded:Connect(CreateAnimationMob)
