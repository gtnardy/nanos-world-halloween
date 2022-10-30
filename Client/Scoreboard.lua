Input.Register("Scoreboard", "Tab")

-- Toggles the Scoreboard
Input.Bind("Scoreboard", InputEvent.Released, function()
	HUD:CallEvent("ToggleScoreboard", false)
end)

Input.Bind("Scoreboard", InputEvent.Pressed, function()
	HUD:CallEvent("ToggleScoreboard", true)
end)

-- Updates someone scoreboard data
function UpdatePlayerScoreboard(player)
	HUD:CallEvent("UpdatePlayer", player:GetID(), true, player:GetName(), player:GetPing())
end

--  Adds someone to the scoreboard
Player.Subscribe("Spawn", function(player)
	UpdatePlayerScoreboard(player)
end)

Player.Subscribe("Destroy", function(player)
	HUD:CallEvent("UpdatePlayer", player:GetID(), false)
end)

-- Updates the ping every 5 seconds
Timer.SetInterval(function()
	for k, player in pairs(Player.GetPairs()) do
		UpdatePlayerScoreboard(player)
	end
end, 5000)

Package.Subscribe("Load", function()
	for k, player in pairs(Player.GetPairs()) do
		UpdatePlayerScoreboard(player)
	end
end)