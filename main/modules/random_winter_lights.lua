local _G = GLOBAL
local TECH = _G.TECH
local TUNING = _G.TUNING
local STRINGS = _G.STRINGS
local AllRecipes = _G.AllRecipes
local Ingredient = _G.Ingredient
local RECIPETABS = _G.RECIPETABS
local CHARACTER_INGREDIENT = _G.CHARACTER_INGREDIENT

STRINGS.NAMES.WINTER_LIGHT_BUILDER = STRINGS.NAMES.WINTER_ORNAMENTLIGHT
STRINGS.RECIPE_DESC.WINTER_LIGHT_BUILDER = STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINTER_ORNAMENTLIGHT

AddRecipe("winter_light_builder",
{Ingredient("fireflies", 3)},
RECIPETABS.LIGHT, TECH.SCIENCE_TWO, nil, nil, nil, nil, nil,
"images/light_builder.xml", "light_builder.tex" )
