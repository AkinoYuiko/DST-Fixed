local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("portablecookpot",function(inst)
	if not TheWorld.ismastersim then return inst end
	if inst.components.portablestructure then
		inst:RemoveComponent("portablestructure")
	end
end)