local _G = GLOBAL
local STRINGS = _G.STRINGS

local GetActionFailString = _G.GetActionFailString
_G.GetActionFailString = function(inst, action, reason, ...)
    local str = GetActionFailString(inst, action, reason, ...)
    if str == STRINGS.CHARACTERS.GENERIC.ACTIONFAIL_GENERIC then
        local character = string.upper(type(inst) == "string" and inst or inst.prefab)
        return STRINGS.CHARACTERS[character]
            and STRINGS.CHARACTERS[character].ACTIONFAIL_GENERIC
            or str
    end
    return str
end
