-- Configures Keybindings Inputs
Input.Register("SpectatePrev", "Left")
Input.Register("SpectateNext", "Right")
Input.Register("Unspectate", "SpaceBar")

Input.Bind("SpectatePrev", InputEvent.Pressed, function()
	SpectateNext(-1)
end)

Input.Bind("SpectateNext", InputEvent.Pressed, function()
	SpectateNext(1)
end)

Input.Bind("Unspectate", InputEvent.Pressed, function()
	if (Client.GetLocalPlayer():GetControlledCharacter()) then return end
	Client.GetLocalPlayer():ResetCamera()
	HUD:CallEvent("SetObjective", "SPECTATING")
end)

-- Spectate function
function SpectateNext(index_increment)
	if (Client.GetLocalPlayer():GetControlledCharacter()) then return end
	Halloween.current_spectating_index = Halloween.current_spectating_index + index_increment

	local players = {}
	for k, v in pairs(Player.GetPairs()) do
		if (v ~= Client.GetLocalPlayer() and v:GetControlledCharacter() ~= nil) then
			table.insert(players, v)
		end
	end

	if (#players == 0) then return end

	local player = players[Halloween.current_spectating_index]

	if (not player) then
		if (index_increment > 0) then
			Halloween.current_spectating_index = 1
		else
			Halloween.current_spectating_index = #players
		end

		player = players[Halloween.current_spectating_index]
	end

	Client.GetLocalPlayer():Spectate(player, 0.5)
	HUD:CallEvent("SetObjective", "SPECTATING " .. player:GetName())
end

function UpdateSpectatingBillboards()
	for k, character in pairs(Character.GetPairs()) do
		local player = character:GetPlayer()
		if (player and player ~= Client.GetLocalPlayer()) then
			-- Spawn billboard
			local texture = "package://halloween/Client/UI/images/worker.png"
			local color = Color.BLUE
			local size = Vector2D(0.01, 0.013)

			if (character:IsA(KnightCharacter)) then
				texture = "package://halloween/Client/UI/images/knight.png"
				color = Color.RED
				size = Vector2D(0.011, 0.011)
			end

			local my_billboard = Billboard(Vector(), "nanos-world::M_Default_Translucent_Unlit_Depth", size, true)
			my_billboard:SetMaterialTextureParameter("Texture", texture)
			my_billboard:SetMaterialScalarParameter("Opacity", 1)
			my_billboard:SetMaterialColorParameter("Emissive", color * 0.05)
			my_billboard:AttachTo(character, AttachmentRule.SnapToTarget, "", 0)
			my_billboard:SetRelativeLocation(Vector(0, 0, 125))

			character.billboard = my_billboard
		end
	end
end