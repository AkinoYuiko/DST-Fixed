local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local allowed_prefabs = {
    "blowdart_sleep",
    "blowdart_fire",
    "blowdart_pipe",
    "blowdart_yellow",
}

local function post_init(inst)
    if not TheWorld.ismastersim then return end
    local onprehit = inst.components.projectile and inst.components.projectile.onprehit
    inst.components.projectile.onprehit = function(inst, attacker, target, ...)
        if target and target:IsValid() and target.components.health and target.components.health:IsDead() then
            local new_dart = SpawnPrefab(inst.prefab)
            if new_dart then
                new_dart.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end
        if onprehit then
            return onprehit(inst, attacker, target, ...)
        end
    end
end

for _, v in ipairs(allowed_prefabs) do
    AddPrefabPostInit(v, post_init)
end
