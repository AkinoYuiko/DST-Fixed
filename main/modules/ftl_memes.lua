local AddSimPostInit = AddSimPostInit
GLOBAL.setfenv(1, GLOBAL)

local function check_added(t, loot)
    if type(t) ~= "table" then return end

    for _, tab in ipairs(t) do
        if type(tab) == "table" and tab[1] == loot then
            return true
        end
    end
end


local function insert_loottable(prefab, loot, chance)
    local loottable = LootTables[prefab]
    if not check_added(loottable, loot) then
        table.insert(LootTables[prefab], {loot, chance})
    end
end

AddSimPostInit(function(self)
    insert_loottable("penguin", "lightninggoathorn", 0.1)
    insert_loottable("mutated_penguin", "lightninggoathorn", 0.1)
end)

-- ftk classic strings.
scheduler:ExecuteInTime(0, function()
    local chs_languages = {
        zh = true,
        zht = true,
        chs = true,
    }

    if chs_languages[LanguageTranslator.defaultlang] then
        STRINGS.xxx = "断开连接"
        -- print("Moose Strings Hack!")
    else
        STRINGS.xxx = "null"
    end
end)
