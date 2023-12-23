local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local NOISY_CONTAINERS =
{
    "beargerfur_sack",
    "battlesong_container",

}

for _, container in ipairs(NOISY_CONTAINERS) do
    AddPrefabPostInit(container, function(inst)
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
end

local TACKLE_CONTAINERS =
{
    "tacklecontainer",
    "supertacklecontainer",
}

for _, prefab in ipairs(TACKLE_CONTAINERS) do
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end

        if inst.components.container then
            inst.components.container.droponopen = false
        end
    end)
end

-- local rummage_fn = ACTIONS.RUMMAGE.fn
-- ACTIONS.RUMMAGE.fn = function(act)

-- end
