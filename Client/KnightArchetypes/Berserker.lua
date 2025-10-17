THE_BERSERKER = {
	name = "The Berserker",
	active_ability = {
		name = "Rage",
		callback_client = nil,
		callback_client_global = nil,
		cancel_client = nil,
	},
}

function THE_BERSERKER.active_ability.callback_client_global(character)
	local scream = Sound(character:GetLocation(), "package://halloween/Client/Sounds/AngryScream.ogg", false, true, SoundType.SFX, 1.4, 0.95, 1000, 15000, AttenuationFunction.Logarithmic)
	scream:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
end

function THE_BERSERKER.active_ability.callback_client(character)
	PostProcess.SetImageEffects(0.7, 0.25)
	PostProcess.SetGlobalContrast(Color(1.5))
	PostProcess.SetGlobalGain(Color(1.7, 1, 1, 1))
	PostProcess.SetChromaticAberration(5)
	PostProcess.SetBloom(1)
end

function THE_BERSERKER.active_ability.cancel_client(character)
	PostProcess.SetImageEffects(0.6, 0)
	PostProcess.SetGlobalContrast(Color(1))
	PostProcess.SetGlobalGain(Color(1))
	PostProcess.SetChromaticAberration(0)
	PostProcess.SetBloom(0.675)
end

ADD_KNIGHT_ARCHETYPE(THE_BERSERKER)