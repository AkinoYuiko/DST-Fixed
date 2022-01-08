local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function count_dps(t)
    local dps = 0
    local time = GetTime() - 1

    local j = 1
    for i = 1, #t do
        local val = t[i]
        if val.time < time then
            t[i] = nil
        else
            dps = dps + val.amount
            if i ~= j then
                t[j] = val
                t[i] = nil
            end
            j = j + 1
        end
    end

    return dps
end

local function record_dps(t, amount)
    t[#t + 1] = {amount = amount, time = GetTime()}
end

local function OnHealthDelta(inst, data)
    if data.amount <= 0 then
        record_dps(inst.dps_history, math.abs(data.amount))

        inst.Label:SetText(data.amount .. "\nDPS: " .. count_dps(inst.dps_history))
        inst.Label:SetUIOffset(math.random() * 20 - 10, math.random() * 20 + 90, 0)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

AddPrefabPostInit("dummytarget", function(inst)
    if not TheWorld.ismastersim then return end

    inst.dps_history = {}

    inst.event_listening["healthdelta"][inst] = nil
    inst.event_listeners["healthdelta"][inst] = nil

    if inst.components.health then
        inst:ListenForEvent("healthdelta", OnHealthDelta)
    end
end)

STRINGS.NAMES.DUMMYTARGET = table.contains({"zh", "zht", "chs"}, LanguageTranslator.defaultlang)
                        and "伤害测试木桩"
                        or "Dummy Target"
