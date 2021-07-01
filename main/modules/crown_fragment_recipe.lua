local _G = GLOBAL
local STRINGS = _G.STRINGS
local Ingredient = _G.Ingredient
local RECIPETABS = _G.RECIPETABS
local TECH = _G.TECH
local AllRecipes = _G.AllRecipes

AddRecipe(
    "alterguardianhatshard_builder", { Ingredient("moonglass", 160) },
    RECIPETABS.REFINE, TECH.LOST, nil, nil, nil, nil, nil, nil,
    "alterguardianhatshard.tex", nil, "alterguardianhatshard"
)

Recipe("alterguardianhat", { Ingredient("alterguardianhatshard", 5), Ingredient("alterguardianhatshard_builder_blueprint", 1) }, nil, TECH.LOST, nil, nil, true)

STRINGS.NAMES.ALTERGUARDIANHATSHARD_BUILDER = STRINGS.NAMES.ALTERGUARDIANHATSHARD
STRINGS.RECIPE_DESC.ALTERGUARDIANHATSHARD = STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALTERGUARDIANHATSHARD
