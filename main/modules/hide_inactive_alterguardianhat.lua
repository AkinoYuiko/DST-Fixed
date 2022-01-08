GLOBAL.setfenv(1, GLOBAL)

local animstate_override_symbol = AnimState.OverrideSymbol
function AnimState:OverrideSymbol(symbol, build, ...)
    if symbol == "swap_hat" and build == "hat_alterguardian" then
        return
    else
        return animstate_override_symbol(self, symbol, build, ...)
    end
end

local animstate_override_item_skin_symbol = AnimState.OverrideItemSkinSymbol
function AnimState:OverrideItemSkinSymbol(symbol, build, ...)
    if symbol == "swap_hat" and table.contains(PREFAB_SKINS["alterguardianhat"], build) then
        return
    else
        return animstate_override_item_skin_symbol(self, symbol, build, ...)
    end
end
