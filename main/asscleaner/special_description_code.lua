local AddPlayerPostInit = AddPlayerPostInit
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

--------------------------------------------------------
--------------------  PLAYER COMMON --------------------
--------------------------------------------------------

local function TryDescribe(base_str, descstrings, modifier)
    return descstrings and (
            type(descstrings) == "string" and base_str
            or descstrings[modifier] and base_str.."."..modifier
            or descstrings.GENERIC and base_str..".GENERIC"
        )
end

local function TryCharStrings(inst, base_str, charstrings, modifier)
    if charstrings then
        base_str = base_str..".DESCRIBE."
        local character = string.upper(inst.prefab)
        return TryDescribe(base_str..character, charstrings.DESCRIBE[character], modifier)
            or TryDescribe(base_str.."PLAYER", charstrings.DESCRIBE.PLAYER, modifier)
    end
end

local function GetDescription(inst, viewer)
    local modifier = inst.components.inspectable:GetStatus(viewer) or "GENERIC"
    local character = string.upper(viewer.prefab)
    local str = character
            and TryCharStrings(inst, "CHARACTERS."..character, STRINGS.CHARACTERS[character], modifier)
            or TryCharStrings(inst, "CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, modifier)
    local ret = {
        strtype = "format",
        content = str,
        params = {inst:GetDisplayName()}
    }
    return STRCODE_HEADER .. json.encode(ret)
end

AddPlayerPostInit(function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.inspectable then
        inst.components.inspectable.getspecialdescription = GetDescription
    end
end)

--------------------------------------------------------
----------------------  SKELETONS ----------------------
--------------------------------------------------------

local function getdesc(inst, viewer)
    if inst.char and not viewer:HasTag("playerghost") then
        local mod = GetGenderStrings(inst.char)
        -- local desc = GetDescriptionCode(viewer, inst, mod)
        local char = string.upper(inst.char)
        local name = inst.playername or STRINGS.NAMES[char] and STRCODE_HEADER..".NAMES."..char
        local params = {}
        --no translations for player killer's name
        if inst.pkname then
            params = {name, inst.pkname}
            return GetDescriptionCode(viewer, inst, mod, "format", params)
        end

        --permanent translations for death cause
        if inst.cause == "unknown" then
            inst.cause = "shenanigans"
        elseif inst.cause == "moose" then
            inst.cause = math.random() < .5 and "moose1" or "moose2"
        end

        --viewer based temp translations for death cause
        local cause =
            inst.cause == "nil"
            and (viewer == "waxwell" and
                "charlie" or
                "darkness")
            or inst.cause

        local caus = string.upper(cause)
        params = {name, STRCODE_HEADER .. "NAMES.".. (STRINGS.NAMES[caus] and caus or "SHENANIGANS")}
        return GetDescriptionCode(viewer, inst, mod, "format", params)
    end
end

AddPrefabPostInit("skeleton", function(inst)
    if not TheWorld.ismastersim then return end
    if inst.components.inspectable then
        inst.components.inspectable.getspecialdescription = getdesc
    end
end)
