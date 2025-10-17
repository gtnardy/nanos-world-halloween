
function CalculateEndScores()
	local survivors = {}
	local knights = {}

	local knight_initial_count = math.ceil(Halloween.initial_player_count / (HalloweenSettings.custom_settings.survivors_per_knight + 1))
	local survivor_initial_count = Halloween.initial_player_count - knight_initial_count
	local survivors_per_knight_actual = math.min(survivor_initial_count, HalloweenSettings.custom_settings.survivors_per_knight)

	local total_survivors = 0
	local total_knights = 0
	local survivors_escaped = 0
	local survivors_killed = 0

	for k, player in pairs(Player.GetPairs()) do
		local player_role = player:GetValue("Role")
		local player_data = {}

		player_data.name = player:GetName()
		player_data.distance_traveled = player:GetValue("DistanceTraveled", 0)

		if (player_role == ROLES.SURVIVOR) then
			total_survivors = total_survivors + 1

			-- Data
			local is_alive = player:GetValue("IsAlive", false)
			local escaped = player:GetValue("Escaped", false)
			local killed_time = player:GetValue("KilledTime", 0) -- WE WILL NOT NEED IT?
			local stunned_knights = player:GetValue("StunnedKnights", 0)
			local damage_taken = player:GetValue("DamageTaken", 0)

			-- Pick Ups
			player_data.pumpkins = player:GetValue("PickedUpPumpkins", 0)
			player_data.lollipops = player:GetValue("PickedUpLollipops", 0)
			player_data.goggles = player:GetValue("PickedUpGoggles", 0)

			-- Status
			if (escaped) then
				survivors_escaped = survivors_escaped + 1
				player_data.status = "escaped"
			elseif (is_alive) then
				player_data.status = "alive"
			else
				survivors_killed = survivors_killed + 1
				player_data.status = "dead"
			end

			-- Score
			player_data.score =
				player_data.pumpkins * 100 +
				player_data.lollipops * 200 +
				player_data.goggles * 200 +
				stunned_knights * 300

			-- Objective Medal
			if (player_data.pumpkins >= HalloweenSettings.custom_settings.pumpkins_per_player * 2) then
				player_data.objective_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (player_data.pumpkins >= HalloweenSettings.custom_settings.pumpkins_per_player) then
				player_data.objective_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (player_data.pumpkins >= 1) then
				player_data.objective_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.objective_medal = "none"
			end

			-- Evader Medal
			if (stunned_knights >= 3 and damage_taken == 0) then
				player_data.evader_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (stunned_knights >= 2 and damage_taken <= 50) then
				player_data.evader_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (stunned_knights >= 1) then
				player_data.evader_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.evader_medal = "none"
			end

			-- Survival Medal
			if (escaped and damage_taken == 0) then
				player_data.survival_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (escaped) then
				player_data.survival_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (is_alive) then
				player_data.survival_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.survival_medal = "none"
			end

			table.insert(survivors, player_data)

		-- Knights that aren't alive, means they quit
		elseif (player_role == ROLES.KNIGHT and player:GetValue("IsAlive", false)) then
			total_knights = total_knights + 1

			-- Data
			player_data.damage_dealt = player:GetValue("DamageDealt", 0)
			player_data.kills = player:GetValue("KilledSurvivors", 0)

			-- Score
			player_data.score =
				player_data.kills * 500 +
				((player_data.damage_dealt * 100) / 20)

			-- Devout Medal
			if (player_data.kills >= survivors_per_knight_actual or (player_data.kills >= 0 and player_data.kills == total_survivors)) then
				player_data.devout_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (player_data.kills >= survivors_per_knight_actual / 2) then
				player_data.devout_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (player_data.kills >= 1) then
				player_data.devout_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.devout_medal = "none"
			end

			-- Brutality Medal
			if (player_data.damage_dealt >= survivors_per_knight_actual * 100) then
				player_data.brutality_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (player_data.damage_dealt >= survivors_per_knight_actual * 50) then
				player_data.brutality_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (player_data.damage_dealt > 0) then
				player_data.brutality_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.brutality_medal = "none"
			end

			-- Chaser Medal
			local average_chase_time = player:GetValue("AverageChaseTime", 0)

			if (average_chase_time <= 45 and (player_data.kills >= 2 or (player_data.kills >= 0 and player_data.kills == total_survivors))) then
				player_data.chaser_medal = "gold"
				player_data.score = player_data.score + 1000
			elseif (average_chase_time <= 90 and player_data.kills >= 2) then
				player_data.chaser_medal = "silver"
				player_data.score = player_data.score + 500
			elseif (average_chase_time <= 135 and player_data.kills >= 1) then
				player_data.chaser_medal = "bronze"
				player_data.score = player_data.score + 200
			else
				player_data.chaser_medal = "none"
			end

			table.insert(knights, player_data)
		end
	end

	local result_label = ""

	if (total_knights == 0) then
		result_label = "THE KNIGHTS PERISHED"
	elseif (total_survivors == 0) then
		result_label = "THE SURVIVORS PERISHED"
	elseif (survivors_escaped == total_survivors) then
		result_label = "ALL SURVIVORS ESCAPED"
	elseif (survivors_killed == total_survivors) then
		result_label = "ALL SURVIVORS DIED"
	elseif (survivors_escaped >= total_survivors / 2) then
		result_label = "MOST SURVIVORS ESCAPED"
	elseif (survivors_killed >= total_survivors / 2) then
		result_label = "MOST SURVIVORS DIED"
	else
		result_label = "KILLERS AND SURVIVORS TIED"
	end

	Chat.BroadcastMessage("Round finished! <green>" .. result_label .. "</>!")
	Console.Log("Round finished! " .. result_label)

	Events.BroadcastRemote("UpdatePostTimeResults", result_label, survivors, knights)
end