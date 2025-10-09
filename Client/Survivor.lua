SurvivorCharacter = Character.Inherit("SurvivorCharacter")

function SurvivorCharacter:SetHighlight(highlight)
	self:SetHighlightEnabled(highlight, 0)

	if (highlight) then
		-- If already running a timer, just resets it
		if (self.highlight_timer and Timer.IsValid(self.highlight_timer)) then
			Timer.ResetElapsedTime(self.highlight_timer)
		else
			-- Backs to normal after 10 seconds
			self.highlight_timer = Timer.SetTimeout(function(_char)
				_char:SetHighlight(false)
				_char.highlight_timer = nil
			end, 10000, self)

			Timer.Bind(self.highlight_timer, self)
		end
	else
		if (self.highlight_timer and Timer.IsValid(self.highlight_timer)) then
			Timer.ClearTimeout(self.highlight_timer)
		end

		self.highlight_timer = nil
	end

	if (Halloween.local_character == self) then
		HUD:CallEvent("SpottedToggled", highlight)
	end
end

function SurvivorCharacter:OnEquipLollipop(equipped)
	-- Updates UI
	HUD:CallEvent("SetLollipop", equipped)
end

function SurvivorCharacter:OnEquipGoggles()
	-- Night Vision Effects
	Sky.SetNightBrightness(0.4)

	PostProcess.SetChromaticAberration(0.25)
	PostProcess.SetGlobalSaturation(Color(0.75))
	PostProcess.SetExposure(0)
	PostProcess.SetImageEffects(0.6, 0.75)
	PostProcess.SetGlobalGain(Color(0.95, 1.05, 0.95, 1))

	-- Updates UI
	HUD:CallEvent("SetNightVision", true)
end

function SurvivorCharacter:OnDeath()
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS and Halloween.match_state ~= MATCH_STATES.WARM_UP) then return end

	-- Updates UI
	HUD:CallEvent("KillSurvivor")

	-- Global Scream
	-- TODO it seems we can hear both Pain and this
	Sound(self:GetLocation(), "city-park::A_Scream", false, true, SoundType.SFX, 1, 1, 1000, 50000, AttenuationFunction.Logarithmic, true)

	-- Sets his corpse as Highlight
	self:SetHighlight(true)
end

function SurvivorCharacter:OnTriggerAbility(cooldown)
	local scream = Sound(self:GetLocation(), "city-park::A_Scream", false, true, SoundType.SFX, 1, 1.2, 400, 10000, AttenuationFunction.NaturalSound)
	scream:AttachTo(self, AttachmentRule.SnapToTarget, "head", 0)

	-- Make me highlight for all knights and me
	if (Halloween.current_role == ROLES.KNIGHT or Halloween.local_character == self) then
		self:SetHighlight(true)
	end

	if (Halloween.local_character == self) then
		HUD:CallEvent("SetSpecialCooldown", cooldown)
	end
end

SurvivorCharacter.SubscribeRemote("TriggerAbility", SurvivorCharacter.OnTriggerAbility)
SurvivorCharacter.SubscribeRemote("EquipGoggles", SurvivorCharacter.OnEquipGoggles)
SurvivorCharacter.SubscribeRemote("EquipLollipop", SurvivorCharacter.OnEquipLollipop)
SurvivorCharacter.Subscribe("Death", SurvivorCharacter.OnDeath)

-- Radar triggers at each 2 seconds
local survivor_interval_radar_flipflop = false
Timer.SetInterval(function()
	if (not Halloween.local_character or Halloween.match_state ~= MATCH_STATES.IN_PROGRESS) then return end
	if (Halloween.current_role ~= ROLES.SURVIVOR) then return end

	local local_character_location = Halloween.local_character:GetLocation()

	-- Only triggers radar at each 4 seconds
	survivor_interval_radar_flipflop = not survivor_interval_radar_flipflop

	-- TODO: if more than 2 pumpkins/characters are close, it triggers the first it finds even if it's distant
	if (not Halloween.is_trapdoor_opened and survivor_interval_radar_flipflop) then
		for k, p in pairs(Pumpkin.GetPairs()) do
			local distance = local_character_location:DistanceSquared(p:GetLocation())
			if (distance < 5000 * 5000) then
				HUD:CallEvent("TriggerRadar")

				local pitch = 1
				if distance < 2000 * 2000 then pitch = 1.5 end

				Sound(Vector(), "city-park::A_Sonar_Ping", true, true, SoundType.SFX, 0.4, pitch)
				break
			end
		end
	end

	-- Heartbeat Sound if Knight is nearby
	local has_knight_nearby = false
	for k, c in pairs(KnightCharacter.GetPairs()) do
		local distance = local_character_location:DistanceSquared(c:GetLocation())
		if (distance < 2000 * 2000 and c:GetHealth() > 0) then
			has_knight_nearby = true
			break
		end
	end

	if (has_knight_nearby) then
		if (not Halloween.heartbeat_sound:IsPlaying()) then
			Halloween.heartbeat_sound:FadeIn(2)
		end
	else
		if (Halloween.heartbeat_sound:IsPlaying()) then
			Halloween.heartbeat_sound:FadeOut(4)
		end
	end
end, 2000)