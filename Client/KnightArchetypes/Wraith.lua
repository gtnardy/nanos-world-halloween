THE_WRAITH = {
	name = "The Wraith",
	active_ability = {
		name = "Vanish",
		callback_client = nil,
		cancel_client = nil,
	},
}

function THE_WRAITH.active_ability.callback_client(character)
	Sound(character:GetLocation(), "package://halloween/Client/Sounds/Woosh.ogg", true, true, SoundType.SFX, 2, 1.3)

	PostProcess.SetImageEffects(0.7, 0.25)
	PostProcess.SetChromaticAberration(5)
	PostProcess.SetBloom(10)

	local light = Light(character:GetLocation(), Rotator(), Color(1, 0.75, 0.68), LightType.Point, 0.01, 20000, 44, 0, 20000, false, false, true, 4)
	light:AttachTo(character, AttachmentRule.KeepRelative, "head", 0)
	character.vanish_light = light
end

function THE_WRAITH.active_ability.cancel_client(character)
	Sound(character:GetLocation(), "package://halloween/Client/Sounds/Woosh.ogg", true, true, SoundType.SFX, 1.25, 0.7)

	PostProcess.SetImageEffects(0.6, 0)
	PostProcess.SetChromaticAberration(0)
	PostProcess.SetBloom(0.675)

	character.vanish_light:Destroy()
end

table.insert(KNIGHT_ARCHETYPES, THE_WRAITH)