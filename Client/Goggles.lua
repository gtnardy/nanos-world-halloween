Goggles = StaticMesh.Inherit("Goggles")

function Goggles:OnPickedUp()
	Sound(self:GetLocation(), "package://halloween/Client/Sounds/NightVision.ogg", false, true, SoundType.SFX, 0.25, 1, 400, 3600, AttenuationFunction.NaturalSound)
end

Goggles.SubscribeRemote("PickUp", Goggles.OnPickedUp)