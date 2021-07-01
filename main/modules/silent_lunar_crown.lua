AddPrefabPostInit("alterguardianhat", function(inst)
	if inst.components.equippable then
		local on_equip = inst.components.equippable.onequipfn
		inst.components.equippable.onequipfn = function(inst, owner, ...)
			if inst.components.container then
				local open_fn = inst.components.container.Open
				inst.components.container.Open = function() --[[ Disabled ]] end
				local rt = on_equip(inst, owner, ...)
				inst.components.container.Open = open_fn
				return rt
			else
				return on_equip(inst, owner, ...)
			end
		end
	end
end)
