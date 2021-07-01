local change_list = {"beefalo", "babybeefalo", "koalefant_summer", "koalefant_winter"}

for _, v in ipairs(change_list) do

	AddPrefabPostInit(v, function(inst)

		local function stop_periodicspwning(inst)
			if inst.components.periodicspawner then
				inst.components.periodicspawner:Stop()
			end
		end

		local function add_loot(inst)
			if inst.components.lootdropper then
				local lootsetupfn = inst.components.lootdropper.lootsetupfn or function() end
				inst.components.lootdropper:SetLootSetupFn(function(lootdropper, ...)
					local rt = lootsetupfn(lootdropper, ...)
					local loot = lootdropper.loot or {}
					table.insert(loot, "trinket_8")
					lootdropper.loot = loot
					return rt
				end)
			end
		end

		if not inst.components.trader then
			inst:AddComponent("trader")
		end

		local should_accept_fn = inst.components.trader.test or function() end
		inst.components.trader:SetAcceptTest(function(inst, item, giver, ...)
			if item and item.prefab == "trinket_8" and not inst.no_periodicspawn then
				return true
			end
			return should_accept_fn(inst, item, giver, ...)
		end)

		local onaccept_fn = inst.components.trader.onaccept or function() end
		inst.components.trader.onaccept = function(inst, giver, item, ...)
			if item and item.prefab == "trinket_8" then
				inst.no_periodicspawn = true
				stop_periodicspwning(inst)
				add_loot(inst)
				return
			end
			return onaccept_fn(inst, giver, item, ...)
		end

		local on_save = inst.OnSave or function() end
		inst.OnSave = function(inst, data, ...)
			data.no_periodicspawn = inst.no_periodicspawn
			return on_save(inst, data, ...)
		end

		local on_load = inst.OnLoad or function() end
		inst.OnLoad = function(inst, data, ...)
			inst.no_periodicspawn = data and data.no_periodicspawn
			if inst.no_periodicspawn then
				stop_periodicspwning(inst)
				add_loot(inst)
			end
			return on_load(inst, data, ...)
		end

	end)

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
