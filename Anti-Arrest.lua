local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local originalPosition = HumanoidRootPart.Position

local hasTriggered = false

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
			warn("Reset failed, destroying character manually.")
			char:Destroy()
		end
	end)
end

local function resetAndTeleport()
	if hasTriggered then return end
	hasTriggered = true

	StarterGui:SetCore("SendNotification", {
		Title = "Reset Status",
		Text = "Nearby cuffs detected. Resetting...",
		Duration = 5
	})

	forceResetCharacter()
	originalPosition = HumanoidRootPart.Position

	local newChar = Player.CharacterAdded:Wait()
	newChar:WaitForChild("HumanoidRootPart")
	RunService.Heartbeat:Wait()
	RunService.Heartbeat:Wait()

	newChar.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

	task.delay(5, function()
		hasTriggered = false
	end)
end

RunService.Heartbeat:Connect(function()
	local myChar = Player.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if otherPlayer ~= Player then
			local otherChar = otherPlayer.Character
			if otherChar and otherChar:FindFirstChild("HumanoidRootPart") then
				local distance = (myChar.HumanoidRootPart.Position - otherChar.HumanoidRootPart.Position).Magnitude
				if distance <= 5 then
					local tool = otherChar:FindFirstChildOfClass("Tool")
					if tool and tool.Name == "Handcuffs" then
						resetAndTeleport()
						break
					end
				end
			end
		end
	end
end)

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
