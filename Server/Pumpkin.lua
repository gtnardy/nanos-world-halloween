Pumpkin = StaticMesh.Inherit("Pumpkin")

function Pumpkin:Constructor(location, rotation)
	-- Spawns me
	local pumpkin_mesh = HalloweenSettings.pumpkin_meshes[math.random(#HalloweenSettings.pumpkin_meshes)]
	self.Super:Constructor(location or Vector(), rotation or Rotator(), pumpkin_mesh, CollisionType.NoCollision)

	-- Spawns Light
	self.light = Light(location + Vector(0, 0, 100), Rotator(), Color(1, 0.7, 0.4), LightType.Point, 0.05, 300, 44, 0, 5000, true, false)
	self.light:AttachTo(self, AttachmentRule.KeepWorld, "", 0)

	-- Spawns Trigger
	self.trigger = Trigger(location, Rotator(), Vector(200), TriggerType.Sphere, false, Color.BLACK, { "Character" })
	self.trigger:AttachTo(self, AttachmentRule.SnapToTarget, "", 0)
	self.trigger:SetValue("TriggerSurvivorItem", self)
end

function Pumpkin:OnTriggerBeginOverlap(trigger, player, character)
	-- If trapdoor is opened, skips
	if (Halloween.is_trapdoor_opened or Halloween.pumpkins_found > Halloween.total_pumpkins) then return end

	-- Increments Player picked up count
	player:SetValue("PickedUpPumpkins", player:GetValue("PickedUpPumpkins", 0) + 1)

	-- Increments global picked up count
	Halloween.pumpkins_found = Halloween.pumpkins_found + 1

	-- Chat.BroadcastMessage("The Survivor '" .. player:GetName() .. "' found a <green>Pumpkin</>! " .. (Halloween.total_pumpkins - Halloween.pumpkins_found) .. " remaining!")

	self:BroadcastRemoteEvent("PickUp")

	Events.BroadcastRemote("AddFeedItem", "pumpkin", player:GetName())

	-- If already found enough Pumpkins, opens the Trapdoor
	if (Halloween.pumpkins_found >= Halloween.total_pumpkins) then
		Halloween.trapdoor:Open()
	end

	-- Picked up the Pumpkin, destroys it
	self:Destroy()
end