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

	-- The Equipment --
	EQUIPMENT = "repairable_equipment",
	LUNARCROWN = "enhanced_alterguardianhat",
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

	-- The Recipe --
	RANDOMLIGHTS = "random_winter_lights",
	CROWNFRAGMENT = "crown_fragment_recipe",
	TURFARCHIVE = "turf_archive_recipe",
	PROPSIGN = "craftable_prop_sign",

	-- Removed --
	-- STAFF = "caller_staff_use_on_equip",
	-- BEEFALO = "beefalo_nogreeting",
}

for config, module in pairs(config_table) do
	if GetModConfigData(config) then
		modimport("main/modules/" .. module)
	end
end

-- angri_BOT boss death tips --
for _,v in pairs(GLOBAL.ModManager:GetEnabledModNames()) do
	if table.contains({"Glassic API", "Glassic API - DEV"}, GLOBAL.KnownModIndex:GetModInfo(v).name) then
		modimport("main/modules/angri_bot_events_log")
		break
	end
end

-- Some temp fixes, since klei is too down bad
-- Wang wang wang!
local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

-- Fix active_item's stack-lost when swimming
local Inventory = require("components/inventory")
function Inventory:DropActiveItem()
    if self.activeitem then
        local active_item = self:DropItem(self.activeitem, true) -- Do whole stack
        self:SetActiveItem(nil)
		return active_item
    end
end

-- Fix abandon ship board invalid
AddStategraphPostInit("wilson", function(self)
    local onenter = self.states["abandon_ship_pre"].onenter
    self.states["abandon_ship_pre"].onenter = function(inst, ...)
		if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.ABANDON_SHIP then
			inst.sg.statemem.action = inst.bufferedaction
		end
		if onenter then
        	return onenter(inst, ...)
		end
    end

    local onexit = self.states["abandon_ship_pre"].onexit
    self.states["abandon_ship_pre"].onexit = function(inst, ...)
		local bufferedaction = inst.sg.statemem.action
		if bufferedaction and bufferedaction:IsValid() then
			bufferedaction:Do()
		end
		if onexit then
        	return onexit(inst, ...)
		end
    end
end)
