local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function on_dug_up(inst)
	if inst.components.lootdropper then
		inst.components.lootdropper:SpawnLootPrefab("petals_evil")
	end
	inst:Remove()
end

AddPrefabPostInit("flower_evil", function(inst)
	if inst.components.pickable then
		inst:RemoveComponent("pickable")
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(on_dug_up)
	inst.components.workable:SetWorkable(true)
end)
