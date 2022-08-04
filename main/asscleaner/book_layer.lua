local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local book_list = {
    "book_birds",
    "book_horticulture",
    "book_silviculture",
    "book_sleep",
    "book_brimstone",
    "book_tentacles",

    "book_fish",
    "book_fire",
    "book_web",
    "book_temperature",
    "book_light",
    "book_rain",
    "book_moon",
    "book_bees",
    "book_research_station",
}

local function book_layer_fn(book)
    if book.def then
        if book.def.layer == nil then
            book.def.layer = ""
        end
    end
end

for _, book in ipairs(book_list) do
    AddPrefabPostInit(book, book_layer_fn)
end
