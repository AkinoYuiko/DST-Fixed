GLOBAL.setfenv(1, GLOBAL)

local CHARACTERLIST =
{
    "wilson",
    "willow",
    "wolfgang",
    "wendy",
    "wx78",
    "wickerbottom",
    "woodie",
    "wes",
    "waxwell",
    "wathgrithr",
    "webber",
    "winona",
    "warly",
    --DLC chars:
    -- "wortox",
    -- "wormwood",
    -- "wurt",
    "walter"
}

local CheckClientOwnership = InventoryProxy.CheckClientOwnership
InventoryProxy.CheckClientOwnership = function(self, ...)
    local args = {...}
    for _, character in ipairs(CHARACTERLIST) do
        if args[2] == character.."_none" then
            return true
        end
    end
    return CheckClientOwnership(self, unpack(args))
end

local OldValidateSpawnPrefabRequest = ValidateSpawnPrefabRequest
ValidateSpawnPrefabRequest = function(...)
    local REAL_PREFAB_SKINS = deepcopy(PREFAB_SKINS)
    local characterlist = GetActiveCharacterList()
    for _, character in ipairs(characterlist) do
        if PREFAB_SKINS[character] then
            for _, _character in ipairs(characterlist) do
                if REAL_PREFAB_SKINS[_character] then
                    for _, skin in ipairs(REAL_PREFAB_SKINS[_character]) do
                        table.insert(PREFAB_SKINS[character], skin)
                    end
                end
            end
        end
    end
    local ret = { OldValidateSpawnPrefabRequest(...) }
    PREFAB_SKINS = REAL_PREFAB_SKINS
    return unpack(ret)
end

local Wardrobe = require("components/wardrobe")

local ActivateChanging = Wardrobe.ActivateChanging
function Wardrobe:ActivateChanging(doer, skins, ...)
    local get_character_skin_bases = GetCharacterSkinBases
    GetCharacterSkinBases = function()
        local skins = {}
        for _, character in ipairs(GetActiveCharacterList()) do
            shallowcopy(get_character_skin_bases(character), skins)
        end
        return skins
    end
    local ret = { ActivateChanging(self, doer, skins, ...) }
    GetCharacterSkinBases = get_character_skin_bases
    return unpack(ret)
end
