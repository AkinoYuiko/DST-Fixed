GLOBAL.setfenv(1, GLOBAL)

local PlayerController = require("components/playercontroller")
function PlayerController:GetMapActions(position)
    local LMBaction, RMBaction

    local pos = self.inst:GetPosition()
    local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(pos)[1]
    LMBaction = self:RemapMapAction(lmbact, position)

    local map = getmetatable(TheWorld.Map).__index

    local is_passable_at_point = map.IsPassableAtPoint
    map.IsPassableAtPoint = function() return true end
    local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(pos)[1]
    map.IsPassableAtPoint = is_passable_at_point
    RMBaction = self:RemapMapAction(rmbact, position)

    return LMBaction, RMBaction
end
