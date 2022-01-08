-- local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
    table.insert(LootTables["beequeen"], {"giftwrap_blueprint",1})
end
