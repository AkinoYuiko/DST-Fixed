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
