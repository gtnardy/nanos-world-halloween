Package.Require("KnightWeapons.lua")
Package.Require("Pumpkin.lua")
Package.Require("Trapdoor.lua")
Package.Require("Flashlight.lua")
Package.Require("Knight.lua")
Package.Require("Survivor.lua")
Package.Require("Goggles.lua")
Package.Require("Lollipop.lua")
Package.Require("Tally.lua")

-- TODO load all /* from folder?
Package.Require("KnightArchetypes/Wraith.lua")
Package.Require("KnightArchetypes/Berserker.lua")
Package.Require("KnightArchetypes/Crusher.lua")

-- Static Settings
HalloweenSettings = {
	 -- Parsed from map
	config = {},

	 -- Parsed from server/game-mode
	custom_settings = {
		warmup_time = nil,
		match_time = nil,
		post_time = nil,
		trapdoor_time = nil,
		preparing_time = nil,
		players_to_start = nil,
		survivors_per_knight = nil,
		pumpkins_per_player = nil,
		extra_pumpkins = nil,
		knights_xray_cooldown = nil,
		knights_xray_initial_cooldown = nil,
		survivor_scream_cooldown = nil,
		knight_speed_multiplier = nil,
		survivor_speed_multiplier = nil,
	},

	-- Knight Head Pumpkin meshes
	knight_pumpkins = {
		"halloween-city-park::SM_Pumpkin_Carved_00",
		"halloween-city-park::SM_Pumpkin_Carved_01",
		"halloween-city-park::SM_Pumpkin_Carved_02",
	},

	-- Map Pumpkin meshes
	pumpkin_meshes = {
		"halloween-city-park::SM_Pumpkin_Carved_00",
		"halloween-city-park::SM_Pumpkin_Carved_01",
		"halloween-city-park::SM_Pumpkin_Carved_02",
	},

	-- Survivor pain sounds
	survivor_pain_sounds = {
		"nanos-world::A_Female_01_Pain",
		"nanos-world::A_Female_02_Pain",
		"nanos-world::A_Female_03_Pain",
		"nanos-world::A_Female_04_Pain",
		"nanos-world::A_Female_05_Pain",
		"nanos-world::A_Female_06_Pain",
		"nanos-world::A_Female_07_Pain",
		"nanos-world::A_Female_08_Pain",
	}
}

-- Current Match Status
Halloween = {
	remaining_time = 0,
	match_state = MATCH_STATES.WAITING_PLAYERS,
	current_knights_global_xray_cooldown = 0,
	is_trapdoor_opened = false,
	trapdoor = nil,
	pumpkins_found = 0,
	total_pumpkins = 0,
	players_saved = 0,
	initial_player_count = 0
}

-- When player fully connects (custom event)
Events.SubscribeRemote("PlayerReady", function(player)
	-- Sends the current state of the game to him
	Events.CallRemote("UpdateMatchState", player, Halloween.match_state, Halloween.remaining_time, Halloween.total_pumpkins, Halloween.pumpkins_found)

	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		Chat.BroadcastMessage("<green>" .. player:GetName() .. "</> has joined the server (" .. Player.GetCount() .. "/" .. HalloweenSettings.custom_settings.players_to_start .. ")!")
		Chat.SendMessage(player, "<grey>Welcome to the Server! Waiting players to start the match! Use Headphones to have a better experience!</>")

		if (Player.GetCount() >= HalloweenSettings.custom_settings.players_to_start) then
			UpdateMatchState(MATCH_STATES.PREPARING)
		end
	else
		Chat.BroadcastMessage("<green>" .. player:GetName() .. "</> has joined the server as Spectator!")
		Chat.SendMessage(player, "<grey>Welcome to the Server! Match in progress! Please wait until the match finishes! Use Headphones to have a better experience!</>")
	end
end)

function StartMatch()
	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		UpdateMatchState(MATCH_STATES.WARM_UP)
	end
end

-- Console commands
Console.RegisterCommand("start", function()
	StartMatch()
end, "starts the match", {})

Chat.Subscribe("PlayerSubmit", function(text, player)
	-- To start the game
	if (text == "/start") then
		StartMatch()
		return false
	end
end)

-- If player disconnects, kills the character
Player.Subscribe("Destroy", function (player)
	local character = player:GetControlledCharacter()
	if (character) then
		character:SetHealth(0)
	end

	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		Chat.BroadcastMessage("<green>" .. player:GetName() .. "</> has left the server (" .. Player.GetCount() .. "/" .. HalloweenSettings.custom_settings.players_to_start .. ")")
	else
		Chat.BroadcastMessage("<green>" .. player:GetName() .. "</> has left the server")
	end
end)

-- Adds damage dealt when damaging
Character.Subscribe("TakeDamage", function(character, damage, bone, type, from, instigator, causer)
	if (character:IsDead()) then return end

	-- If it's suicide, ignore it
	local character_player = character:GetPlayer()
	if (not instigator or instigator == character_player) then
		return
	end

	-- Clamps the damage to Health
	local health = character:GetHealth()
	local true_damage = health < damage and health or damage

	instigator:SetValue("DamageDealt", instigator:GetValue("DamageDealt", 0) + true_damage)
	character_player:SetValue("DamageTaken", character_player:GetValue("DamageTaken", 0) + true_damage)

	-- Does more debuff
	local instigator_character = instigator:GetControlledCharacter()
	if (instigator_character:IsA(KnightCharacter)) then
		instigator_character:DoAttackDebuff(true)
	end
end)

Character.Subscribe("Death", function(character)
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS and Halloween.match_state ~= MATCH_STATES.WARM_UP) then return end

	local player = character:GetPlayer()

	player:SetValue("IsAlive", false, true)
	player:SetValue("KilledTime", Halloween.remaining_time)
end)

function VerifyEndConditions()
	local survivors_count = 0
	local knights_count = 0

	-- Check how many is still alive, and how many is Knight
	for k, player in pairs(Player.GetPairs()) do
		if (player:GetValue("IsAlive")) then
			local player_role = player:GetValue("Role")
			if (player_role == ROLES.KNIGHT) then
				knights_count = knights_count + 1
			elseif (player_role == ROLES.SURVIVOR) then
				survivors_count = survivors_count + 1
			end
		end
	end

	-- If all Knights or Survivors were killed
	if (knights_count == 0 or survivors_count == 0) then
		FinishRound()
	end
end

function FinishRound()
	CalculateEndScores()
	UpdateMatchState(MATCH_STATES.POST_TIME)
end

-- Clears the server, making it new
function ClearServer()
	Halloween.is_trapdoor_opened = false
	Halloween.trapdoor = nil
	Halloween.pumpkins_found = 0
	Halloween.total_pumpkins = 0
	Halloween.players_saved = 0
	Halloween.initial_player_count = 0

	for k, e in pairs(Character.GetAll()) do e:Destroy() end
	for k, e in pairs(Prop.GetAll()) do e:Destroy() end
	for k, e in pairs(StaticMesh.GetAll()) do e:Destroy() end
	for k, e in pairs(Weapon.GetAll()) do e:Destroy() end
	for k, e in pairs(Melee.GetAll()) do e:Destroy() end
	for k, e in pairs(Trigger.GetAll()) do e:Destroy() end
	for k, e in pairs(Light.GetAll()) do e:Destroy() end
end

-- Spawns a character for a given player
function SpawnCharacter(player, player_role)
	local character = nil

	-- Spawns specific Mesh and location for Survivor or Knight
	if (player_role == ROLES.SURVIVOR) then
		local character_spawn_location = HalloweenSettings.config.survivors_spawn_locations[math.random(#HalloweenSettings.config.survivors_spawn_locations)]
		character = SurvivorCharacter(character_spawn_location.location, character_spawn_location.rotation or Rotator())
	else
		local character_spawn_location = HalloweenSettings.config.knights_spawn_locations[math.random(#HalloweenSettings.config.knights_spawn_locations)]
		character = KnightCharacter(character_spawn_location.location, character_spawn_location.rotation or Rotator())
	end

	player:Possess(character)

	return character
end

function SetPlayerRole(player, role)
	player:SetValue("Role", role, true)
	player:SetValue("IsAlive", true, true)

	Events.BroadcastRemote("SetPlayerRole", player, role)

	local character = SpawnCharacter(player, role)

	if (role == ROLES.KNIGHT) then
		-- For now, randomly selects an archetype for the Knight
		SetKnightArchetype(player, character, math.random(#KNIGHT_ARCHETYPES))
	elseif (role == ROLES.SURVIVOR) then
		-- Tells him he is a survivor
		Chat.SendMessage(player, "You are a <blue>Survivor</>!")
	end
end

function SetKnightArchetype(player, character, archetype)
	player:SetValue("KnightArchetype", archetype)

	local archetype_data = KNIGHT_ARCHETYPES[archetype]

	-- Applies Passive Ability
	if (archetype_data.passive_ability and archetype_data.passive_ability.callback_server) then
		archetype_data.passive_ability.callback_server(player)
	end

	-- Spawns Weapon
	local weapon = archetype_data.weapon(Vector(), Rotator())
	character:PickUp(weapon)

	Events.BroadcastRemote("SetKnightArchetype", player, archetype)

	Chat.BroadcastMessage(player:GetName() .. " is a <red>Horseless Headless Horseman (" .. archetype_data.name .. ")</>!")
end

function SpawnEntities()
	-- Spawn Trapdoor
	local random_position = HalloweenSettings.config.trapdoor_spawn_locations[math.random(#HalloweenSettings.config.trapdoor_spawn_locations)]
	Halloween.trapdoor = Trapdoor(random_position.location, random_position.rotation)

	-- Shuffle pumpkins list location
	local pumpkins_list_location = {}
	for k, pumpkin_pos in pairs(HalloweenSettings.config.pumpkins_spawn_locations) do
		table.insert(pumpkins_list_location, math.random(1, #pumpkins_list_location + 1), pumpkin_pos.location)
	end

	-- Spawns more pumpkins than the needed
	local total_pumpkins_to_spawn = math.ceil(Halloween.total_pumpkins + HalloweenSettings.custom_settings.extra_pumpkins)

	-- Maximum pumpkins spawned
	total_pumpkins_to_spawn = math.min(total_pumpkins_to_spawn, #pumpkins_list_location)

	-- Spawns total_pumpkins_to_spawn pumpkins
	for i = 1, total_pumpkins_to_spawn do
		Pumpkin(pumpkins_list_location[i], Rotator(0, math.random(0, 360), 0))
	end

	-- Spawns Goggles
	local total_goggles_to_spawn = math.ceil(Halloween.total_pumpkins / 5)

	for i = 1, total_goggles_to_spawn do
		Goggles(pumpkins_list_location[total_pumpkins_to_spawn + i], Rotator(0, math.random(0, 360), 0))
	end

	-- Spawns Lollipops
	local total_lollipops_to_spawn = math.ceil(Halloween.total_pumpkins / 5)

	for i = 1, total_lollipops_to_spawn do
		Lollipop(pumpkins_list_location[total_pumpkins_to_spawn + total_goggles_to_spawn + i], Rotator(0, math.random(0, 360), 0))
	end
end

function UpdateMatchState(new_state)
	Halloween.match_state = new_state

	if (new_state == MATCH_STATES.PREPARING) then
		-- During preparing, we just wait a few more seconds so more players can connect before starting
		Halloween.remaining_time = HalloweenSettings.custom_settings.preparing_time

		Console.Log("Preparing to start!")
		Chat.BroadcastMessage("<grey>Preparing to start!</>")

	elseif (new_state == MATCH_STATES.WARM_UP) then
		-- During warm-up, set all player's a role and spawns a Character for each
		Halloween.remaining_time = HalloweenSettings.custom_settings.warmup_time

		-- Incredible random function to select random Knights
		local player_count = Player.GetCount()
		local player_list = {}

		local knight_count = math.ceil(player_count / (HalloweenSettings.custom_settings.survivors_per_knight + 1))

		-- Randomly select players
		for k, player in pairs(Player.GetPairs()) do
			table.insert(player_list, math.random(1, #player_list + 1), player)
		end

		for k, player in pairs(player_list) do
			-- Cleanup Player data
			player:SetValue("PickedUpPumpkins", 0)
			player:SetValue("PickedUpLollipops", 0)
			player:SetValue("PickedUpGoggles", 0)
			player:SetValue("DamageDealt", 0)
			player:SetValue("DamageTaken", 0)
			player:SetValue("StunnedKnights", 0)
			player:SetValue("KilledSurvivors", 0)
			player:SetValue("KilledTime", 0)
			player:SetValue("IsAlive", false)
			player:SetValue("Escaped", false)
			player:SetValue("DistanceTraveled", 0)
			player:SetValue("LastLocationTraveled", 0)
			player:SetValue("ChaseTime", 0)
			player:SetValue("AverageChaseTime", 0)

			Halloween.initial_player_count = Halloween.initial_player_count + 1

			if (k <= knight_count) then
				SetPlayerRole(player, ROLES.KNIGHT)
			else
				SetPlayerRole(player, ROLES.SURVIVOR)
			end
		end

		-- Sets how many pumpkins needed to open trapdoor
		Halloween.total_pumpkins = player_count * HalloweenSettings.custom_settings.pumpkins_per_player

		SpawnEntities()

		Console.Log("Warm-up! We have %d Knights and %d Survivors!", knight_count, player_count - knight_count)

	elseif (new_state == MATCH_STATES.IN_PROGRESS) then
		Console.Log("Round started!")
		Chat.BroadcastMessage("<grey>Round Started!</>")

		Halloween.current_knights_global_xray_cooldown = HalloweenSettings.custom_settings.knights_xray_initial_cooldown

		for k, character in pairs(Character.GetPairs()) do
			character:SetInputEnabled(true)
		end

		Halloween.remaining_time = HalloweenSettings.custom_settings.match_time

	elseif (new_state == MATCH_STATES.WAITING_PLAYERS) then
		Console.Log("Waiting for players to start the match... Type 'start' here to force start!")
		Chat.BroadcastMessage("<grey>Waiting for players (" .. Player.GetCount() .. "/" .. HalloweenSettings.custom_settings.players_to_start .. ").</>")

		ClearServer()

	elseif (new_state == MATCH_STATES.POST_TIME) then
		Halloween.remaining_time = HalloweenSettings.custom_settings.post_time
	end

	Events.BroadcastRemote("UpdateMatchState", new_state, Halloween.remaining_time, Halloween.total_pumpkins, 0)
end

-- Server Tick to check remaining times
Timer.SetInterval(function()
	if (Halloween.match_state == MATCH_STATES.PREPARING) then
		if (DecreaseRemainingTime()) then
			UpdateMatchState(MATCH_STATES.WARM_UP)
		end
	elseif (Halloween.match_state == MATCH_STATES.WARM_UP) then
		if (DecreaseRemainingTime()) then
			UpdateMatchState(MATCH_STATES.IN_PROGRESS)
		elseif (Halloween.remaining_time == 15) then
			Events.BroadcastRemote("MatchWillBegin")
		end
	elseif (Halloween.match_state == MATCH_STATES.IN_PROGRESS) then
		if (DecreaseRemainingTime()) then
			FinishRound()
		elseif (Halloween.remaining_time == 13) then
			Events.BroadcastRemote("MatchEnding")
		end

		if (Halloween.current_knights_global_xray_cooldown > 0) then
			Halloween.current_knights_global_xray_cooldown = Halloween.current_knights_global_xray_cooldown - 1
		end

		if (Halloween.current_knights_global_xray_cooldown <= 0) then
			Halloween.current_knights_global_xray_cooldown = HalloweenSettings.custom_settings.knights_xray_cooldown
			Events.BroadcastRemote("TriggerXRay")
		end

		AccumulateStatistics()

		-- Check winning conditions
		-- We check here because if we check on Death, we can't be sure all Death events are called before checking
		VerifyEndConditions()

	elseif (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		if (Player.GetCount() >= HalloweenSettings.custom_settings.players_to_start) then
			UpdateMatchState(MATCH_STATES.PREPARING)
		end
	elseif (Halloween.match_state == MATCH_STATES.POST_TIME) then
		if (DecreaseRemainingTime()) then
			UpdateMatchState(MATCH_STATES.WAITING_PLAYERS)
		end
	end
end, 1000)

function DecreaseRemainingTime()
	Halloween.remaining_time = Halloween.remaining_time - 1
	return (Halloween.remaining_time <= 0)
end

function AccumulateDistanceTraveled(player, character)
	local character_location = character:GetLocation()
	local last_location_traveled = player:GetValue("LastLocationTraveled")
	if (not last_location_traveled) then last_location_traveled = character_location end

	-- meters
	local distance = math.floor((character_location - last_location_traveled):Size() / 100)
	player:SetValue("DistanceTraveled", player:GetValue("DistanceTraveled", 0) + distance)

	player:SetValue("LastLocationTraveled", character_location)
end

function AccumulateStatistics()
	local survivors_alive = {}
	for s, survivor in pairs(SurvivorCharacter.GetPairs()) do
		local player = survivor:GetPlayer()
		if (player and player:GetValue("IsAlive")) then
			AccumulateDistanceTraveled(player, survivor)
			table.insert(survivors_alive, survivor)
		end
	end

	for k, knight in pairs(KnightCharacter.GetPairs()) do
		local player = knight:GetPlayer()
		if (player and player:GetValue("IsAlive")) then
			AccumulateDistanceTraveled(player, knight)

			local is_chasing = false
			local chase_time = player:GetValue("ChaseTime", 0)

			-- iterate all alive survivors and check if they are close
			for s, survivor in pairs(survivors_alive) do
				if (knight:GetLocation():IsNear(survivor:GetLocation(), 2000)) then
					player:SetValue("ChaseTime", chase_time + 1)
					is_chasing = true
					break
				end
			end

			-- Resets chasing
			if (not is_chasing and chase_time > 0) then
				player:SetValue("ChaseTime", 0)
			end
		end
	end
end

Trigger.Subscribe("BeginOverlap", function(trigger, actor_triggering)
	-- If another event destroyed the trigger, this will be nil
	if (not NanosUtils.IsEntityValid(trigger)) then return end

	-- Only triggers for Survivors
	local player = actor_triggering:GetPlayer()
	if (not player or not player:GetValue("IsAlive") or player:GetValue("Role") ~= ROLES.SURVIVOR) then return end

	-- If triggered a Special Item
	local special_item = trigger:GetValue("TriggerSurvivorItem")
	if (not special_item) then return end

	-- It will have a OnTriggerBeginOverlap method
	special_item:OnTriggerBeginOverlap(trigger, player, actor_triggering)
end)

Package.Subscribe("Load", function()
	-- Loads Custom Settings
	HalloweenSettings.custom_settings = Server.GetCustomSettings()

	-- Loads Map Configuration
	HalloweenSettings.config = Server.GetMapConfig() or {}
	HalloweenSettings.config.survivors_spawn_locations = Server.GetMapSpawnPoints()

	if (#HalloweenSettings.config.survivors_spawn_locations == 0) then
		HalloweenSettings.config.survivors_spawn_locations = {
			{ location = Vector(0, 0, 100), rotation = Rotator() }
		}

		Console.Warn("Map config missing 'survivors_spawn_locations'. Using default.")
	end

	if (HalloweenSettings.config.knights_spawn_locations == nil) then
		HalloweenSettings.config.knights_spawn_locations = HalloweenSettings.config.survivors_spawn_locations

		Console.Warn("Map config missing 'knights_spawn_locations'. Using default.")
	end

	if (HalloweenSettings.config.pumpkins_spawn_locations == nil) then
		HalloweenSettings.config.pumpkins_spawn_locations = {
			{ location = Vector(500, 0, 0) },
			{ location = Vector(1000, 0, 0) },
			{ location = Vector(1500, 0, 0) },
			{ location = Vector(2000, 0, 0) },
			{ location = Vector(500, 500, 0) },
			{ location = Vector(1000, 500, 0) },
			{ location = Vector(1500, 500, 0) },
			{ location = Vector(2000, 500, 0) },
			{ location = Vector(500, -500, 0) },
			{ location = Vector(1000, -500, 0) },
			{ location = Vector(1500, -500, 0) },
			{ location = Vector(2000, -500, 0) },
			{ location = Vector(-500, 0, 0) },
			{ location = Vector(-1000, 0, 0) },
			{ location = Vector(-1500, 0, 0) },
			{ location = Vector(-2000, 0, 0) },
			{ location = Vector(-500, 500, 0) },
			{ location = Vector(-1000, 500, 0) },
			{ location = Vector(-1500, 500, 0) },
			{ location = Vector(-2000, 500, 0) },
			{ location = Vector(-500, -500, 0) },
			{ location = Vector(-1000, -500, 0) },
			{ location = Vector(-1500, -500, 0) },
			{ location = Vector(-2000, -500, 0) },
		}

		Console.Warn("Map config missing 'pumpkins_spawn_locations'. Using default.")
	end

	if (HalloweenSettings.config.trapdoor_spawn_locations == nil) then
		HalloweenSettings.config.trapdoor_spawn_locations = {
			{ location = Vector(0, 1000, 0), rotation = Rotator() }
		}

		Console.Warn("Map config missing 'trapdoor_spawn_locations'. Using default.")
	end
end)