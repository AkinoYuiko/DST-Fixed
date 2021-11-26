local AddPrefabPostInit = env.AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("lureplantbulb",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    end
end)

AddPrefabPostInit("spidereggsack",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    end
end)

AddPrefabPostInit("fossil_piece",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
        inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
    end
end)