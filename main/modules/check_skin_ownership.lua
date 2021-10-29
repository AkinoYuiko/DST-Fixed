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

local Skinner = require("components/skinner")

function Skinner:SetSkinMode(skintype, default_build, ...)
    skintype = skintype or self.skintype
	local base_skin = ""

	self.skintype = skintype

	if self.skin_data == nil then
		--fix for legacy saved games with already spawned players that don't have a skin_name set
		self:SetSkinName(self.inst.prefab.."_none")
	end

	if skintype == "ghost_skin" then
		--DST characters should all be using self.skin_data, ghostbuild is legacy for mod characters
		base_skin = self.skin_data[skintype] or self.skin_data["normal_skin"] or self.inst.ghostbuild or default_build or "ghost_" .. self.inst.prefab .. "_build" -- Changed Part
	else
		base_skin = self.skin_data[skintype] or self.skin_data["normal_skin"] or default_build or self.inst.prefab -- Changed Part
	end

	SetSkinsOnAnim( self.inst.AnimState, self.inst.prefab, base_skin, self.clothing, skintype, default_build )

	self.inst.Network:SetPlayerSkin( self.skin_name or "", self.clothing["body"] or "", self.clothing["hand"] or "", self.clothing["legs"] or "", self.clothing["feet"] or "" )
end
