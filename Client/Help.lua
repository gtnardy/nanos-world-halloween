Input.Register("HalloweenHelp", "H", "Toggles Help")

function SetHelpEnabled(enabled)
	if (Halloween.is_help_opened == enabled) then return end

	Halloween.is_help_opened = enabled

	HUD:CallEvent("HelpToggled", Halloween.is_help_opened)
	Sound(Vector(), "city-park::A_Paper", true, true, SoundType.UI, 0.7)

	if (Halloween.is_help_opened and Halloween.is_map_opened) then
		Halloween.is_map_opened = false
		HUD:CallEvent("MapToggled", false)
	end
end

Input.Bind("HalloweenHelp", InputEvent.Pressed, function()
	SetHelpEnabled(not Halloween.is_help_opened)
end)