local RecipeUtil = require("utils/recipe2util")
local AddRecipe = RecipeUtil.AddRecipe
GLOBAL.setfenv(1, GLOBAL)

AddRecipe("turf_archive", {Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)}, TECH.TURFCRAFTING_ONE, {nomods = true}, {"DECOR"})
