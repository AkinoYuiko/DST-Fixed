local function initprint(...)
    if KnownModIndex:IsModInitPrintEnabled() then
        local modname = getfenvminfield(3, "modname")
        print(ModInfoname(modname), ...)
    end
end

-- set a recipe not listed in search filter or "EVERYTHING".
local function RecipeNoSearch(recipe)
    local CraftingMenuWidget = require("widgets/redux/craftingmenu_widget")
    local is_recipe_valid_for_search = CraftingMenuWidget.IsRecipeValidForSearch
    function CraftingMenuWidget:IsRecipeValidForSearch(name)
        local ret = {is_recipe_valid_for_search(self, name)}
        if name == recipe then
            return
        end
        return unpack(ret)
    end
end

local function AddRecipeToFilter(recipe_name, filter_name)
    initprint("AddRecipeToFilter", recipe_name, filter_name)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter ~= nil and filter.default_sort_values[recipe_name] == nil then
        table.insert(filter.recipes, recipe_name)
        filter.default_sort_values[recipe_name] = #filter.recipes
    end
end

-- a smarter way to add a mod recipe, and you don't need to think about filters too much.
-- also, with confog.hidden, you can set your recipe no searching or in "EVERYTHING" filter.
-- same format as AddRecipe2
local function AddRecipe(name, ingredients, tech, config, filters)
    initprint("AddRecipe2", name)
    require("recipe")
    mod_protect_Recipe = false
    local rec = Recipe2(name, ingredients, tech, config)

    if not rec.is_deconstruction_recipe then

        if config and config.nounlock then
            AddRecipeToFilter(name, CRAFTING_FILTERS.CRAFTING_STATION.name)
        end

        if config and config.builder_tag and config.nochar == nil then
            AddRecipeToFilter(name, CRAFTING_FILTERS.CHARACTER.name)
        end

        if config and config.nomods == nil then
            AddRecipeToFilter(name, CRAFTING_FILTERS.MODS.name)
        end

        if config and config.hidden then
            RecipeNoSearch(name)
        end

        if filters then
            for _, filter_name in ipairs(filters) do
                AddRecipeToFilter(name, filter_name)
            end
        end
    end

    mod_protect_Recipe = true
    rec:SetModRPCID()
    return rec
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
local function get_index(t, v)
    for index, value in pairs(t) do
        if value == v then
            return index
        end
    end
end

local function do_sorting(a, b, filter_name, offset, force_sort)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes and type(filter.recipes) == "table" then
        local target_position
        local recipes = filter.recipes
        if get_index(recipes, a) then
            if force_sort or table.contains(recipes, b) then
                recipes[get_index(recipes, a)] = nil
                target_position = #recipes + 1
            end
        end

        if get_index(recipes, b) then
            target_position = get_index(recipes, b) + offset
        end

        if type(target_position) == "number" then
            table.insert(recipes, target_position, a)
            filter.default_sort_values[a] = filter.default_sort_values[a] or #recipes
        end
    end
end

local function try_sorting(a, b, filter_type, offset)
    if filter_type then
        do_sorting(a, b, filter_type, offset, true)
    elseif b then
        for filter, data in pairs(CRAFTING_FILTERS) do
            do_sorting(a, b, filter, offset)
        end
    end
end

-- a quick way to sort recipes before or after current recipes.
---@param a string - the recipe name that you want to sort
---@param b string - the target recipe name that we base on.
---@param filter_type string
-- e.g. RecipeSortAfter("darkcrystal", "purplegem") will sort "darkcrystal" after "purplegem" in all filters that "purplegem" has.
-- e.g. RecipeSortAfter("darkcrystal", "purplegem", "MAGIC") will only sort "darkcrystal" after "purplegem" in "MAGIC" filter.
-- e.g. RecipeSortAfter("darkcrystal", "purplegem", "TOOLS") will only sort "darkcrystal" to the last in "TOOLS" because "purplegem" is not in "TOOLS".
-- one of b and filter_type must not be nil.
local function SortBefore(a, b, filter_type)
    try_sorting(a, b, filter_type, 0)
end

local function SortAfter(a, b, filter_type)
    try_sorting(a, b, filter_type, 1)
end

return {
    AddRecipe   = AddRecipe,
    SortBefore  = SortBefore,
    SortAfter   = SortAfter,
}
