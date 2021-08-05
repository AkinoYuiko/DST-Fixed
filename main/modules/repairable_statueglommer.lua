local ENV = env
GLOBAL.setfenv(1, GLOBAL)

MATERIALS.MARBLE = "marble"

local function OnRepaired(inst)
    local workable = inst.components.workable
	local workleft = workable.workleft
    if workleft then
        if workleft >= workable.maxwork then
            inst:RemoveComponent("repairable")
        end
        if inst.components.lootdropper.chanceloottable == nil and workleft >= 0 then
            inst.components.lootdropper:SetChanceLootTable("statueglommer")
        end
    end
end

local function MakeRepairable(inst)
	print("MakeRepairable", inst.components.repairable)
    if inst.components.repairable == nil then
        inst:AddComponent("repairable")
        inst.components.repairable.repairmaterial = "marble"
        inst.components.repairable.onrepaired = OnRepaired
        inst.components.repairable.noannounce = true
    end
end

local function OnWorked(inst, data)
	print("fuck klei", data.workleft < 6)
	print("fucking klei: workleft", data.workleft)
	-- print("fucking klei: maxwork", 6)
	if data.workleft < 6 then
		MakeRepairable(inst)
	end
end

local function RemoveComponentProxy(inst, name, ...)
    if name == "workable" then
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(nil)
        inst.components.workable:SetWorkable(false)
        return true
    elseif name == "lootdropper" then
        inst.components.lootdropper:SetChanceLootTable(nil)
        return true
    end
end

local function MakeRemoveComponentProxy(fn)
    return function(inst, ...)
        local remove_component = inst.RemoveComponent
        inst.RemoveComponent = function(...)
            if RemoveComponentProxy(...) then return end
            return remove_component(...)
        end
        fn(inst, ...)
        inst.RemoveComponent = remove_component
    end
end

ENV.AddPrefabPostInit("statueglommer", function(inst)
    if not TheWorld.ismastersim then return end

    inst:ListenForEvent("worked", OnWorked)

	inst._onworked = OnWorked
    inst.components.workable:SetMaxWork(inst.components.workable.workleft)
    inst.components.workable:SetOnWorkCallback(MakeRemoveComponentProxy(inst.components.workable.onwork))
    inst.components.workable:SetOnLoadFn(MakeRemoveComponentProxy(inst.components.workable.onloadfn))
    inst.OnLoad = MakeRemoveComponentProxy(inst.OnLoad)
end)

ENV.AddPrefabPostInit("marble", function(inst)
	if not TheWorld.ismastersim then return end

    if not inst.components.repairer then
        inst:AddComponent("repairer")
    end
    inst.components.repairer.repairmaterial = "marble"
    inst.components.repairer.workrepairvalue = 2
end)
