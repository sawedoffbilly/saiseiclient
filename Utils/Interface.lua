loadstring(game:HttpGet('https://raw.githubusercontent.com/sawedoffbilly/saiseiclient/refs/heads/main/Utils/Interface.lua'))()

local SaiseiTab = library:AddTab("Saisei");
local DebugTab = library:AddTab("Debug");
local SettingsTab = library:AddTab("Settings");

local SaiseiColumn1 = SaiseiTab:AddColumn();
local SaiseiCombat = SaiseiColumn1:AddSection("Combat")

SaiseiCombat:AddDivider("Main Cheats");
SaiseiCombat:AddToggle{text = "Autoparry: Disabled", flag = "AutoParryEnabled"}
SaiseiCombat:AddSlider{text = "Autoparry Delay", flag = "AutoparryDelay", min = 0, max = 1, value = 0.4, suffix = "s"}

SaiseiCombat:AddDivider("Rage Cheats");
SaiseiCombat:AddToggle{text = "Cooldowns: Disabled", flag = "CooldownsEnabled"}
SaiseiCombat:AddToggle{text = "Infinite Stamina: Disabled", flag = "InfiniteStaminaEnabled"}
SaiseiCombat:AddToggle{text = "Stun: Enabled", flag = "StunEnabled"}

local SettingsColumn = SettingsTab:AddColumn(); 
local SettingsColumn2 = SettingsTab:AddColumn(); 

local SettingSection = SettingsColumn:AddSection("Menu"); 

local Warning = library:AddWarning({type = "confirm"});

SettingSection:AddBind({text = "Open / Close", flag = "UI Toggle", nomouse = true, key = "End", callback = function()
	library:Close();
end});

SettingSection:AddColor({text = "Accent Color", flag = "Menu Accent Color", color = Color3.new(0.599623620510101318359375, 0.447115242481231689453125, 0.97174417972564697265625), callback = function(color)
	if library.currentTab then
		library.currentTab.button.TextColor3 = color;
	end

	for i,v in pairs(library.theme) do
		v[(v.ClassName == "TextLabel" and "TextColor3") or (v.ClassName == "ImageLabel" and "ImageColor3") or "BackgroundColor3"] = color;
	end
end});

local backgroundlist = {
	Floral = "rbxassetid://5553946656",
	Flowers = "rbxassetid://6071575925",
	Circles = "rbxassetid://6071579801",
	Hearts = "rbxassetid://6073763717"
};

local back = SettingSection:AddList({text = "Background", max = 4, flag = "background", values = {"Floral", "Flowers", "Circles", "Hearts"}, value = "Floral", callback = function(v)
	if library.main then
		library.main.Image = backgroundlist[v];
	end
end});

back:AddColor({flag = "backgroundcolor", color = Color3.new(), callback = function(color)
	if library.main then
		library.main.ImageColor3 = color;
	end
end, Trans = 1, calltrans = function(Trans)
	if library.main then
		library.main.ImageTransparency = 1 - Trans;
	end
end});	

SettingSection:AddSlider({text = "Tile Size", min = 50, max = 500, value = 50, callback = function(size)
	if library.main then
		library.main.TileSize = UDim2.new(0, size, 0, size);
	end
end});

library:Init();
library:selectTab(library.tabs[1]);
