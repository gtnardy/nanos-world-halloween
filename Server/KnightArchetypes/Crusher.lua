THE_CRUSHER = {
	name = "The Crusher",
	weapon = GreatHammer,
	active_ability = {
		name = "Slam",
		cooldown = 30,
		slam_damage = 40,
		slam_radius = 750,
		callback_server = nil,
		finish_server = nil,
		cancel_server = nil,
	},
}

function THE_CRUSHER.active_ability.callback_server(player)
	local character = player:GetControlledCharacter()

	local control_rotation = character:GetControlRotation()
	character:SetRotation(Rotator(0, control_rotation.Yaw, 0))

	local play_rate = 1.5
	character:PlayAnimation("nanos-world::A_Boss_Attack_Running_WithAOEBlow_RM", AnimationSlotType.FullBody, false, 0.25, 0.25, play_rate)

	local timer_crush = Timer.SetTimeout(THE_CRUSHER.active_ability.finish_server, 2000 / play_rate, player, character)
	Timer.Bind(timer_crush, character)

	-- Also applies debuff
	character:SetInputEnabled(false)

	return true
end

function THE_CRUSHER.active_ability.finish_server(player, character)
	-- Do the crush
	local killer_location = character:GetLocation()

	for k, survivor in pairs(SurvivorCharacter.GetPairs()) do
		if (not survivor:IsDead() and killer_location:IsNear(survivor:GetLocation(), THE_CRUSHER.active_ability.slam_radius)) then
			-- Do Damage
			survivor:ApplyDamage(THE_CRUSHER.active_ability.slam_damage, "", DamageType.Melee, killer_location, player, character)

			-- TODO Stun?
		end
	end

	character:DoAttackDebuff(true)
	character:SetInputEnabled(true)
	character:BroadcastRemoteEvent("FinishAbility", THE_CRUSHER.id)
end

ADD_KNIGHT_ARCHETYPE(THE_CRUSHER)