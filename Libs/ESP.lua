local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local Base = "https://raw.githubusercontent.com/sawedoffbilly/saiseiclient/refs/heads/main/"

local function HttpRequire(Folder)
	local FileURL = Base .. Folder
	local FileContent = game:HttpGet(FileURL)

	return loadstring(FileContent)()
end

local DrawingUtils = HttpRequire("Utils/Drawing.lua")

local ESP = {}

local Functions = {}

Functions.CreateESP = function(Player: Player, Settings)
	if Player == LocalPlayer or ESP[Player] then
		return
	end

	ESP[Player] = {
		BlackTracer = DrawingUtils.DrawLine(Settings.TracerThickness * 2, Color3.fromRGB(0, 0, 0)),
		Tracer = DrawingUtils.DrawLine(Settings.TracerThickness, Settings.TracerColor),

		Black = DrawingUtils.DrawQuad(Settings.BoxThickness * 2, Color3.fromRGB(0, 0, 0)),
		Box = DrawingUtils.DrawQuad(Settings.BoxThickness, Settings.BoxColor),

		HealthBar = DrawingUtils.DrawLine(3, Color3.fromRGB(0, 0, 0)),
		HealthSlider = DrawingUtils.DrawLine(1.5, Color3.fromRGB(0, 0, 0)),

		StaminaBar = DrawingUtils.DrawLine(3, Color3.fromRGB(0, 0, 0)),
		StaminaSlider = DrawingUtils.DrawLine(1.5, Color3.fromRGB(255, 255, 255)),

		PostureBar = DrawingUtils.DrawLine(3, Color3.fromRGB(0, 0, 0)),
		PostureSlider = DrawingUtils.DrawLine(1.5, Color3.fromRGB(255, 220, 0)),

		Distance = DrawingUtils.DrawText(13, Color3.fromRGB(255, 255, 255)),
		Username = DrawingUtils.DrawText(13, Color3.fromRGB(255, 255, 255)),

		Settings = Settings,
	}
end

Functions.RemoveESP = function(Player: Player)
	local Library = ESP[Player]

	if not Library then
		return
	end

	for _, v in pairs(Library) do
		v:Remove()
	end

	ESP[Player] = nil
end

local function Hide(lib)
	for _, v in pairs(lib) do
		if v.From then
			v.From = Vector2.new(0, 0)
			v.To = Vector2.new(0, 0)
		elseif v.PointA then
			v.PointA = Vector2.new(0, 0)
			v.PointB = Vector2.new(0, 0)
			v.PointC = Vector2.new(0, 0)
			v.PointD = Vector2.new(0, 0)
		elseif v.Position then
			v.Position = Vector2.new(0, 0)
		end
		v.Visible = false
	end
end

local function Colorize(Library, color)
	for _, x in pairs(Library) do
		if x ~= Library.HealthBar and x ~= Library.HealthSlider and x ~= Library.BlackTracer and x ~= Library.Black and x ~= Library.StaminaBar and x ~= Library.StaminaSlider and x ~= Library.PostureBar and x ~= Library.PostureSlider and x ~= Library.Username and x ~= Library.Distance then
			x.Color = color
		end
	end
end

local Connection = nil

Functions.Start = function()
	Connection = RunService.RenderStepped:Connect(function()
		local LocalCharacter = LocalPlayer.Character
		local LocalHumanoidRootPart = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")

		if not LocalHumanoidRootPart then
			return
		end

		for Player, Library in pairs(ESP) do
			local Character = Player.Character

			if not Character then
				Hide(Library)

				continue
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			local Head = Character:FindFirstChild("Head")

			if not Humanoid or not HumanoidRootPart or not Head or Humanoid.Health <= 0 then
				Hide(Library)

				continue
			end

			local HumanoidPosition, OnScreen = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)

			if not OnScreen or HumanoidPosition.Z < 0 then
				Hide(Library)

				continue
			end

			local HeadPosition = CurrentCamera:WorldToViewportPoint(Head.Position)

			local DistanceY = math.clamp((Vector2.new(HeadPosition.X, HeadPosition.Y) - Vector2.new(HumanoidPosition.X, HumanoidPosition.Y)).Magnitude, 2, math.huge)

			Library.Box.PointA = Vector2.new(HumanoidPosition.X + DistanceY, HumanoidPosition.Y - DistanceY * 2)
			Library.Box.PointB = Vector2.new(HumanoidPosition.X - DistanceY, HumanoidPosition.Y - DistanceY * 2)
			Library.Box.PointC = Vector2.new(HumanoidPosition.X - DistanceY, HumanoidPosition.Y + DistanceY * 2)
			Library.Box.PointD = Vector2.new(HumanoidPosition.X + DistanceY, HumanoidPosition.Y + DistanceY * 2)

			Library.Black.PointA = Library.Box.PointA
			Library.Black.PointB = Library.Box.PointB
			Library.Black.PointC = Library.Box.PointC
			Library.Black.PointD = Library.Box.PointD

			if Library.Settings.Tracers then
				local LocalRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

				if LocalRoot then
					local ScreenPosition = workspace.CurrentCamera:WorldToViewportPoint(LocalRoot.Position)
					local ClientPosition = Vector2.new(ScreenPosition.X, ScreenPosition.Y)

					Library.Tracer.From = ClientPosition
					Library.BlackTracer.From = ClientPosition
					Library.Tracer.To = Vector2.new(HumanoidPosition.X, HumanoidPosition.Y + DistanceY * 2)
					Library.BlackTracer.To = Vector2.new(HumanoidPosition.X, HumanoidPosition.Y + DistanceY * 2)
				end
			end

			local Distance = DistanceY * 4
			local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
			local HealthOffset = HealthPercent * Distance

			Library.HealthSlider.From = Vector2.new(HumanoidPosition.X - DistanceY - 4, HumanoidPosition.Y + DistanceY * 2)
			Library.HealthSlider.To = Vector2.new(HumanoidPosition.X - DistanceY - 4, HumanoidPosition.Y + DistanceY * 2 - HealthOffset)
			Library.HealthBar.From = Vector2.new(HumanoidPosition.X - DistanceY - 4, HumanoidPosition.Y + DistanceY * 2)
			Library.HealthBar.To = Vector2.new(HumanoidPosition.X - DistanceY - 4, HumanoidPosition.Y - DistanceY * 2)
			Library.HealthSlider.Color = Library.Settings.HealthEndColor:Lerp(Library.Settings.HealthStartColor, HealthPercent)

			if Library.Settings.StaminaBar then
				local Stamina = Player.Backpack:FindFirstChild("Stamina")

				if Stamina and (Stamina:IsA("NumberValue") or Stamina:IsA("IntValue")) then
					local Percent = math.clamp(Stamina.Value / 100, 0, 1)
					local Offset = Percent * Distance

					Library.StaminaSlider.From = Vector2.new(HumanoidPosition.X - DistanceY - 9, HumanoidPosition.Y + DistanceY * 2)
					Library.StaminaSlider.To = Vector2.new(HumanoidPosition.X - DistanceY - 9, HumanoidPosition.Y + DistanceY * 2 - Offset)
					Library.StaminaBar.From = Vector2.new(HumanoidPosition.X - DistanceY - 9, HumanoidPosition.Y + DistanceY * 2)
					Library.StaminaBar.To = Vector2.new(HumanoidPosition.X - DistanceY - 9, HumanoidPosition.Y - DistanceY * 2)
					Library.StaminaSlider.Visible = true
					Library.StaminaBar.Visible = true
				else
					Library.StaminaSlider.Visible = false
					Library.StaminaBar.Visible = false
				end
			end

			if Library.Settings.PostureBar then
				local Posture = Player.Backpack:FindFirstChild("Posture")

				if Posture and (Posture:IsA("NumberValue") or Posture:IsA("IntValue")) then
					local Percent = math.clamp(Posture.Value / 100, 0, 1)
					local Offset = Percent * Distance

					Library.PostureSlider.From = Vector2.new(HumanoidPosition.X - DistanceY - 14, HumanoidPosition.Y + DistanceY * 2)
					Library.PostureSlider.To = Vector2.new(HumanoidPosition.X - DistanceY - 14, HumanoidPosition.Y + DistanceY * 2 - Offset)
					Library.PostureBar.From = Vector2.new(HumanoidPosition.X - DistanceY - 14, HumanoidPosition.Y + DistanceY * 2)
					Library.PostureBar.To = Vector2.new(HumanoidPosition.X - DistanceY - 14, HumanoidPosition.Y - DistanceY * 2)
					Library.PostureSlider.Visible = true
					Library.PostureBar.Visible = true
				else
					Library.PostureSlider.Visible = false
					Library.PostureBar.Visible = false
				end
			end

			if Library.Settings.Distance then
				local Distance = math.floor((HumanoidRootPart.Position - LocalHumanoidRootPart.CFrame.Position).Magnitude)

				Library.Distance.Text = Distance .. " Studs"
				Library.Distance.Position = Vector2.new(HumanoidPosition.X, HumanoidPosition.Y - DistanceY * 2 - 16)
				Library.Distance.Visible = true
			else
				Library.Distance.Visible = false
			end

			if Library.Settings.Username then
				Library.Username.Text = Character.Name
				Library.Username.Position = Vector2.new(HumanoidPosition.X, HumanoidPosition.Y - DistanceY * 2 - 32)
				Library.Username.Visible = true
			else
				Library.Username.Visible = false
			end

			Library.Tracer.Color = Library.Settings.TracerColor
			Library.Box.Color = Library.Settings.BoxColor

			Library.Box.Visible = true
			Library.Black.Visible = true
			Library.Tracer.Visible = Library.Settings.Tracers
			Library.BlackTracer.Visible = Library.Settings.Tracers
			Library.HealthSlider.Visible = true
			Library.HealthBar.Visible = true
		end
	end)
end

Functions.Stop = function()
	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
end

return Functions
