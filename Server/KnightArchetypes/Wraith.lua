THE_WRAITH = {
	name = "The Wraith",
	weapon = Sickle,
	active_ability = {
		name = "Vanish",
		cooldown = 40,
		duration = 30,
		callback_server = nil,
		cancel_server = nil,
	},
}

function THE_WRAITH.active_ability.callback_server(player)
	local character = player:GetControlledCharacter()

	if (character.is_using_ability) then return false end

	character.is_using_ability = true

	-- Slightly faster
	character:SetSpeedMultiplier(character.speed_multiplier * 1.1)
	character:SetFOVMultiplier(1.1)

	-- Sets specter effect
	local color = Color(0.0075, 0.0075, 0.0075, 0.2)

	character:SetMaterial("nanos-world::M_Default_Translucent_Lit")
	character:SetMaterial("nanos-world::M_Default_Translucent_Lit", -1, "pumpkin")
	character:SetMaterialColorParameter("Tint", color)
	character:SetMaterialColorParameter("Tint", color, -1, "pumpkin")

	local weapon = character:GetPicked()
	if (weapon and weapon:IsValid()) then
		weapon:SetMaterial("nanos-world::M_Default_Translucent_Lit")
		weapon:SetMaterialColorParameter("Tint", color)
	end

	-- Turns off flashlight if on
	local light = character.light
	if (light ~= nil and light:GetValue("Enabled")) then
		ToggleFlashlight(player)
	end

	character:SetValue("IsInvisible", true, true)

	-- Reset after duration
	character.timer_cancel_ability = Timer.SetTimeout(THE_WRAITH.active_ability.cancel_server, THE_WRAITH.active_ability.duration * 1000, player, character)
	Timer.Bind(character.timer_cancel_ability, character)

	-- Cancels if using weapon
	character:Subscribe("PullUse", function(cha, wep)
		THE_WRAITH.active_ability.cancel_server(cha:GetPlayer())
	end)

	return true
end

function THE_WRAITH.active_ability.cancel_server(player)
	if (not NanosUtils.IsEntityValid(player)) then return false end

	local character = player:GetControlledCharacter()

	if (not character.is_using_ability) then return false end

	if (character.timer_cancel_ability and Timer.IsValid(character.timer_cancel_ability)) then
		Timer.ClearTimeout(character.timer_cancel_ability)
	end

	character.timer_cancel_ability = nil

	character.is_using_ability = false

	character:SetValue("IsInvisible", false, true)

	-- Restores Materials
	character:ResetMaterial()
	character:ResetMaterial(-1, "pumpkin")
	character:SetMaterialScalarParameter("Emissive_Intensity", 0, 0, "pumpkin")
	character:SetFOVMultiplier(1)
	character:SetSpeedMultiplier(character.speed_multiplier)

	local wep = character:GetPicked()
	if (wep and character:IsValid()) then
		wep:ResetMaterial()
	end

	character:Unsubscribe("PullUse")

	character:BroadcastRemoteEvent("CancelAbility", THE_WRAITH.id)

	return true
end

ADD_KNIGHT_ARCHETYPE(THE_WRAITH)