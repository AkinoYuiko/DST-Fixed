local allowed_prefabs = {
    "blowdart_sleep",
    "blowdart_fire",
    "blowdart_pipe",
    "blowdart_yellow",
}
for _, v in ipairs(allowed_prefabs) do
    AddPrefabPostInit(v, function(inst)
        if not GLOBAL.TheWorld.ismastersim then return end
        local onprehit = inst.components.projectile and inst.components.projectile.onprehit or function() end
        inst.components.projectile.onprehit = function(inst, attacker, target, ...)
            if target and target:IsValid() and target.components.health and target.components.health:IsDead() then
                local new_dart = GLOBAL.SpawnPrefab(inst.prefab)
                if new_dart then
                    new_dart.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end
            return onprehit(inst, attacker, target, ...)
        end
    end)
end