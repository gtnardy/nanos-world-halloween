Goggles = StaticMesh.Inherit("Goggles")

function Goggles:Constructor(location, rotation)
	-- Spawns me
	self.Super:Constructor((location or Vector()) + Vector(0, 0, 15), rotation or Rotator(), "city-park::SM_Goggles", CollisionType.NoCollision)
	self:SetScale(Vector(2))

	-- Spawns Light
	self.light = Light(location + Vector(0, 0, 100), Rotator(), Color(1, 0.7, 0.4), LightType.Point, 0.05, 300, 44, 0, 5000, true, false)
	self.light:AttachTo(self, AttachmentRule.KeepWorld, "", 0)

	-- Spawns Trigger
	self.trigger = Trigger(location, Rotator(), Vector(200), TriggerType.Sphere, false, Color.BLACK, { "Character" })
	self.trigger:AttachTo(self, AttachmentRule.SnapToTarget, "", 0)
	self.trigger:SetValue("TriggerSurvivorItem", self)
end

function Goggles:OnTriggerBeginOverlap(trigger, player, character)
	if (character.has_goggles) then return end

	-- Increments Player picked up count
	player:SetValue("PickedUpGoggles", player:GetValue("PickedUpGoggles", 0) + 1)

	character:EquipGoggles()

	self:BroadcastRemoteEvent("PickUp")

	Events.BroadcastRemote("AddFeedItem", "goggles", player:GetName())

	-- Picked up the Goggles, destroys it
	self:Destroy()
end