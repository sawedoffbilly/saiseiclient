local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local Utils = {}

local Base = "https://raw.githubusercontent.com/sawedoffbilly/saiseiclient/refs/heads/main/"

local function HttpRequire(Folder)
	local FileURL = Base .. Folder
	local FileContent = game:HttpGet(FileURL)

	return loadstring(FileContent)()
end

local ESPSettings = {
	BoxColor = Color3.fromRGB(255, 0, 0),
	TracerColor = Color3.fromRGB(255, 0, 0),
	HealthEndColor = Color3.fromRGB(255, 0, 0),
	HealthStartColor = Color3.fromRGB(71, 255, 51),
	TracerThickness = 1,
	BoxThickness = 1,
	Tracers = true,
	Distance = true,
	Username = true,
	StaminaBar = true,
	PostureBar = true
}

Utils.Init = function()
	local Repository = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

	local Library = loadstring(game:HttpGet(Repository .. 'Library.lua'))()
	local ThemeManager = loadstring(game:HttpGet(Repository .. 'addons/ThemeManager.lua'))()
	local SaveManager = loadstring(game:HttpGet(Repository .. 'addons/SaveManager.lua'))()
	
	local ESP = HttpRequire("Libs/ESP.lua")
	
	local Connections = {}

	local Window = Library:CreateWindow({
		Title = "Natrix Hub",
		Center = true,
		AutoShow = true,
		TabPadding = 50,
		MenuFadeTime = 0.2
	})

	local Tabs = {
		Saisei = Window:AddTab('Saisei'),
		Debug = Window:AddTab('Debug'),
		Settings = Window:AddTab('Settings'),
	}

	local CombatGroupBox = Tabs.Saisei:AddLeftGroupbox('Combat')
	local MenuGroupBox = Tabs.Settings:AddLeftGroupbox('Menu')
	
	CombatGroupBox:AddToggle('AutoParry', {
		Text = 'AutoParry',
		Default = false, 
		Tooltip = 'Whether or not AutoParry is enabled for combat.',

		Callback = function(Value)
			print('[cb] MyToggle changed to:', Value)
		end
	})
	
	CombatGroupBox:AddToggle('ESP', {
		Text = 'ESP',
		Default = false, 
		Tooltip = 'Whether or not ESP is enabled for combat.',

		Callback = function(Value)
			if Value == true then
				ESP.Start()
				
				for _, Player in pairs(Players:GetPlayers()) do
					if Player ~= nil and Player.Parent ~= nil and Player ~= LocalPlayer then
						ESP.CreateESP(Player, ESPSettings)
					end
				end
				
				Connections["ESP_PlayerAdded"] = Players.PlayerAdded:Connect(ESP.CreateESP)
				Connections["ESP_PlayerRemoving"] = Players.PlayerRemoving:Connect(ESP.RemoveESP)
			else
				for _, Player in pairs(Players:GetPlayers()) do
					if Player ~= nil and Player.Parent ~= nil and Player ~= LocalPlayer then
						ESP.RemoveESP(Player)
					end
				end
				
				if Connections["ESP_PlayerAdded"] then
					Connections["ESP_PlayerAdded"]:Disconnect()
					Connections["ESP_PlayerAdded"] = nil
				end
				
				if Connections["ESP_PlayerRemoving"] then
					Connections["ESP_PlayerRemoving"]:Disconnect()
					Connections["ESP_PlayerRemoving"] = nil
				end
				
				ESP.Stop()
			end
		end
	})

	CombatGroupBox:AddToggle('AutoDodge', {
		Text = 'AutoDodge',
		Default = false, 
		Tooltip = 'Whether or not the character should auto dodge when an enemy feints an attack.',

		Callback = function(Value)
			print('[cb] MyToggle changed to:', Value)
		end
	})
	
	CombatGroupBox:AddSlider('AutoParryDelay', {
		Text = 'AutoParry Delay',
		Default = 0.5,
		Min = 0,
		Max = 1,
		Suffix = "s",
		Rounding = 1,
		Compact = true,

		Callback = function(Value)
			print('[cb] AutoDodge Delay was changed! New value:', Value)
		end
	})
	
	CombatGroupBox:AddSlider('AutoDodgeDelay', {
		Text = 'AutoDodge Delay',
		Default = 0.25,
		Min = 0,
		Max = 1,
		Suffix = "s",
		Rounding = 1,
		Compact = true,

		Callback = function(Value)
			print('[cb] AutoDodge Delay was changed! New value:', Value)
		end
	})
	
	Toggles.AutoParry:OnChanged(function()
		print('AutoParry changed to:', Toggles.AutoParry.Value)
	end)
	
	Toggles.AutoDodge:OnChanged(function()
		print('AutoDodge changed to:', Toggles.AutoDodge.Value)
	end)

	Library:OnUnload(function()
		print('Unloaded!')
		Library.Unloaded = true
	end)

	MenuGroupBox:AddButton('Unload', function()
		Library:Unload()
	end)
	
	ThemeManager:SetLibrary(Library)
	
	SaveManager:IgnoreThemeSettings()
	ThemeManager:ApplyToTab(Tabs.Settings)
	SaveManager:LoadAutoloadConfig()
end



return Utils
