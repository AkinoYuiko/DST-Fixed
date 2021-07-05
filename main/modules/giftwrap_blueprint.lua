local LootTables = GLOBAL.LootTables
AddPrefabPostInit("beequeen", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	-- giftwrap_added = true
	for _,v in pairs(LootTables["beequeen"]) do
		if table.contains(v,"giftwrap_blueprint") then return end
	end
	table.insert(LootTables["beequeen"],{"giftwrap_blueprint",1})
end)