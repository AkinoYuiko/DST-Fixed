local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local NIGHTVISIONMODULE_GRUEIMMUNITY_NAME = "wxnightvisioncircuit"
local function SetForcedNightVision(inst, nightvision_on)
    if nightvision_on then
        inst._forced_nightvision:set(nightvision_on)
        if inst.components.playervision then
            inst.components.playervision:ForceNightVision(nightvision_on)
        end
    else
        inst:DoTaskInTime(5 * FRAMES, function(inst)
            inst._forced_nightvision:set(nightvision_on)
            if inst.components.playervision then
                inst.components.playervision:ForceNightVision(nightvision_on)
            end
        end)
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





-- local function nightvision_onworldstateupdate(wx)
--     local set_on = TheWorld.state.isnight and not TheWorld.state.isfullmoon
--     if
--     wx:SetForcedNightVision(TheWorld.state.isnight and not TheWorld.state.isfullmoon)
-- end

-- local function nightvision_activate(inst, wx)
--     wx._nightvision_modcount = (wx._nightvision_modcount or 0) + 1

--     if wx._nightvision_modcount == 1 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
--         if TheWorld:HasTag("cave") then
--             wx:SetForcedNightVision(true)
--         else
--             wx:WatchWorldState("isnight", nightvision_onworldstateupdate)
--             wx:WatchWorldState("isfullmoon", nightvision_onworldstateupdate)
--             nightvision_onworldstateupdate(wx)
--         end
--     end
-- end

-- local function nightvision_deactivate(inst, wx)
--     wx._nightvision_modcount = math.max(0, wx._nightvision_modcount - 1)

--     if wx._nightvision_modcount == 0 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
--         if TheWorld:HasTag("cave") then
--             wx:SetForcedNightVision(false)
--         else
--             wx:StopWatchingWorldState("isnight", nightvision_onworldstateupdate)
--             wx:StopWatchingWorldState("isfullmoon", nightvision_onworldstateupdate)
--             wx:SetForcedNightVision(false)
--         end
--     end
-- end

-- local wx78_moduledefs = require("wx78_moduledefs")
-- for _, module in ipairs(wx78_moduledefs.module_definitions) do
--     if module.name == "nightvision" then
--         module.activatefn = nightvision_activate
--         module.deactivatefn = nightvision_deactivate
--     end
-- end
