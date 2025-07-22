loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Auto Parry Test",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "por Spike",
   ConfigurationSaving = {
      Enabled = false
   }
})

local Tab = Window:CreateTab("Teste", 4483362458)
local Section = Tab:CreateSection("Auto Parry")

local Toggle = Tab:CreateToggle({
   Name = "Auto Parry",
   CurrentValue = false,
   Flag = "AutoParry",
   Callback = function(Value)
      local RunService = game:GetService("RunService")
      local Players = game:GetService("Players")
      local VirtualInputManager = game:GetService("VirtualInputManager")

      local Player = Players.LocalPlayer
      local Cooldown = tick()
      local Parried = false
      local autoParryConnection

      local function GetBall()
         for _, Ball in ipairs(workspace.Balls:GetChildren()) do
            if Ball:GetAttribute("realBall") then
               return Ball
            end
         end
      end

      if Value then
         autoParryConnection = RunService.PreSimulation:Connect(function()
            local Ball = GetBall()
            local HRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if not Ball or not HRP then return end

            local Speed = Ball.zoomies.VectorVelocity.Magnitude
            local Distance = (HRP.Position - Ball.Position).Magnitude

            if Ball:GetAttribute("target") == Player.Name and not Parried and Distance / Speed <= 0.65 then
               VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
               Parried = true
               Cooldown = tick()
            elseif (tick() - Cooldown) >= 1 then
               Parried = false
            end
         end)
      else
         if autoParryConnection then
            autoParryConnection:Disconnect()
            autoParryConnection = nil
         end
      end
   end,
})
