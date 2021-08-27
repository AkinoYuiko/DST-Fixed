local ENV = env
GLOBAL.setfenv(1, GLOBAL)
local AddRecipe = ENV.AddRecipe
local AddRecipeTab = ENV.AddRecipeTab

AddRecipe("turf_archive",
{Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)},
RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE, nil, nil, true)
