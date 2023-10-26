local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("beargerfur_sack", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.container then
        inst.components.container.droponopen = false
        local _onclose = inst.components.container.onclosefn
        inst.components.container.onclosefn = function(inst)
            _onclose(inst)
            local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
            if owner then
                if owner.SoundEmitter then
                    owner.SoundEmitter:PlaySound(inst._sounds.close)
                end
            end
        end
    end
end)

AddPrefabPostInit("tacklecontainer", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.container then
        inst.components.container.droponopen = false
    end
end)
