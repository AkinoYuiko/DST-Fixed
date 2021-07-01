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

local _G = GLOBAL
local InventoryProxy = _G.InventoryProxy

local CheckClientOwnership = InventoryProxy.CheckClientOwnership
InventoryProxy.CheckClientOwnership = function(self, ...)
    local arg = {...}
    for _, character in ipairs(CHARACTERLIST) do
        if arg[2] == character.."_none" then
            return true
        end
    end
    return CheckClientOwnership(self, _G.unpack(arg))
end

local ValidateSpawnPrefabRequest = _G.ValidateSpawnPrefabRequest
_G.ValidateSpawnPrefabRequest = function(user_id, prefab_name, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet, ...)
    local characterlist = {}
    for _, v in ipairs(_G.DST_CHARACTERLIST) do
        table.insert(characterlist, v)
    end
    for _, v in ipairs(_G.MODCHARACTERLIST) do
        table.insert(characterlist, v)
    end
    local GLOBAL_PREFAB_SKINS = _G.PREFAB_SKINS
    local PREFAB_SKINS = _G.deepcopy(_G.PREFAB_SKINS)
    for _, character in ipairs(characterlist) do
        if _G.PREFAB_SKINS[character] then
            for _, _character in ipairs(characterlist) do
                if _G.PREFAB_SKINS[_character] then
                    for _, skin in ipairs(_G.PREFAB_SKINS[_character]) do
                        table.insert(PREFAB_SKINS[character], skin)
                    end
                end
            end
        end
    end
    _G.PREFAB_SKINS = PREFAB_SKINS
    local validated_prefab, validated_skin_base, validated_clothing_body, validated_clothing_hand, validated_clothing_legs, validated_clothing_feet = ValidateSpawnPrefabRequest(user_id, prefab_name, skin_base, clothing_body, clothing_hand, clothing_legs, clothing_feet, ...)
    _G.PREFAB_SKINS = GLOBAL_PREFAB_SKINS
    return validated_prefab, validated_skin_base, validated_clothing_body, validated_clothing_hand, validated_clothing_legs, validated_clothing_feet
end