local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local TARGET_PART = "HumanoidRootPart"
local MAX_DISTANCE = 150
local AimbotEnabled = true

StarterGui:SetCore("SendNotification", {
	Title = "Auto Aim ON",
	Text = "Press L to toggle",
	Duration = 5
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.L then
		AimbotEnabled = not AimbotEnabled

		StarterGui:SetCore("SendNotification", {
			Title = "Auto Aim " .. (AimbotEnabled and "ON" or "OFF"),
			Text = "Press L to toggle",
			Duration = 4
		})
	end
end)

local function getFacingTarget()
	local origin = Camera.CFrame.Position
	local direction = Camera.CFrame.LookVector * MAX_DISTANCE

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist

	local result = Workspace:Raycast(origin, direction, rayParams)
	if result and result.Instance then
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		if model then
			local player = Players:GetPlayerFromCharacter(model)
			if player and player.Team and player.Team.Name == "Guard" then
				local hrp = model:FindFirstChild(TARGET_PART)
				if hrp then
					return hrp
				end
			elseif if player and player.Team and player.Team.Name == "Swat" then
				local hrp = model:FindFirstChild(TARGET_PART)
				if hrp then
					return hrp
				end
			end
		end
	end

	return nil
end

local function startAimbot()
	while true do
		if AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local targetPart = getFacingTarget()
			if targetPart then
				local origin = Camera.CFrame.Position
				Camera.CFrame = CFrame.new(origin, targetPart.Position)
			end
		end
		RunService.RenderStepped:Wait()
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	AimbotEnabled = false
	StarterGui:SetCore("SendNotification", {
		Title = "Auto Aim OFF",
		Text = "You reset. Press L to re-enable.",
		Duration = 5
	})
end)

task.spawn(startAimbot)
