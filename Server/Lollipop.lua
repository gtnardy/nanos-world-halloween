Lollipop = StaticMesh.Inherit("Lollipop")

function Lollipop:Constructor(location, rotation)
	-- Spawns me
	self.Super:Constructor((location or Vector()) + Vector(0, 0, 0), rotation or Rotator(), "city-park::SM_Lollipop", CollisionType.NoCollision)
	self:SetScale(Vector(4))

	-- Spawns Light
	self.light = Light(location + Vector(0, 0, 200), Rotator(), Color(1, 0.7, 0.4), LightType.Point, 0.05, 300, 44, 0, 5000, true, false)
	self.light:AttachTo(self, AttachmentRule.KeepWorld, "", 0)

	-- Spawns Trigger
	self.trigger = Trigger(location, Rotator(), Vector(200), TriggerType.Sphere, false, Color.BLACK, { "Character" })
	self.trigger:AttachTo(self, AttachmentRule.SnapToTarget, "", 0)
	self.trigger:SetValue("TriggerSurvivorItem", self)
end

function Lollipop:OnTriggerBeginOverlap(trigger, player, character)
	if (character.has_lollipop) then return end

	-- Increments Player picked up count
	player:SetValue("PickedUpLollipops", player:GetValue("PickedUpLollipops", 0) + 1)

	character:EquipLollipop()

	self:BroadcastRemoteEvent("PickUp")

	Events.BroadcastRemote("AddFeedItem", "lollipop", player:GetName())

	-- Picked up the Lollipop, destroys it
	self:Destroy()
end