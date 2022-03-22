local AddSimPostInit = AddSimPostInit
local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

local CHINESE_CODES = {
    zh = true,
    zht = true,
    chs = true,
}

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

AddSimPostInit(function()
    insert_loottable("penguin", "lightninggoathorn", 0.02)
    insert_loottable("mutated_penguin", "lightninggoathorn", 0.02)

    -- FTK classic strings
    if CHINESE_CODES[LanguageTranslator.defaultlang] then
        STRINGS.UI.NOTIFICATION.LEFTGAME = "%s 已断开连接。"
        STRINGS.CHARACTERS.GENERIC.ANNOUNCE_STILLALIVE = "仍然活着"
    else
        STRINGS.UI.NOTIFICATION.LEFTGAME = "%s has disconnected."
        STRINGS.CHARACTERS.GENERIC.ANNOUNCE_STILLALIVE = "Still Alive"
    end
    if rawget(_G, "STRCODE_TALKER") then
        STRCODE_TALKER[STRINGS.UI.NOTIFICATION.LEFTGAME] = "UI.NOTIFICATION.LEFTGAM"
        STRCODE_TALKER[STRINGS.CHARACTERS.GENERIC.ANNOUNCE_STILLALIVE] = "CHARACTERS.GENERIC.ANNOUNCE_STILLALIVE"
    end
end)

local still_alive_event = TimeEvent(3 * FRAMES, function(inst)
    inst.components.talker:Say(GetString(inst, "ANNOUNCE_STILLALIVE"), 4)
end)
AddStategraphPostInit("wilson", function(self)
    local timeline = self.states["amulet_rebirth"].timeline
    for i, v in ipairs(timeline) do
        if v.time > still_alive_event.time then
            table.insert(timeline, math.max(i, 1), still_alive_event)
            break
        end
    end
end)
