GLOBAL.setfenv(1, GLOBAL)

local PlayerController = require("components/playercontroller")
function PlayerController:GetMapActions(position)

    local pos = self.inst:GetPosition()

    local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(position)[1]
    LMBaction = self:RemapMapAction(lmbact, position)

    local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(position)[1]
    RMBaction = self:RemapMapAction(rmbact, position)

    return LMBaction, RMBaction
end
