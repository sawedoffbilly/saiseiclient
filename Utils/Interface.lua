return function(Library)
	local SaiseiTab = Library:AddTab("Saisei");
	local DebugTab = Library:AddTab("Debug");
	
	local SaiseiColumn1 = SaiseiTab:AddColumn();
	local SaiseiCombat = SaiseiColumn1:AddSection("Combat")
	
	SaiseiCombat:AddDivider("Main Cheats");
	SaiseiCombat:AddToggle{text = "Autoparry: Disabled", flag = "AutoParryEnabled"}
	SaiseiCombat:AddSlider{text = "Autoparry Delay", flag = "AutoparryDelay", min = 0, max = 1, value = 0.4, suffix = "s"}
	
	SaiseiCombat:AddDivider("Rage Cheats");
	SaiseiCombat:AddToggle{text = "Cooldowns: Disabled", flag = "CooldownsEnabled"}
	SaiseiCombat:AddToggle{text = "Infinite Stamina: Disabled", flag = "InfiniteStaminaEnabled"}
	SaiseiCombat:AddToggle{text = "Stun: Enabled", flag = "StunEnabled"}
end
