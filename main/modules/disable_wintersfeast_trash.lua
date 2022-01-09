GLOBAL.setfenv(1, GLOBAL)

local LootDropper = require("components/lootdropper")
-- local drop_loot = LootDropper.DropLoot
-- function LootDropper:DropLoot(pt, ...)
--     local is_winters_feast = IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) -- do record event
--     if is_winters_feast then

--         -- do hacking
--         local is_special_event_active = IsSpecialEventActive
--         IsSpecialEventActive = function(event)
--             return false
--         end

--         drop_loot(self, pt, ...)

--         -- drop loot post fn
--         local prefabname = string.upper(self.inst.prefab)
--         local num_decor_loot = self.GetWintersFeastOrnaments ~= nil and self.GetWintersFeastOrnaments(self.inst) or TUNING.WINTERS_FEAST_TREE_DECOR_LOOT[prefabname] or nil
--         if num_decor_loot ~= nil then
--             -- for i = 1, num_decor_loot.basic do
--             --     self:SpawnLootPrefab(GetRandomBasicWinterOrnament(), pt)
--             -- end
--             if num_decor_loot.special ~= nil then
--                 self:SpawnLootPrefab(num_decor_loot.special, pt)
--             end
--         end

--         -- restore IsSpecialEventActive
--         IsSpecialEventActive = is_special_event_active
--     else
--         drop_loot(self, pt, ...)
--     end
-- end

local NUM_BASIC_ORNAMENT = 12
local muted_loot_prefabs = {}
for i = 1, NUM_BASIC_ORNAMENT do
    muted_loot_prefabs[#muted_loot_prefabs + 1] = "winter_ornament_plain" .. i
end
for i = 1, NUM_WINTERFOOD do
    muted_loot_prefabs[#muted_loot_prefabs + 1] = "winter_food" .. i
end

local spawn_loot_prefab = LootDropper.SpawnLootPrefab
function LootDropper:SpawnLootPrefab(lootprefab, ...)
    if not table.contains(muted_loot_prefabs, lootprefab) then
        return spawn_loot_prefab(self, lootprefab, ...)
    end
end
