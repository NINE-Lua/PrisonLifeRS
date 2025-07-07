local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local function waitForCharacter()
	local character = Player.Character or Player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	return character, hrp.Position
end

local function forceResetCharacter()
	local char = Player.Character
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if humanoid then
		humanoid.Health = 0
	end

	local timeout = 5
	local start = tick()
	task.spawn(function()
		while Player.Character == char and tick() - start < timeout do
			task.wait()
		end
		if Player.Character == char then
			warn("Health reset failed, destroying character manually.")
			char:Destroy()
		end
	end)
end

local function resetAndTeleport(originalPosition)
	StarterGui:SetCore("SendNotification", {
		Title = "Reset Status",
		Text = "Resetting and teleporting back...",
		Duration = 5
	})

	forceResetCharacter()

	local newChar = Player.CharacterAdded:Wait()
	newChar:WaitForChild("HumanoidRootPart")
	RunService.Heartbeat:Wait()
	RunService.Heartbeat:Wait()

	newChar.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
end

local function watchForGuiTrigger()
	local character, originalPos = waitForCharacter()
	local head = character:WaitForChild("Head")

	if head:FindFirstChild("Arrest") then
		resetAndTeleport(originalPos)
	else
		head.ChildAdded:Connect(function(child)
			if child.Name == "Arrest" then
				resetAndTeleport(originalPos)
			end
		end)
	end
end

local function setupBypass()
	local mt = getrawmetatable(game)
	local oldIndex = mt.__index
	setreadonly(mt, false)
	mt.__index = function(self, key)
		if key == "Kick" or key == "Ban" then
			return function() end
		end
		return oldIndex(self, key)
	end
	setreadonly(mt, true)
end

local function obfuscate()
	local dummy = Instance.new("BoolValue")
	dummy.Name = math.random(100000, 999999) .. "_Obf"
	dummy.Parent = game.ReplicatedStorage
	wait(1)
	dummy:Destroy()
end

setupBypass()
spawn(obfuscate)
watchForGuiTrigger()
