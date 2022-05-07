local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local NIGHTVISIONMODULE_GRUEIMMUNITY_NAME = "wxnightvisioncircuit"
local function SetForcedNightVision(inst, nightvision_on)
    inst._forced_nightvision:set(nightvision_on)
    if inst.components.playervision ~= nil then
        inst.components.playervision:ForceNightVision(nightvision_on)
    end

    -- The nightvision event might get consumed during save/loading,
    -- so push an extra custom immunity into the table.
    if nightvision_on then
        inst.components.grue:AddImmunity(NIGHTVISIONMODULE_GRUEIMMUNITY_NAME)
    else
        -- inst.components.grue:RemoveImmunity(NIGHTVISIONMODULE_GRUEIMMUNITY_NAME)
        inst:DoTaskInTime(5 * FRAMES, function(inst) inst.components.grue:RemoveImmunity(NIGHTVISIONMODULE_GRUEIMMUNITY_NAME) end)
    end
end

AddPrefabPostInit("wx78", function(inst)
    if not TheWorld.ismastersim then return end

    inst.SetForcedNightVision = SetForcedNightVision
end)
