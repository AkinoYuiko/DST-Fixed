require "prefabutil"

local assets = {}

local prefabs = {
    "gestalt_flash_fx",
    "electrichitsparks",
    "hitsparks_fx",
}

local function doattack(inst, target)
    if inst.components.combat:CanHitTarget(target) then
        inst.components.combat:DoAttack(target)
    end
end

local function onattackother(inst, data)
    local target = data.target
    local owner = inst.entity:GetParent()
    if target and target:IsValid() and inst:IsValid() then
        if inst.components.electricattacks then
            SpawnPrefab("electrichitsparks"):AlignToTarget(target, inst, true)
        end
        SpawnPrefab("hitsparks_fx"):Setup(inst, target)
    end
end

local props = {"externaldamagemultipliers", "damagebonus"}
local function SetTarget(inst, owner, target)
    if owner then
        for _, v in ipairs(props) do
            inst.components.combat[v] = owner.components.combat[v]
        end
        inst.components.combat.damagemultiplier = math.max(1, (owner.components.combat.damagemultiplier or 1))
        if owner.components.electricattacks then
            inst:AddComponent("electricattacks")
        end

        inst:ListenForEvent("onattackother", onattackother)

        inst.entity:SetParent(owner.entity)
        inst:DoTaskInTime(8 * FRAMES, doattack, target)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()

    inst:AddTag("ignore_planar_entity")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE)
    inst.components.combat:SetRange(TUNING.GESTALTGUARD_ATTACK_RANGE * 10)

    inst.SetTarget = SetTarget

    inst:DoTaskInTime(0.5, function(inst) inst:Remove() end)

    return inst
end

return Prefab("gestalt_flash", fn, assets, prefabs)
