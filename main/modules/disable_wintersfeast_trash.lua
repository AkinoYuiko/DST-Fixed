GLOBAL.setfenv(1, GLOBAL)

local NUM_BASIC_ORNAMENT = 12
local muted_loot_prefabs = {}
for i = 1, NUM_BASIC_ORNAMENT do
	muted_loot_prefabs["winter_ornament_plain" .. tostring(i)] = true
end
for i = 1, NUM_WINTERFOOD do
	muted_loot_prefabs["winter_food" .. tostring(i)] = true
end

local LootDropper = require("components/lootdropper")
local spawn_loot_prefab = LootDropper.SpawnLootPrefab
function LootDropper:SpawnLootPrefab(lootprefab, ...)
	if not muted_loot_prefabs[lootprefab] then
		return spawn_loot_prefab(self, lootprefab, ...)
	end
end
