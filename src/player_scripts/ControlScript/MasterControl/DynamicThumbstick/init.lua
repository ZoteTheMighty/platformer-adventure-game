--[[
	// FileName: DynamicThumbstick
	// Version 0.9
	// Written by: jhelms
	// Description: Implements dynamic thumbstick controls for touch devices
--]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Settings = UserSettings()
local GameSettings = Settings.GameSettings

local MasterControl = require(script.Parent)

local FFlagUserEnableDynamicThumbstickIntroSuccess, FFlagUserEnableDynamicThumbstickIntroResult = pcall(function() return UserSettings():IsUserFeatureEnabled("UserEnableDynamicThumbstickIntro") end)
local FFlagUserEnableDynamicThumbstickIntro = FFlagUserEnableDynamicThumbstickIntroSuccess and FFlagUserEnableDynamicThumbstickIntroResult
local Intro = FFlagUserEnableDynamicThumbstickIntro and require(script:WaitForChild("Intro")) or nil

local Thumbstick = {}
local Enabled = false

--[[ Script Variables ]]--
while not Players.LocalPlayer do
	Players.PlayerAdded:wait()
end
local LocalPlayer = Players.LocalPlayer

local Tools = {}
local ToolEquipped = nil

local RevertAutoJumpEnabledToFalse = false

local ThumbstickFrame = nil
local StartImage = nil
local EndImage = nil
local MiddleImages = {}

local IsFollowStick = false
local ThumbstickFrame = nil
local OnMoveTouchEnded = nil		-- defined in Create()
local OnTouchMovedCn = nil
local OnTouchEndedCn = nil
local TouchActivateCn = nil
local OnRenderSteppedCn = nil
local currentMoveVector = Vector3.new(0,0,0)

--[[ Constants ]]--

local IMAGE_DISK = "rbxasset://textures/ui/Input/Disk_padded.png"
local IMAGE_RING = "rbxasset://textures/ui/Input/Ring_padded.png"

local MIDDLE_TRANSPARENCIES = {
	1 - 0.69,
	1 - 0.50,
	1 - 0.40,
	1 - 0.30,
	1 - 0.20,
	1 - 0.10,
	1 - 0.05
}
local NUM_MIDDLE_IMAGES = #MIDDLE_TRANSPARENCIES

local TOUCH_IS_TAP_TIME_THRESHOLD = 0.5
local TOUCH_IS_TAP_DISTANCE_THRESHOLD = 25

local HasFadedBackgroundInPortrait = false
local HasFadedBackgroundInLandscape = false
local FadeInAndOutBackground = true
local FadeInAndOutMaxAlpha = 0.35
local TweenInAlphaStart = nil
local TweenOutAlphaStart = nil

local FADE_IN_OUT_HALF_DURATION_DEFAULT = 0.3
local FADE_IN_OUT_HALF_DURATION_ORIENTATION_CHANGE = 2
local FADE_IN_OUT_BALANCE_DEFAULT = 0.5
local FadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
local FadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT

local ThumbstickFadeTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

--[[ Local functionality ]]--

local function isDynamicThumbstickEnabled()
	return ThumbstickFrame and ThumbstickFrame.Visible
end

local function enableAutoJump(humanoid)
	if humanoid and isDynamicThumbstickEnabled() then
		local shouldRevert = humanoid.AutoJumpEnabled == false
		shouldRevert = shouldRevert and LocalPlayer.DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice
		RevertAutoJumpEnabledToFalse = shouldRevert
		humanoid.AutoJumpEnabled = true
	end
end

local function doesToolHaveListeners()
	if not ToolEquipped then
		return false
	end
	local success, result = pcall(function()	
		return ToolEquipped.HasActivatedListenersServer or ToolEquipped.HasActivatedListenersClient
	end)
	if not success then
		return true --assume tool has listeners if the API doesn't exist
	else
		return result
	end
end

do
	local function onCharacterAdded(character)	
		for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
			if child:IsA("Tool") then
				ToolEquipped = child
			end
		end
		character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				ToolEquipped = child
			elseif child:IsA("Humanoid") then
				enableAutoJump(child)
			end
		end)
		character.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then
				if child == ToolEquipped then
					ToolEquipped = nil
				end
			end
		end)
		
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			enableAutoJump(humanoid)
		end
	end
	LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
	if LocalPlayer.Character then
		onCharacterAdded(LocalPlayer.Character)
	end
end



--[[ Public API ]]--
function Thumbstick:Enable()
	Enabled = true
	ThumbstickFrame.Visible = true
	local humanoid = MasterControl:GetHumanoid()
	enableAutoJump(humanoid)

	if FFlagUserEnableDynamicThumbstickIntro and Intro then
		coroutine.wrap(function()
			--TODO: Remove this pcall when API is stable
			local success, shouldShowIntro = pcall(function()
				local wasIntroShown = GameSettings:GetOnboardingCompleted("DynamicThumbstick")
				return not wasIntroShown
			end)
			if success and not shouldShowIntro then return end

			--Give the game some time to initialize
			wait(1)
			--Wait to play the intro until the character can move
			while true do
				if not humanoid then
					humanoid = MasterControl:GetHumanoid()
				end
				if humanoid and humanoid.WalkSpeed ~= 0 and not humanoid.Torso.Anchored then
					break
				else
					wait()
				end
			end
			Intro.play()
		end)()
	end
end

function Thumbstick:Disable()
	Enabled = false
	if RevertAutoJumpEnabledToFalse then
		local humanoid = MasterControl:GetHumanoid()
		if humanoid then
			humanoid.AutoJumpEnabled = false
		end
	end
	ThumbstickFrame.Visible = false
	OnMoveTouchEnded()
end

function Thumbstick:Create(parentFrame)
	if ThumbstickFrame then
		ThumbstickFrame:Destroy()
		ThumbstickFrame = nil
		if OnTouchMovedCn then
			OnTouchMovedCn:disconnect()
			OnTouchMovedCn = nil
		end
		if OnTouchEndedCn then
			OnTouchEndedCn:disconnect()
			OnTouchEndedCn = nil
		end
		if OnRenderSteppedCn then
			OnRenderSteppedCn:disconnect()
			OnRenderSteppedCn = nil
		end
		if TouchActivateCn then
			TouchActivateCn:disconnect()
			TouchActivateCn = nil
		end
	end
	
	local ThumbstickSize = 40
	local ThumbstickRingSize = 58
	local MiddleSize = 13
	local MiddleSpacing = MiddleSize + 5
	local RadiusOfDeadZone = 2
	local RadiusOfMaxSpeed = 50
	
	local screenSize = parentFrame.AbsoluteSize
	local isBigScreen = math.min(screenSize.x, screenSize.y) > 500
	if isBigScreen then
		ThumbstickSize = ThumbstickSize * 2
		ThumbstickRingSize = ThumbstickRingSize * 2
		MiddleSize = MiddleSize * 2
		MiddleSpacing = MiddleSpacing * 2
		RadiusOfDeadZone = RadiusOfDeadZone * 2
		RadiusOfMaxSpeed = RadiusOfMaxSpeed * 2
	end
	
	local color = Color3.fromRGB(255, 255, 255)
	
	local function layoutThumbstickFrame(portraitMode)
		if portraitMode then
			ThumbstickFrame.Size = UDim2.new(1, 0, .4, 0)
			ThumbstickFrame.Position = UDim2.new(0, 0, 0.6, 0)
		else
			ThumbstickFrame.Size = UDim2.new(1, 0, .5, 18)
			ThumbstickFrame.Position = UDim2.new(0, 0, 0.5, -18)
		end
	end
		
	ThumbstickFrame = Instance.new('Frame')
	ThumbstickFrame.Name = "DynamicThumbstickFrame"
	ThumbstickFrame.Active = false
	ThumbstickFrame.Visible = false
	ThumbstickFrame.BackgroundTransparency = 1.0
	ThumbstickFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	layoutThumbstickFrame()

	StartImage = Instance.new("ImageLabel")
	StartImage.Name = "ThumbstickStart"
	StartImage.Visible = false
	StartImage.BackgroundTransparency = 1
	StartImage.Image = IMAGE_RING
	StartImage.AnchorPoint = Vector2.new(0.5, 0.5)
	StartImage.Size = UDim2.new(0, ThumbstickRingSize, 0, ThumbstickRingSize)
	StartImage.ZIndex = 10
	StartImage.Parent = ThumbstickFrame
	
	EndImage = Instance.new("ImageLabel")
	EndImage.Name = "ThumbstickEnd"
	EndImage.Visible = false
	EndImage.BackgroundTransparency = 1
	EndImage.Image = IMAGE_DISK
	EndImage.ImageTransparency = 0.20
	EndImage.AnchorPoint = Vector2.new(0.5, 0.5)
	EndImage.Size = UDim2.new(0, ThumbstickSize, 0, ThumbstickSize)
	EndImage.ZIndex = 10
	EndImage.Parent = ThumbstickFrame
	
	for i = 1, NUM_MIDDLE_IMAGES do
		MiddleImages[i] = Instance.new("ImageLabel")
		MiddleImages[i].Name = "ThumbstickMiddle"
		MiddleImages[i].Visible = false
		MiddleImages[i].BackgroundTransparency = 1
		MiddleImages[i].Image = IMAGE_DISK
		MiddleImages[i].ImageTransparency = MIDDLE_TRANSPARENCIES[i]
		MiddleImages[i].AnchorPoint = Vector2.new(0.5, 0.5)
		MiddleImages[i].ZIndex = 9
		MiddleImages[i].Parent = ThumbstickFrame
	end

	if FFlagUserEnableDynamicThumbstickIntro and Intro then
		Intro.setup(isBigScreen, parentFrame, ThumbstickFrame, StartImage, EndImage, MiddleImages)
	end

	local CameraChangedConn = nil
	local function onWorkspaceChanged(property)
		if property == 'CurrentCamera' then
			if CameraChangedConn then
				CameraChangedConn:Disconnect()
				CameraChangedConn = nil
			end
			local newCamera = workspace.CurrentCamera
			if newCamera then
				local size = newCamera.ViewportSize
				local portraitMode = size.X < size.Y
				layoutThumbstickFrame(portraitMode)
				CameraChangedConn = newCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
					size = newCamera.ViewportSize
					portraitMode = size.X < size.Y
					layoutThumbstickFrame(portraitMode)
				end)
			end
		end
	end
	workspace.Changed:Connect(onWorkspaceChanged)
	if workspace.CurrentCamera then
		onWorkspaceChanged('CurrentCamera')
	end
	
	local JumpTouchObject = nil
	local JumpTouchStartTime = nil
	local JumpTouchStartPosition = nil
	
	local MoveTouchObject = nil
	local MoveTouchStartTime = nil
	local MoveTouchStartPosition = nil

	local startImageFadeTween, endImageFadeTween, middleImageFadeTweens = nil, nil, {}
	local function fadeThumbstick(visible)
		if not visible and MoveTouchObject then
			return
		end
		if startImageFadeTween then
			startImageFadeTween:Cancel()
		end
		if endImageFadeTween then
			endImageFadeTween:Cancel()
		end
		for i = 1, #MiddleImages do
			if middleImageFadeTweens[i] then
				middleImageFadeTweens[i]:Cancel()
			end
		end

		if visible then
			startImageFadeTween = TweenService:Create(StartImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0 })
			startImageFadeTween:Play()

			endImageFadeTween = TweenService:Create(EndImage, ThumbstickFadeTweenInfo, { ImageTransparency = 0.2 })
			endImageFadeTween:Play()

			for i = 1, #MiddleImages do
				middleImageFadeTweens[i] = TweenService:Create(MiddleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = MIDDLE_TRANSPARENCIES[i] })
				middleImageFadeTweens[i]:Play()
			end
		else
			startImageFadeTween = TweenService:Create(StartImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
			startImageFadeTween:Play()

			endImageFadeTween = TweenService:Create(EndImage, ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
			endImageFadeTween:Play()

			for i = 1, #MiddleImages do
				middleImageFadeTweens[i] = TweenService:Create(MiddleImages[i], ThumbstickFadeTweenInfo, { ImageTransparency = 1 })
				middleImageFadeTweens[i]:Play()
			end
		end
	end
	local function fadeThumbstickFrame(fadeDuration, fadeRatio)
		FadeInAndOutHalfDuration = fadeDuration * 0.5
		FadeInAndOutBalance = fadeRatio
		TweenInAlphaStart = tick()
	end

	if FFlagUserEnableDynamicThumbstickIntro and Intro then
		Intro.fadeThumbstick = fadeThumbstick
		Intro.fadeThumbstickFrame = fadeThumbstickFrame
	end
		
	local function doMove(direction)
		MasterControl:AddToPlayerMovement(-currentMoveVector)
		
		currentMoveVector = direction
		
		-- Scaled Radial Dead Zone
		local inputAxisMagnitude = currentMoveVector.magnitude
		if inputAxisMagnitude < RadiusOfDeadZone then
			currentMoveVector = Vector3.new()
		else
			currentMoveVector = currentMoveVector.unit*(1 - math.max(0, (RadiusOfMaxSpeed - currentMoveVector.magnitude)/RadiusOfMaxSpeed))
			currentMoveVector = Vector3.new(currentMoveVector.x, 0, currentMoveVector.y)
		end
		
		MasterControl:AddToPlayerMovement(currentMoveVector)
	end
	
	local function layoutMiddleImages(startPos, endPos)
		local startDist = (ThumbstickSize / 2) + MiddleSize
		local vector = endPos - startPos
		local distAvailable = vector.magnitude - (ThumbstickRingSize / 2) - MiddleSize
		local direction = vector.unit

		local distNeeded = MiddleSpacing * NUM_MIDDLE_IMAGES
		local spacing = MiddleSpacing
		
		if distNeeded < distAvailable then
			spacing = distAvailable / NUM_MIDDLE_IMAGES
		end
			
		for i = 1, NUM_MIDDLE_IMAGES do
			local image = MiddleImages[i]
			local distWithout = startDist + (spacing * (i - 2))
			local currentDist = startDist + (spacing * (i - 1))	
				
			if distWithout < distAvailable then
				local pos = endPos - direction * currentDist
				local exposedFraction = math.clamp(1 - ((currentDist - distAvailable) / spacing), 0, 1)
				
				image.Visible = true
				image.Position = UDim2.new(0, pos.X, 0, pos.Y)
				image.Size = UDim2.new(0, MiddleSize * exposedFraction, 0, MiddleSize * exposedFraction)
			else
				image.Visible = false
			end
		end
	end
	
	local function moveStick(pos)
		local startPos = Vector2.new(MoveTouchStartPosition.X, MoveTouchStartPosition.Y) - ThumbstickFrame.AbsolutePosition
		local endPos = Vector2.new(pos.X, pos.Y) - ThumbstickFrame.AbsolutePosition
		local relativePosition = endPos - startPos
		local length = relativePosition.magnitude
		local maxLength = ThumbstickFrame.AbsoluteSize.X
		
		length = math.min(length, maxLength)
		relativePosition = relativePosition*length
		
		EndImage.Position = UDim2.new(0, endPos.X, 0, endPos.Y)
		EndImage.Size = UDim2.new(0, ThumbstickSize, 0, ThumbstickSize)
		
		layoutMiddleImages(startPos, endPos)
	end
	
	-- input connections
	ThumbstickFrame.InputBegan:connect(function(inputObject)
		if inputObject.UserInputType ~= Enum.UserInputType.Touch or inputObject.UserInputState ~= Enum.UserInputState.Begin then
			return
		end
		if MoveTouchObject then
			if not JumpTouchObject then
				JumpTouchObject = inputObject
				JumpTouchStartTime = tick()
				JumpTouchStartPosition = inputObject.Position
			end
			return
		end

		if FFlagUserEnableDynamicThumbstickIntro and Intro then
			Intro.onThumbstickMoveBegin()
		end

		MoveTouchObject = inputObject
		MoveTouchStartTime = tick()
		MoveTouchStartPosition = inputObject.Position
		local startPosVec2 = Vector2.new(inputObject.Position.X - ThumbstickFrame.AbsolutePosition.X, inputObject.Position.Y - ThumbstickFrame.AbsolutePosition.Y)

		StartImage.Visible = true
		StartImage.Position = UDim2.new(0, startPosVec2.X, 0, startPosVec2.Y)
		EndImage.Visible = true
		EndImage.Position = StartImage.Position
		EndImage.Size = UDim2.new(0, ThumbstickSize, 0, ThumbstickSize)

		fadeThumbstick(true)
		moveStick(inputObject.Position)
		
		if FadeInAndOutBackground then
			local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local hasFadedBackgroundInOrientation = false

			-- only fade in/out the background once per orientation
			if playerGui then
				if playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or 
					playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight then
						hasFadedBackgroundInOrientation = HasFadedBackgroundInLandscape
						HasFadedBackgroundInLandscape = true
				elseif playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait then
						hasFadedBackgroundInOrientation = HasFadedBackgroundInPortrait
						HasFadedBackgroundInPortrait = true
				end
			end

			if not hasFadedBackgroundInOrientation then
				FadeInAndOutHalfDuration = FADE_IN_OUT_HALF_DURATION_DEFAULT
				FadeInAndOutBalance = FADE_IN_OUT_BALANCE_DEFAULT
				TweenInAlphaStart = tick()
			end
		end
	end)
	
	OnTouchMovedCn = UserInputService.TouchMoved:connect(function(inputObject, isProcessed)
		if inputObject == MoveTouchObject then
			
			local direction = Vector2.new(inputObject.Position.x - MoveTouchStartPosition.x, inputObject.Position.y - MoveTouchStartPosition.y)
			if math.abs(direction.x) > 0 or math.abs(direction.y) > 0 then
				doMove(direction)
				moveStick(inputObject.Position)
			end
		end
	end)
	
	OnMoveTouchEnded = function(inputObject)
		if inputObject then
			local direction = Vector2.new(inputObject.Position.x - MoveTouchStartPosition.x, inputObject.Position.y - MoveTouchStartPosition.y)
			if FFlagUserEnableDynamicThumbstickIntro and Intro then
				coroutine.wrap(function() Intro.onThumbstickMoved(direction.magnitude) end)()
			end
		end

		MoveTouchObject = nil
		fadeThumbstick(false)
		
		MasterControl:AddToPlayerMovement(-currentMoveVector)
		currentMoveVector = Vector3.new(0,0,0)
	end

	OnRenderSteppedCn = RunService.RenderStepped:Connect(function(step)
		if TweenInAlphaStart ~= nil then
			local delta = tick() - TweenInAlphaStart
			local fadeInTime = (FadeInAndOutHalfDuration * 2 * FadeInAndOutBalance)
			ThumbstickFrame.BackgroundTransparency = 1 - FadeInAndOutMaxAlpha*math.min(delta/fadeInTime, 1)
			if delta > fadeInTime then
				TweenOutAlphaStart = tick()
				TweenInAlphaStart = nil
			end
		elseif TweenOutAlphaStart ~= nil then
			local delta = tick() - TweenOutAlphaStart
			local fadeOutTime = (FadeInAndOutHalfDuration * 2) - (FadeInAndOutHalfDuration * 2 * FadeInAndOutBalance)
			ThumbstickFrame.BackgroundTransparency = 1 - FadeInAndOutMaxAlpha + FadeInAndOutMaxAlpha*math.min(delta/fadeOutTime, 1)
			if delta > fadeOutTime  then
				TweenOutAlphaStart = nil
			end
		end

		if FFlagUserEnableDynamicThumbstickIntro and Intro then
			if Intro.currentState == Intro.states.MoveThumbstick then
				local startPos = StartImage.AbsolutePosition - ThumbstickFrame.AbsolutePosition + (StartImage.AbsoluteSize * 0.5)
				local endPos = EndImage.AbsolutePosition - ThumbstickFrame.AbsolutePosition + (EndImage.AbsoluteSize * 0.5)

				layoutMiddleImages(startPos, endPos)
			end
		end
	end)

	--todo: remove this pcall when TouchTapInWorld is on for all platforms
	local success = pcall(function() 
		local function positionIntersectsGuiObject(position, guiObject)
			if position.X < guiObject.AbsolutePosition.X + guiObject.AbsoluteSize.X
				and position.X > guiObject.AbsolutePosition.X
				and position.Y < guiObject.AbsolutePosition.Y + guiObject.AbsoluteSize.Y
				and position.Y > guiObject.AbsolutePosition.Y then
				return true
			end
			return false
		end

		local debounce = false
		TouchActivateCn = UserInputService.TouchTapInWorld:connect(function(touchPos, processed)
			if not processed and Enabled and not doesToolHaveListeners() and positionIntersectsGuiObject(touchPos, ThumbstickFrame) then
				if not debounce then
					debounce = true
					MasterControl:DoJump()

					if FFlagUserEnableDynamicThumbstickIntro and Intro then
						Intro.onJumped()
					end
					wait(0.25)
					debounce = false
				end
			end
		end)
	end)

	if not success then
		local function JumpIfTouchIsTap(startTime, startPosition, position)
			if (not doesToolHaveListeners()) and tick() - startTime < TOUCH_IS_TAP_TIME_THRESHOLD then
				if (position - startPosition).magnitude < TOUCH_IS_TAP_DISTANCE_THRESHOLD then
					MasterControl:DoJump()
					if FFlagUserEnableDynamicThumbstickIntro and Intro then
						Intro.onJumped()
					end
				end
			end
		end
		
		OnTouchEndedCn = UserInputService.TouchEnded:connect(function(inputObject, isProcessed)
			if inputObject == MoveTouchObject then
				JumpIfTouchIsTap(MoveTouchStartTime, MoveTouchStartPosition, inputObject.Position) 
				OnMoveTouchEnded(inputObject)
			elseif inputObject == JumpTouchObject then
				JumpIfTouchIsTap(JumpTouchStartTime, JumpTouchStartPosition, inputObject.Position)
				JumpTouchObject = nil
			end
		end)
	else
		OnTouchEndedCn = UserInputService.TouchEnded:connect(function(inputObject, isProcessed)
			if inputObject == MoveTouchObject then
				OnMoveTouchEnded(inputObject)
			elseif inputObject == JumpTouchObject then
				JumpTouchObject = nil
			end
		end)
	end
	
	GuiService.MenuOpened:connect(function()
		if MoveTouchObject then
			OnMoveTouchEnded(nil)
		end
		if JumpTouchObject then
			JumpTouchObject = nil
		end
	end)

	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	while not playerGui do
		LocalPlayer.ChildAdded:wait()
		playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	end

	local playerGuiChangedConn = nil
	local originalScreenOrientationWasLandscape = playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeLeft or
													playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.LandscapeRight

	local function longShowBackground()
		FadeInAndOutHalfDuration = 2.5
		FadeInAndOutBalance = 0.05
		TweenInAlphaStart = tick()
	end

	playerGuiChangedConn = playerGui.Changed:connect(function(prop)
		if prop == "CurrentScreenOrientation" then
			if (originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation == Enum.ScreenOrientation.Portrait) or
				(not originalScreenOrientationWasLandscape and playerGui.CurrentScreenOrientation ~= Enum.ScreenOrientation.Portrait) then
					playerGuiChangedConn:disconnect()
					longShowBackground()

					if originalScreenOrientationWasLandscape then
						HasFadedBackgroundInPortrait = true
					else
						HasFadedBackgroundInLandscape = true
					end
			end
		end
	end)
	
	ThumbstickFrame.Parent = parentFrame

	spawn(function()
		if game:IsLoaded() then
			longShowBackground()
		else
			game.Loaded:wait()
			longShowBackground()
		end
	end)
end

return Thumbstick
