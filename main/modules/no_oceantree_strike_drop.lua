local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("oceantree_pillar", function(inst)
    if not TheWorld.ismastersim then return end
    inst.components.lightningblocker:SetOnLightningStrike(nil)
end)
