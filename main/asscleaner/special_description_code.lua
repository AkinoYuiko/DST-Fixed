local AddPlayerPostInit = AddPlayerPostInit
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

-- local official_prefabs = {
--     "mermwatchtower",
--     "singingshell_octave5",
--     "singingshell_octave4",
--     "singingshell_octave3",
-- }

local function mermwatchtower_special_description_code(inst, viewer)
    if TheWorld.components.mermkingmanager and TheWorld.components.mermkingmanager:HasKing() then
        return GetStringCode(viewer.prefab, "DESCRIBE", "MERMWATCHTOWER_REGULAR" )
    else
        return GetStringCode(viewer.prefab, "DESCRIBE", "MERMWATCHTOWER_NOKING" )
    end
end
AddPrefabPostInit("mermwatchtower", function(inst)
    if not TheWorld.ismastersim then return end

    inst.components.inspectable.special_description_code = mermwatchtower_special_description_code
end)

-- function subfmt(s, tab)
--     return (s:gsub('(%b{})', function(w) return tab[w:sub(2, -2)] or w end))
-- end

-- local function singingshell_special_description_code(inst, viewer)
-- 	return subfmt(GetDescription(viewer, inst, "GENERIC"), {note = NOTES[inst.components.cyclable.step]})
-- end
-- AddPrefabPostInit("mermwatchtower", function(inst)
--     if not TheWorld.ismastersim then return end

--     inst.components.inspectable.special_description_code = singingshell_special_description_code
-- end)

------------------------------------
----------  PLAYER COMMON ----------
------------------------------------
local function TryDescribe(descstrings, modifier)
    return descstrings ~= nil and (
            type(descstrings) == "string" and
            descstrings or
            descstrings[modifier] or
            descstrings.GENERIC
        ) or nil
end

local function TryCharStrings(inst, charstrings, modifier)
    return charstrings ~= nil and (
            TryDescribe(charstrings.DESCRIBE[string.upper(inst.prefab)], modifier) or
            TryDescribe(charstrings.DESCRIBE.PLAYER, modifier)
        ) or nil
end

local function GetDescription(inst, viewer)
    local modifier = inst.components.inspectable:GetStatus(viewer) or "GENERIC"
    return string.format(
            TryCharStrings(inst, STRINGS.CHARACTERS[string.upper(viewer.prefab)], modifier) or
            TryCharStrings(inst, STRINGS.CHARACTERS.GENERIC, modifier),
            inst:GetDisplayName()
        )
end

-- AddPlayerPostInit(function(inst)
--     if not TheWorld.ismastersim then return end
--     if inst.components.inspectable then
--         inst.components.inspectable.getspecialdescription = GetDescription
--     end
-- end)
