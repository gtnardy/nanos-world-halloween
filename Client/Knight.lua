KnightCharacter = Character.Inherit("KnightCharacter")


function KnightCharacter:OnStun()
	if (Halloween.local_character == self) then
		self.stunned = true

		-- Play stunned sound
		local s = Sound(Vector(), "package://halloween/Client/Sounds/Tinnitus.ogg", true, true, SoundType.SFX, 0.3, 0.5)
		s:FadeOut(4)

		-- Disables Highlight, as it keeps appearing while screen is faded out
		for k, c in pairs(SurvivorCharacter.GetPairs()) do
			c:SetHighlight(false)
		end

		-- Sets effects on screen, to feel stunned
		PostProcess.SetImageEffects(2)
		PostProcess.SetChromaticAberration(20)
		PostProcess.SetBloom(20)
		PostProcess.SetExposure(-4)
	else
		-- Play pain
		local s = Sound(self:GetLocation(), "nanos-world::A_Male_01_Growl", false, true, SoundType.SFX, 2, 0.8, 400, 3600, AttenuationFunction.NaturalSound)
		s:AttachTo(self, AttachmentRule.SnapToTarget, "head", 0)
	end
end

function KnightCharacter:OnCancelStun()
	self.stunned = false
	PostProcess.SetImageEffects()
	PostProcess.SetChromaticAberration()
	PostProcess.SetBloom()
	PostProcess.SetExposure()
end

function KnightCharacter:OnTriggerAbility(archetype, cooldown, duration)
	local archetype_data = KNIGHT_ARCHETYPES[archetype]

	if (archetype_data.active_ability.callback_client_global) then
		archetype_data.active_ability.callback_client_global(self)
	end

	if (Halloween.local_character == self) then
		HUD:CallEvent("SetSpecialCooldown", cooldown)

		if (duration) then
			HUD:CallEvent("SetSpecialActive", duration)
		end

		if (archetype_data.active_ability.callback_client) then
			archetype_data.active_ability.callback_client(self)
		end
	end
end

function KnightCharacter:OnCancelAbility(archetype)
	if (Halloween.local_character == self) then

		local archetype_data = KNIGHT_ARCHETYPES[archetype]
		archetype_data.active_ability.cancel_client(self)

		HUD:CallEvent("SetSpecialActive", 0)
	end
end

function KnightCharacter:OnFinishAbility(archetype)
	local archetype_data = KNIGHT_ARCHETYPES[archetype]

	if (archetype_data.active_ability.finish_client_global) then
		archetype_data.active_ability.finish_client_global(self)
	end

	if (Halloween.local_character == self) then
		if (archetype_data.active_ability.finish_client) then
			archetype_data.active_ability.finish_client(self)
		end
	end
end

-- Knights die when quit
function KnightCharacter:OnDeath()
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS and Halloween.match_state ~= MATCH_STATES.WARM_UP) then return end

	-- Updates UI
	HUD:CallEvent("KillKnight")

	-- Global Scream
	Sound(self:GetLocation(), "halloween-city-park::A_Monster_Shout", false, true, SoundType.SFX, 1, 1, 5000, 50000, AttenuationFunction.Logarithmic, true)

	-- Sets his corpse as Highlight for 5 seconds
	self:SetHighlightEnabled(true, 0)
	Timer.Bind(
		Timer.SetTimeout(function(_char)
			_char:SetHighlightEnabled(false, 0)
		end, 5000, self),
		self
	)
end

KnightCharacter.SubscribeRemote("CancelAbility", KnightCharacter.OnCancelAbility)
KnightCharacter.SubscribeRemote("FinishAbility", KnightCharacter.OnFinishAbility)
KnightCharacter.SubscribeRemote("TriggerAbility", KnightCharacter.OnTriggerAbility)
KnightCharacter.SubscribeRemote("Stun", KnightCharacter.OnStun)
KnightCharacter.SubscribeRemote("CancelStun", KnightCharacter.OnCancelStun)
KnightCharacter.Subscribe("Death", KnightCharacter.OnDeath)

-- Radar triggers at each 4 seconds
Timer.SetInterval(function()
	if (not Halloween.local_character or Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end
	if (Halloween.current_role ~= ROLES.KNIGHT) then return end
	if (Halloween.local_character.stunned) then return end

	local local_character_location = Halloween.local_character:GetLocation()

	-- TODO: if more than 2 pumpkins/characters are close, it triggers the first even if it's distant
	for k, c in pairs(SurvivorCharacter.GetPairs()) do
		local distance = local_character_location:DistanceSquared(c:GetLocation())
		if (distance < 5000 * 5000 and not c:IsDead()) then
			HUD:CallEvent("TriggerRadar")

			local pitch = 1
			if distance < 2000 * 2000 then pitch = 1.5 end

			Sound(Vector(), "halloween-city-park::A_Sonar_Ping", true, true, SoundType.SFX, 0.4, pitch)
			break
		end
	end
end, 4000)