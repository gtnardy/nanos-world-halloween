function ToggleFlashlight(player)
	local character = player:GetControlledCharacter()
	if (character == nil) then return end

	-- Prevent enabling light if invisible
	if (character:GetValue("IsInvisible")) then return end

	local light = character.light
	if (light == nil) then return end

	if (light:GetValue("Enabled")) then
		light:SetIntensity(0)
		light:SetValue("Enabled", false)

		Events.BroadcastRemote("FlashlightToggled", player, character:GetLocation(), false)

		-- Toggle head's mesh dark
		character:SetMaterialScalarParameter("Emissive_Intensity", 0, 0, "pumpkin")
	else
		light:SetIntensity(character.light_intensity)
		light:SetValue("Enabled", true)

		Events.BroadcastRemote("FlashlightToggled", player, character:GetLocation(), true)

		-- Toggle head's mesh bright
		character:SetMaterialScalarParameter("Emissive_Intensity", 0.1, 0, "pumpkin")
	end
end

Events.SubscribeRemote("ToggleFlashlight", ToggleFlashlight)