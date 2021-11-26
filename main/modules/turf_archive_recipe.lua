local AddRecipe = env.AddRecipe
GLOBAL.setfenv(1, GLOBAL)

AddRecipe("turf_archive",
{Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)},
RECIPETABS.TURFCRAFTING, TECH.TURFCRAFTING_ONE, nil, nil, true)
