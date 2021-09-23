local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BURRYMOUND = Action()

BURRYMOUND.id = "BURRYMOUND"
BURRYMOUND.str = "Burry"

-- BURRYMOUND.stroverridefn = function(act)
-- 	if act.invobject ~= nil then
-- 		return act.invobject:GetIsWet() and STRINGS.ACTIONS.ADDWETFUEL or STRINGS.ACTIONS.ADDFUEL
-- 	end
-- end

BURRYMOUND.fn = function(act)
    if act.target.AnimState:IsCurrentAnimation("dug") then
        local item = act.doer.components.inventory:RemoveItem(act.invobject)
        local mound = act.target
        -- mound.Transform:SetPosition(act.target:GetPosition():Get())
        -- act.target:Remove()
        mound.is_honored = true
        mound.AnimState:PlayAnimation("gravedirt")
        SpawnPrefab("sand_puff").entity:SetParent(mound.entity)
        item:Remove()
        return true
    end
end

ENV.AddAction(BURRYMOUND)

ENV.AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst.prefab == "ghostflower" and target.prefab == "mound" and target.AnimState:IsCurrentAnimation("dug") then
        table.insert(actions, ACTIONS.BURRYMOUND)
    end
end)

local handler = ActionHandler(ACTIONS.BURRYMOUND, "dolongaction")
ENV.AddStategraphActionHandler("wilson", handler)
ENV.AddStategraphActionHandler("wilson_client", handler)

-- STRINGS.NAMES.HONOR_MOUND = STRINGS.NAMES.MOUND
-- STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONOR_MOUND = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOUND.GENERIC


local function OnCyclesChanged(inst)
    -- print("OnCyclesChanged", inst)
    -- local mound = SpawnPrefab("mound")
    -- local sand_fx = SpawnPrefab("sand_puff")
    -- mound.Transform:SetPosition(inst:GetPosition():Get())
    -- SpawnPrefab("sand_puff").entity:SetParent(mound.entity)
    -- inst:Remove()
    if inst.is_honored then
        inst.is_honored = false
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetWorkLeft(1)
        if not inst.components.lootdropper then inst:AddComponent("lootdropper") end
        inst.components.workable:SetOnFinishCallback(inst.on_finish_fn)

        inst.AnimState:PlayAnimation("gravedirt")
        
        inst._light = SpawnPrefab("chesterlight")
        inst._light.Transform:SetPosition(inst:GetPosition():Get())
        inst._light:TurnOn()
        -- inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")

        inst:DoTaskInTime(2, function(inst)
            if inst._light then
                inst._light:TurnOff()
                inst._light:DoTaskInTime(2, function(inst) inst:Remove() end)
            end
        end)
    end
end

local function GetStatus(inst)
    if not inst.is_honored and not inst.components.workable then
        return "DUG"
    end
end
local function OnSave(inst, data)
    if inst.is_honored then
        data.is_honored = true
        data.dug = nil
    elseif inst.components.workable == nil then
        data.is_honored = nil
        data.dug = true
    else
        data.dug = nil
    end
end

local function OnLoad(inst, data)
    if data and ( data.dug or data.is_honored ) or inst.components.workable == nil then
        inst:RemoveComponent("workable")
        if not ( data and data.is_honored ) then
            inst.AnimState:PlayAnimation("dug")
        end
    end
    if data and data.is_honored then
        inst.is_honored = true
        data.dug = nil
        data.is_honored = nil
    end
end

ENV.AddPrefabPostInit("mound", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.inspectable then inst.components.inspectable.getstatus = GetStatus end

    inst:WatchWorldState("cycles", OnCyclesChanged)

    inst.on_finish_fn = inst.components.workable and inst.components.workable.onfinish

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

end)