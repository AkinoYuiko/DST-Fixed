local __dummy = function() end

local function do_block(inst)
	inst.no_periodicspawn = true

	if inst.components.periodicspawner then
		inst.components.periodicspawner:Stop()
	end
	
	if inst.components.lootdropper then
		local lootsetupfn = inst.components.lootdropper.lootsetupfn or __dummy
		inst.components.lootdropper:SetLootSetupFn(function(lootdropper, ...)
			local rt = lootsetupfn(lootdropper, ...)
			local loot = lootdropper.loot or {}
			table.insert(loot, "trinket_8")
			lootdropper.loot = loot
			return rt
		end)
	end
end

local function post_init(inst)
	if not GLOBAL.TheWorld.ismastersim then return end

	if not inst.components.trader then
		inst:AddComponent("trader")
	end

	local should_accept_fn = inst.components.trader.test or __dummy
	inst.components.trader:SetAcceptTest(function(inst, item, giver, ...)
		if item and item.prefab == "trinket_8" and not inst.no_periodicspawn then
			return true
		end
		return should_accept_fn(inst, item, giver, ...)
	end)

	local onaccept_fn = inst.components.trader.onaccept or __dummy
	inst.components.trader.onaccept = function(inst, giver, item, ...)
		if item and item.prefab == "trinket_8" then
			do_block(inst)
			return
		end
		return onaccept_fn(inst, giver, item, ...)
	end

	local on_save = inst.OnSave or __dummy
	inst.OnSave = function(inst, data, ...)
		data.no_periodicspawn = inst.no_periodicspawn
		return on_save(inst, data, ...)
	end

	local on_load = inst.OnLoad or __dummy
	inst.OnLoad = function(inst, data, ...)
		if data and data.no_periodicspawn then
			do_block(inst)
		end
		return on_load(inst, data, ...)
	end
end

local change_list = {"beefalo", "babybeefalo", "koalefant_summer", "koalefant_winter"}
for _, v in ipairs(change_list) do
	AddPrefabPostInit(v, post_init)
end

local UpvalueHacker = require("tools/upvaluehacker")
AddPrefabPostInit("beefaloherd", function(inst)
	UpvalueHacker.SetUpvalue(inst.components.periodicspawner.onspawn, function(inst)
		for member in pairs(inst.components.herd.members) do
			if not member.no_periodicspawn then -- Changed Part
				if member.components.domesticatable == nil
					or (member.components.domesticatable:IsDomesticated() == false and member.components.rideable:GetRider() == nil)
					then

					return member
				end
			end
		end
		return nil
	end, "SpawnableParent")
end)
