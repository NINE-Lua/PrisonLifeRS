-- v2

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local hasTriggered = false
local originalPosition = nil

local function forceResetCharacter()
    local char = Player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end

    local start = tick()
    task.spawn(function()
        while Player.Character == char and tick() - start < 2 do
            task.wait(0.05)
        end
        if Player.Character == char then
            char:Destroy()
        end
    end)
end

local function teleportToOriginalPosition(char)
    local hrp = char:WaitForChild("HumanoidRootPart")

    for i = 1, 5 do
        if hrp and hrp.Parent then
            hrp.CFrame = CFrame.new(originalPosition)
        end
        task.wait(0.1)
    end
end

local function resetAndTeleport()
    if hasTriggered then return end
    hasTriggered = true

    local char = Player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    originalPosition = hrp.Position

    StarterGui:SetCore("SendNotification", {
        Title = "Reset Status",
        Text = "Nearby cuffs detected. Resetting...",
        Duration = 3
    })

    forceResetCharacter()

    local newChar = Player.CharacterAdded:Wait()

    teleportToOriginalPosition(newChar)

    task.delay(2, function()
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
                if distance <= 7.44 then
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
