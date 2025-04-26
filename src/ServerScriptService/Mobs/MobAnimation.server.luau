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

	local walkTrack: AnimationTrack = animator:LoadAnimation(walkAnimation)
    walkTrack:Play()
end

Mobs.ChildAdded:Connect(CreateAnimationMob)
