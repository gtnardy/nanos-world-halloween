THE_BERSERKER = {
	name = "The Berserker",
	weapon = GreatAxe,
	active_ability = {
		name = "Rage",
		cooldown = 25,
		duration = 5,
		callback_server = nil,
		cancel_server = nil,
	},
}

-- TODO should we slow it after effect ends?
function THE_BERSERKER.active_ability.callback_server(player)
	local character = player:GetControlledCharacter()

	if (character.is_using_ability) then return false end

	character.is_using_ability = true
	character.is_using_berserker_ability = true

	local weapon = character:GetPicked()
	if (weapon and weapon:IsValid()) then
		weapon:SetCooldown(weapon.cooldown / 2)
	end

	-- Slightly faster
	character:SetFOVMultiplier(1.2)
	character:SetSpeedMultiplier(character.speed_multiplier * 1.3)

	-- Change light/pumpkin color to RED
	character.light:SetColor(Color(0.8, 0, 0))
	character:SetMaterialColorParameter("Emissive", Color.RED * 2, 0, "pumpkin")

	-- Turns on flashlight if off
	local light = character.light
	if (light ~= nil and not light:GetValue("Enabled")) then
		ToggleFlashlight(player)
	end

	-- Reset after duration
	character.timer_cancel_ability = Timer.SetTimeout(THE_BERSERKER.active_ability.cancel_server, THE_BERSERKER.active_ability.duration * 1000, player, character)
	Timer.Bind(character.timer_cancel_ability, character)

	return true
end

function THE_BERSERKER.active_ability.cancel_server(player)
	local character = player:GetControlledCharacter()

	if (not character.is_using_ability) then return false end

	if (character.timer_cancel_ability and Timer.IsValid(character.timer_cancel_ability)) then
		Timer.ClearTimeout(character.timer_cancel_ability)
	end

	character.timer_cancel_ability = nil

	character.is_using_berserker_ability = false
	character.is_using_ability = false

	local weapon = character:GetPicked()
	if (weapon and weapon:IsValid()) then
		weapon:SetCooldown(weapon.cooldown / 2)
	end

	character:SetFOVMultiplier(1)
	character:SetSpeedMultiplier(character.speed_multiplier)

	character.light:SetColor(Color(0.97, 0.66, 0.57))
	character:SetMaterialColorParameter("Emissive", Color(1, 0.32, 0), 0, "pumpkin")

	character:BroadcastRemoteEvent("CancelAbility", THE_BERSERKER.id)

	return true
end

ADD_KNIGHT_ARCHETYPE(THE_BERSERKER)