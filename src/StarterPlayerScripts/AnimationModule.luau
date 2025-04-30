local Module = {}

function Module.SetAnimation(model: Model, animName: string): AnimationTrack
    local humanoid: Humanoid = model:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        error("Humanoid not found in model " .. model.Name)
        return nil
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
        return nil
    end

    local animation: Animation = animations:FindFirstChild(animName)
    if not animation then
        error(animName .. " animation not found in model " .. model.Name)
        return nil
    end

    local animationTrack: AnimationTrack = animator:LoadAnimation(animation)
    if not animationTrack then
        error("Failed to load animation " .. animName .. " for model " .. model.Name)
        return nil
    end

    return animationTrack
end

function Module.PlayAnimation(model: Model, animName: string, loop: boolean?)
    local animationTrack: AnimationTrack = Module.SetAnimation(model, animName)
    if animationTrack == nil then
        return
    end

    if loop ~= nil then
        animationTrack.Looped = loop
    end

    task.wait(0.5) -- Wait for the model to be fully loaded

    animationTrack:Play()
end

return Module
