table.insert(Assets, Asset("ANIM", "anim/stagehand_fix.zip"))

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("endtable", function(inst)
    inst.AnimState:SetBank("stagehand_fix")
end)
