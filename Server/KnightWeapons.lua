GreatAxe = Melee.Inherit("GreatAxe")

-- OLIVATO PODE FICAR CLIANDO COM MELEE VARIAS VEZES POR PING

function GreatAxe:Constructor(location, rotation)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "weapon-pack::SM_GreatAxe", CollisionType.Normal, true, HandlingMode.DoubleHandedMelee)

	self.cooldown = 1
	self.base_damage = 25

	self:SetScale(Vector(1.1, 1.1, 1.8))
	self:AddAnimationCharacterUse("nanos-world::AM_Mannequin_Melee_Slash_Attack", 0.8)
	self:SetSoundUse("nanos-world::A_Male_04_Attack", 5, 0.5)
	self:SetDamageSettings(0.5, 0.6)
	self:SetCooldown(self.cooldown)
	self:SetBaseDamage(self.base_damage)
	self:SetImpactSound(SurfaceType.Flesh, "city-park::A_SplashBlood_Cue")
	self:SetImpactSound(SurfaceType.Default, "nanos-world::A_MetalHeavy_Impact_MS")

	self:SetAttachmentSettings(Vector(), Rotator(10, 0, 0))
end


Sickle = Melee.Inherit("Sickle")

function Sickle:Constructor(location, rotation)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "weapon-pack::SM_Sickle", CollisionType.Normal, true, HandlingMode.DoubleHandedMelee)

	self.cooldown = 3
	self.base_damage = 50

	self:SetScale(Vector(1.1, 1.1, 2))
	self:AddAnimationCharacterUse("nanos-world::A_Boss_Attack_Swing_InP", 1.4)
	self:SetSoundUse("nanos-world::A_Male_04_Attack", 5, 0.5)
	self:SetDamageSettings(1.25, 1.5)
	self:SetCooldown(self.cooldown)
	self:SetBaseDamage(self.base_damage)
	self:SetImpactSound(SurfaceType.Flesh, "city-park::A_SplashBlood_Cue")
	self:SetImpactSound(SurfaceType.Default, "nanos-world::A_MetalHeavy_Impact_MS")

	self:SetAttachmentSettings(Vector(), Rotator(-10, 180, -30))
end


GreatHammer = Melee.Inherit("GreatHammer")

function GreatHammer:Constructor(location, rotation)
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "weapon-pack::SM_GreatHammer", CollisionType.Normal, true, HandlingMode.DoubleHandedMelee)

	self.cooldown = 4
	self.base_damage = 60

	self:SetScale(Vector(1.1, 1.1, 1.8))
	self:AddAnimationCharacterUse("nanos-world::A_Boss_Attack_Uppercut_InP", 1.7, AnimationSlotType.UpperBody)
	self:SetSoundUse("nanos-world::A_Male_04_Attack", 5, 0.5)
	self:SetDamageSettings(1.3, 0.5)
	self:SetCooldown(self.cooldown)
	self:SetBaseDamage(self.base_damage)
	self:SetImpactSound(SurfaceType.Flesh, "city-park::A_SplashBlood_Cue")
	self:SetImpactSound(SurfaceType.Default, "nanos-world::A_MetalHeavy_Impact_MS")

	self:SetAttachmentSettings(Vector(), Rotator(10, 0, 0))
end