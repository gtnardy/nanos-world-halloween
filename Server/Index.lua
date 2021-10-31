Package.RequirePackage("nanos-world-weapons")

-- Static Settings
HalloweenSettings = {
	warmup_time = 40,
	match_time = 600,
	post_time = 25,
	preparing_time = 10,
	players_to_start = 4,
	players_per_knight = 6,
	pumpkins_per_player = 2,
	pumpkins_extra_percent = 0.2,
	knights_special_cooldown = 30,
	knights_spawn_locations = {
		Vector(-59018.000, 2641.000, -608.891),
		Vector(-59018.000, 2130.000, -608.891),
		Vector(-58808.000, 2641.000, -608.891),
		Vector(-58808.000, 2130.000, -608.891),
		Vector(-58614.000, 2641.000, -608.891),
		Vector(-58614.000, 2130.000, -608.891),
	},
	survivors_spawn_locations = {
		Vector(-65076.000, 4184.000, -106.923),
		Vector(-65076.000, 2295.000, -106.923),
		Vector(-65076.000, 239.000, -106.923),
		Vector(-67469.000, 14820.000, 399.217),
		Vector(-67469.000, 16752.000, 399.217),
		Vector(-67469.000, 12835.000, 399.217),
		Vector(-52230.000, 12190.000, 202.163),
		Vector(-53790.000, 12479.000, 193.795),
		Vector(-44975.000, 12411.000, -298.149),
		Vector(-45069.000, 12956.000, -298.149),
		Vector(-45163.000, 13672.000, -298.149),
		Vector(-32219.000, 10587.000, 197.131),
		Vector(-31788.000, 11671.000, 197.131),
		Vector(-31309.000, 12776.000, 197.131),
		Vector(-30774.000, 13907.000, 197.131),
		Vector(-25101.000, 6002.000, 176.502),
		Vector(-24110.000, 6577.000, 176.502),
		Vector(-22842.000, -18222.000, -52.235),
		Vector(-24534.000, -18334.000, -151.480),
		Vector(-33860.000, -15033.000, -145.480),
		Vector(-37388.000, -11335.000, 168.078),
		Vector(-36571.000, -6030.000, -396.766),
		Vector(-30177.000, -1527.000, -281.594),
		Vector(-26788.000, 2497.000, 49.047),
		Vector(-34133.000, 917.000, -436.952),
		Vector(-56030.000, -15969.000, -30.660),
		Vector(-54339.000, -15367.000, -181.141),
		Vector(-57500.000, -11528.000, -32.134),
		Vector(-66100.000, -5985.000, 643.852),
		Vector(-41677.000, 12607.000, 217.587),
	},
	pumpkins_spawn_locations = {
		Vector(-69534.977, 18157.869, 302.167),
		Vector(-66169.969, 20971.881, 101.818),
		Vector(-74359.000, -1804.000, -195.000),
		Vector(-71172.000, -4386.000, 459.000),
		Vector(-64835.000, -2636.000, -195.000),
		Vector(-66612.000, -6631.000, 484.000),
		Vector(-64106.000, -7511.000, -161.000),
		Vector(-57076.000, 65.000, -447.000),
		Vector(-57261.000, 3904.000, -197.000),
		Vector(-59476.000, 2381.000, -697.000),
		Vector(-51293.000, 4793.000, -692.000),
		Vector(-56690.000, 5719.000, -291.000),
		Vector(-53194.000, 9977.000, -53.000),
		Vector(-51838.000, 12882.000, 120.000),
		Vector(-48082.000, 15621.000, 147.000),
		Vector(-45695.000, 11185.000, -188.000),
		Vector(-43723.000, 11101.000, -327.000),
		Vector(-38237.000, 13652.000, 106.000),
		Vector(-33562.000, 17995.000, 96.000),
		Vector(-30586.000, 14242.000, 108.000),
		Vector(-28351.000, 16438.000, 100.000),
		Vector(-29668.000, 10973.000, 106.000),
		Vector(-34417.000, 11299.000, 106.000),
		Vector(-34023.000, 6979.000, -167.000),
		Vector(-34672.000, 3753.000, -380.000),
		Vector(-32273.000, 4543.000, -26.000),
		Vector(-24214.000, 8084.000, 84.000),
		Vector(-21663.000, 7408.000, 42.000),
		Vector(-23187.000, 3934.000, -180.000),
		Vector(-26924.000, 1572.000, -229.000),
		Vector(-27567.000, -3089.000, -427.000),
		Vector(-22867.000, -4330.000, -261.000),
		Vector(-27008.000, -7038.000, -176.000),
		Vector(-29329.000, -5703.000, -170.000),
		Vector(-38152.000, -7865.000, -359.000),
		Vector(-36689.000, -11017.000, 127.000),
		Vector(-35279.000, -16405.002, -484.000),
		Vector(-28686.000, -15584.002, -96.000),
		Vector(-24500.000, -16405.002, -157.000),
		Vector(-23199.000, -13136.002, -119.000),
		Vector(-22454.000, -8258.000, -267.000),
		Vector(-53466.000, -14433.002, -269.000),
		Vector(-57920.000, -13526.002, -326.000),
		Vector(-63375.000, -8193.000, 561.000),
		Vector(-43062.000, 729.000, -758.000),
		Vector(-38678.000, -118.000, -767.000),
		Vector(-34933.000, 0.000, -685.000),
		Vector(-29897.000, -6.000, -316.000),
		Vector(-23935.000, -1139.000, -212.000),
		Vector(-21453.000, -86.000, -263.000),
		Vector(-25645.000, -13272.002, -3.000),
		Vector(-34597.000, -9295.000, -225.000),
		Vector(-37027.000, -13251.002, -224.000),
		Vector(-46719.000, -10434.000, -461.000),
		Vector(-50529.000, -8399.000, -371.000),
		Vector(-55480.000, -5015.000, -350.000),
		Vector(-59093.000, -4202.000, -144.000),
		Vector(-63110.000, 4441.000, -195.000),
		Vector(-71863.000, 10649.000, 41.000),
		Vector(-67216.000, 11591.000, 302.000),
		Vector(-72732.000, 16174.000, 334.000),
		Vector(-61319.000, 16192.000, 570.000),
		Vector(-62683.000, 8782.000, 60.000),
		Vector(-56246.000, 9082.000, 64.000),
		Vector(-46633.000, 8762.000, -419.000),
		Vector(-40505.000, 10508.000, -541.000),
		Vector(-42372.000, 15412.000, 59.000),
		Vector(-45501.000, 15906.000, 120.000),
		Vector(-28339.000, 14157.000, 106.000),
		Vector(-28518.000, 9132.000, 109.000),
		Vector(-26244.000, 7443.000, 62.000),
		Vector(-31608.000, -14608.002, -323.000),
		Vector(-36576.000, -14971.002, -355.000),
		Vector(-48486.000, -7778.000, -549.000),
		Vector(-55803.000, -10478.000, -23.000),
		Vector(-62391.000, -11354.000, 195.000),
		Vector(-71404.000, 1204.000, -195.000),
		Vector(-68976.000, 6383.000, -195.000),
		Vector(-54687.000, 17682.000, 96.000),
		Vector(-58429.000, 14579.000, 89.000),
		Vector(-58716.000, -7760.000, 108.000),
		Vector(-30915.000, -10212.000, -318.000),
		Vector(-25191.000, 12958.000, 102.000),
		Vector(-75640.000, 8676.000, -179.000),
		Vector(-76203.000, -2087.000, 6.000),
		Vector(-73178.000, -5523.000, 448.000),
		Vector(-67999.000, -3371.000, 47.000),
		Vector(-60342.000, -2016.000, -169.000),
		Vector(-57704.000, -3761.000, -190.000),
	},
	trapdoor_spawn_locations = {
		-- {location = Vector(-2000, 0, 0), rotation = Rotator()},

		{location = Vector(-50914.000, -7387.000, -426.000), rotation = Rotator(0.000000, -177.187576, 0.000335)},
		{location = Vector(-55107.312, -9310.598, 97.600), rotation = Rotator(0.000000, -177.187576, 5.625330)},
		{location = Vector(-54739.035, 10634.541, 46.016), rotation = Rotator(0.000000, -177.187576, 2.812838)},
		{location = Vector(-60712.680, 15805.539, 630.994), rotation = Rotator(0.000000, -177.187576, 0.000335)},
		{location = Vector(-67127.062, -3931.250, 45.109), rotation = Rotator(-0.000184, -5.625187, 8.437948)},
		{location = Vector(-31884.627, -13810.760, -384.777), rotation = Rotator(0.000219, 42.187237, -0.000275)},
		{location = Vector(-26605.039, -11517.965, -215.004), rotation = Rotator(0.000219, 42.187695, 5.624833)},
		{location = Vector(-21641.490, 693.138, -305.000), rotation = Rotator(0.000219, 42.187237, -0.000275)},
		{location = Vector(-25310.000, 9208.000, 76.000), rotation = Rotator(0.000219, 42.187237, -0.000275)},
		{location = Vector(-36462.578, 14166.349, 94.000), rotation = Rotator(0.000219, 42.187237, -0.000275)},
		{location = Vector(-50526.504, 15863.049, 104.012), rotation = Rotator(-2.812371, -174.374985, 0.000458)},
		{location = Vector(-70286.000, 3187.000, -204.999), rotation = Rotator(0.000382, 89.999626, -0.000031)},
		{location = Vector(-35198.676, 3057.297, -450.989), rotation = Rotator(2.812720, 42.187332, -0.000275)},
		{location = Vector(-31006.457, -2500.981, -400.003), rotation = Rotator(0.000348, 70.312119, 2.812374)},
		{location = Vector(-31201.230, -6163.334, -355.986), rotation = Rotator(-2.812221, 42.188011, 5.624834)},
		{location = Vector(-53427.000, -1390.000, -707.000), rotation = Rotator(0.000219, 42.187237, -0.000275)},
		{location = Vector(-61077.000, -7504.000, 441.000), rotation = Rotator(-5.624763, 42.187393, -0.000275)},
	},
	weapon_knight = function()
		local random_weapon = {
			NanosWorldWeapons.Moss500,
			NanosWorldWeapons.Ithaca37,
			NanosWorldWeapons.Rem870,
			NanosWorldWeapons.SPAS12,
		}

		local weapon = random_weapon[math.random(#random_weapon)](Vector(), Rotator())

		weapon:SetDamage(10)
		weapon:SetCadence(1.5)
		weapon:SetRecoil(5)
		weapon:SetSpread(70)

		return weapon
	end,
	weapon_survivor = function()
		local random_weapon = {
			NanosWorldWeapons.Glock,
			NanosWorldWeapons.Makarov,
			NanosWorldWeapons.M1911,
		}

		local weapon = random_weapon[math.random(#random_weapon)](Vector(), Rotator())

		weapon:SetDamage(20)
		weapon:SetCadence(0.35)
		weapon:SetRecoil(1)
		weapon:SetSpread(50)

		return weapon
	end,
	pumpkin_spawn = function(location, rotation)
		local pumpkin = Prop(location, rotation, "halloween-city-park::SM_Pumpkin_Lit", CollisionType.NoCollision, false, true, true)

		pumpkin:Subscribe("Interact", function(prop, character)
			local player = character:GetPlayer()
			if (not player:GetValue("IsAlive") or player:GetValue("Role") ~= ROLES.SURVIVOR) then return end

			-- Picked up the Pumpkin, destroys it
			local pumpkin_location = prop:GetLocation()
			prop:Destroy()

			Halloween.pumpkins_found = Halloween.pumpkins_found + 1

			player:SetValue("PickedUpPumpkins", player:GetValue("PickedUpPumpkins", 0) + 1, true)

			Server.BroadcastChatMessage("The Survivor '" .. player:GetName() .. "' found a <green>Pumpkin</>! " .. (Halloween.total_pumpkins - Halloween.pumpkins_found) .. " remaining!")
			Events.BroadcastRemote("PumpkinFound", pumpkin_location)

			-- If already found enough Pumpkins, opens the Door
			if (Halloween.pumpkins_found >= Halloween.total_pumpkins) then
				local trapdoor_location = Halloween.trapdoor:GetLocation()
				local trapdoor_rotation = Halloween.trapdoor:GetRotation()

				Halloween.trapdoor:Destroy()
				Halloween.trapdoor = StaticMesh(trapdoor_location, trapdoor_rotation, "halloween-city-park::SM_Trapdoor_Opened", CollisionType.NoCollision)
				Light(trapdoor_location + Vector(0, 0, 100), Rotator(), Color(0.73, 0.67, 0.42), 0, 10, 1000)
				Halloween.is_trapdoor_opened = true

				Server.BroadcastChatMessage("A <green>Trapdoor</> has been opened! Survivors must find it to escape!")
				Events.BroadcastRemote("TrapdoorOpened", Halloween.trapdoor)
			end
			return false
		end)
	end,
	entities_spawn = function()
		-- Spawn Trapdoor
		local random_position = HalloweenSettings.trapdoor_spawn_locations[math.random(#HalloweenSettings.trapdoor_spawn_locations)]

		Halloween.trapdoor = StaticMesh(random_position.location, random_position.rotation, "halloween-city-park::SM_Trapdoor_Closed", CollisionType.NoCollision)

		-- Spawns a Trigger for this Trapdoor
		local trigger = Trigger(random_position.location, Rotator(), Vector(300))
		trigger:SetValue("Trapdoor", true)

		-- Spawns Pumpkins
		local pumpkins_list = {}
		for k, pumpkin_pos in pairs(HalloweenSettings.pumpkins_spawn_locations) do
			table.insert(pumpkins_list, math.random(1, #pumpkins_list + 1), pumpkin_pos)
		end

		-- Spawns 20% more pumpkins thant he needed
		local total_pumpkins_to_spawn = math.ceil(Halloween.total_pumpkins * HalloweenSettings.pumpkins_extra_percent)

		-- Minimum pumpkins spawned
		total_pumpkins_to_spawn = math.min(math.max(total_pumpkins_to_spawn, 5), #HalloweenSettings.pumpkins_spawn_locations)

		-- Spawns total_pumpkins_to_spawn pumpkins
		for i = 1, total_pumpkins_to_spawn do
			HalloweenSettings.pumpkin_spawn(pumpkins_list[i], Rotator())
		end
	end,
}

-- Current Game Settings
Halloween = {
	remaining_time = 0,
	match_state = MATCH_STATES.WAITING_PLAYERS,
	current_knights_special_cooldown = HalloweenSettings.knights_special_cooldown,
	is_trapdoor_opened = false,
	trapdoor = nil,
	pumpkins_found = 0,
	total_pumpkins = 0,
	players_saved = 0,
	initial_player_count = 0
}


Trigger.Subscribe("BeginOverlap", function(trigger, actor_triggering)
	if (actor_triggering:GetType() ~= "Character") then return end

	-- Only triggers for Survivors
	local player = actor_triggering:GetPlayer()
	if (not player:GetValue("IsAlive") or player:GetValue("Role") ~= ROLES.SURVIVOR) then return end

	-- If triggered Trapdoor
	if (trigger:GetValue("Trapdoor")) then
		if (not Halloween.is_trapdoor_opened) then return end

		-- Player escaped!
		actor_triggering:Destroy()

		player:SetValue("IsAlive", false)
		player:GetValue("Weapon"):Destroy()

		Halloween.players_saved = Halloween.players_saved + 1

		VerifyWinners()

		Server.BroadcastChatMessage("The Survivor '" .. player:GetName() .. "' has <green>escaped</> alive!")
		Events.BroadcastRemote("SurvivorEscaped")

		return
	end
end)

-- When player fully connects (custom event)
Events.Subscribe("PlayerReady", function(player)
	-- Sends the current state of the game to him
	Events.CallRemote("UpdateMatchState", player, Halloween.match_state, Halloween.remaining_time, Halloween.total_pumpkins)

	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		Server.BroadcastChatMessage("<green>" .. player:GetName() .. "</> has joined the server (" .. Player.GetCount() .. "/" .. HalloweenSettings.players_to_start .. ")!")
		Server.SendChatMessage(player, "<grey>Welcome to the Server! Waiting players to start the match! Use Headphones to have a better experience!</>")

		if (Player.GetCount() >= HalloweenSettings.players_to_start) then
			UpdateMatchState(MATCH_STATES.PREPARING)
		end
	else
		Server.BroadcastChatMessage("<green>" .. player:GetName() .. "</> has joined the server as Spectator!")
		Server.SendChatMessage(player, "<grey>Welcome to the Server! Please wait until the match finishes! Use Headphones to have a better experience!</>")
	end
end)

function StartMatch()
	if (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then
		UpdateMatchState(MATCH_STATES.WARM_UP)
	end
end

-- Console commands
Server.Subscribe("Console", function(text)
	-- To start the game
	if (text == "start") then
		StartMatch()
	end
end)

Server.Subscribe("Chat", function(text, player)
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

	Server.BroadcastChatMessage("<green>" .. player:GetName() .. "</> has left the server")
end)

Character.Subscribe("WeaponAimModeChanged", function(character, old_state, new_state)
	local player = character:GetPlayer()
	local player_role = player:GetValue("Role")

	if (player_role == ROLES.SURVIVOR) then
		local weapon = player:GetValue("Weapon")
		local light = character:GetValue("Light")
		if (new_state == AimMode.None) then
			light:AttachTo(character, AttachmentRule.SnapToTarget, "head")
			light:SetRelativeLocation(Vector(0, 15, 0))
			light:SetRelativeRotation(Rotator(0, 87, 0))
		elseif (old_state == AimMode.None) then
			light:AttachTo(weapon, AttachmentRule.SnapToTarget, "muzzle")
			light:SetRelativeLocation(Vector(-50, -10, 5))
		end
	end
end)

-- Adds damage dealt when damaging
Character.Subscribe("TakeDamage", function(character, damage, bone, type, from, instigator, causer)
	-- If it's suicide, ignore it
	if (not instigator or instigator == character:GetPlayer()) then
		return
	end

	-- Clamps the damage to Health
	local health = character:GetHealth()
	local true_damage = health < damage and health or damage

	instigator:SetValue("DamageDealt", instigator:GetValue("DamageDealt", 0) + true_damage, true)
end)

Character.Subscribe("SwimmingModeChanged", function(character, old_state, new_state)
	local timer_damage = character:GetValue("TimerDamage")

	if (timer_damage) then
		Timer.ClearInterval(timer_damage)
		character:SetValue("TimerDamage", nil)
	end

	if (new_state == SwimmingMode.Underwater) then
		timer_damage = Timer.SetInterval(function(c)
			c:ApplyDamage(5)
		end, 3000, character)

		Timer.Bind(
			timer_damage,
			character
		)

		character:SetValue("TimerDamage", timer_damage)
	end
end)

Character.Subscribe("Death", function(character)
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS and Halloween.match_state ~= MATCH_STATES.WARM_UP) then return end

	local player = character:GetValue("Player")

	player:SetValue("IsAlive", false)
	player:GetValue("Weapon"):Destroy()

	local light = character:GetValue("Light")

	if (light and light:IsValid()) then
		light:Destroy()
		character:SetValue("Light", nil)
	end

	Server.BroadcastChatMessage("The Survivor '" .. player:GetName() .. "' has been <red>killed</>!")
	Server.SendChatMessage(player, "You are <red>dead</>! You can spectate other players by switching <bold>Left</> or <bold>Right</> keys!")

	-- Unpossess the Character after 2 seconds
	Timer.Bind(
		Timer.SetTimeout(function(p)
			p:UnPossess()
		end, 2000, player),
		player
	)

	Events.BroadcastRemote("CharacterDeath", character, player:GetValue("Role"))

	-- Check winning conditions
	VerifyWinners()
end)

function VerifyWinners()
	local alive_players_count = 0
	local knights_count = 0

	-- Check how many is still alive, and how many is Knight
	for k, player in pairs(Player.GetPairs()) do
		if (player:GetValue("IsAlive")) then
			alive_players_count = alive_players_count + 1

			if (player:GetValue("Role") == ROLES.KNIGHT) then
				knights_count = knights_count + 1
			end
		end
	end

	-- If all Knights were killed
	if (knights_count == 0) then
		FinishRound(ROLES.SURVIVOR)
	-- If there is only Knights remaining
	elseif (alive_players_count == knights_count) then
		-- If everyone escaped
		if (Halloween.players_saved == Halloween.initial_player_count) then
			FinishRound(ROLES.SURVIVOR)
		-- If someone survived
		elseif (Halloween.players_saved > 0) then
			-- TODO change to custom end (if half were saved but half died, nor survivor or knight win)
			FinishRound(ROLES.SURVIVOR)
		-- Knights killed everyone
		else
			FinishRound(ROLES.KNIGHT)
		end
	end
end

function FinishRound(role_winner)
	-- TODO: first to escape

	local player_mvp = nil
	local value_mvp = 0

	local player_most_damage = nil
	local value_most_damage = 0

	local player_most_pumpkins = nil
	local value_most_pumpkins = 0

	for k, player in pairs(Player.GetPairs()) do
		local damage = player:GetValue("DamageDealt", 0)
		local pumpkins = player:GetValue("PickedUpPumpkins", 0)
		local score_mvp = damage + pumpkins * 100

		if (pumpkins > value_most_pumpkins or (not player_most_pumpkins and player:GetValue("Role") == ROLES.SURVIVOR)) then
			player_most_pumpkins = player
			value_most_pumpkins = pumpkins
		end

		if (damage > value_most_damage or not player_most_damage) then
			player_most_damage = player
			value_most_damage = damage
		end

		if (score_mvp > value_mvp or not player_mvp) then
			player_mvp = player
			value_mvp = damage
		end
	end

	if (role_winner == ROLES.SURVIVOR) then
		Package.Log("[Halloween] Round finished! Survivors win!")
		Server.BroadcastChatMessage("Round finished! <blue>Survivors</> Win!")
		Events.BroadcastRemote("SurvivorWins", player_mvp:GetName(), player_most_damage:GetName() .. " - " .. value_most_damage, player_most_pumpkins:GetName() .. " - " .. value_most_pumpkins)
	else
		Package.Log("[Halloween] Round finished! Knights win!")
		Server.BroadcastChatMessage("Round finished! <red>Horseless Headless Horseman</> Win!")
		Events.BroadcastRemote("KnightWins", player_mvp:GetName(), player_most_damage:GetName() .. " - " .. value_most_damage, player_most_pumpkins:GetName() .. " - " .. value_most_pumpkins)
	end

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
	for k, e in pairs(Trigger.GetAll()) do e:Destroy() end
	for k, e in pairs(Light.GetAll()) do e:Destroy() end
end

-- Spawns a character for a given player
function SpawnCharacter(player)
	local player_role = player:GetValue("Role")

	local player_character_model = nil
	local character_spawn_location = nil

	-- Spawns specific Mesh and location for Survivor or Knight
	if (player_role == ROLES.SURVIVOR) then
		player_character_model = "nanos-world::SK_PostApocalyptic"
		character_spawn_location = HalloweenSettings.survivors_spawn_locations[math.random(#HalloweenSettings.survivors_spawn_locations)]
	else
		player_character_model = "halloween-city-park::SK_GothicKnight"
		character_spawn_location = HalloweenSettings.knights_spawn_locations[math.random(#HalloweenSettings.knights_spawn_locations)]
	end

	local character = Character(character_spawn_location, Rotator(), player_character_model)
	local weapon = nil

	-- Specific settings for Survivor or Knight
	if (player_role == ROLES.SURVIVOR) then
		character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_MinerHat_Lit", "head", Vector(5, 5, 0), Rotator(-90, 0, 0))
		character:SetSpeedMultiplier(1.15)
		character:SetCameraMode(1)
		character:SetTeam(1)
		character:SetCanDrop(false)

		-- Survivor light
		local my_light = Light(Vector(), Rotator(), Color(0.97, 0.76, 0.46), LightType.Spot, 0.15, 6000, 25, 0.95, 15000, false, true, true)
		my_light:SetValue("Enabled", true)
		my_light:SetTextureLightProfile(LightProfile.Shattered_02)
		my_light:AttachTo(character, AttachmentRule.SnapToTarget, "head")
		my_light:SetRelativeLocation(Vector(0, 15, 0))
		my_light:SetRelativeRotation(Rotator(0, 87, 0))
		character:SetValue("Light", my_light)

		weapon = HalloweenSettings.weapon_survivor()

	-- Knight
	else
		character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_Pumpkin_Lit", "head", Vector(-10, 5, 0), Rotator(-90, 0, 0))
		character:SetSpeedMultiplier(1.25)
		character:SetCameraMode(2)
		character:SetTeam(2)
		character:SetCanDrop(false)
		character:SetMaxHealth(1000)
		character:SetHealth(1000)
		character:SetScale(Vector(1.5, 1.5, 1.5))
		character:SetPainSound("nanos-world::A_Male_01_Growl")

		-- Knight light
		local my_light = Light(Vector(), Rotator(), Color(0.97, 0.66, 0.57), LightType.Spot, 2, 7500, 60, 0, 15000, false, true, true)
		my_light:SetValue("Enabled", true)
		my_light:AttachTo(character, AttachmentRule.SnapToTarget, "head")
		my_light:SetRelativeLocation(Vector(15, 35, 0))
		my_light:SetRelativeRotation(Rotator(0, 85, 0))
		character:SetValue("Light", my_light)

		weapon = HalloweenSettings.weapon_knight()
	end

	player:Possess(character)

	player:SetValue("Character", character)
	player:SetValue("Weapon", weapon)
	player:SetValue("IsAlive", true)

	character:PickUp(weapon)

	-- Blocks movement until match starts
	character:SetMovementEnabled(false)

	character:SetValue("Player", player)
end

function SetPlayerRole(player, role)
	player:SetValue("Role", role)

	if (role == ROLES.KNIGHT) then
		Server.BroadcastChatMessage(player:GetName() .. " is a <red>Horseless Headless Horseman</>!")
	elseif (role == ROLES.SURVIVOR) then
		Server.SendChatMessage(player, "You are a <blue>Survivor</>!")
	end

	Events.BroadcastRemote("SetPlayerRole", player, role)
end

function UpdateMatchState(new_state)
	Halloween.match_state = new_state

	if (new_state == MATCH_STATES.WARM_UP) then
		-- During warm-up, set all player's a role and spawns a Character for each
		Halloween.remaining_time = HalloweenSettings.warmup_time

		-- Incredible random function to select random Knights
		local player_count = Player.GetCount()
		local player_list = {}

		local knight_count = math.ceil(player_count / HalloweenSettings.players_per_knight)

		math.randomseed(os.time())

		for k, player in pairs(Player.GetPairs()) do
			local pos = math.random(1, #player_list + 1)
			table.insert(player_list, pos, player)
		end

		for k, player in pairs(player_list) do
			-- Cleanup Player  data
			player:SetValue("PickedUpPumpkins", 0, true)
			player:SetValue("DamageDealt", 0, true)

			Halloween.initial_player_count = Halloween.initial_player_count + 1

			if (k <= knight_count) then
				SetPlayerRole(player, ROLES.KNIGHT)
			else
				SetPlayerRole(player, ROLES.SURVIVOR)
			end

			SpawnCharacter(player)
		end

		Halloween.total_pumpkins = #player_list * HalloweenSettings.pumpkins_per_player

		HalloweenSettings.entities_spawn()

		Package.Log("[Halloween] Warm-up! We have " .. tostring(knight_count) .. " Knights and " .. tostring(player_count - knight_count) .. " Survivors!")

	elseif (new_state == MATCH_STATES.IN_PROGRESS) then
		Package.Log("[Halloween] Round started!")
		Server.BroadcastChatMessage("<grey>Round Started!</>")

		Halloween.current_knights_special_cooldown = 15
		Events.BroadcastRemote("SetSpecialCooldown", Halloween.current_knights_special_cooldown)

		for k, character in pairs(Character.GetPairs()) do
			character:SetMovementEnabled(true)
		end

		Halloween.remaining_time = HalloweenSettings.match_time

	elseif (new_state == MATCH_STATES.WAITING_PLAYERS) then
		Package.Log("[Halloween] Waiting for players to start the match... Type 'start' here to force start!")
		Server.BroadcastChatMessage("<grey>Waiting for players (" .. Player.GetCount() .. "/" .. HalloweenSettings.players_to_start .. ").</>")

		ClearServer()

	elseif (new_state == MATCH_STATES.POST_TIME) then
		Halloween.remaining_time = HalloweenSettings.post_time
	end

	Events.BroadcastRemote("UpdateMatchState", new_state, Halloween.remaining_time, Halloween.total_pumpkins)
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
			FinishRound(ROLES.KNIGHT)
		elseif (Halloween.remaining_time == 13) then
			Events.BroadcastRemote("MatchEnding")
		end

		if (Halloween.current_knights_special_cooldown > 0) then
			Halloween.current_knights_special_cooldown = Halloween.current_knights_special_cooldown - 1
		end
	elseif (Halloween.match_state == MATCH_STATES.WAITING_PLAYERS) then

	elseif (Halloween.match_state == MATCH_STATES.POST_TIME) then
		if (DecreaseRemainingTime()) then
			if (Player.GetCount() >= HalloweenSettings.players_to_start) then
				UpdateMatchState(MATCH_STATES.PREPARING)
			else
				UpdateMatchState(MATCH_STATES.WAITING_PLAYERS)
			end
		end
	end
end, 1000)

function DecreaseRemainingTime()
	Halloween.remaining_time = Halloween.remaining_time - 1
	return (Halloween.remaining_time <= 0)
end

Events.Subscribe("ToggleFlashlight", function(player)
	local character = player:GetControlledCharacter()
	if (character == nil) then return end

	local light = character:GetValue("Light")
	if (light == nil) then return end

	if (light:GetValue("Enabled")) then
		light:SetColor(Color(0, 0, 0))
		light:SetValue("Enabled", false)

		Events.BroadcastRemote("FlashlightToggled", player, character:GetLocation(), false)

		character:RemoveStaticMeshAttached("pumpkin")

		-- Toggle head's mesh dark
		if (player:GetValue("Role") == ROLES.KNIGHT) then
			character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_Pumpkin", "head", Vector(-10, 5, 0), Rotator(-90, 0, 0))
		else
			character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_MinerHat", "head", Vector(5, 5, 0), Rotator(-90, 0, 0))
		end
	else
		light:SetColor(Color(0.73, 0.67, 0.42))
		light:SetValue("Enabled", true)

		Events.BroadcastRemote("FlashlightToggled", player, character:GetLocation(), true)

		character:RemoveStaticMeshAttached("pumpkin")

		-- Toggle head's mesh bright
		if (player:GetValue("Role") == ROLES.KNIGHT) then
			character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_Pumpkin_Lit", "head", Vector(-10, 5, 0), Rotator(-90, 0, 0))
		else
			character:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_MinerHat_Lit", "head", Vector(5, 5, 0), Rotator(-90, 0, 0))
		end
	end
end)

-- Knights Special Power (Q)
Events.Subscribe("TriggerSpecial", function(player)
	if (player:GetValue("Role") == ROLES.KNIGHT and Halloween.match_state == MATCH_STATES.IN_PROGRESS and player:GetValue("IsAlive")) then
		if (Halloween.current_knights_special_cooldown > 0) then
			Server.SendChatMessage(player, "<red>The Special is on cooldown!</>")
			return
		end

		Halloween.current_knights_special_cooldown = HalloweenSettings.knights_special_cooldown

		Events.BroadcastRemote("SetSpecialCooldown", Halloween.current_knights_special_cooldown)
		Events.BroadcastRemote("TriggerSpecial", player:GetControlledCharacter():GetLocation())

		for k, character in pairs(Character.GetPairs()) do
			local controller = character:GetPlayer()
			if (controller and controller:GetValue("Role") == ROLES.KNIGHT) then
				character:SetSpeedMultiplier(1.5)
				character:SetFOVMultiplier(1.2)
			end
		end

		-- Resets all Knights speed after 5 seconds
		Timer.SetTimeout(function()
			for k, character in pairs(Character.GetPairs()) do
				local controller = character:GetPlayer()
				if (controller and controller:GetValue("Role") == ROLES.KNIGHT) then
					character:SetSpeedMultiplier(1.15)
					character:SetFOVMultiplier(1)
				end
			end
		end, 5000)
	end
end)

Package.Subscribe("Load", function()
	-- Spawns a Moon
	local moon = StaticMesh(Vector(0, 0, 25000), Rotator(), "nanos-world::SM_Sphere")
	moon:SetScale(Vector(10, 10, 10))
	moon:SetMaterialColorParameter("Emissive", Color(100, 35, 15))
end)

Package.Subscribe("Unload", function()
	ClearServer()
end)
