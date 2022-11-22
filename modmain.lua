Assets = {}
PrefabFiles = {}

local config_table = {
    -- Default On --
    BUNDLE = "show_bundle",
    -- The Player --
    ATKSPEED = "attack_speed",
    SMARTUNWRAP = "smart_unwrap",
    CHECKSKINOWNERSHIP = "check_skin_ownership",
    SITEMOTE = "static_sit_emote",
    CUSTOMFAILSTR = "custom_actionfail_strings",
    NOGHOSTHOUNDED = "no_ghost_hounded",
    LOCALIZEDESC = "localize_description",
    WORTOXTIMETRAVEL = "jump_into_watch",
    EVERYONEMAGICHAT = "everyone_magic_hat",
    FTKMEMES = "ftk_memes",

    -- The Equipment --
    BLINK_MAP = "blink_map",
    EQUIPMENT = "repairable_equipment",
    HIDELUNARCROWN = "hide_inactive_alterguardianhat",
    LUNARCROWN = "enhanced_alterguardianhat",
    BOOKMOON = "enhanced_book_moon",
    SANDSTONE = "enhanced_sandstone",
    NAMEABLE_WATCHES = "nameable_watches",
    NODARTWASTE = "no_lost_blowdart",
    POCKETRESKIN = "pocket_reskin",
    BEEQUEENHAT = "facking_hivehat",
    MHATS = "glowing_mushroom_hats",

    -- The Builder --
    BETTERFOSSIL = "easy_fossil_stalker",
    FIREFLIES = "fireflies_into_lamp",
    SISTURN = "enhanced_sisturn",
    GLOMMER = "repairable_statueglommer",
    COOKPOT = "no_dismantle_cookpot",
    LUREPLANT = "classic_lureplant",
    ENDTABLE = "floating_burnt_endtable",

    -- The Mob --
    BIRD = "birds_no_sleep",
    BLOCKABLEPOOPING = "blockable_pooping",
    TENTACLE = "tentacle_pillar_noloot",
    BEEQUEENGIFTWRAP = "giftwrap_blueprint",

    -- The World --
    SEED = "disable_seedrots",
    FLOWER = "nopicking_evil_flower",
    NOOCEANTREESTRIKEDROP = "no_oceantree_strike_drop",
    SUMMONMAGIC = "summon_magic",
    HONORMOUND = "honor_mound",
    BAT = "bats_attack_eyeturret",
    GATHERMOONGLASS = "gather_moonglass",
    PIGKINGMOONGLASS = "pigking_reward_moonglass",
    NOFORESTRESOURCEREGEN = "disable_forestresouce_regen",
    HALLOWEEN = "disable_halloween_candies",
    WINTERSFEASTLOOTS = "disable_wintersfeast_trash",

    -- The Recipe --
    RANDOMLIGHTS = "random_winter_lights",
    CROWNFRAGMENT = "crown_fragment_recipe",
    PROPSIGN = "craftable_prop_sign",
    CLASSICBOOKGARDENING = "book_gardening_recipe",

}

for config, module in pairs(config_table) do
    if GetModConfigData(config) then
        modimport("main/modules/" .. module)
    end
end

-- Some temp fixes, since klei is too down bad
local asscleaner = {
    "abandon_ship_board",
    "active_item_stack",
    "dummytarget_dps",
    "getmapaction_pos",
    "wx78_delay_remove_grueimmunity",
}

for _, v in ipairs(asscleaner) do
    modimport("main/asscleaner/" .. v)
end
