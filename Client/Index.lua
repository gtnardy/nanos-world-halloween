Halloween = {
	current_role = 0,
	current_spectating_index = 1,
	match_state = 0,
	is_trapdoor_opened = false,
	total_pumpkins = 0,
	pumpkins_found = 0,
}

-- Stores the UI Instance
HUD = nil

-- Creates a WebUI for the Inventory when the package loads
Package:Subscribe("Load", function()
	HUD = WebUI("HUD", "file:///UI/index.html")
	Sound(Vector(), "HalloweenCityPark::A_Music_End", true, true, 0.5)
end)

-- Destroys the WebUI when the package unloads
Package:Subscribe("Unload", function()
	HUD:Destroy()
end)

Client:SetHighlightColor(Color(3, 0, 0, 0.05))

-- Set's someone Role
Events:Subscribe("SetPlayerRole", function(player, role)
	player:SetValue("Role", role)

	-- If it's me
	if (NanosWorld:GetLocalPlayer() == player) then
		Halloween.current_role = role
		if (role == ROLES.KNIGHT) then
			HUD:CallEvent("IAmKnight", {})
		else
			HUD:CallEvent("IAmSurvivor", {})
		end

		Sound(Vector(), "HalloweenCityPark::A_Paper", true)
	end

	if (role == ROLES.KNIGHT) then
		HUD:CallEvent("AddKnight", {})
	else
		HUD:CallEvent("AddSurvivor", {})
	end
end)

Client:Subscribe("KeyUp", function(KeyName)
	if (KeyName == "F") then
		Events:CallRemote("ToggleFlashlight", {})
	elseif (KeyName == "Left") then
		SpectateNext(-1)
	elseif (KeyName == "Q") then
		Events:CallRemote("TriggerSpecial", {})
	elseif (KeyName == "Right") then
		SpectateNext(1)
	elseif (KeyName == "SpaceBar") then
		if (NanosWorld:GetLocalPlayer():GetControlledCharacter()) then return end
		Client:Unspectate()
	end
end)

-- Spectate function
function SpectateNext(index_increment)
	if (NanosWorld:GetLocalPlayer():GetControlledCharacter()) then return end
	Halloween.current_spectating_index = Halloween.current_spectating_index + index_increment

	local players = {}
	for k, v in pairs(NanosWorld:GetPlayers()) do
		if (v ~= NanosWorld:GetLocalPlayer() and v:GetControlledCharacter() ~= nil) then
			table.insert(players, v)
		end
	end

	if (#players == 0) then return end

	if (not players[Halloween.current_spectating_index]) then
		if (index_increment > 0) then
			Halloween.current_spectating_index = 1
		else
			Halloween.current_spectating_index = #players
		end
	end

	Client:Spectate(players[Halloween.current_spectating_index])
end

Events:Subscribe("MatchWillBegin", function()
	Sound(Vector(), "HalloweenCityPark::A_Announcer_MatchBegin", true, true, 1, 0.9)
end)

Events:Subscribe("MatchEnding", function()
	Sound(Vector(), "HalloweenCityPark::A_Announcer_Cooldown", true, true, 1, 0.9)
end)

Events:Subscribe("FlashlightToggled", function(player, location, enabled)
	Sound(location, "HalloweenCityPark::A_Flashlight", false)
	if (player == NanosWorld:GetLocalPlayer()) then
		HUD:CallEvent("FlashlightToggled", {enabled})
	end
end)

Events:Subscribe("SurvivorWins", function()
	HUD:CallEvent("SetLabelBig", {"SURVIVORS WIN!"})

	if (Halloween.current_role == ROLES.SURVIVOR) then
		Sound(Vector(), "HalloweenCityPark::A_Announcer_Victory", true)
	else
		Sound(Vector(), "HalloweenCityPark::A_Announcer_Defeat", true)
	end 
end)

Events:Subscribe("KnightWins", function()
	HUD:CallEvent("SetLabelBig", {"HORSELESS HEADLESS HORSEMAN WIN!"})
	
	if (Halloween.current_role == ROLES.KNIGHT) then
		Sound(Vector(), "HalloweenCityPark::A_Announcer_Victory", true)
	else
		Sound(Vector(), "HalloweenCityPark::A_Announcer_Defeat", true)
	end
end)

Events:Subscribe("UpdateMatchState", function(new_state, remaining_time, total_pumpkins)
	remaining_time = remaining_time - 1
	Halloween.match_state = new_state
	Halloween.total_pumpkins = total_pumpkins

	if (new_state == MATCH_STATES.WARM_UP) then
	
		HUD:CallEvent("SetClock", {remaining_time})
		HUD:CallEvent("UpdatePumpkinsFound", {total_pumpkins, 0})
		HUD:CallEvent("SetLabel", {"PREPARING"})
	elseif (new_state == MATCH_STATES.WAITING_PLAYERS) then

		Halloween.current_role = 0
		Halloween.current_spectating_index = 1
		Halloween.pumpkins_found = 0
		Halloween.is_trapdoor_opened = false

		local sounds = {}
		for k, s in pairs(Sound) do table.insert(sounds, s) end
		for k, s in pairs(sounds) do s:Destroy() end

		HUD:CallEvent("ClearHUD", {})
		HUD:CallEvent("SetLabel", {"WAITING FOR HOST"})
	elseif (new_state == MATCH_STATES.IN_PROGRESS) then
	
		HUD:CallEvent("SetClock", {remaining_time})
		HUD:CallEvent("SetLabel", {"IN PROGRESS"})

	elseif (new_state == MATCH_STATES.POST_TIME) then

		HUD:CallEvent("SetClock", {remaining_time})
		HUD:CallEvent("SetLabel", {"POST TIME"})
		Sound(Vector(), "HalloweenCityPark::A_Music_End", true, true, 0.5)
	end
end)

Events:Subscribe("CharacterDeath", function(character, role)
	-- Sets his corpose as Highlight for 5 seconds
	if (Halloween.current_role == ROLES.SURVIVOR) then
		character:SetHighlightEnabled(true)
		Timer:SetTimeout(5000, function(_char)
			if (_char and _char:IsValid()) then
				_char:SetHighlightEnabled(false)
			end
			return false
		end, {character})
	end

	-- Triggers a Scream at the location
	if (role == ROLES.KNIGHT) then
		HUD:CallEvent("KillKnight", {})
		Sound(character:GetLocation(), "HalloweenCityPark::A_Monster_Shout", false, true, 0, 1, 1, 5000, 50000, 1, true)
	else
		HUD:CallEvent("KillSurvivor", {})
		Sound(character:GetLocation(), "HalloweenCityPark::A_Scream", false, true, 0, 1, 1, 5000, 50000, 1, true)
	end
end)

Events:Subscribe("SetSpecialCooldown", function(current_knights_special_cooldown)
	if (Halloween.current_role == ROLES.KNIGHT) then
		HUD:CallEvent("SetSpecialCooldown", {current_knights_special_cooldown})
	end
end)

Events:Subscribe("TriggerSpecial", function(location)
	if (Halloween.current_role == ROLES.KNIGHT) then
		-- Makes everyone red for 10 seconds
		for k, character in pairs(NanosWorld:GetCharacters()) do
			local player = character:GetPlayer()
			if (player and player:GetValue("Role") == ROLES.SURVIVOR and player ~= NanosWorld:GetLocalPlayer()) then
				character:SetHighlightEnabled(true)
			end
		end
	else
		local character = NanosWorld:GetLocalPlayer():GetControlledCharacter()
		if (character) then
			character:SetHighlightEnabled(true)
		end
	end

	Timer:SetTimeout(10000, function()
		for k, character in pairs(NanosWorld:GetCharacters()) do
			character:SetHighlightEnabled(false)
		end
		return false
	end)

	-- Spawns a evil Laugh at the location of the Knight
	Sound(location, "HalloweenCityPark::A_Evil_Laugh", false, true, 0, 5, 1, 5000, 50000, 1, true)
end)

-- Player is ready after 3 seconds the Package is loaded
Timer:SetTimeout(3000, function()
	Events:CallRemote("PlayerReady", {})
	return false
end)

Events:Subscribe("PumpkinFound", function(pumpkin_location)
	Sound(pumpkin_location, "HalloweenCityPark::A_Pumpkin_Pickup", false)

	Halloween.pumpkins_found = Halloween.pumpkins_found + 1
	HUD:CallEvent("UpdatePumpkinsFound", {Halloween.total_pumpkins, Halloween.pumpkins_found})
end)

Events:Subscribe("TrapdoorOpened", function(trapdoor)
	Halloween.is_trapdoor_opened = true
	Sound(trapdoor:GetLocation(), "HalloweenCityPark::A_Hatch_Cue", false, false, 0, 2, 1, 1000, 25000, 1, true)
end)

Events:Subscribe("SurvivorEscaped", function()
	HUD:CallEvent("EscapeSurvivor", {})
	Sound(Vector(), "HalloweenCityPark::A_Pumpkin_Pickup", true)
end)

-- Radar triggers at each 4 seconds
Timer:SetTimeout(4000, function()
	local local_character = NanosWorld:GetLocalPlayer():GetControlledCharacter()
	if (not local_character or Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end

	if (Halloween.current_role == ROLES.KNIGHT) then
		for k, c in pairs(Character) do
			local distance = local_character:GetLocation():Distance(c:GetLocation())

			if (local_character ~= c and distance < 5000 and c:GetHealth() > 0) then
				HUD:CallEvent("TriggerRadar", {})
				
				local pitch = 1
				if distance < 2000 then pitch = 1.5 end

				Sound(Vector(), "HalloweenCityPark::A_Sonar_Ping", true, true, 0, 0.5, pitch)

				return
			end
		end
	else
		if (not Halloween.is_trapdoor_opened) then
			for k, p in pairs(Prop) do
				local distance = local_character:GetLocation():Distance(p:GetLocation())
				if (p:GetAssetName() == "HalloweenCityPark::SM_Pumpkin_Lit" and distance < 5000) then
					HUD:CallEvent("TriggerRadar", {})

					local pitch = 1
					if distance < 2000 then pitch = 1.5 end

					Sound(Vector(), "HalloweenCityPark::A_Sonar_Ping", true, true, 0, 0.5, pitch)
					return
				end
			end
		end
	end
end)