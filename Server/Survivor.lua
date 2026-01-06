SurvivorCharacter = Character.Inherit("SurvivorCharacter")

SurvivorMeshes = {
	{
		main = "nanos-world::SK_Adventure_01_Body",
		head_offset = Vector(-2, 0, 0),
		meshes = {
			-- "nanos-world::SK_Adventure_01_Hair_02", -- It got bad with Hat
			-- "nanos-world::SK_Adventure_01_Hair_03",
			"nanos-world::SK_Adventure_01_Neck_Cloth", -- may or may not have
			"nanos-world::SK_Adventure_01_Pants",
			"nanos-world::SK_Adventure_01_Shoes",
		},
		materials = {
			"nanos-world::MI_Adventure_01_01",
			"nanos-world::MI_Adventure_01_02",
			"nanos-world::MI_Adventure_01_03",
		}
	},
	{
		main = "nanos-world::SK_Adventure_02_Cloth_02",
		head_offset = Vector(-2, -1, 0),
		meshes = {
			"nanos-world::SK_Adventure_02_Hands",
			"nanos-world::SK_Adventure_02_Head",
			"nanos-world::SK_Adventure_02_Pants",
			"nanos-world::SK_Adventure_02_Shoes",
			"nanos-world::SK_Adventure_02_Jacket",
		},
		materials = {
			"nanos-world::MI_Adventure_02_01",
			"nanos-world::MI_Adventure_02_02",
			"nanos-world::MI_Adventure_02_03",
		}
	},
	{
		main = "nanos-world::SK_Adventure_02_Cloth_01",
		head_offset = Vector(-2, -1, 0),
		meshes = {
			"nanos-world::SK_Adventure_02_Hands",
			"nanos-world::SK_Adventure_02_Head",
			"nanos-world::SK_Adventure_02_Pants",
			"nanos-world::SK_Adventure_02_Shoes",
		},
		materials = {
			"nanos-world::MI_Adventure_02_01",
			"nanos-world::MI_Adventure_02_02",
			"nanos-world::MI_Adventure_02_03",
		}
	},
	{
		main = "nanos-world::SK_Adventure_03_Head",
		head_offset = Vector(8, -3, 0),
		goggles_offset = Vector(1, -3, 0),
		-- todo glass is bad
		meshes = {
			"nanos-world::SK_Adventure_03_Hat",
			"nanos-world::SK_Adventure_03_Hair_Hat",
			"nanos-world::SK_Adventure_03_Pants",
			"nanos-world::SK_Adventure_03_Shoes",
			"nanos-world::SK_Adventure_03_Body_Cloth_02",
			"nanos-world::SK_Adventure_03_Arms",
		},
		materials = {
			"nanos-world::MI_Adventure_03_01",
			"nanos-world::MI_Adventure_03_02",
			"nanos-world::MI_Adventure_03_03",
		}
	},
	{
		main = "nanos-world::SK_Adventure_04_Body_Cloth_01",
		head_offset = Vector(-2, -1, 0),
		-- todo beard
		meshes = {
			"nanos-world::SK_Adventure_04_Hands",
			"nanos-world::SK_Adventure_04_Head",
			"nanos-world::SK_Adventure_04_Pants",
			"nanos-world::SK_Adventure_04_Shoes",
			"nanos-world::SK_Adventure_04_Hair" -- optional
		},
		materials = {
			"nanos-world::MI_Adventure_04_01",
			"nanos-world::MI_Adventure_04_02",
			"nanos-world::MI_Adventure_04_03",
		}
	},
	{
		main = "nanos-world::SK_Adventure_05_Body_Cloth",
		head_offset = Vector(1, 1, 0),
		-- todo others
		meshes = {
			"nanos-world::SK_Adventure_05_Arms",
			"nanos-world::SK_Adventure_05_Head",
			"nanos-world::SK_Adventure_05_Mustache",
			"nanos-world::SK_Adventure_05_Shoes",
		},
		materials = {
			"nanos-world::MI_Adventure_05_01",
			"nanos-world::MI_Adventure_05_02",
			"nanos-world::MI_Adventure_05_03",
			"nanos-world::MI_Adventure_05_NoTattoo_01",
			"nanos-world::MI_Adventure_05_NoTattoo_02",
			"nanos-world::MI_Adventure_05_NoTattoo_03",
		}
	},
	-- {
	-- 	main = "nanos-world::SK_PostApocalyptic",
	-- 	head_offset = Vector(-1, 0, 0),
	-- 	meshes = {}
	-- }
}

function SurvivorCharacter:Constructor(location, rotation)
	local mesh_data = SurvivorMeshes[math.random(#SurvivorMeshes)]
	self.goggles_offset = mesh_data.goggles_offset or Vector(0)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), mesh_data.main)

	-- TODO test combinations
	if (mesh_data.meshes) then
		for k, m in pairs(mesh_data.meshes) do
			self:AddSkeletalMeshAttached(tostring(k), m)
		end
	end

	if (mesh_data.materials) then
		local selected_material = mesh_data.materials[math.random(#mesh_data.materials)]
		self:SetMaterial(selected_material, 0)
	end

	self.light_intensity = 0.02
	self.speed_multiplier = HalloweenSettings.custom_settings.survivor_speed_multiplier

	self:SetSpeedMultiplier(self.speed_multiplier)
	self:SetCameraMode(CameraMode.FPSOnly)
	self:SetTeam(1)
	self:SetCanDrop(false)
	self:SetCanAim(false)
	self:SetCanPunch(false)
	-- Note: weapons are dropped when Knight dies, but no one can pickup so it's fine
	self:SetCanPickupPickables(false)
	self:SetJumpZVelocity(500)
	self:SetCapsuleSize(36, 96)
	self:SetCanCrouch(false)
	self:SetPainSound(HalloweenSettings.survivor_pain_sounds[math.random(#HalloweenSettings.survivor_pain_sounds)])

	-- Survivor Pack requires it as it's modular character and have Close_Mouth open by default
	self:SetPhysicsAsset("nanos-world::PHYS_Mannequin")
 	self:SetMorphTarget("Close_Mouth", 1)

	-- Hat
	self:AddStaticMeshAttached("pumpkin", "halloween-city-park::SM_MinerHat_02", "head", Vector(12, 1, 0) + (mesh_data.head_offset or Vector(0)), Rotator(-90, 0, 0))

	-- Blocks movement until match starts
	self:SetInputEnabled(false)

	-- Survivor light
	self.light = Light(Vector(), Rotator(), Color(0.97, 0.76, 0.46), LightType.Spot, self.light_intensity, 6000, 30, 0.75, 15000, false, true, true, 100)
	self.light:SetValue("Enabled", true)
	self.light:SetTextureLightProfile(LightProfile.Star_Burst_07)
	self.light:AttachTo(self, AttachmentRule.SnapToTarget, "head", 0)
	self.light:SetRelativeLocation(Vector(20, 10, 0))
	self.light:SetRelativeRotation(Rotator(0, 85, 0))
end

function SurvivorCharacter:EquipGoggles()
	self.has_goggles = true
	self:AddStaticMeshAttached("goggles", "halloween-city-park::SM_Goggles", "head", Vector(3.5, 6, 0) + self.goggles_offset, Rotator(-90, 0, 0))

	self:CallRemoteEvent("EquipGoggles", self:GetPlayer())
end

function SurvivorCharacter:EquipLollipop()
	self.has_lollipop = true

	-- Adds 50 Health
	self:SetHealth(self:GetHealth() + 50)

	self:AddStaticMeshAttached("lollipop", "halloween-city-park::SM_Lollipop", "hand_r_socket", Vector(2, -1, -5), Rotator(0, 0, 0))

	self:CallRemoteEvent("EquipLollipop", self:GetPlayer(), true)
end

function SurvivorCharacter:UnequipLollipop()
	self.has_lollipop = false

	self:RemoveStaticMeshAttached("lollipop")

	self:CallRemoteEvent("EquipLollipop", self:GetPlayer(), false)
end

function SurvivorCharacter:OnTakeDamage(damage, bone, type, from, instigator, causer)
	-- If has Lollipop, ignore the damage and unequip it
	-- WRONG, BERSERKER DOESNT KILL LOLLIPOP
	-- TODO should we just ignore the hit? instead of adding health
	if (self.has_lollipop and not self:IsDead()) then
		self:UnequipLollipop()
	end
end

function SurvivorCharacter:OnDeath(last_damage_taken, last_bone_damaged, damage_type_reason, hit_from_direction, instigator, causer)
	local player = self:GetPlayer()

	if (instigator and instigator ~= player) then
		local time_chasing = instigator:GetValue("ChaseTime") or 0
		local killed_survivors = instigator:GetValue("KilledSurvivors") or 0
		local average_chase_time = instigator:GetValue("AverageChaseTime") or 0

		-- Updates average chase time
		if (average_chase_time == 0) then
			average_chase_time = time_chasing
		else
			average_chase_time = (average_chase_time * killed_survivors + time_chasing) / (killed_survivors + 1)
		end

		instigator:SetValue("AverageChaseTime", average_chase_time)

		instigator:SetValue("KilledSurvivors", killed_survivors + 1)

		Events.BroadcastRemote("AddFeedItem", "kill", player:GetName(), instigator:GetName())
	else
		Events.BroadcastRemote("AddFeedItem", "kill", player:GetName())
	end

	-- Chat.SendMessage(player, "You are <red>dead</>! You can spectate other players by switching <bold>Left</> or <bold>Right</> keys!")

	Timer.Bind(
		Timer.SetTimeout(function(p)
			p:UnPossess()
		end, 10000, player),
		player
	)
end

function SurvivorCharacter:ResetDebuffs()
	self:SetSpeedMultiplier(self.speed_multiplier)
	self:SetFOVMultiplier(1)
end

-- Special Survivor Ability (Q)
function SurvivorCharacter:TriggerAbility(player)
	-- Only if is Survivor, match is in progress, is alive and the caller is the possesser
	if (Halloween.match_state ~= MATCH_STATES.IN_PROGRESS or not player:GetValue("IsAlive") or self:GetPlayer() ~= player) then
		return
	end

	-- Cooldown check
	local curr_time = os.time()
	if (self.ability_last_used and os.difftime(curr_time, self.ability_last_used) < HalloweenSettings.custom_settings.survivor_scream_cooldown) then
		Chat.SendMessage(player, "<red>The Ability is on cooldown!</>")
		return
	end

	self.ability_last_used = curr_time

	self:BroadcastRemoteEvent("TriggerAbility", HalloweenSettings.custom_settings.survivor_scream_cooldown)

	self:PlayAnimation("nanos-world::A_Mannequin_Taunt_Praise", AnimationSlotType.UpperBody, false, 0.2, 0.6, 1.1)

	-- Sets Debuffs
	self:SetSpeedMultiplier(self.speed_multiplier * 1.3)
	self:SetFOVMultiplier(1.2)

	-- Reset Debuffs after 3 seconds
	if (self.debuff_timer and Timer.IsValid(self.debuff_timer)) then
		Timer.ResetElapsedTime(self.debuff_timer)
	else
		self.debuff_timer = Timer.SetTimeout(function(cha)
			cha:ResetDebuffs()
			self.debuff_timer = nil
		end, 3000, self)

		Timer.Bind(self.debuff_timer, self)
	end

	-- Stuns nearby Knights
	local survivor_location = self:GetLocation()

	for k, c in pairs(KnightCharacter.GetPairs()) do
		local distance = survivor_location:Distance(c:GetLocation())

		if (distance < 500 and not c:IsDead()) then
			c:Stun()
			player:SetValue("StunnedKnights", (player:GetValue("StunnedKnights") or 0) + 1)
		end
	end
end

SurvivorCharacter.SubscribeRemote("TriggerAbility", SurvivorCharacter.TriggerAbility)
SurvivorCharacter.Subscribe("Death", SurvivorCharacter.OnDeath)
SurvivorCharacter.Subscribe("TakeDamage", SurvivorCharacter.OnTakeDamage)