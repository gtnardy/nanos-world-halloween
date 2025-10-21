Package.Require("Pumpkin.lua")
Package.Require("Trapdoor.lua")
Package.Require("Spectate.lua")
Package.Require("Flashlight.lua")
Package.Require("Knight.lua")
Package.Require("Survivor.lua")
Package.Require("Map.lua")
Package.Require("Help.lua")
Package.Require("Scoreboard.lua")
Package.Require("Goggles.lua")
Package.Require("Lollipop.lua")
Package.Require("Nametags.lua")

Package.Require("KnightArchetypes/Wraith.lua")
Package.Require("KnightArchetypes/Berserker.lua")
Package.Require("KnightArchetypes/Crusher.lua")

Halloween = {
	current_role = 0,
	current_archetype = 0,
	current_spectating_index = 1,
	match_state = 0,
	is_trapdoor_opened = false,
	total_pumpkins = 0,
	pumpkins_found = 0,
	flashlight_enabled = true,
	local_character = nil,
	is_map_opened = false,
	is_help_opened = false,
}

HalloweenSettings = {
	survivor_escape_sounds = {
		"nanos-world::A_Female_01_Laugh",
		"nanos-world::A_Female_02_Laugh",
		"nanos-world::A_Male_01_Laugh",
		"nanos-world::A_Male_02_Laugh",
		"nanos-world::A_Male_03_Laugh",
		"nanos-world::A_Male_04_Laugh",
		"nanos-world::A_Male_05_Laugh",
		"nanos-world::A_Male_06_Laugh",
	}
}

Client.SetEscapeMenuText([[
<h1>🎃 Halloween Special Game-Mode 🎃</>

A dark and spooky PvP game-mode where ruthless <strong>Hunters (the Horseless Headless Horsemen)</> stalk helpless <strong>Survivors</> in a haunted park.

Survivors must work together to collect pumpkins and escape, while the Hunters use powers and brutal weapons to hunt them down.

<h2>🙍‍♂️ Survivors</>
- <strong>Goal:</> Collect enough pumpkins scattered around the map to open the <strong>Hatch</> and escape.
- Once the hatch is open, <strong>escape before the Hunters catch you</>.
- Use your <strong>scream</> to daze a Hunter if caught, but it will reveal your location.
- Survivors can find items (like <strong>Gears</> or <strong>Lollipops</>) to increase survivability.

<h2>👹 Horseless Headless Horsemen</>
- <strong>Goal:</> Eliminate all Survivors before they can escape.
- Use your <strong>deadly melee weapon</> and <strong>unique archetype powers</> to hunt.
- Each Hunter archetype comes with different abilities (e.g. invisibility, rage, ground slam).
- Survivors are revealed periodically or through their actions, stay alert and keep the pressure on!

<h3>🎲 Archetypes</>
The Hunters can choose from different archetypes, each with unique abilities:

- <strong>The Wraith:</> Can turn invisible for a short duration to ambush Survivors.
- <strong>The Berserker:</> Can turn into rage that increases your movement and attack speed.
- <strong>The Crusher:</> Can slam the ground to create a shockwave that damages nearby Survivors.

<h2>🎖️ Post Game Emblems</>
When the game ends, players are awarded emblems based on their performance:

<h3>Survivor</>
<strong>🎯 Objective</>: for collecting pumpkins to achieve the objective.
<strong>💀 Survival</>: for staying alive or escaping the match.
<strong>🏃 Evader</>: for stunning hunters while avoiding damage.

<h3>Horseless Headless Horsemen</>
<strong>🔪 Murder</>: for eliminating survivors effectively.
<strong>💥 Savage</>: for dealing significant damage to survivors.
<strong>🏃‍♂️ Chaser</>: for efficient and quick chases during the hunt.
]])


-- Stores the UI Instance
HUD = WebUI("HUD", "file:///UI/index.html")

-- Disable Debug settings
Client.SetDebugEnabled(false)
Client.SetSettingGammaOverride(true, 1)

-- Configure Highlight
Client.SetHighlightColor(Color(1, 0, 0, 0.05), 0, HighlightMode.Always)

-- Creates a WebUI for the Inventory when the package loads
Package.Subscribe("Load", function()
	Sound(Vector(), "halloween-city-park::A_Music_End", true, true, SoundType.Music, 0.5)

	-- Initialize existing Sky
	Sky.Spawn(false, true)
	Sky.SetTimeOfDay(0, 0)
	Sky.SetAnimateTimeOfDay(false)

	Input.SetInputEnabled(true)

	UpdateMappedKeys()
	UpdateDefaultVisualEffects()
end)

function UpdateDefaultVisualEffects()
	-- Makes the map more visible while spectating
	Sky.SetNightBrightness(0.25)
	Sky.SetFog(0)

	-- Restores changed settings
	PostProcess.SetImageEffects()
	PostProcess.SetChromaticAberration()
	PostProcess.SetBloom()
	PostProcess.SetExposure()
	PostProcess.SetGlobalSaturation(Color(1, 1, 1, 1))
	PostProcess.SetGlobalGain(Color(1, 1, 1, 1))
	PostProcess.SetGlobalContrast(Color(1, 1, 1, 1))
end

function UpdateMappedKeys()
	-- TODO new scheme for key:// so we can get icons directly? How would it auto update if user change the key?
	local mapped_keys = { "HalloweenMap", "HalloweenHelp", "HalloweenFlashlight", "HalloweenAbility", "LeftClick", "Sprint", "SpectatePrev", "SpectateNext", "Unspectate" }
	local key_bindings = {}

	for _, binding_name in pairs(mapped_keys) do
		-- Get the mapped key or use it as Raw if didn't find (probably it's a raw key)
		local mapped_key = Input.GetMappedKeys(binding_name)[1] or binding_name

		-- Gets the image path
		local key_icon = Input.GetKeyIcon(mapped_key, true)

		key_bindings[binding_name] = key_icon
	end

	HUD:CallEvent("UpdateMappedKeys", key_bindings)
end

Input.Subscribe("KeyBindingChange", function(binding_name, key, scale)
	UpdateMappedKeys()
end)

-- Player is ready after 1 second the Package is loaded
Timer.SetTimeout(function()
	Events.CallRemote("PlayerReady")
end, 1000)

Player.Subscribe("Possess", function(player, character)
	if (player == Client.GetLocalPlayer()) then
		Halloween.local_character = character

		-- Attaches a subtle Light to the Character, so we can see nearby
		local light = Light(character:GetLocation(), Rotator(), Color(1, 0.75, 0.68), LightType.Point, 0.01, 1000, 44, 0, 1000, false, false, true, 4)
		light:AttachTo(character, AttachmentRule.KeepRelative, "head", 0)

		if (character:IsA(KnightCharacter)) then
			player:SetCameraSocketOffset(Vector(0, 0, 60))
		end
	end
end)

Player.Subscribe("UnPossess", function(player, character)
	if (player == Client.GetLocalPlayer()) then
		Halloween.local_character = nil
		HUD:CallEvent("SetSpectating", true)
		HUD:CallEvent("SetObjective", "SPECTATING")

		UpdateDefaultVisualEffects()
		UpdateSpectatingBillboards()
	end
end)

Character.Subscribe("Death", function (self, last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
	if (self.billboard and self.billboard:IsValid()) then
		self.billboard:Destroy()
		self.billboard = nil
	end

	-- If I died, stop heartbeat sound
	if (Halloween.local_character == self) then
		Halloween.heartbeat_sound:Stop()
	end
end)

-- VOIP Animation
Player.Subscribe("VOIP", function(player, is_talking)
	local character = player:GetControlledCharacter()
	if (character and character:IsA(SurvivorCharacter)) then
		if (is_talking and character:GetLocation():IsNear(Client.GetLocalPlayer():GetCameraLocation(), 1000)) then
			character:PlayAnimation("nanos-world::A_Adventure_Mouth_Talk", AnimationSlotType.Head, true)
		else
			character:StopAnimation("nanos-world::A_Adventure_Mouth_Talk")
		end
	end
end)

-- Set's someone Role
Events.SubscribeRemote("SetPlayerRole", function(player, role)
	-- If it's me
	if (Client.GetLocalPlayer() == player) then
		Halloween.current_role = role
		if (role == ROLES.KNIGHT) then
			HUD:CallEvent("IAmKnight")
			HUD:CallEvent("SetObjective", "HUNT DOWN ALL SURVIVORS")

			Sky.SetNightBrightness(0.1)
			Sky.SetFog(0)
		else
			HUD:CallEvent("IAmSurvivor")
			HUD:CallEvent("SetObjective", "COLLECT PUMPKINS TO OPEN THE HATCH")

			Sky.SetNightBrightness(0.05)
			Sky.SetFog(1)

			Halloween.heartbeat_sound = Sound(Vector(), "halloween-city-park::A_Heartbeat_Cue", true, false, SoundType.SFX, 1, 1, 400, 3600, 0, false, 0, false)
		end

		Sound(Vector(), "halloween-city-park::A_Paper", true)
	end

	if (role == ROLES.KNIGHT) then
		HUD:CallEvent("AddKnight")
	else
		HUD:CallEvent("AddSurvivor")
	end
end)

-- Set's someone Archetype
Events.SubscribeRemote("SetKnightArchetype", function(player, archetype)
	player:SetValue("KnightArchetype", archetype)

	-- If it's me
	if (Client.GetLocalPlayer() == player) then
		Halloween.current_archetype = archetype

		local archetype_data = KNIGHT_ARCHETYPES[archetype]
		HUD:CallEvent("SetKnightArchetype", archetype_data.name, archetype_data.active_ability.name)
	end
end)

-- Configures Keybindings Inputs
Input.Register("HalloweenAbility", "X", "Special Ability")

Input.Bind("HalloweenAbility", InputEvent.Pressed, function()
	if (NanosUtils.IsEntityValid(Halloween.local_character)) then
		Halloween.local_character:CallRemoteEvent("TriggerAbility")
	end
end)

Events.SubscribeRemote("MatchWillBegin", function()
	Sound(Vector(), "halloween-city-park::A_Announcer_MatchBegin_Cue", true, true)
end)

Events.SubscribeRemote("MatchEnding", function()
	Sound(Vector(), "halloween-city-park::A_Announcer_Cooldown", true, true)
end)

function ClearServer()
	Halloween.current_role = 0
	Halloween.current_archetype = 0
	Halloween.current_spectating_index = 1
	Halloween.pumpkins_found = 0
	Halloween.is_trapdoor_opened = false
	Halloween.flashlight_enabled = true
	Halloween.local_character = nil
	Halloween.is_map_opened = false
	Halloween.is_help_opened = false

	if (Halloween.match_state ~= 0) then
		for k, s in pairs(Sound.GetAll()) do s:Destroy() end
		for k, l in pairs(Light.GetAll()) do l:Destroy() end
	end

	HUD:CallEvent("ClearHUD")
end

Player.Subscribe("Spawn", function(player)
	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		UpdateWaitingPlayers()
	end
end)

Player.Subscribe("Destroy", function(player)
	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		UpdateWaitingPlayers()
	end
end)

function UpdateWaitingPlayers()
	local player_count = Player.GetCount()
	HUD:CallEvent("SetLabel", "WAITING PLAYERS (" .. player_count .. "/4)")
end

Events.SubscribeRemote("UpdatePostTimeResults", function(result_label, survivors, knights)
	HUD:CallEvent("SetLabel", "MATCH ENDED: " .. result_label)
	HUD:CallEvent("UpdatePostTimeResults", survivors, knights)
end)

Events.SubscribeRemote("UpdateMatchState", function(new_state, remaining_time, total_pumpkins, pumpkins_found)
	remaining_time = remaining_time - 1
	Halloween.total_pumpkins = total_pumpkins
	Halloween.pumpkins_found = pumpkins_found

	if (new_state == MATCH_STATES.WAITING_PLAYERS) then

		ClearServer()
		Input.SetInputEnabled(true)
		HUD:CallEvent("SetPostTime", false)
		HUD:CallEvent("SetMatchInProgress", false)
		HUD:CallEvent("SetSpectating", true)
		UpdateWaitingPlayers()
	elseif (new_state == MATCH_STATES.PREPARING) then

		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("SetLabel", "STARTING")
	elseif (new_state == MATCH_STATES.WARM_UP) then

		HUD:CallEvent("SetMatchInProgress", true)
		HUD:CallEvent("SetSpectating", false)
		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("UpdatePumpkinsFound", total_pumpkins, 0)
		HUD:CallEvent("SetLabel", "PREPARING")
		SetHelpEnabled(true)
	elseif (new_state == MATCH_STATES.IN_PROGRESS) then

		SetHelpEnabled(false)
		HUD:CallEvent("SetMatchInProgress", true)
		HUD:CallEvent("SetClock", remaining_time)
		HUD:CallEvent("SetLabel", "")

		-- Means the Match is in progress and I'm a spectator
		if (Halloween.current_role == ROLES.NONE) then
			UpdateSpectatingBillboards()
			HUD:CallEvent("SetSpectating", true)
			HUD:CallEvent("UpdatePumpkinsFound", total_pumpkins, pumpkins_found)

			-- If the hatch is open
			if (total_pumpkins == pumpkins_found) then
				HUD:CallEvent("SetLabel", "THE HATCH HAS OPENED!")
			else
				HUD:CallEvent("SetLabel", "")
			end

			-- Updates amount of knights and survivors
			for k, p in pairs(Player.GetPairs()) do
				local role = p:GetValue("Role")
				local is_alive = p:GetValue("IsAlive")

				if (role == ROLES.KNIGHT) then
					HUD:CallEvent("AddKnight")

					if (not is_alive) then
						HUD:CallEvent("KillKnight")
					end
				elseif (role == ROLES.SURVIVOR) then
					HUD:CallEvent("AddSurvivor")

					if (not is_alive) then
						HUD:CallEvent("KillSurvivor")
					end
				end
			end

			HUD:CallEvent("SetObjective", "SPECTATING")
		end

	elseif (new_state == MATCH_STATES.POST_TIME) then
		-- TODO force close map/help?

		Input.SetInputEnabled(false)

		HUD:CallEvent("SetPostTime", true)
		HUD:CallEvent("SetClock", remaining_time)
		Sound(Vector(), "halloween-city-park::A_Music_End", true, true, SoundType.Music, 0.5)
	end

	Halloween.match_state = new_state
end)

Events.SubscribeRemote("SetSpecialCooldown", function(current_knights_special_cooldown)
	if (Halloween.current_role == ROLES.KNIGHT) then
		HUD:CallEvent("SetSpecialCooldown", current_knights_special_cooldown)
	end

end)

Events.SubscribeRemote("AddFeedItem", function(type, name1, name2)
	HUD:CallEvent("AddFeedItem", type, name1, name2)
end)

Events.SubscribeRemote("TriggerXRay", function()
	if (Halloween.current_role == ROLES.KNIGHT) then
		if (Halloween.local_character and Halloween.local_character.stunned) then return end

		-- Makes everyone red for 10 seconds
		for k, character in pairs(SurvivorCharacter.GetPairs()) do
			if (not character:IsDead()) then
				character:SetHighlight(true)
			end
		end
	else
		-- Makes myself red as well
		if (NanosUtils.IsEntityValid(Halloween.local_character)) then
			Halloween.local_character:SetHighlight(true)
		end
	end

	-- Spawns a evil Laugh at the location of the Knights
	for k, character in pairs(Character.GetPairs()) do
		local player = character:GetPlayer()
		if (player and player:GetValue("Role") == ROLES.KNIGHT) then
			local laugh = Sound(character:GetLocation(), "halloween-city-park::A_Evil_Laugh_Cue", false, true, SoundType.SFX, 3, 0.9, 5000, 50000, AttenuationFunction.Logarithmic, true)
			laugh:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
		end
	end
end)