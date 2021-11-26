local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("beefalo", function(inst)
    if TheWorld.ismastersim then
        inst:SetBrain(require("brains/newbeefalobrain"))
    end
end)
