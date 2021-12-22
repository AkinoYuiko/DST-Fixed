local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("hivehat",function(inst)
    if inst:HasTag("regal") then inst:RemoveTag("regal") end
end)
