local AddPrefabPostInit = env.AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("endtable", function(inst)
	inst.AnimState:SetBank("stagehand_fix")
end)
