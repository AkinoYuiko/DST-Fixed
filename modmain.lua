Assets = {
	Asset( "ANIM", "anim/stagehand_fix.zip" ),
	Asset( "ANIM", "anim/ui_showbundle.zip" ),
	Asset( "ANIM", "anim/ui_showbundle_3x2.zip" ),
	Asset( "ATLAS", "images/light_builder.xml" ),
}

PrefabFiles = {
	-- "honor_hound",
	-- "winter_light_builder",
	-- "townportal_shadow",
}

local function ImportModuleForConfig(config, module)
	if GetModConfigData(config) then
		modimport("main/modules/"..module)
	end
end

local config_table = {
	BUNDLE = "show_bundle",
	EQUIPMENT = "repairable_equipment",
	SEED = "disable_seedrots",
	SISTURN = "enhanced_sisturn",
	FLOWER = "nopicking_evil_flower",
	BIRD = "birds_no_sleep",
	BAT = "bats_attack_eyeturret",
	STAFF = "caller_staff_use_on_equip",
	FIREFLIES = "fireflies_into_lamp",
	RANDOMLIGHTS = {
		module = "random_winter_lights",
		prefabfiles = {
			"winter_light_builder"
		}
	},
	GLOMMER = "repairable_statueglommer",
	MHATS = "glowing_mushroom_hats",
	BEEFALO = "beefalo_nogreeting",
	COOKPOT = "no_dismantle_cookpot",
	TENTACLE = "tentacle_pillar_noloot",
	SANDSTONE = {
		module = "enhanced_sandstone",
		prefabfiles = {
			"townportal_shadow"
		}
	},
	CHECKSKINOWNERSHIP = "check_skin_ownership",
	HALLOWEEN = "disable_halloween_candies",
	BEEQUEENHAT = "facking_hivehat",
	BEEQUEENGIFTWRAP = "giftwrap_blueprint",
	ATKSPEED = "attack_speed",
	LUREPLANT = "classic_lureplant",
	LUNARCROWN = "enhanced_alterguardianhat",
	CROWNFRAGMENT = "crown_fragment_recipe",
	BLOCKABLEPOOPING = "blockable_pooping",
	NOFORESTRESOURCEREGEN = "disable_forestresouce_regen",
	POCKETRESKIN = "pocket_reskin",
	NOGHOSTHOUNDED = "no_ghost_hounded",
	SITEMOTE = "static_sit_emote",
	NODARTWASTE = "no_lost_blowdart",
	GATHERMOONGLASS = "gather_moonglass",
	CUSTOMFAILSTR = "custom_actionfail_strings",
	ENDTABLE = "floating_burnt_endtable",
	PROPSIGN = "craftable_prop_sign",
	SUMMONMAGIC = "summon_magic",
	BETTERFOSSIL = "easy_fossil_stalker",
	SMARTUNWRAP = "smart_unwrap",
	TURFARCHIVE = "turf_archive_recipe",
	HONORMOUND = {
		module = "honor_mound",
		prefabfiles = {
			"honor_mound"
		}
	}
}

for k, v in pairs(config_table) do
	if type(v) == "string" then
		ImportModuleForConfig(k, v)
	elseif type(v) == "table" then
		ImportModuleForConfig(k, v["module"])
		for _, prefab in ipairs(v["prefabfiles"]) do
			table.insert(PrefabFiles, prefab)
		end
	end
end


-- Some temp fixes, since klei is too down bad
-- Wang wang wang!
local Inventory = require("components/inventory")
function Inventory:DropActiveItem()
    if self.activeitem ~= nil then
        local active_item = self:DropItem(self.activeitem, true) -- Do whole stack
        self:SetActiveItem(nil)
		return active_item
    end
end

AddStategraphPostInit("wilson", function(self)
    local onenter = self.states["abandon_ship_pre"].onenter
    self.states["abandon_ship_pre"].onenter = function(inst, ...)
		if inst.bufferedaction and inst.bufferedaction.action == GLOBAL.ACTIONS.ABANDON_SHIP then
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
