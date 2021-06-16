





local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera           = game:GetService("Workspace").CurrentCamera
local Players          = game:GetService("Players")
local Player           = Players.LocalPlayer
local Mouse            = Player:GetMouse()
local Metatable        = getrawmetatable(game)
local Index            = Metatable.__index
local Target           = nil

local Silentaim = true

local Circle        = Drawing.new("Circle")
Circle.Color        = Color3.new(128,0,128)
Circle.Thickness    = 1
Circle.Radius       = 350
Circle.Visible      = true
Circle.NumSides     = 1000
Circle.Filled       = false
Circle.Transparency = 1

function GetClosest() 
    local Closest = nil;
    local Magnitude = math.huge

    for i, v in next, Players:GetPlayers() do 
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then 
            local Position, Visible = Camera:WorldToScreenPoint(v.Character["HumanoidRootPart"].Position) 

            if Visible then
                local Mouse = Player:GetMouse()
                local Distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Position.X, Position.Y)).Magnitude 

                if not Circle.Visible and Distance < Magnitude or Circle.Visible and Distance < Magnitude and Distance < Circle.Radius then 
                    Closest = v 
                    Magnitude = Distance
                end
            end
        end
    end

    return Closest 
end

setreadonly(Metatable, false)
        
Metatable.__index = newcclosure(function(self, Property)
    if Silentaim and self == Mouse and Property == "Hit" and Target ~= nil then
        
        return CFrame.new(Target.Character.Head.Position)
    end
            
    return Index(self, Property)
end)
        
setreadonly(Metatable, true)

RunService.RenderStepped:Connect(function()
    local Mouse = UserInputService:GetMouseLocation()

    Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
    Target = GetClosest()
end)
