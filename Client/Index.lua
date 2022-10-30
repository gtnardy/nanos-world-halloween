Halloween = {
	current_role = 0,
	current_spectating_index = 1,
	match_state = 0,
	is_trapdoor_opened = false,
	total_pumpkins = 0,
	pumpkins_found = 0,
	flashlight_enabled = true,
}

-- Stores the UI Instance
HUD = nil

-- Disable Debug settings
Client.SetDebugEnabled(false)

-- Creates a WebUI for the Inventory when the package loads
Package.Subscribe("Load", function()
	HUD = WebUI("HUD", "file:///UI/index.html")
	Sound(Vector(), "halloween-city-park::A_Music_End", true, true, SoundType.SFX, 0.5)
end)

Client.SetHighlightColor(Color(3, 0, 0, 1.5), 0, HighlightMode.Always)

-- Set's someone Role
Events.Subscribe("SetPlayerRole", function(player, role)
	player:SetValue("Role", role)

	-- If it's me
	if (Client.GetLocalPlayer() == player) then
		Halloween.current_role = role
		if (role == ROLES.KNIGHT) then
			HUD:CallEvent("IAmKnight")
		else
			HUD:CallEvent("IAmSurvivor")
		end

		Sound(Vector(), "halloween-city-park::A_Paper", true)
	end

	if (role == ROLES.KNIGHT) then
		HUD:CallEvent("AddKnight")
	else
		HUD:CallEvent("AddSurvivor")
	end
end)

-- Configures Keybindings Inputs
Input.Register("HalloweenFlashlight", "F")
Input.Register("HalloweenSpecial", "X")
Input.Register("SpectatePrev", "Left")
Input.Register("SpectateNext", "Right")
Input.Register("Unspectate", "SpaceBar")
Input.Register("Map", "M")

Input.Bind("HalloweenFlashlight", InputEvent.Pressed, function()
	Events.CallRemote("ToggleFlashlight")
end)

Input.Bind("HalloweenSpecial", InputEvent.Pressed, function()
	Events.CallRemote("TriggerSpecial")
end)

Input.Bind("SpectatePrev", InputEvent.Pressed, function()
	SpectateNext(-1)
end)

Input.Bind("SpectateNext", InputEvent.Pressed, function()
	SpectateNext(1)
end)

Input.Bind("Map", InputEvent.Pressed, function()
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end

	HUD:CallEvent("MapToggled", true)
	Sound(Vector(), "halloween-city-park::A_Paper", true)
end)

Input.Bind("Map", InputEvent.Released, function()
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end

	HUD:CallEvent("MapToggled", false)
	Sound(Vector(), "halloween-city-park::A_Paper", true)
end)

Input.Bind("Unspectate", InputEvent.Pressed, function()
	if (Client.GetLocalPlayer():GetControlledCharacter()) then return end
	Client.GetLocalPlayer():ResetCamera()
end)

-- Flick the Flashlight
Timer.SetInterval(function()
	if (Halloween.current_role == ROLES.SURVIVOR and Halloween.match_state == MATCH_STATES.IN_PROGRESS and Halloween.flashlight_enabled and math.random() <= 0.05) then
		Events.CallRemote("ToggleFlashlight")
		Timer.SetTimeout(function()
			Events.CallRemote("ToggleFlashlight")
		end, 150)
	end
end, 15000)

-- Spectate function
function SpectateNext(index_increment)
	if (Client.GetLocalPlayer():GetControlledCharacter()) then return end
	Halloween.current_spectating_index = Halloween.current_spectating_index + index_increment

	local players = {}
	for k, v in pairs(Player.GetPairs()) do
		if (v ~= Client.GetLocalPlayer() and v:GetControlledCharacter() ~= nil) then
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

	Client.Spectate(players[Halloween.current_spectating_index])
end

Events.Subscribe("MatchWillBegin", function()
	Sound(Vector(), "halloween-city-park::A_Announcer_MatchBegin", true, true)
end)

Events.Subscribe("MatchEnding", function()
	Sound(Vector(), "halloween-city-park::A_Announcer_Cooldown", true, true)
end)

Events.Subscribe("FlashlightToggled", function(player, location, enabled)
	Halloween.flashlight_enabled = enabled

	Sound(location, "halloween-city-park::A_Flashlight")

	if (player == Client.GetLocalPlayer()) then
		HUD:CallEvent("FlashlightToggled", enabled)
	end
end)

Events.Subscribe("SurvivorWins", function(player_mvp, player_most_damage, player_most_pumpkins)
	HUD:CallEvent("SetLabelBig", "SURVIVORS WIN!", player_mvp, player_most_damage, player_most_pumpkins)

	if (Halloween.current_role == ROLES.SURVIVOR) then
		Sound(Vector(), "halloween-city-park::A_Announcer_Victory", true)
	else
		Sound(Vector(), "halloween-city-park::A_Announcer_Defeat", true)
	end
end)

Events.Subscribe("KnightWins", function(player_mvp, player_most_damage, player_most_pumpkins)
	HUD:CallEvent("SetLabelBig", "HORSELESS HEADLESS HORSEMAN WIN!", player_mvp, player_most_damage, player_most_pumpkins)

	if (Halloween.current_role == ROLES.KNIGHT) then
		Sound(Vector(), "halloween-city-park::A_Announcer_Victory", true)
	else
		Sound(Vector(), "halloween-city-park::A_Announcer_Defeat", true)
	end
end)

Events.Subscribe("UpdateMatchState", function(new_state, remaining_time, total_pumpkins, pumpkins_found)
	remaining_time = remaining_time - 1
	Halloween.total_pumpkins = total_pumpkins

	if (new_state == MATCH_STATES.PREPARING) then

		HUD:CallEvent("ClearHUD")
		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("SetLabel", "STARTING")
	elseif (new_state == MATCH_STATES.WARM_UP) then

		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("UpdatePumpkinsFound", total_pumpkins, 0)
		HUD:CallEvent("SetLabel", "PREPARING")
	elseif (new_state == MATCH_STATES.WAITING_PLAYERS) then

		Halloween.current_role = 0
		Halloween.current_spectating_index = 1
		Halloween.pumpkins_found = 0
		Halloween.is_trapdoor_opened = false
		Halloween.flashlight_enabled = true

		if (Halloween.match_state ~= 0) then
			for k, s in pairs(Sound.GetAll()) do s:Destroy() end
		end

		HUD:CallEvent("ClearHUD")
		HUD:CallEvent("SetLabel", "WAITING PLAYERS")
	elseif (new_state == MATCH_STATES.IN_PROGRESS) then

		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("SetLabel", "IN PROGRESS")

		-- Means the Match is in progress and I'm a spectator
		if (Halloween.current_role == 0) then
			HUD:CallEvent("UpdatePumpkinsFound", total_pumpkins, pumpkins_found)

			-- Updates amount of knights and survivors 
			for k, p in pairs(Player.GetPairs()) do
				local role = p:GetValue("Role")
				local is_alive = p:GetValue("IsAlive")

				if (role == ROLES.KNIGHT) then
					HUD:CallEvent("AddKnight")

					if (not is_alive) then
						HUD:CallEvent("KillKnight")
					end
				else
					HUD:CallEvent("AddSurvivor")

					if (not is_alive) then
						HUD:CallEvent("KillSurvivor")
					end
				end
			end
		end

	elseif (new_state == MATCH_STATES.POST_TIME) then

		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("SetLabel", "POST TIME")
		Sound(Vector(), "halloween-city-park::A_Music_End", true, true, SoundType.SFX, 0.5)
	end

	Halloween.match_state = new_state
end)

Events.Subscribe("CharacterDeath", function(character, role)
	-- Sets his corpose as Highlight for 5 seconds
	if (Halloween.current_role == ROLES.SURVIVOR) then
		character:SetHighlightEnabled(true, 0)
		Timer.Bind(
			Timer.SetTimeout(function(_char)
				_char:SetHighlightEnabled(false, 0)
			end, 5000, character),
			character
		)
	end

	-- Triggers a Scream at the location
	if (role == ROLES.KNIGHT) then
		HUD:CallEvent("KillKnight")
		Sound(character:GetLocation(), "halloween-city-park::A_Monster_Shout", false, true, SoundType.SFX, 1, 1, 5000, 50000, AttenuationFunction.Logarithmic, true)
	else
		HUD:CallEvent("KillSurvivor")
		Sound(character:GetLocation(), "halloween-city-park::A_Scream", false, true, SoundType.SFX, 1, 1, 5000, 50000, AttenuationFunction.Logarithmic, true)
	end
end)

Events.Subscribe("SetSpecialCooldown", function(current_knights_special_cooldown)
	if (Halloween.current_role == ROLES.KNIGHT) then
		HUD:CallEvent("SetSpecialCooldown", current_knights_special_cooldown)
	end
end)

Events.Subscribe("TriggerSpecial", function(location)
	if (Halloween.current_role == ROLES.KNIGHT) then
		-- Makes everyone red for 10 seconds
		for k, character in pairs(Character.GetPairs()) do
			local player = character:GetPlayer()
			if (player and player:GetValue("Role") == ROLES.SURVIVOR and player ~= Client.GetLocalPlayer()) then
				character:SetHighlightEnabled(true, 0)
			end
		end
	else
		local character = Client.GetLocalPlayer():GetControlledCharacter()
		if (character) then
			character:SetHighlightEnabled(true, 0)
		end
	end

	Timer.SetTimeout(function()
		for k, character in pairs(Character.GetPairs()) do
			character:SetHighlightEnabled(false, 0)
		end
	end, 10000)

	-- Spawns a evil Laugh at the location of the Knights
	for k, character in pairs(Character.GetPairs()) do
		local player = character:GetPlayer()
		if (player and player:GetValue("Role") == ROLES.KNIGHT) then
			local laugh = Sound(location, "halloween-city-park::A_Evil_Laugh", false, true, SoundType.SFX, 5, 1, 5000, 50000, AttenuationFunction.Logarithmic, true)
			laugh:AttachTo(character)
		end
	end
end)

-- Player is ready after 3 seconds the Package is loaded
Timer.SetTimeout(function()
	Events.CallRemote("PlayerReady")
end, 3000)

Events.Subscribe("PumpkinFound", function(pumpkin_location)
	Sound(pumpkin_location, "halloween-city-park::A_Pumpkin_Pickup", false)

	Halloween.pumpkins_found = Halloween.pumpkins_found + 1
	HUD:CallEvent("UpdatePumpkinsFound", Halloween.total_pumpkins, Halloween.pumpkins_found)
end)

Events.Subscribe("TrapdoorOpened", function(trapdoor)
	Halloween.is_trapdoor_opened = true
	Sound(trapdoor:GetLocation(), "halloween-city-park::A_Hatch_Cue", false, false, SoundType.SFX, 2, 1, 1000, 35000, AttenuationFunction.Logarithmic, true)
end)

Events.Subscribe("SurvivorEscaped", function()
	HUD:CallEvent("EscapeSurvivor")
	Sound(Vector(), "halloween-city-park::A_Pumpkin_Pickup", true)
end)

-- Radar triggers at each 4 seconds
Timer.SetInterval(function()
	local local_character = Client.GetLocalPlayer():GetControlledCharacter()
	if (not local_character or Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end

	-- TODO: if more than 2 pumpkins is close, it triggers the first even if it's distant
	if (Halloween.current_role == ROLES.KNIGHT) then
		for k, c in pairs(Character) do
			if (c:GetValue("Role") ~= ROLES.KNIGHT) then
				local distance = local_character:GetLocation():Distance(c:GetLocation())

				if (local_character ~= c and distance < 5000 and c:GetHealth() > 0) then
					HUD:CallEvent("TriggerRadar")

					local pitch = 1
					if distance < 2000 then pitch = 1.5 end

					Sound(Vector(), "halloween-city-park::A_Sonar_Ping", true, true, SoundType.SFX, 0.5, pitch)

					return
				end
			end
		end
	else
		if (not Halloween.is_trapdoor_opened) then
			for k, p in pairs(Prop) do
				local distance = local_character:GetLocation():Distance(p:GetLocation())
				if (p:GetAssetName() == "halloween-city-park::SM_Pumpkin_Lit" and distance < 5000) then
					HUD:CallEvent("TriggerRadar")

					local pitch = 1
					if distance < 2000 then pitch = 1.5 end

					Sound(Vector(), "halloween-city-park::A_Sonar_Ping", true, true, SoundType.SFX, 0.5, pitch)
					return
				end
			end
		end
	end
end, 4000)


Package.Require("Scoreboard.lua")