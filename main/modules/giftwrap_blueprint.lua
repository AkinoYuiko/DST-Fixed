local AddSimPostInit = AddSimPostInit
GLOBAL.setfenv(1, GLOBAL)

local function check_added(t)
    if type(t) ~= "table" then return end

    for _, tab in ipairs(t) do
        if type(tab) == "table" and tab[1] == "giftwrap_blueprint" then
            return true
        end
    end
end

AddSimPostInit(function(self)
    local lootable = LootTables["beequeen"]
    if not check_added(lootable) and not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
        table.insert(LootTables["beequeen"], {"giftwrap_blueprint", 1.00})
    end
end)
