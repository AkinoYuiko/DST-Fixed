-- local AddRecipeToFilter = AddRecipeToFilter

local function initprint(...)
    if KnownModIndex:IsModInitPrintEnabled() then
        local modname = getfenvminfield(3, "modname")
        print(ModInfoname(modname), ...)
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

local function AddRecipe(name, ingredients, tech, config, extra_filters)
    initprint("AddRecipe2", name)
    require("recipe")
    mod_protect_Recipe = false
    local rec = Recipe2(name, ingredients, tech, config)

    if not rec.is_deconstruction_recipe then

        if config and config.nounlock then
            AddRecipeToFilter(name, CRAFTING_FILTERS.CRAFTING_STATION.name)
        end

        if config and config.builder_tag then
			AddRecipeToFilter(name, CRAFTING_FILTERS.CHARACTER.name)
        end

        if config and config.nomods == nil then
			AddRecipeToFilter(name, CRAFTING_FILTERS.MODS.name)
        end

        if extra_filters then
            for _, filter_name in ipairs(extra_filters) do
                AddRecipeToFilter(name, filter_name)
            end
        end
    end

    mod_protect_Recipe = true
    rec:SetModRPCID()
    return rec
end

local function sort_recipe(a, b, filter_name, offset)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end

        table.insert(filter.recipes, target_position, a)
    end
end

local function SortBefore(a, b, filter_name)
    sort_recipe(a, b, filter_name, 0)
end

local function SortAfter(a, b, filter_name)
    sort_recipe(a, b, filter_name, 1)
end

return {
    AddRecipe   = AddRecipe,
    SortBefore  = SortBefore,
    SortAfter   = SortAfter
}
