local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("bookstation",function(inst)
    if not inst:HasTag("giftmachine") then
        inst:AddTag("giftmachine")
    end
end)
