KnightCharacter = Character.Inherit("KnightCharacter")

function KnightCharacter:Constructor(location, rotation)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "gknight::SK_GothicKnight_VD")

	local pumpkin_mesh = HalloweenSettings.knight_pumpkins[math.random(#HalloweenSettings.knight_pumpkins)]

	self.speed_multiplier = HalloweenSettings.custom_settings.knight_speed_multiplier
	self.light_intensity = 0.2

	self:SetAnimationIdleWalkRunStanding("nanos-world::BS_BossyEnemy_Standing")
	self:AddStaticMeshAttached("pumpkin", pumpkin_mesh, "head", Vector(-10, 0, 0), Rotator(20, 90, -90))
	self:SetSpeedMultiplier(self.speed_multiplier)
	self:SetCameraMode(CameraMode.TPSOnly)
	self:SetTeam(2)
	self:SetCanDrop(false)
	self:SetCanAim(false)
	self:SetMaxHealth(1000)
	self:SetJumpZVelocity(500)
	self:SetHealth(1000)
	self:SetScale(Vector(1.25, 1.25, 1.25))
	self:SetCapsuleSize(36, 96)
	self:SetPainSound("nanos-world::A_Male_01_Growl")
	self:SetPhysicalMaterial("nanos-world::PM_Flesh")
	self:HideBone("neck_01")
	self:SetCanCrouch(false)
	self:SetAccelerationSettings(1500)
	self:SetFallDamageTaken(0)
	self:SetPhysicsAsset("nanos-world::PHYS_Mannequin")
	-- self:SetBrakingSettings(2, 2, 1)

	-- Blocks movement until match starts
	self:SetInputEnabled(false)

	-- Knight Light
	self.light = Light(Vector(), Rotator(), Color(0.97, 0.66, 0.57), LightType.Spot, self.light_intensity, 8000, 50, 0.1, 15000, false, true, true, 100)
	self.light:SetValue("Enabled", true)
	self.light:AttachTo(self, AttachmentRule.SnapToTarget, "head", 0)
	self.light:SetRelativeLocation(Vector(20, 35, 0))
	self.light:SetRelativeRotation(Rotator(0, 85, 0))
end

-- Slows down the Knight when attacking
function KnightCharacter:OnAttack(melee)
	self:DoAttackDebuff(false)
end

-- function KnightCharacter:OnPullUse(melee)

-- end

function KnightCharacter:DoAttackDebuff(hit_success)
	-- Does not slow if using berserker ability
	if (self.is_using_berserker_ability) then return end

	local multiplier = hit_success and 0.3 or 0.4
	self:SetSpeedMultiplier(self.speed_multiplier * multiplier)

	-- Prevents from using Melee
	self:SetCanUsePickables(false)

	-- TODO native method for this?
	-- Clear existing timeout
	if (self.attack_debuff_timer and Timer.IsValid(self.attack_debuff_timer)) then
		Timer.ClearTimeout(self.attack_debuff_timer)
	end

	-- Resets after 2 or seconds depending it hit
	local cooldown = hit_success and 2500 or 1750
	self.attack_debuff_timer = Timer.SetTimeout(KnightCharacter.CancelAttackDebuff, cooldown, self)

	Timer.Bind(self.attack_debuff_timer, self)
end

function KnightCharacter:CancelAttackDebuff()
	if (self.attack_debuff_timer and Timer.IsValid(self.attack_debuff_timer)) then
		Timer.ClearTimeout(self.attack_debuff_timer)
	end

	self.attack_debuff_timer = nil

	self:SetCanUsePickables(true)

	-- Prevents resetting the speed if using ability
	if (self.is_using_ability) then return end

	self:SetSpeedMultiplier(self.speed_multiplier)
end

-- TODO should prevent hitting? or prevent input?
function KnightCharacter:Stun()
	self.stunned = true
	self:PlayAnimation("nanos-world::A_Boss_Parried_InP", AnimationSlotType.UpperBody, false, 0.2, 0.2, 0.5)
	-- Mannequin_Taunt_EarCom

	if (self.is_using_ability) then
		self:CancelAbility()
	end

	self:BroadcastRemoteEvent("Stun")

	-- Resets or Starts timer
	if (self.stun_timer and Timer.IsValid(self.stun_timer)) then
		Timer.ResetElapsedTime(self.stun_timer)
	else
		-- Resets after 4 seconds
		self.stun_timer = Timer.SetTimeout(KnightCharacter.CancelStun, 4000, self)

		Timer.Bind(self.stun_timer, self)
	end
end

function KnightCharacter:CancelStun()
	self.stunned = false

	if (self.stun_timer and Timer.IsValid(self.stun_timer)) then
		Timer.ClearTimeout(self.stun_timer)
	end

	self.stun_timer = nil

	self:CallRemoteEvent("CancelStun", self:GetPlayer())
end

-- Special Knight Ability (X)
function KnightCharacter:TriggerAbility(player)
	-- Only if is Knight, match is in progress, is alive and the caller is the possesser
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS or not player:GetValue("IsAlive") or self:GetPlayer() ~= player) then
		return
	end

	if (self.stunned) then
		Chat.SendMessage(player, "<red>Can't use Ability while stunned!</>")
		return
	end

	if (self.attack_debuff_timer) then
		Chat.SendMessage(player, "<red>Can't use Ability yet!</>")
		return
	end

	local archetype = player:GetValue("KnightArchetype")
	local archetype_data = KNIGHT_ARCHETYPES[archetype]

	-- Cooldown check
	local curr_time = os.time()
	if (self.ability_last_used and os.difftime(curr_time, self.ability_last_used) < archetype_data.active_ability.cooldown) then
		Chat.SendMessage(player, "<red>The Ability is on cooldown!</>")
		return
	end

	self.ability_last_used = curr_time

	-- Triggers Active Ability
	local success = archetype_data.active_ability.callback_server(player)
	if (success) then
		self:BroadcastRemoteEvent("TriggerAbility", archetype, archetype_data.active_ability.cooldown, archetype_data.active_ability.duration)
	end
end

function KnightCharacter:CancelAbility()
	local player = self:GetPlayer()
	local archetype = player:GetValue("KnightArchetype")
	local archetype_data = KNIGHT_ARCHETYPES[archetype]

	if (archetype_data.active_ability.cancel_server) then
		archetype_data.active_ability.cancel_server(player)
	end
end

KnightCharacter.SubscribeRemote("TriggerAbility", KnightCharacter.TriggerAbility)
KnightCharacter.Subscribe("Attack", KnightCharacter.OnAttack)
-- KnightCharacter.Subscribe("PullUse", KnightCharacter.OnPullUse)