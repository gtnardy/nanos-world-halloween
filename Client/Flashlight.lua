-- Configures Keybindings Inputs
Input.Register("HalloweenFlashlight", "F")

Input.Bind("HalloweenFlashlight", InputEvent.Pressed, function()
	Events.CallRemote("ToggleFlashlight")
end)

Events.SubscribeRemote("FlashlightToggled", function(player, location, enabled)
	Halloween.flashlight_enabled = enabled

	Sound(location, "halloween-city-park::A_Flashlight")

	if (player == Client.GetLocalPlayer()) then
		HUD:CallEvent("FlashlightToggled", enabled)
	end
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
