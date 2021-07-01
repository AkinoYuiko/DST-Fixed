local _G = GLOBAL

AddPrefabPostInit("flower_evil", function(inst)
	local function on_dug_up(inst)
	    if inst.components.lootdropper ~= nil then
	        inst.components.lootdropper:SpawnLootPrefab("petals_evil")
	    end
    	inst:Remove()
	end

	if inst.components.pickable then
		inst:RemoveComponent("pickable")
	end

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(_G.ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(on_dug_up)
    inst.components.workable:SetWorkable(true)

end)