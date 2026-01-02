local AddSimPostInit = AddSimPostInit
GLOBAL.setfenv(1, GLOBAL)

AddSimPostInit(function(self)
	local loots = LootTables["beequeen"]
	if loots and not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		table.insert(loots, { "giftwrap_blueprint", 1.00 })
	end
end)
