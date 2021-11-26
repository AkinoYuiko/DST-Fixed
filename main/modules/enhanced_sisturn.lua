local AddPrefabPostInit = env.AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("sisturn", function(inst)

	local function sisturn_test_fn(container, item, slot)
	    return item:HasTag("sisturnbattery")
	end

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            if inst.replica.container then
            	inst.replica.container.itemtestfn=sisturn_test_fn
            end
        end
        return inst
    end

	local container = inst.components.container
    removesetter(container, "itemtestfn")
    container.itemtestfn = sisturn_test_fn
	if inst.replica.container ~= nil then inst.replica.container.itemtestfn = sisturn_test_fn end
	makereadonly(container, "itemtestfn")

end)

local battery_list = {
	"petals",
	"boneshard",
	"ghostflower",
}

for _, v in ipars(battery_list) do
	AddPrefabPostInit(v, function(inst)
		inst:AddTag("sisturnbattery")
	end)
end