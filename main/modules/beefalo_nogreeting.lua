AddPrefabPostInit("beefalo", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:SetBrain(require("brains/newbeefalobrain"))
    end
end)
