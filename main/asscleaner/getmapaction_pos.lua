GLOBAL.setfenv(1, GLOBAL)
local UpvalueUtil = require("upvalueutil")

local COMPONENT_ACTIONS = UpvalueUtil.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

local PlayerController = require("components/playercontroller")
-- function PlayerController:GetMapActions(position)
--     local LMBaction, RMBaction

--     local pos = self.inst:GetPosition()
--     local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(pos)[1] -- pos :nimabi:
--     LMBaction = self:RemapMapAction(lmbact, position)

--     local map = getmetatable(TheWorld.Map).__index

--     local blinkstaff_fn = COMPONENT_ACTIONS.POINT.blinkstaff
--     COMPONENT_ACTIONS.POINT.blinkstaff = function(...)
--         local is_above_ground_at_point = map.IsAboveGroundAtPoint
--         map.IsAboveGroundAtPoint = function() return true end
--         local ret = blinkstaff_fn(...)
--         map.IsAboveGroundAtPoint = is_above_ground_at_point
--         return ret
--     end

--     local is_passable_at_point = map.IsPassableAtPoint
--     map.IsPassableAtPoint = function() return true end
--     local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(pos)[1]
--     map.IsPassableAtPoint = is_passable_at_point
--     RMBaction = self:RemapMapAction(rmbact, position)
--     COMPONENT_ACTIONS.POINT.blinkstaff = blinkstaff_fn

--     return LMBaction, RMBaction
-- end

function PlayerController:GetMapActions(position, maptarget)
    -- NOTES(JBK): In order to not interface with the playercontroller too harshly and keep that isolated from this system here
    --             it is better to get what the player could do at their location as a quick check to make sure the actions done
    --             here will not interfere with actions done without the map up.
    local LMBaction, RMBaction = nil, nil

    local pos = self.inst:GetPosition()

    self.inst.checkingmapactions = true -- NOTES(JBK): Workaround flag to not add function argument changes for this task and lets things opt-in to special handling.
    local action_maptarget = maptarget and not maptarget:HasTag("INLIMBO") and maptarget or nil -- NOTES(JBK): Workaround passing the maptarget entity if it is out of scope for world actions.

    local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(pos, action_maptarget)[1]
    if lmbact then
        lmbact.maptarget = maptarget
        LMBaction = self:RemapMapAction(lmbact, position)
    end

    -- changed part start --
    local map = getmetatable(TheWorld.Map).__index

    local blinkstaff_fn = COMPONENT_ACTIONS.POINT.blinkstaff
    COMPONENT_ACTIONS.POINT.blinkstaff = function(...)
        local is_above_ground_at_point = map.IsAboveGroundAtPoint
        map.IsAboveGroundAtPoint = function() return true end
        local ret = blinkstaff_fn(...)
        map.IsAboveGroundAtPoint = is_above_ground_at_point
        return ret
    end

    local is_passable_at_point = map.IsPassableAtPoint
    map.IsPassableAtPoint = function() return true end
    -- changed part end --
    local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(pos, action_maptarget)[1]
    -- changed part start --
    map.IsPassableAtPoint = is_passable_at_point
    -- changed part end --
    if rmbact then
        rmbact.maptarget = maptarget
        RMBaction = self:RemapMapAction(rmbact, position)
    end

    if RMBaction and LMBaction and RMBaction.action == LMBaction.action then -- NOTES(JBK): If the actions are the same for the same target remove the LMBaction.
        LMBaction = nil
    end

    self.inst.checkingmapactions = nil

    return LMBaction, RMBaction
end
