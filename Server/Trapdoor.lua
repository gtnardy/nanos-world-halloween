Trapdoor = StaticMesh.Inherit("Trapdoor")

function Trapdoor:Constructor(location, rotation)
	-- Spawns me
	self.Super:Constructor(location or Vector(), rotation or Rotator(), "city-park::SM_Trapdoor_Closed", CollisionType.NoCollision)

	-- Spawns Trigger
	self.trigger = Trigger(location, Rotator(), Vector(300), TriggerType.Sphere, false, Color.BLACK, { "Character" })
	self.trigger:SetValue("TriggerSurvivorItem", self)
	self.trigger:AttachTo(self, AttachmentRule.SnapToTarget, "", 0)
end

function Trapdoor:Open()
	self:SetMesh("city-park::SM_Trapdoor_Opened")
	Halloween.is_trapdoor_opened = true

	-- Sets additional time
	if (Halloween.remaining_time < HalloweenSettings.trapdoor_time) then
		Halloween.remaining_time = HalloweenSettings.trapdoor_time
	end

	Chat.BroadcastMessage("A <green>Trapdoor</> has been opened! Survivors must find it to escape!")

	self:BroadcastRemoteEvent("Open")
end

function Trapdoor:OnTriggerBeginOverlap(trigger, player, character)
	if (not Halloween.is_trapdoor_opened) then return end

	-- Player escaped!
	character:Destroy()

	player:SetValue("Escaped", true)
	player:SetValue("IsAlive", false, true)

	Halloween.players_saved = Halloween.players_saved + 1

	VerifyEndConditions()

	Events.BroadcastRemote("AddFeedItem", "escaped", player:GetName())

	self:BroadcastRemoteEvent("SurvivorEscaped")
end