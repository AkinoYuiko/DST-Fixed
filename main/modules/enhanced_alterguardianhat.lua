-- table.insert(PrefabFiles, "gflash")

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function do_glash_attack(inst, attacker, target)
    local prev_damagemultiplier = attacker.components.combat.damagemultiplier
    attacker.components.combat.damagemultiplier = math.max(1, (prev_damagemultiplier or 1))
    attacker.components.combat:DoAttack(target, inst, inst)
    attacker.components.combat.damagemultiplier = prev_damagemultiplier
end


local function get_attacker_mult(attacker)
    local damagemult = attacker.components.combat.damagemultiplier or 1
    damagemult = math.min(2, damagemult)
    damagemult = math.max(1, damagemult)
    local electricmult = attacker.components.electricattacks and 1.5 or 1
    return damagemult * electricmult
end

local function target_testfn(target, owner)
    return target and target ~= owner and target:IsValid() and
        (target.components.health == nil or not target.components.health:IsDead() and
        not target:HasTag("structure") and
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

local function glash_fn(inst, owner, data)
    if owner.components.debuffable:HasDebuff("buff_moonglass") then
        return
    elseif not inst.components.container:Has("moonglass", 1) then
        return inst.alterguardian_spawngestalt_fn(owner, data)
    elseif data and data.weapon == inst then
        return
    elseif not inst._is_active then
        return
    end

    if owner_testfn(owner) then
        local target = data.target
        if target_testfn(target, owner) then

            if launching_projectile_testfn(data) then return end

            do_glash_attack(inst, owner, target)

            if owner.components.sanity and math.random() < ( 0.25 * get_attacker_mult(owner) ) then
                inst.components.container:ConsumeByName("moonglass", 1)
            end
        end
    end
end

local ALTERGUARDIANHAT_ITEMS = {"alterguardianhatbattery", "spore", "lunarseed"}
local function alterguardianhat_test_fn(container, item, slot)
    return item:HasAnyTag(ALTERGUARDIANHAT_ITEMS)
end

local function onequip(inst, owner, ...)

    -- local open_fn
    -- if inst.components.container then
    --     open_fn = inst.components.container.Open
    --     inst.components.container.Open = function() --[[ Disabled ]] end
    -- end

    inst.onequip_prefns["dst-fixed"](inst, owner, ...)

    inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, owner)

    inst.glash_fn = function(_owner, _data) glash_fn(inst, _owner, _data) end
    inst:ListenForEvent("onattackother", inst.glash_fn, owner)

    -- if open_fn and inst.components.container then
    --     inst.components.container.Open = open_fn
    -- end

end

local function onunequip(inst, owner, ...)
    inst.onunequip_prefns["dst-fixed"](inst, owner, ...)
    inst:RemoveEventCallback("onattackother", inst.glash_fn, owner)
end

local function OnEntityReplicated(inst)
    if inst.replica.container then
        -- inst.replica.container.type = "head_inv"
        inst.replica.container.acceptsstacks = true
        inst.replica.container.itemtestfn = alterguardianhat_test_fn
    end
end

local function on_attack(inst, attacker, target)
    if target and target:IsValid() then
        SpawnPrefab("hitsparks_fx"):Setup(inst, target)
    end
end

AddPrefabPostInit("alterguardianhat", function(inst)
    inst:AddTag("ignore_planar_entity")
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

    inst.onequip_prefns = inst.onequip_prefns or {}
    inst.onunequip_prefns = inst.onunequip_prefns or {}
    if inst.components.equippable then
        inst.onequip_prefns["dst-fixed"] = inst.onequip_prefns["dst-fixed"] or inst.components.equippable.onequipfn
        inst.onunequip_prefns["dst-fixed"] = inst.onunequip_prefns["dst-fixed"] or inst.components.equippable.onunequipfn
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetRange(40)
    inst.components.weapon:SetOnAttack(on_attack)

    inst:AddComponent("projectile")
end)

AddPrefabPostInit("moonglass", function(inst)
    inst:AddTag("alterguardianhatbattery")
end)

if not rawget(_G, "NS_PLANARENTITY_HACKING") then
    local PlanarEntity = require("components/planarentity")
    local AbsorbDamage = PlanarEntity.AbsorbDamage

    function PlanarEntity:AbsorbDamage(damage, attacker, weapon, spdmg, ...)
        -- print(attacker)
        if (attacker and attacker:HasTag("ignore_planar_entity")) or (weapon and weapon:HasTag("ignore_planar_entity")) then
            return damage, spdmg
        end
        return AbsorbDamage(self, damage, attacker, weapon, spdmg, ...)
    end
end
