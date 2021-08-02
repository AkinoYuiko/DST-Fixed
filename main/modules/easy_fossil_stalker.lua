AddPrefabPostInit("fossil_stalker", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end

    local onrepaired = inst.components.repairable.onrepaired
    inst.components.repairable.onrepaired = function(inst, ...)
        onrepaired(inst, ...)
        inst.form = 1
        inst.AnimState:PlayAnimation(tostring(inst.form).."_"..tostring(inst.moundsize))
    end
end)
