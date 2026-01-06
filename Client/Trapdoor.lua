Trapdoor = StaticMesh.Inherit("Trapdoor")

function Trapdoor:OnOpen(new_remaining_time)
	Halloween.is_trapdoor_opened = true
	Sound(self:GetLocation(), "halloween-city-park::A_Hatch_Cue", false, false, SoundType.SFX, 1.5, 1, 1000, 60000, AttenuationFunction.Logarithmic, true, SoundLoopMode.Forever)

	HUD:CallEvent("SetLabel", "THE HATCH HAS OPENED")

	if (Halloween.current_role == ROLES.SURVIVOR) then
		HUD:CallEvent("SetObjective", "ESCAPE THROUGH THE HATCH")
	end

	-- Updates remaining time
	HUD:CallEvent("SetClock", new_remaining_time - 1)
end

function Trapdoor:OnSurvivorEscaped()
	HUD:CallEvent("EscapeSurvivor")

	local sound_to_play = HalloweenSettings.survivor_escape_sounds[math.random(#HalloweenSettings.survivor_escape_sounds)]
	Sound(self:GetLocation(), sound_to_play, false, true, SoundType.SFX, 2, 1, 1000, 30000, AttenuationFunction.Logarithmic)
end

Trapdoor.SubscribeRemote("Open", Trapdoor.OnOpen)
Trapdoor.SubscribeRemote("SurvivorEscaped", Trapdoor.OnSurvivorEscaped)