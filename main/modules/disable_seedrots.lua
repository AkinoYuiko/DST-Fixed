AddPrefabPostInit("seeds",function(inst)
	if inst.components.perishable then
	    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)
    	inst.components.perishable:StartPerishing()
    	-- inst.components.perishable.onperishreplacement = inst.Remove
    	inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)
    end
end)

AddPrefabPostInit("lightbulb",function(inst)
	if inst.components.perishable then
	    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    	inst.components.perishable:StartPerishing()
    	-- inst.components.perishable.onperishreplacement = inst.Remove
    	inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)
    end
end)

-- if GLOBAL.Prefabs["roe"] then
-- if GLOBAL.KnownModIndex:IsModEnabled("workshop-1467214795") then
AddPrefabPostInit("roe",function(inst)
    if inst.components.perishable then
        inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
        inst.components.perishable:StartPerishing()
        -- inst.components.perishable.onperishreplacement = inst.Remove
        inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)
    end
end)
-- end
-- AddPrefabPostInit("crumbs",function(inst)
-- 	if inst.components.perishable then
-- 	    inst.components.perishable:SetPerishTime(TUNING.PERISH_ONE_DAY)
--     	inst.components.perishable:StartPerishing()
--     	-- inst.components.perishable.onperishreplacement = inst.Remove
--     	inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)
--     end
-- end)