local _G = GLOBAL

AddPrefabPostInit("portablecookpot",function(inst)
	if not _G.TheWorld.ismastersim then return inst end
	if inst.components.portablestructure then
		inst:RemoveComponent("portablestructure")
	end
end)