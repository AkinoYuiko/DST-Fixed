AddPrefabPostInit("beefalo",function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
    inst:SetBrain(GLOBAL.require("brains/newbeefalobrain"))
end)