local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("beargerfur_sack", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.container then
        inst.components.container.droponopen = false
        local _onclose = inst.components.container.onclosefn
        inst.components.container.onclosefn = function(inst)
            _onclose(inst)
            local owner = inst.components.inventoryitem.owner
            if owner then
                inst.SoundEmitter:PlaySound(inst._sounds.close)
            end
        end
    end
end)

local TACKLECONTAINERS =
{
    "tacklecontainer",
    "supertacklecontainer",

}

for _, prefab in ipairs(TACKLECONTAINERS) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end

        if inst.components.container then
            inst.components.container.droponopen = false
        end
    end)
end
