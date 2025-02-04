-- // basic 

getgenv().Prediction = 0.12167
getgenv().AimPart = "Head"
getgenv().Smoothness = 0.0122
getgenv().Enabled = false
getgenv().Target = nil
getgenv().MaxDistance = 150

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetClosestToMouse()
    local MaxDistance = getgenv().MaxDistance
    local Target = nil
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(getgenv().AimPart) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local Position = Camera:WorldToViewportPoint(v.Character[getgenv().AimPart].Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            
            if Distance < MaxDistance then
                MaxDistance = Distance
                Target = v
            end
        end
    end
    
    return Target
end

Mouse.KeyDown:Connect(function(Key)
    if Key == "q" then
        if not getgenv().Enabled then
            getgenv().Enabled = true
            getgenv().Target = GetClosestToMouse()
        else
            getgenv().Enabled = false
            getgenv().Target = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if getgenv().Enabled and getgenv().Target and getgenv().Target.Character and getgenv().Target.Character:FindFirstChild(getgenv().AimPart) then
        if getgenv().Target.Character.Humanoid.Health <= 0 then
            getgenv().Enabled = false
            getgenv().Target = nil
            return
        end
        
        local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if Tool and Tool:FindFirstChild("Handle") then
            local TargetPos = getgenv().Target.Character[getgenv().AimPart].Position
            local TargetVel = getgenv().Target.Character[getgenv().AimPart].Velocity
            local TargetPrediction = TargetPos + (TargetVel * getgenv().Prediction)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, TargetPrediction), getgenv().Smoothness)
        end
    end
end)
