local AddPlayerPostInit = AddPlayerPostInit
local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

local DELIM = "＋"

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
            local ret = base_str .. "." .. item
            return ret and DELIM .. ret
        elseif type(topic_tab) == "table" then
            base_str = base_str .. "." .. item
            local ret = getmodifiedstring(base_str, topic_tab, modifier)
            return ret and DELIM .. ret
        end
    end
end

function GetStringCode(inst, stringtype, modifier)
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

    local ret = GetSpecialCharacterString(specialcharacter)
    if ret ~= nil then
        return ret
    end

    if stringtype then
        stringtype = string.upper(stringtype)
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

    if not character then
        return getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, stringtype, modifier)
    end

    return getcharacterstring("CHARACTERS."..character, STRINGS.CHARACTERS[character], stringtype, modifier)
        or getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, stringtype, modifier)
end
function GetString(inst, item, modifier)
    return GetStringCode(inst, item, modifier)
end

function GetDescriptionCode(inst, item, modifier)
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

    local ret = GetSpecialCharacterString(specialcharacter)
    if ret ~= nil then
        return ret
    end

    if character ~= nil and STRINGS.CHARACTERS[character] ~= nil then
        ret = getcharacterstring("CHARACTERS."..character..".DESCRIBE", STRINGS.CHARACTERS[character].DESCRIBE, itemname, modifier)
        if ret ~= nil then
            if item ~= nil and item.components.repairable ~= nil and not item.components.repairable.noannounce and item.components.repairable:NeedsRepairs() then
                return ret .. (getcharacterstring("CHARACTERS."..character, STRINGS.CHARACTERS[character], "ANNOUNCE_CANFIX", modifier) or "")
            end
            return ret
        end
    end

    ret = getcharacterstring("CHARACTERS.GENERIC.DESCRIBE", STRINGS.CHARACTERS.GENERIC.DESCRIBE, itemname, modifier)

    if item ~= nil and item.components.repairable ~= nil and not item.components.repairable.noannounce and item.components.repairable:NeedsRepairs() then
        if ret ~= nil then
            return ret .. (getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, "ANNOUNCE_CANFIX", modifier) or "")
        end
        ret = getcharacterstring("CHARACTERS.GENERIC", STRINGS.CHARACTERS.GENERIC, "ANNOUNCE_CANFIX", modifier)
        if ret ~= nil then
            return ret
        end
    end

    return ret or (DELIM .. "CHARACTERS.GENERIC.DESCRIBE_GENERIC")
end
function GetDescription(inst, item, modifier)
    return GetDescriptionCode(inst, item, modifier)
end

function GetActionFailStringCode(inst, action, reason)
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

    local ret = GetSpecialCharacterString(specialcharacter)
    if ret ~= nil then
        return ret
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

    if not character then
        return getcharacterstring("CHARACTERS.GENERIC.ACTIONFAIL", STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, action, reason)
            or (DELIM .. "CHARACTERS.GENERIC.ACTIONFAIL_GENERIC")
    end

    return getcharacterstring("CHARACTERS."..character..".ACTIONFAIL", STRINGS.CHARACTERS[character].ACTIONFAIL, action, reason)
        or getcharacterstring("CHARACTERS.GENERIC.ACTIONFAIL", STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, action, reason)
        or (DELIM .. "CHARACTERS."..character..".ACTIONFAIL_GENERIC")
end
GetActionFailString = function(inst, action, reason, ...)
    return GetActionFailStringCode(inst, action, reason)
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
    local talker = self.inst.components.talker
    if talker and type(script) == "string" and script:find("^"..DELIM) then
        talker:SpeakStrCode(script, time, noanim)
    else
        TalkerSay(self, script, time, noanim, ...)
    end
end

local function ResolveChatterString(str)
    local ret = ""
    for sub_str in str:gmatch("[^" .. DELIM .. "]+") do
        local val = STRINGS
        for v in sub_str:gmatch("[^%.]+") do
            val = val[v]
            if val == nil then
                return
            end
        end
        ret = ret .. (type(val) ~= "string" and "VAL is not STRING" or val)
    end
    return ret ~= "" and ret or nil
end

local function OnSpeakerDirty(inst)
    local self = inst.components.talker

    local strcode = self.str_code_speaker.strcode:value()
    if #strcode > 0 then
        local str = ResolveChatterString(strcode)

        if str ~= nil then
            local time = self.str_code_speaker.strtime:value()
            local forcetext = self.str_code_speaker.forcetext:value()
            TalkerSay(self, str, time > 0 and time or nil, forcetext, forcetext, true)
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
    if type(message) == "string" and message:find("^"..DELIM) then
        message = ResolveChatterString(message)
    end
    return ChatHistoryOnSay(self, guid, userid, netid, name, prefab, message, ...)
end
-- fix strings code for specified prefabs
-- modimport("main/asscleaner/special_description_code")

-- ＋CHARACTERS.WANDA.ACTIONFAIL_GENERIC＋CHARACTERS.WANDA.ACTIONFAIL_GENERIC
