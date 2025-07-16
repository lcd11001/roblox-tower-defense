local Module = {}

function Module.SetAnimation(model: Model, animName: string): AnimationTrack
    local humanoid: Humanoid = model:WaitForChild("Humanoid")

    local animator: Animator = humanoid:FindFirstChild("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Name = "Animator"
        animator.Parent = humanoid
    end

    local animations: Configuration = model:FindFirstChild("Animations")
    if not animations then
        warn("Animations not found in model " .. model.Name)
        return nil
    end

    local animation: Animation = animations:FindFirstChild(animName)
    if not animation then
        warn(animName .. " animation not found in model " .. model.Name)
        return nil
    end

    -- Optimization: Check if the animation is already loaded
    local playingTracks = animator:GetPlayingAnimationTracks()
    for _, track in ipairs(playingTracks) do
        -- print("Checking track: " .. track.Name)
        if track.Name == animName then
            return track -- Return the existing track if it's already loaded
        end
    end

    local animationTrack: AnimationTrack = animator:LoadAnimation(animation)
    if not animationTrack then
        warn("Failed to load animation " .. animName .. " for model " .. model.Name)
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

    -- task.wait(0.5) -- Wait for the model to be fully loaded

    animationTrack:Play()
end

return Module
