Assets = {
	Asset("ANIM", "anim/ui_showbundle.zip"),
	Asset("ANIM", "anim/ui_showbundle_3x2.zip"),
	Asset( "ATLAS", "images/light_builder.xml" ),
}

PrefabFiles = {
	"winter_light_builder",
	"townportal_shadow",
}

if GetModConfigData("BUNDLE") then modimport("scripts/modules/show_bundle.lua") end
if GetModConfigData("EQUIPMENT") then modimport("scripts/modules/repairable_equipment.lua") end
if GetModConfigData("SEED") then modimport("scripts/modules/disable_seedrots.lua") end
if GetModConfigData("SISTURN") then modimport("scripts/modules/enhanced_sisturn.lua") end
if GetModConfigData("FLOWER") then modimport("scripts/modules/nopicking_evil_flower.lua") end
if GetModConfigData("BIRD") then modimport("scripts/modules/birds_no_sleep.lua") end
if GetModConfigData("BAT") then modimport("scripts/modules/bats_attack_eyeturret.lua") end
if GetModConfigData("STAFF") then modimport("scripts/modules/caller_staff_use_on_equip.lua") end
if GetModConfigData("FIREFLIES") then modimport("scripts/modules/fireflies_into_lamp.lua") end
if GetModConfigData("RANDOMLIGHTS") then modimport("scripts/modules/random_winter_lights.lua") end
if GetModConfigData("GLOMMER") then modimport("scripts/modules/repairable_statueglommer.lua") end
if GetModConfigData("MHATS") then modimport("scripts/modules/glowing_mushroom_hats.lua") end
if GetModConfigData("BEEFALO") then modimport("scripts/modules/beefalo_nogreeting.lua") end
if GetModConfigData("COOKPOT") then modimport("scripts/modules/no_dismantle_cookpot.lua") end
if GetModConfigData("TENTACLE") then modimport("scripts/modules/tentacle_pillar_noloot.lua") end
if GetModConfigData("SANDSTONE") then modimport("scripts/modules/enhanced_sandstone.lua") end
if GetModConfigData("CHECKSKINOWNERSHIP") then modimport("scripts/modules/check_skin_ownership.lua") end
if GetModConfigData("HALLOWEEN") then modimport("scripts/modules/disable_halloween_candies.lua") end
if GetModConfigData("BEEQUEENHAT") then modimport("scripts/modules/facking_hivehat.lua") end
if GetModConfigData("BEEQUEENGIFTWRAP") then modimport("scripts/modules/giftwrap_blueprint.lua") end
if GetModConfigData("ATKSPEED") then modimport("scripts/modules/attack_speed.lua") end
if GetModConfigData("LUREPLANT") then modimport("scripts/modules/classic_lureplant.lua") end
if GetModConfigData("LUNARCROWN") then modimport("scripts/modules/enhanced_alterguardianhat.lua") end
if GetModConfigData("CROWNFRAGMENT") then modimport("scripts/modules/crown_fragment_recipe.lua") end
if GetModConfigData("BLOCKABLEPOOPING") then modimport("scripts/modules/blockable_pooping.lua") end
if GetModConfigData("NOFORESTRESOURCEREGEN") then modimport("scripts/modules/disable_forestresouce_regen.lua") end
if GetModConfigData("POCKETRESKIN") then modimport("scripts/modules/pocket_reskin.lua") end
if GetModConfigData("NOGHOSTHOUNDED") then modimport("scripts/modules/no_ghost_hounded.lua") end
