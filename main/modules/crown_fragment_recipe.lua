local RecipeUtil = require("utils/recipe2util")
local AddRecipe = RecipeUtil.AddRecipe
local SortBefore = RecipeUtil.SortBefore
local SortAfter = RecipeUtil.SortAfter
local AddDeconstructRecipe = AddDeconstructRecipe
GLOBAL.setfenv(1, GLOBAL)

local IA_MODNAMES = {
    "workshop-1467214795",
    "IslandAdventures"
}
local IA_FANCY_NAME = "Island Adventures"

local function IsIA(modname, moddata)
    return table.contains(IA_MODNAMES, modname)
        or moddata.modinfo and moddata.modinfo.name == IA_FANCY_NAME
end

local function HasIA()
    for modname, moddata in pairs(KnownModIndex.savedata.known_mods) do
        if IsIA(modname, moddata) and KnownModIndex:IsModEnabledAny(modname) then
            return true
        end
    end
end

local has_ia_number = HasIA() and 40 or 160

AddRecipe("alterguardianhatshard", {Ingredient("moonglass", has_ia_number)}, TECH.LOST, {nomods = true, no_deconstruction = true}, {"REFINE"})
STRINGS.RECIPE_DESC.ALTERGUARDIANHATSHARD = STRINGS.CHARACTERS.GENERIC.DESCRIBE.ALTERGUARDIANHATSHARD

AddDeconstructRecipe("alterguardianhat", {Ingredient("alterguardianhatshard", 5), Ingredient("alterguardianhatshard_blueprint", 1)})
