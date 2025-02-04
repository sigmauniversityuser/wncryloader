getgenv().wncryuniversal = {
    Enabled = false,
    Prediction = 0.1337,
    AimPart = "Head",
    Key = "Q",
    FOV = 150
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local CurrentTarget = nil

function GetClosestToMouse()
    local closestPlayer, shortestDistance = nil, wncryuniversal.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(wncryuniversal.AimPart) then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character[wncryuniversal.AimPart].Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

Mouse.KeyDown:Connect(function(key)
    if key:lower() == wncryuniversal.Key:lower() then
        wncryuniversal.Enabled = not wncryuniversal.Enabled
        if wncryuniversal.Enabled then
            CurrentTarget = GetClosestToMouse()
        else
            CurrentTarget = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if wncryuniversal.Enabled and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild(wncryuniversal.AimPart) then
        local head = CurrentTarget.Character[wncryuniversal.AimPart]
        local predictedPosition = head.Position + (head.Velocity * wncryuniversal.Prediction)
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPosition)
    elseif wncryuniversal.Enabled then
        CurrentTarget = GetClosestToMouse()
    end
end)
