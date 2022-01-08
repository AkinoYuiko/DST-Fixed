table.insert(PrefabFiles, "gestalt_flash")

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

local function target_testfn(target, owner)
    return target and target ~= owner and target:IsValid() and
            (target.components.health == nil or not target.components.health:IsDead() and
            (target:HasTag("spiderden") or not target:HasTag("structure")) and
            not target:HasTag("wall"))
end

local function owner_testfn(owner)
    return owner and (owner.components.health == nil or not owner.components.health:IsDead())
end

local function launching_projectile_testfn(data)
    return data.weapon and data.projectile == nil
        and (data.weapon.components.projectile
            or data.weapon.components.complexprojectile
            or data.weapon.components.weapon:CanRangedAttack())
end

local function super_spawngestalt_fn(inst, owner, data)

    if not inst.components.container:Has("moonglass", 1) then
        return inst.alterguardian_spawngestalt_fn(owner, data)
    end

    if not inst._is_active then
        return
    end

    if owner_testfn(owner) then
        local target = data.target
        if target_testfn(target, owner) then

            if launching_projectile_testfn(data) then return end

            SpawnPrefab("gestalt_flash"):SetTarget(owner, target)

            if owner.components.sanity and math.random() < 0.25 then
                inst.components.container:ConsumeByName("moonglass", 1)
            end
        end
    end
end

local function alterguardianhat_test_fn(container, item, slot)
    return item:HasTag("alterguardianhatbattery") or item:HasTag("spore")
end

local function hide_on_deactive(inst, owner)
    local sanity = owner.components.sanity ~= nil and owner.components.sanity:GetPercent() or 0
    if sanity <= TUNING.SANITY_BECOME_ENLIGHTENED_THRESH and inst._task then
        inst._task:Cancel()
        inst._task = nil
    end
end

local function new_onequip(inst, owner, ...)

    local open_fn
    if inst.components.container then
        open_fn = inst.components.container.Open
        inst.components.container.Open = function() --[[ Disabled ]] end
    end

    inst.onequip_prefns["dst-fixed"](inst, owner, ...)

    inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, owner)

    inst.new_spawngestalt_fn = function(_owner, _data) super_spawngestalt_fn(inst, _owner, _data) end
    inst:ListenForEvent("onattackother", inst.new_spawngestalt_fn, owner)

    -- if owner.prefab == "dummy" then
        -- inst:ListenForEvent("healthdelta", inst._onsanitydelta, owner)
    -- end

    if open_fn and inst.components.container then
        inst.components.container.Open = open_fn
    end

    if owner then owner.AnimState:ClearOverrideSymbol("swap_hat") end
end

local function new_onunequip(inst, owner, ...)
    inst.onunequip_prefns["dst-fixed"](inst, owner, ...)
    inst:RemoveEventCallback("onattackother", inst.new_spawngestalt_fn, owner)
    -- if owner.prefab == "dummy" then
    --     inst:RemoveEventCallback("healthdelta", inst._onsanitydeltas, owner)
    -- end
end

local function OnEntityReplicated(inst)
    if inst.replica.container then
        -- inst.replica.container.type = "head_inv"
        inst.replica.container.acceptsstacks = true
        inst.replica.container.itemtestfn = alterguardianhat_test_fn
    end
end

AddPrefabPostInit("alterguardianhat", function(inst)

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated
        return
    end

    local container = inst.components.container
    removesetter(container, "acceptsstacks")
    removesetter(container, "itemtestfn")
    removesetter(container, "type")
    container.type = "head_inv"
    inst.components.container.acceptsstacks = true
    container.itemtestfn = alterguardianhat_test_fn
    if inst.replica.container then
        -- inst.replica.container.type = "head_inv"
        inst.replica.container.acceptsstacks = true
        inst.replica.container.itemtestfn = alterguardianhat_test_fn
    end
    makereadonly(container, "acceptsstacks")
    makereadonly(container, "itemtestfn")
    makereadonly(container, "type")

    local hackpath = "alterguardian_onsanitydelta.alterguardian_deactivate"
    local alterguardian_deactivate = UpvalueHacker.GetUpvalue(inst.components.equippable.onequipfn, hackpath)
    local function deactivate_fn(inst)
        alterguardian_deactivate(inst)
        if inst._task then
            inst._task:Cancel()
            inst._task = nil
        end
    end
    UpvalueHacker.SetUpvalue(inst.components.equippable.onequipfn, hackpath, deactivate_fn)


    inst.onequip_prefns = inst.onequip_prefns or {}
    inst.onunequip_prefns = inst.onunequip_prefns or {}
    if inst.components.equippable then
        inst.onequip_prefns["dst-fixed"] = inst.components.equippable.onequipfn
        inst.onunequip_prefns["dst-fixed"] = inst.components.equippable.onunequipfn
        inst.components.equippable:SetOnEquip(new_onequip)
        inst.components.equippable:SetOnUnequip(new_onunequip)
    end
end)

AddPrefabPostInit("moonglass", function(inst)
    inst:AddTag("alterguardianhatbattery")
end)
