local _G = GLOBAL

AddPrefabPostInit("lureplantbulb",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(_G.DEPLOYMODE.ANYWHERE)
        -- inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.DEFAULT)
        inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.NONE)
    end
end)

AddPrefabPostInit("spidereggsack",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(_G.DEPLOYMODE.ANYWHERE)
        -- inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.DEFAULT)
        inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.NONE)
    end
end)


AddPrefabPostInit("fossil_piece",function(inst)
    if inst.components.deployable then
        inst.components.deployable:SetDeployMode(_G.DEPLOYMODE.ANYWHERE)
        inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.NONE)
    end
end)