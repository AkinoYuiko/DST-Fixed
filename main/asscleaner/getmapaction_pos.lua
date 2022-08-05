GLOBAL.setfenv(1, GLOBAL)
local UpvalueUtil = require("upvalueutil")

local COMPONENT_ACTIONS = UpvalueUtil.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")

local PlayerController = require("components/playercontroller")
function PlayerController:GetMapActions(position)
    local LMBaction, RMBaction

    local pos = self.inst:GetPosition()
    local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(pos)[1] -- pos :nimabi:
    LMBaction = self:RemapMapAction(lmbact, position)

    local map = getmetatable(TheWorld.Map).__index

    local blinkstaff_fn = COMPONENT_ACTIONS.POINT.blinkstaff
    COMPONENT_ACTIONS.POINT.blinkstaff = function(...)
        local is_above_ground_at_point = TheWorld.Map.IsAboveGroundAtPoint
        TheWorld.Map.IsAboveGroundAtPoint = function() return true end
        local ret = blinkstaff_fn(...)
        TheWorld.Map.IsAboveGroundAtPoint = is_above_ground_at_point
        return ret
    end

    local is_passable_at_point = map.IsPassableAtPoint
    map.IsPassableAtPoint = function() return true end
    local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(pos)[1]
    map.IsPassableAtPoint = is_passable_at_point
    RMBaction = self:RemapMapAction(rmbact, position)
    COMPONENT_ACTIONS.POINT.blinkstaff = blinkstaff_fn

    return LMBaction, RMBaction
end
