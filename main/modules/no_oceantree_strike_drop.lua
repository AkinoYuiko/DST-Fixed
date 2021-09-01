AddPrefabPostInit("oceantree_pillar", function(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    inst.components.lightningblocker:SetOnLightningStrike(nil)
end)
