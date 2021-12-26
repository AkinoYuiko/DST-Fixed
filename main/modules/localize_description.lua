local CUSTOMFAILSTR = GetModConfigData("CUSTOMFAILSTR")

local AddPlayerPostInit = AddPlayerPostInit
local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

STRCODE_HEADER = "/strcode "
-- local DELIM = "＋"

function IsStrCode(value)
    return type(value) == "string" and value:find("^"..STRCODE_HEADER)
end

function SubStrCode(str)
    return str:sub(#STRCODE_HEADER + 1, -1)
end

function EncodeStrCode(tbl)
    return STRCODE_HEADER .. json.encode(tbl)
end

local function getmodifiedstring(base_str, topic_tab, modifier)
    if type(modifier) == "table" then
        local tab = topic_tab
        for _, v in ipairs(modifier) do
            if tab == nil then
                return nil
            end
            tab = tab[v]
            base_str = base_str .. "." .. v
        end
        return base_str
    elseif modifier ~= nil then
        local tab = topic_tab[modifier]
        local postfix =
            (type(tab) == "table" and #tab > 0 and modifier .. "." .. tostring(math.random(#tab)))
            or (tab and modifier)
            or (topic_tab.GENERIC and "GENERIC")
            or (#topic_tab > 0 and tostring(math.random(#topic_tab)))
        if postfix then
            return base_str .. "." .. postfix
        end
    else
        local postfix =
            (topic_tab.GENERIC and "GENERIC")
            or (#topic_tab > 0 and tostring(math.random(#topic_tab)))
        if postfix then
            return base_str .. "." .. postfix
        end
    end
end

local function getcharacterstring(base_str, tab, item, modifier)
    if tab then
        local topic_tab = tab[item]
        if type(topic_tab) == "string" then
            return base_str .. "." .. item
        elseif type(topic_tab) == "table" then
            base_str = base_str .. "." .. item
            return getmodifiedstring(base_str, topic_tab, modifier)
        end
    end
end

function GetStringCode(inst, item, modifier, strtype, params)
    local character =
        type(inst) == "string"
        and inst
        or (inst ~= nil and inst.prefab or nil)

    character = character ~= nil and string.upper(character) or nil

    local specialcharacter =
        type(inst) == "table"
        and ((inst:HasTag("mime") and "mime") or
            (inst:HasTag("playerghost") and "ghost"))
        or character

    if GetSpecialCharacterString(specialcharacter) then
        return
    end

    if item then
        item = string.upper(item)
    end
    if modifier then
        if type(modifier) == "table" then
            for i, v in ipairs(modifier) do
                modifier[i] = string.upper(v)
            end
        else
            modifier = string.upper(modifier)
        end
    end

    local str = character
        and getcharacterstring("CHARACTERS."..character, STRINGS.CHARACTERS[character], item, modifier)
        or getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, item, modifier)
    if str then
        local ret = {
            strtype = strtype,
            content = str,
            params = params
        }
        return EncodeStrCode(ret)
    end
end
local get_string = GetString
function GetString(inst, item, modifier, ...)
    return GetStringCode(inst, item, modifier)
        or get_string(inst, item, modifier, ...)
end

function GetDescriptionCode(inst, item, modifier, strtype, params)
    local character =
        type(inst) == "string"
        and inst
        or (inst ~= nil and inst.prefab or nil)

    character = character ~= nil and string.upper(character) or nil
    local itemname = item.nameoverride or item.components.inspectable.nameoverride or item.prefab or nil
    itemname = itemname ~= nil and string.upper(itemname) or nil
    if modifier then
        if type(modifier) == "table" then
            for i, v in ipairs(modifier) do
                modifier[i] = string.upper(v)
            end
        else
            modifier = string.upper(modifier)
        end
    end

    local specialcharacter =
        type(inst) == "table"
        and ((inst:HasTag("mime") and "mime") or
            (inst:HasTag("playerghost") and "ghost"))
        or character

    if GetSpecialCharacterString(specialcharacter) then
        return
    end

    local ret = {
        strtype = strtype,
        content = {},
        params = params
    }

    local character_speech = character and STRINGS.CHARACTERS[character]
    local str = character_speech
        and getcharacterstring("CHARACTERS."..character..".DESCRIBE", character_speech.DESCRIBE, itemname, modifier)
        or getcharacterstring("CHARACTERS.GENERIC.DESCRIBE", STRINGS.CHARACTERS.GENERIC.DESCRIBE, itemname, modifier)

    if str then
        table.insert(ret.content, str)
    end
    if item and item.components.repairable and not item.components.repairable.noannounce and item.components.repairable:NeedsRepairs() then
        str = character
            and getcharacterstring("CHARACTERS."..character, character_speech, "ANNOUNCE_CANFIX", modifier)
            or getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, "ANNOUNCE_CANFIX", modifier)
        if str then
            table.insert(ret.content, str)
        end
    end

    return #ret.content > 0 and EncodeStrCode(ret) or nil
end
local get_description = GetDescription
function GetDescription(inst, item, modifier, ...)
    return GetDescriptionCode(inst, item, modifier)
        or get_description(inst, item, modifier, ...)
end

function GetActionFailStringCode(inst, action, reason, strtype, params)
    local character =
        type(inst) == "string"
        and inst
        or (inst ~= nil and inst.prefab or nil)

    character = character ~= nil and string.upper(character) or nil

    local specialcharacter =
        type(inst) == "table"
        and ((inst:HasTag("mime") and "mime") or
            (inst:HasTag("playerghost") and "ghost"))
        or character

    if GetSpecialCharacterString(specialcharacter) then
        return
    end

    if action then
        action = string.upper(action)
    end
    if reason then
        if type(reason) == "table" then
            for i, v in ipairs(reason) do
                reason[i] = string.upper(v)
            end
        else
            reason = string.upper(reason)
        end
    end
    local character_speech = character and STRINGS.CHARACTERS[character]
    local str = character_speech
        and getcharacterstring("CHARACTERS."..character..".ACTIONFAIL", character_speech.ACTIONFAIL, action, reason)
        or getcharacterstring("CHARACTERS.GENERIC.ACTIONFAIL", STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, action, reason)
        or (
            CUSTOMFAILSTR and character_speech
            and "CHARACTERS."..character..".ACTIONFAIL_GENERIC"
            or "CHARACTERS.GENERIC.ACTIONFAIL_GENERIC"
        )

    local ret = {
        strtype = strtype,
        content = str,
        params = params
    }
    return EncodeStrCode(ret)

end
local get_action_fail_string = GetActionFailString
GetActionFailString = function(inst, action, reason, ...)
    return GetActionFailStringCode(inst, action, reason)
        or get_action_fail_string(inst, action, reason, ...)
end

-- Components Inspectable --
-- local Inspectable = require("components/inspectable")
-- function Inspectable:GetDescriptionCode(viewer)
--     if self.inst == viewer then
--         return
--     elseif not CanEntitySeeTarget(viewer, self.inst) then
--         return GetStringCode(viewer, "DESCRIBE_TOODARK")
--     end

--     -- Manually written description fns
--     if self.special_description_code then
--         return self.special_description_code(self.inst, viewer)
--     end

--     local desc
--     if self.getspecialdescription ~= nil then
--         -- for cases where we need to do additional processing before calling GetDescriptionCode (i.e. player skeleton)
--         desc = self.getspecialdescription(self.inst, viewer)
--     elseif self.descriptionfn ~= nil then
--         desc = self.descriptionfn(self.inst, viewer)
--     else
--         desc = self.description
--     end

--     if desc == nil then
--         -- force the call for ghost/mime
--         return GetDescriptionCode(viewer, self.inst, self:GetStatus(viewer))
--     end
-- end
-- function Inspectable:GetDescription(viewer)
--     local inspectable = self.inst.components.inspectable
--     return inspectable:GetDescriptionCode(viewer)
-- end

-- Components Talker --
local Talker = require("components/talker")
local TalkerSay = Talker.Say
function Talker:Say(script, time, noanim, ...)
    if IsStrCode(script) then
        self:SpeakStrCode(SubStrCode(script), time, noanim)
    else
        return TalkerSay(self, script, time, noanim, ...)
    end
end

local function get_string_from_field(str)
    local val = STRINGS
    for v in str:gmatch("[^%.]+") do
        local modifier = tonumber(v) or v
        val = val[modifier]
        if val == nil then
            return
        end
    end
    return val
end

function ResolveStrCode(message)
    if type(message) ~= "string" then
        return
    end
    local data = json.decode(message)
    if not data then
        return
    end

    local res = ""
    if type(data.content) == "table" then
        for _, str in ipairs(data.content) do
            if str:find("^%$") then
                res = res .. str:sub(2, -1)
            else
                local val = get_string_from_field(str)
                if val then
                    res = res .. val
                end
            end
        end
    else
        res = get_string_from_field(data.content)
    end

    if data.params then
        for k, v in pairs(data.params) do
            if IsStrCode(v) then
                data.params[k] = get_string_from_field(SubStrCode(v))
            end
        end
    else
        data.params = {}
    end

    if data.strtype == "format" then
        res = string.format(res, unpack(data.params))
    elseif data.strtype == "subfmt" then
        res = subfmt(res, data.params)
    end
    return res

end

local function OnSpeakerDirty(inst)
    local self = inst.components.talker

    local strcode = self.str_code_speaker.strcode:value()
    if #strcode > 0 then
        local str = ResolveStrCode(strcode)

        if str ~= nil then
            local time = self.str_code_speaker.strtime:value()
            local forcetext = self.str_code_speaker.forcetext:value()
            self:Say(str, time > 0 and time or nil, forcetext, forcetext, true)
            return
        end
    end

    self:ShutUp()
end

function Talker:MakeStringCodeSpeaker()
    if self.str_code_speaker == nil then
        self.str_code_speaker =
        {
            strcode = net_string(self.inst.GUID, "talker.str_code_speaker.strcode", "speakerdirty"),
            strtime = net_tinybyte(self.inst.GUID, "talker.str_code_speaker.strtime"),
            forcetext = net_bool(self.inst.GUID, "talker.str_code_speaker.forcetext"),
        }
        if not TheWorld.ismastersim then
            self.inst:ListenForEvent("speakerdirty", OnSpeakerDirty)
        end
    end
end

local function OnCancelSpeaker(inst, self)
    self.str_code_speaker.task = nil
    self.str_code_speaker.strcode:set_local("")
end

-- TODO: Make a net event for repeat speech
--NOTE: forcetext translates to noanim + force say
function Talker:SpeakStrCode(strcode, time, forcetext)
    -- print("SpeakStrCode", strcode)
    if self.str_code_speaker ~= nil and TheWorld.ismastersim then
        self.str_code_speaker.strcode:set(strcode)
        self.str_code_speaker.strtime:set(time or 0)
        self.str_code_speaker.forcetext:set(forcetext == true)
        if self.str_code_speaker.task ~= nil then
            self.str_code_speaker.task:Cancel()
        end
        self.str_code_speaker.task = self.inst:DoTaskInTime(1, OnCancelSpeaker, self)
        OnSpeakerDirty(self.inst)
    end
end

local OnRemoveFromEntity = Talker.OnRemoveFromEntity
function Talker:OnRemoveFromEntity(...)
    self.inst:RemoveEventCallback("speakerdirty", OnSpeakerDirty)
    return OnRemoveFromEntity(self, ...)
end

AddPlayerPostInit(function(inst)
    local talker = inst.components.talker
    if talker then
        talker:MakeStringCodeSpeaker()
    end
end)

local ChatHistoryOnSay = ChatHistory.OnSay
function ChatHistory:OnSay(guid, userid, netid, name, prefab, message, ...)
    if IsStrCode(message) then
        message = ResolveStrCode(SubStrCode(message))
    end
    return ChatHistoryOnSay(self, guid, userid, netid, name, prefab, message, ...)
end
-- fix strings code for specified prefabs
modimport("main/asscleaner/special_description_code")
