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
    return EncodeStrCode(ret)
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

AddPrefabPostInit("skeleton_player", function(inst)
    if not TheWorld.ismastersim then return end

    local SetSkeletonDescription = inst.SetSkeletonDescription
    inst.SetSkeletonDescription = function(...)
        SetSkeletonDescription(...)
        inst.components.inspectable.getspecialdescription = getdesc
    end

    local onload = inst.OnLoad
    inst.OnLoad = function(...)
        onload(...)
        if inst.components.inspectable then
            inst.components.inspectable.getspecialdescription = getdesc
        end
    end
end)

--------------------------------------------------------
--------------------  SINGING SHELL --------------------
--------------------------------------------------------

local NOTES =
{
	"C",
	"C#",
	"D",
	"D#",
	"E",
	"F",
	"F#",
	"G",
	"G#",
	"A",
	"A#",
	"B",
}

local function shell_getdescription(inst, viewer)
	-- return subfmt(GetDescription(viewer, inst, "GENERIC"), {note = NOTES[inst.components.cyclable.step]})
	return GetDescriptionCode(viewer, inst, "GENERIC", "subfmt", {note = NOTES[inst.components.cyclable.step]})
end

local shells = {
    "singingshell_octave5",
    "singingshell_octave4",
    "singingshell_octave3",
}

local function shell_postinit(inst)
    if not TheWorld.ismastersim then return end
    inst.components.inspectable.descriptionfn = shell_getdescription
end

for _, prefab in ipairs(shells) do
    AddPrefabPostInit(prefab, shell_postinit)
end

--------------------------------------------------------
---------------------  DEATH EVENT ---------------------
--------------------------------------------------------

-- local EventAnnouncer = require("widgets/eventannouncer")
function GetNewDeathAnnouncementString(theDead, source, pkname, sourceispet)
    if not theDead or not source then return "" end

    -- local message = ""
    local msg_tab = {
        strtype = "format",
        content = {},
        params = {}
    }
    if source and not theDead:HasTag("playerghost") then
        if pkname ~= nil then
            local petname = sourceispet and STRINGS.NAMES[string.upper(source)] or nil
            if petname ~= nil then
                msg_tab.content = {
                    "$%s ",
                    "UI.HUD.DEATH_ANNOUNCEMENT_1",
                    "$ ",
                    "UI.HUD.DEATH_PET_NAME",
                }
                msg_tab.params = {
                    theDead:GetDisplayName(),
                    STRCODE_HEADER .. "NAMES." .. string.upper(source)
                }
                -- theDead:GetDisplayName().." "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." "..string.format(STRINGS.UI.HUD.DEATH_PET_NAME, pkname, petname)
            else
                msg_tab.content = {
                    "$%s ",
                    "UI.HUD.DEATH_ANNOUNCEMENT_1",
                    "$ %s",
                }
                msg_tab.params = {
                    theDead:GetDisplayName(),
                    pkname
                }
                -- message = theDead:GetDisplayName().." "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." "..pkname
            end
        elseif table.contains(GetActiveCharacterList(), source) then
            msg_tab.content = {
                "$%s ",
                "UI.HUD.DEATH_ANNOUNCEMENT_1",
                "$ %s",
            }
            msg_tab.params = {
                theDead:GetDisplayName(),
                FirstToUpper(source)
            }
            -- message = theDead:GetDisplayName().." "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." "..FirstToUpper(source)
        else
            source = string.upper(source)
            if source == "NIL" then
                if theDead == "WAXWELL" then
                    source = "CHARLIE"
                else
                    source = "DARKNESS"
                end
            elseif source == "UNKNOWN" then
                source = "SHENANIGANS"
            elseif source == "MOOSE" then
                if math.random() < .5 then
                    source = "MOOSE1"
                else
                    source = "MOOSE2"
                end
            end
            msg_tab.content = {
                "$%s ",
                "UI.HUD.DEATH_ANNOUNCEMENT_1",
                "$ %s",
            }
            msg_tab.params = {
                theDead:GetDisplayName(),
                STRCODE_HEADER .. "NAMES." .. (STRINGS.NAMES[source] and source or "SHENANIGANS")
            }
            -- source = source and STRINGS.NAMES[source] or STRINGS.NAMES.SHENANIGANS
            -- message = theDead:GetDisplayName().." "..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_1.." "..source
        end

        if not theDead.ghostenabled then
            table.insert(msg_tab.content, "$.")
            -- message = message.."."
        else
            local gender = GetGenderStrings(theDead.prefab)
            if STRINGS.UI.HUD["DEATH_ANNOUNCEMENT_2_"..gender] then
                table.insert(msg_tab.content, "UI.HUD.DEATH_ANNOUNCEMENT_2_"..gender)
                -- message = message..STRINGS.UI.HUD["DEATH_ANNOUNCEMENT_2_"..gender]
            else
                table.insert(msg_tab.content, "UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT")
                -- message = message..STRINGS.UI.HUD.DEATH_ANNOUNCEMENT_2_DEFAULT
            end
        end
    else
        local gender = GetGenderStrings(theDead.prefab)

        if STRINGS.UI.HUD["GHOST_DEATH_ANNOUNCEMENT_"..gender] then
            msg_tab.content = {
                "$%s ",
                "UI.HUD.GHOST_DEATH_ANNOUNCEMENT_" .. gender,
            }
            msg_tab.params = {
                theDead:GetDisplayName()
            }
            -- message = theDead:GetDisplayName().." "..STRINGS.UI.HUD["GHOST_DEATH_ANNOUNCEMENT_"..gender]
        else
            msg_tab.content = {
                "$%s ",
                "UI.HUD.GHOST_DEATH_ANNOUNCEMENT_DEFAULT",
            }
            msg_tab.params = {
                theDead:GetDisplayName()
            }
            -- message = theDead:GetDisplayName().." "..STRINGS.UI.HUD.GHOST_DEATH_ANNOUNCEMENT_DEFAULT
        end
    end

    return EncodeStrCode(msg_tab)
end

-- local death_announcement = Networking_DeathAnnouncement
-- function Networking_DeathAnnouncement(message, ...)
--     if IsStrCode(message) then
--         message = ResolveStrCode(SubStrCode(message))
--     end
--     return death_announcement(message, ...)
-- end

function GetNewRezAnnouncementString(theRezzed, source)
    if not theRezzed or not source then return "" end
    -- local message = theRezzed:GetDisplayName().." "..STRINGS.UI.HUD.REZ_ANNOUNCEMENT.." "..source.."."
    local msg_tab = {
        strtype = "format",
        content = {
            "$%s ",
            "UI.HUD.REZ_ANNOUNCEMENT",
            "$ %s."
        },
        params = {
            theRezzed:GetDisplayName(),
            source
        }
    }
    -- return message
    return EncodeStrCode(msg_tab)
end

-- local resurrect_announcement = Networking_ResurrectAnnouncement
-- function Networking_ResurrectAnnouncement(message, ...)
--     if IsStrCode(message) then
--         message = ResolveStrCode(SubStrCode(message))
--     end
--     return resurrect_announcement(message, ...)
-- end
