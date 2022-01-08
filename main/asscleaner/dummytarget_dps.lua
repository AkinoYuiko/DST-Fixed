local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local dps_table = {}

local function count_dps(table)
    if table == nil then return 0 end
    local dps = 0
    for _, time, amounts in sorted_pairs(table) do
        if GetTime() - time > 1 then
            table[time] = nil
        else
            for i = 1, #amounts do
                dps = dps + amounts[i]
            end
        end
    end
    dps = math.abs(dps)

    return dps
end

local function OnHealthDelta(inst, data)
    if data.amount <= 0 then
        local timestamp = GetTime()
        dps_table[timestamp] = dps_table[timestamp] or {}
        local lenth = #dps_table[timestamp]
        dps_table[timestamp][lenth + 1] = data.amount
        inst.Label:SetText(data.amount .. "\nDPS: " .. count_dps(dps_table))
        inst.Label:SetUIOffset(math.random() * 20 - 10, math.random() * 20 + 90, 0)
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

AddPrefabPostInit("dummytarget", function(inst)
    if not TheWorld.ismastersim then return end

    inst.event_listening["healthdelta"][inst] = nil
    inst.event_listeners["healthdelta"][inst] = nil

    if inst.components.health then
        inst:ListenForEvent("healthdelta", OnHealthDelta)
    end
end)
