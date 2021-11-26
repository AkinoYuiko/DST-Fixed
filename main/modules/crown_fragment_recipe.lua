local AddRecipe = env.AddRecipe
GLOBAL.setfenv(1, GLOBAL)

AddRecipe("alterguardianhatshard_builder",
{ Ingredient("moonglass", 160) },
RECIPETABS.REFINE, TECH.LOST, nil, nil, nil, nil, nil, nil,"alterguardianhatshard.tex", nil, "alterguardianhatshard")

AddRecipe("alterguardianhat",
{ Ingredient("alterguardianhatshard", 5), Ingredient("alterguardianhatshard_builder_blueprint", 1) },
nil, TECH.LOST, nil, nil, true)

STRINGS.NAMES.ALTERGUARDIANHATSHARD_BUILDER = STRINGS.NAMES.ALTERGUARDIANHATSHARD
STRINGS.RECIPE_DESC.ALTERGUARDIANHATSHARD = STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALTERGUARDIANHATSHARD
