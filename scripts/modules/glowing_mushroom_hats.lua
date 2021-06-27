local TUNING = GLOBAL.TUNING
-- TUNING.ALLOW={}
-- TUNING.ALLOW["redhat"] = GetModConfigData("REDHAT")
-- TUNING.ALLOW["greenhat"] = GetModConfigData("GREENHAT")
-- TUNING.ALLOW["bluehat"] = GetModConfigData("BLUEHAT")

-- local ALLOW = TUNING.ALLOW
-- if ALLOW["redhat"] then
AddPrefabPostInit("red_mushroomhat",function (inst)
	if inst.components.equippable then
	inst.components.equippable:SetOnEquip(function (inst,owner)
		owner.AnimState:OverrideSymbol("swap_hat","hat_red_mushroom","swap_hat")
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end

		owner:AddTag("spoiler")

		inst.components.periodicspawner:Start()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.MUSHROOMHAT_SLOW_HUNGER)
		end

		if inst._light == nil or not inst._light:IsValid() then
			inst._light = GLOBAL.SpawnPrefab("lanternlight")
			inst._light.Light:SetFalloff(.5)
			inst._light.Light:SetIntensity(.8)
			inst._light.Light:SetRadius(1)
			inst._light.Light:SetColour(197/255,126/255,126/255)
		end

		inst._light.entity:SetParent(owner.entity)


		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
		else
			owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end

	end)
	inst.components.equippable:SetOnUnequip(function (inst,owner)
		owner.AnimState:ClearOverrideSymbol("swap_hat")
       	owner.AnimState:Hide("HAT")
       	owner.AnimState:Hide("HAIR_HAT")
       	owner.AnimState:Show("HAIR_NOHAT")
       	owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
	     	    owner.AnimState:Show("HEAD")
	     	    owner.AnimState:Hide("HEAD_HAT")
	     	end

		owner:RemoveTag("spoiler")

		inst.components.periodicspawner:Stop()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
		end

		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PopBloom(inst)
		else
			owner.AnimState:ClearBloomEffectHandle()
		end


		if inst._light ~= nil then
			if inst._light:IsValid() then
				inst._light:Remove()
			end
			inst._light = nil
		end
	end)
	end
	inst._light = nil
end)
-- end

-- if ALLOW["greenhat"] then
AddPrefabPostInit("green_mushroomhat",function (inst)
	if inst.components.equippable then
		inst.components.equippable:SetOnEquip(function (inst,owner)
		owner.AnimState:OverrideSymbol("swap_hat","hat_green_mushroom","swap_hat")
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end

		owner:AddTag("spoiler")

		inst.components.periodicspawner:Start()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.MUSHROOMHAT_SLOW_HUNGER)
		end

		if inst._light == nil or not inst._light:IsValid() then
			inst._light = GLOBAL.SpawnPrefab("lanternlight")
			inst._light.Light:SetFalloff(.5)
			inst._light.Light:SetIntensity(.8)
			inst._light.Light:SetRadius(1)
			inst._light.Light:SetColour(146/255,225/255,146/255)
		end

		inst._light.entity:SetParent(owner.entity)


		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
		else
			owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
	end)

	inst.components.equippable:SetOnUnequip(function (inst,owner)
		owner.AnimState:ClearOverrideSymbol("swap_hat")
       	owner.AnimState:Hide("HAT")
       	owner.AnimState:Hide("HAIR_HAT")
       	owner.AnimState:Show("HAIR_NOHAT")
       	owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
	     	    owner.AnimState:Show("HEAD")
	     	    owner.AnimState:Hide("HEAD_HAT")
	     	end

		owner:RemoveTag("spoiler")

		inst.components.periodicspawner:Stop()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
		end

		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PopBloom(inst)
		else
			owner.AnimState:ClearBloomEffectHandle()
		end


		if inst._light ~= nil then
			if inst._light:IsValid() then
				inst._light:Remove()
			end
			inst._light = nil
		end
	end)
	end
	inst._light = nil
end)
-- end


-- if ALLOW["bluehat"] then
AddPrefabPostInit("blue_mushroomhat",function (inst)
	if inst.components.equippable then
	inst.components.equippable:SetOnEquip(function (inst,owner)
		owner.AnimState:OverrideSymbol("swap_hat","hat_blue_mushroom","swap_hat")
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HAIR")

		if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAT")
		end

		owner:AddTag("spoiler")

		inst.components.periodicspawner:Start()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING.MUSHROOMHAT_SLOW_HUNGER)
		end

		if inst._light == nil or not inst._light:IsValid() then
			inst._light = GLOBAL.SpawnPrefab("lanternlight")
			inst._light.Light:SetFalloff(.5)
			inst._light.Light:SetIntensity(.8)
			inst._light.Light:SetRadius(1)
			inst._light.Light:SetColour(111/255,111/255,227/255)
		end

		inst._light.entity:SetParent(owner.entity)


		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
		else
			owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
		end
	end)

	inst.components.equippable:SetOnUnequip(function (inst,owner)
		owner.AnimState:ClearOverrideSymbol("swap_hat")
       	owner.AnimState:Hide("HAT")
       	owner.AnimState:Hide("HAIR_HAT")
       	owner.AnimState:Show("HAIR_NOHAT")
       	owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
	     	    owner.AnimState:Show("HEAD")
	     	    owner.AnimState:Hide("HEAD_HAT")
	     	end

		owner:RemoveTag("spoiler")

		inst.components.periodicspawner:Stop()

		if owner.components.hunger ~= nil then
			owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
		end

		if owner.components.bloomer ~= nil then
			owner.components.bloomer:PopBloom(inst)
		else
			owner.AnimState:ClearBloomEffectHandle()
		end


		if inst._light ~= nil then
			if inst._light:IsValid() then
				inst._light:Remove()
			end
			inst._light = nil
		end
	end)
	end
	inst._light = nil
end)
-- end

