Lollipop = StaticMesh.Inherit("Lollipop")

function Lollipop:OnPickedUp()
	Sound(self:GetLocation(), "halloween-city-park::A_Pumpkin_Pickup", false, true, SoundType.SFX, 1, 1.7, 400, 3600, AttenuationFunction.NaturalSound)
end

Lollipop.SubscribeRemote("PickUp", Lollipop.OnPickedUp)