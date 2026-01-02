local get_action_fail_string = GLOBAL.GetActionFailString
GLOBAL.setfenv(1, GLOBAL)

GetActionFailString = function(inst, action, reason, ...)
	local str = get_action_fail_string(inst, action, reason, ...)
	if str == STRINGS.CHARACTERS.GENERIC.ACTIONFAIL_GENERIC then
		local character = string.upper(type(inst) == "string" and inst or inst.prefab)
		return STRINGS.CHARACTERS[character] and STRINGS.CHARACTERS[character].ACTIONFAIL_GENERIC or str
	end
	return str
end
