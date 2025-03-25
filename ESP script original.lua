local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local flying = false
local speed = 50
local flightForce = Instance.new("BodyVelocity")
flightForce.Velocity = Vector3.new(0, 0, 0)
flightForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

local function startFlying()
    flying = true
    flightForce.Parent = humanoidRootPart
end

local function stopFlying()
    flying = false
    flightForce.Parent = nil
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if flying then
        local direction = Vector3.new()
        local camera = workspace.CurrentCamera
        local moveDir = player:GetMoveVector()

        if moveDir.Magnitude > 0 then
            direction = (camera.CFrame.RightVector * moveDir.X + camera.CFrame.LookVector * moveDir.Z).Unit
        end

        flightForce.Velocity = direction * speed + Vector3.new(0, player:GetMouse().WheelDelta * 5, 0)
    end
end)