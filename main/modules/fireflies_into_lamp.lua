local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("fireflies",function(inst)
    inst:AddTag("lightbattery")
end)