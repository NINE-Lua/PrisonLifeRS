--[[
	made by me ;)
]]--

local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "RLPSFlashLoader"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.Size = UDim2.new(0.3, 0, 0.14, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(255, 115, 0)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.new(0.5, 0, 0.4, 0)
title.Size = UDim2.new(0.7, 0, 0.35, 0)
title.BackgroundTransparency = 1
title.Text = "PLRS XPLOIT v1.1"
title.TextColor3 = Color3.fromRGB(255, 140, 0)
title.TextStrokeColor3 = Color3.fromRGB(255, 85, 0)
title.TextStrokeTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextTransparency = 1

local loading = Instance.new("TextLabel", frame)
loading.AnchorPoint = Vector2.new(0.5, 0.5)
loading.Position = UDim2.new(0.5, 0, 0.75, 0)
loading.Size = UDim2.new(0.6, 0, 0.25, 0)
loading.BackgroundTransparency = 1
loading.Text = "Loading."
loading.TextColor3 = Color3.fromRGB(255, 115, 0)
loading.TextStrokeColor3 = Color3.fromRGB(255, 85, 0)
loading.TextStrokeTransparency = 1
loading.TextScaled = true
loading.Font = Enum.Font.Gotham
loading.TextTransparency = 1

TweenService:Create(frame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
TweenService:Create(title, TweenInfo.new(0.6), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.3,
}):Play()
TweenService:Create(loading, TweenInfo.new(0.6), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.3,
}):Play()

TweenService:Create(title, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
	Size = UDim2.new(0.9, 0, 0.4, 0)
}):Play()

local pulse = TweenService:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	TextColor3 = Color3.fromRGB(255, 180, 60)
})
pulse:Play()

local running = true
task.spawn(function()
	local dots = {".", "..", "..."}
	local i = 1
	while running do
		loading.Text = "Loading" .. dots[i]
		i = i % #dots + 1
		task.wait(0.5)
	end
end)

task.spawn(function()
	local originalPos = Camera.CFrame.Position
	for i = 1, 30 do
		local offset = Vector3.new(
			math.random(-2, 2) / 100,
			math.random(-2, 2) / 100,
			math.random(-2, 2) / 100
		)
		Camera.CFrame = CFrame.new(originalPos + offset, originalPos + offset + Camera.CFrame.LookVector)
		task.wait(0.03)
	end
	Camera.CFrame = CFrame.new(originalPos, originalPos + Camera.CFrame.LookVector)
end)

task.delay(4.5, function()
	running = false
	loading.Text = "READY"
	wait(0.5)
	TweenService:Create(title, TweenInfo.new(0.5), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()
	TweenService:Create(loading, TweenInfo.new(0.5), {
		TextTransparency = 1,
		TextStrokeTransparency = 1
	}):Play()
	TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	wait(0.6)
	gui:Destroy()
end)
