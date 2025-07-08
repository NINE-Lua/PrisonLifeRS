local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local enabled = true
local lastPosition = nil
StarterGui:SetCore("SendNotification", {
    Title = "William Afton Mode ACTIVATED.",
    Text = "To turn off/on, press 'Y'.",
    Duration = 5.5
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Y then
        enabled = not enabled
        if enabled then
              StarterGui:SetCore("SendNotification", {
                Title = "William Afton Mode ON",
                Text = "Turned on. :)",
                Duration = 3
              })
        else
              StarterGui:SetCore("SendNotification", {
                Title = "William Afton Mode OFF",
                Text = "Turned off. :(",
                Duration = 3
              })
        end
    end
end)

local function onCharacterAdded(char)
    local humanoid = char:WaitForChild("Humanoid")

    humanoid.HealthChanged:Connect(function(health)
        if not enabled then return end
        if health > 0 then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                lastPosition = hrp.Position
            end
        end
    end)

    humanoid.Died:Connect(function()
        if not enabled or not lastPosition then return end

        local newChar = Player.CharacterAdded:Wait()
        local newHrp = newChar:WaitForChild("HumanoidRootPart")

        for i = 1, 5 do
            if newHrp and newHrp.Parent then
                newHrp.CFrame = CFrame.new(lastPosition)
            end
            task.wait(0.1)
        end
    end)
end

if Player.Character then
    onCharacterAdded(Player.Character)
end
Player.CharacterAdded:Connect(onCharacterAdded)
