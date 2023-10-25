local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("beargerfur_sack", function(inst)
    if not TheWorld.ismastersim then return end

    if inst.components.container then
        inst.components.container.droponopen = false
    end
end)
