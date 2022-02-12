GLOBAL.setfenv(1, GLOBAL)

local function check_build_name(s)
    return s == "hat_alterguardian" or table.contains(PREFAB_SKINS["alterguardianhat"], s)
end

local function check_alterguardianhat(s, b)
    return s == "swap_hat" and check_build_name(b)
end

local animstate_override_symbol = AnimState.OverrideSymbol
function AnimState:OverrideSymbol(symbol, build, ...)
    if check_alterguardianhat(symbol, build) then
        return
    else
        return animstate_override_symbol(self, symbol, build, ...)
    end
end

local animstate_override_item_skin_symbol = AnimState.OverrideItemSkinSymbol
function AnimState:OverrideItemSkinSymbol(symbol, build, ...)
    if check_alterguardianhat(symbol, build) then
        return
    else
        return animstate_override_item_skin_symbol(self, symbol, build, ...)
    end
end
