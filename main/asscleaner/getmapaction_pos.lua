GLOBAL.setfenv(1, GLOBAL)
local UpvalueUtil = require("upvalueutil")

local PlayerController = require("components/playercontroller")
function PlayerController:GetMapActions(position)
    local LMBaction, RMBaction

    local lmbact = self.inst.components.playeractionpicker:GetLeftClickActions(position)[1]
    LMBaction = self:RemapMapAction(lmbact, position)

    local rmbact = self.inst.components.playeractionpicker:GetRightClickActions(position)[1]
    RMBaction = self:RemapMapAction(rmbact, position)

    return LMBaction, RMBaction
end

local ActionCanMapSoulhop = UpvalueUtil.GetUpvalue(ACTIONS.BLINK_MAP.fn, "ActionCanMapSoulhop")

local BLINK_MAP_MUST = { "CLASSIFIED", "globalmapicon", "fogrevealer" }
ACTIONS_MAP_REMAP[ACTIONS.BLINK.code] = function(act, targetpos)
    local doer = act.doer
    if doer == nil then
        return nil
    end
    local aimassisted = false
    if not TheWorld.Map:IsVisualGroundAtPoint(targetpos.x, targetpos.y, targetpos.z) then
        -- NOTES(JBK): No map tile at the cursor but the area might contain a boat that has a maprevealer component around it.
        -- First find a globalmapicon near here and look for if it is from a fogrevealer and assume it is on landable terrain.
        local ents = TheSim:FindEntities(targetpos.x, targetpos.y, targetpos.z, PLAYER_REVEAL_RADIUS * 0.4, BLINK_MAP_MUST)
        local revealer = nil
        local MAX_WALKABLE_PLATFORM_DIAMETERSQ = TUNING.MAX_WALKABLE_PLATFORM_RADIUS * TUNING.MAX_WALKABLE_PLATFORM_RADIUS * 4 -- Diameter.
        for _, v in ipairs(ents) do
            if doer:GetDistanceSqToInst(v) > MAX_WALKABLE_PLATFORM_DIAMETERSQ then -- Ignore close boats because the range for aim assist is huge.
                revealer = v
                break
            end
        end
        if revealer == nil then
            return nil
        end
        targetpos.x, targetpos.y, targetpos.z = revealer.Transform:GetWorldPosition()
        aimassisted = true
    end
    local dist = doer:GetPosition():Dist(targetpos)
    local act_remap = BufferedAction(doer, nil, ACTIONS.BLINK_MAP, act.invobject, targetpos)
    local dist_mod = ((doer._freesoulhop_counter or 0) * (TUNING.WORTOX_FREEHOP_HOPSPERSOUL - 1)) * act.distance
    local dist_perhop = (act.distance * TUNING.WORTOX_FREEHOP_HOPSPERSOUL * TUNING.WORTOX_MAPHOP_DISTANCE_SCALER)
    local dist_souls = (dist + dist_mod) / dist_perhop
    act_remap.maxsouls = TUNING.WORTOX_MAX_SOULS
    act_remap.distancemod = dist_mod
    act_remap.distanceperhop = dist_perhop
    act_remap.distancefloat = dist_souls
    act_remap.distancecount = math.clamp(math.ceil(dist_souls), 1, act_remap.maxsouls)
    act_remap.aimassisted = aimassisted
    if not ActionCanMapSoulhop(act_remap) then
        return nil
    end
    return act_remap
end
