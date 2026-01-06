THE_CRUSHER = {
	name = "The Crusher",
	active_ability = {
		name = "Slam",
		callback_client = nil,
		callback_client_global = nil,
		finish_client_global = nil,
		cancel_client = nil,
	},
}

function THE_CRUSHER.active_ability.callback_client_global(character)
	local scream = Sound(character:GetLocation(), "nanos-world::A_Male_01_BattleShout", false, true, SoundType.SFX, 1.5, 0.6, 1000, 15000, AttenuationFunction.Logarithmic)
	scream:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
end

function THE_CRUSHER.active_ability.finish_client_global(character)
	local melee = character:GetPicked()
	local location = melee:GetLocation()
	location = location + melee:GetRotation():GetUpVector() * 150

	Sound(location, "nanos-world::A_BigHammer_Impact", false, true, SoundType.SFX, 1, 0.95, 1000, 10000, AttenuationFunction.NaturalSound)
	Sound(location, "nanos-world::A_BigHammer_Land", false, true, SoundType.SFX, 2, 0.7, 1000, 15000, AttenuationFunction.Logarithmic)

	local p = Particle(location, Rotator(), "nanos-world::P_Explosion_Dirt", true, true)
	p:SetScale(Vector(2, 2, 2))
end

ADD_KNIGHT_ARCHETYPE(THE_CRUSHER)