Input.Register("HalloweenMap", "M", "Toggles Map")

Input.Bind("HalloweenMap", InputEvent.Pressed, function()
	Halloween.is_map_opened = not Halloween.is_map_opened
	HUD:CallEvent("MapToggled", Halloween.is_map_opened)
	Sound(Vector(), "halloween-city-park::A_Paper", true, true, SoundType.UI, 0.7)

	if (Halloween.is_map_opened and Halloween.is_help_opened) then
		Halloween.is_help_opened = false
		HUD:CallEvent("HelpToggled", false)
	end
end)