local _G = GLOBAL

AddPrefabPostInit("sisturn", function(inst)

	local function sisturn_test_fn(container, item, slot)
	    return item:HasTag("sisturnbattery")
	end

    if not _G.TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            if inst.replica.container then
            	inst.replica.container.itemtestfn=sisturn_test_fn
            end
        end
        return inst
    end

	local container = inst.components.container
    _G.removesetter(container, "itemtestfn")
    container.itemtestfn = sisturn_test_fn
	if inst.replica.container ~= nil then inst.replica.container.itemtestfn = sisturn_test_fn end
	_G.makereadonly(container, "itemtestfn")

end)

AddPrefabPostInit("petals", function(inst)
	inst:AddTag("sisturnbattery")
end)

AddPrefabPostInit("boneshard", function(inst)
	inst:AddTag("sisturnbattery")
end)

AddPrefabPostInit("ghostflower", function(inst)
	inst:AddTag("sisturnbattery")
end)