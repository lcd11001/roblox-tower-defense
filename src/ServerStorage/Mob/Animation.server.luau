-- print("Animation script loaded")

local currentAnim: string = nil
local currentAnimTrack: AnimationTrack = nil
local currentAnimKeyframeHandler: RBXScriptSignal = nil

function stopAllAnimations()
	local oldAnim = currentAnim

	currentAnim = ""
	if currentAnimKeyframeHandler ~= nil then
		currentAnimKeyframeHandler:Disconnect()
	end

	if currentAnimTrack ~= nil then
		currentAnimTrack:Stop()
		currentAnimTrack:Destroy()
		currentAnimTrack = nil
	end

	return oldAnim
end

function keyFrameReachedFunc(frameName, humanoid)
	if frameName == "End" then
--		print("Keyframe : ".. frameName)
		local repeatAnim = stopAllAnimations()
		playLoopAnimation(repeatAnim, 0.0, humanoid)
	end
end

function playLoopAnimation(animName, transitionTime, humanoid)
	if animName ~= currentAnim then		 
		
		if currentAnimTrack ~= nil then
			currentAnimTrack:Stop(transitionTime)
			currentAnimTrack:Destroy()
		end

		-- load it to the humanoid; get AnimationTrack
		currentAnimTrack = humanoid:LoadAnimation(animName)
		 
		-- play the animation
		currentAnimTrack:Play(transitionTime)
		currentAnim = animName

		-- set up keyframe name triggers
		if currentAnimKeyframeHandler ~= nil then
			currentAnimKeyframeHandler:Disconnect()
		end
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:Connect(function(frameName)
            keyFrameReachedFunc(frameName, humanoid)
        end)
	end
end

local model: Model = script.Parent

local humanoid: Humanoid = model:FindFirstChildOfClass("Humanoid")
if not humanoid then
    error("Humanoid not found in model ".. model.Name)
end

local animator: Animator = humanoid:FindFirstChildOfClass("Animator")
if not animator then
    error("Animator not found in model ".. model.Name)
end

local animations: Configuration = model:FindFirstChild("Animations")
if not animations then
    error("Animations not found in model ".. model.Name)
end

local walkAnimation: Animation = animations:FindFirstChild("Walk")
if not walkAnimation then
    error("Walk animation not found in model ".. model.Name)
else
    playLoopAnimation(walkAnimation, 0.1, humanoid)
end

local armsAnimation: Animation = animations:FindFirstChild("Arms")
if not armsAnimation then
    warn("Arms animation not found in model ".. model.Name)
else
    local armsAnim = animator:LoadAnimation(armsAnimation)
    armsAnim:Play(0.1)
end