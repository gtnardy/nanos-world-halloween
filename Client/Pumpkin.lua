Pumpkin = StaticMesh.Inherit("Pumpkin")

function Pumpkin:OnPickedUp()
	Sound(self:GetLocation(), "city-park::A_Pumpkin_Pickup_Cue", false, true, SoundType.SFX, 1, 1, 400, 3600, AttenuationFunction.NaturalSound)

	Halloween.pumpkins_found = Halloween.pumpkins_found + 1
	HUD:CallEvent("UpdatePumpkinsFound", Halloween.total_pumpkins, Halloween.pumpkins_found)
end

Pumpkin.SubscribeRemote("PickUp", Pumpkin.OnPickedUp)