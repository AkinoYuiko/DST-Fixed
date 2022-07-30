GLOBAL.setfenv(1, GLOBAL)
local UpvalueUtil = require("upvalueutil")

local FUELTYPE = "nightmarefuel"
local CHS_CODE = {
    zh = true,
    zht = true,
    chs = true,
}
STRINGS.ACTIONS.BLINK_MAP.GENERIC = CHS_CODE[LanguageTranslator.defaultlan] and "传送({uses})" or "Telepoof({uses})"

local function IsMioBoosted(doer)
    return doer and doer.prefab == "miotan" and doer.boosted_task
end

local function ValidateUses(act)
    if act.invobject and act.invobject.components.blinkstaff then
        local num = act.distancecount

        if IsMioBoosted(act.doer) then
            local is_fuel_enough, fuel_num = act.doer.components.inventory:Has(FUELTYPE, num)
            local staffuses = act.invobject.components.finiteuses.current
            return is_fuel_enough or (fuel_num + staffuses) >= num
        end
        return act.invobject.components.finiteuses.current >= num
    end
end

local function onblink_map(act)
    local act_pos = act:GetActionPoint()
    local ret = act.invobject.components.blinkstaff:Blink(act_pos, act.doer)
    -- Cunsume Extra Uses
    local num = act.distancecount - 1
    if num > 0 then
        for i = 1, num do
            act.invobject.components.blinkstaff.onblinkfn(act.invobject, act_pos, act.doer)
        end
    end
    return ret
end

local blink_map_code = ACTIONS_MAP_REMAP[ACTIONS.BLINK.code]

local action_can_map_soulhop = UpvalueUtil.GetUpvalue(ACTIONS.BLINK_MAP.fn, "ActionCanMapSoulhop")

local function ActionCanMapSoulhop(act)
    if act.invobject and act.invobject.components.blinkstaff and act.doer and ValidateUses(act) then
        return true
    end
    return action_can_map_soulhop(act)
end
UpvalueUtil.SetUpvalue(ACTIONS.BLINK_MAP.fn, "ActionCanMapSoulhop", ActionCanMapSoulhop)

local blink_map_fn = ACTIONS.BLINK_MAP.fn
ACTIONS.BLINK_MAP.fn = function(act)
    if ActionCanMapSoulhop(act) then
        if act.invobject and act.invobject.components.blinkstaff and ValidateUses(act) then
            return onblink_map(act)
        end
    end
    return blink_map_fn(act)
end

local blink_map_stroverridefn = ACTIONS.BLINK_MAP.stroverridefn
ACTIONS.BLINK_MAP.stroverridefn = function(act)
    local blinkstaff = act.invobject and act.invobject.components.blinkstaff
    local doer = act.doer

    if blinkstaff and doer then
        if IsMioBoosted(doer) then
            if doer.replica.inventory:Has(FUELTYPE, 1) then
                return subfmt(STRINGS.ACTIONS.BLINK_MAP.FUEL, { uses = act.distancecount, })
            end
        end
        return subfmt(STRINGS.ACTIONS.BLINK_MAP.GENERIC, { uses = act.distancecount, })
    end
    return blink_map_stroverridefn(act)
end
