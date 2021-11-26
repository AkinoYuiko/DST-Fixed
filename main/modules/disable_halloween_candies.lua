local AddPrefabPostInit = env.AddPrefabPostInit
local UpvalueHacker = require("tools/upvaluehacker")
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("pigking", function(inst)
    if not TheWorld.ismastersim then return end
    inst:DoTaskInTime(0, function(inst) -- Compatible with Mio the Nightmare Eater
        local on_trade_for_gold = UpvalueHacker.GetUpvalue(inst.components.trader.onaccept, "ontradeforgold")

        local function on_accept_fn(inst, item, giver)
            local is_special_event_active = IsSpecialEventActive
            IsSpecialEventActive = function(event)
                if event == SPECIAL_EVENTS.HALLOWED_NIGHTS then
                    return false
                end
                return is_special_event_active(event)
            end
            on_trade_for_gold(inst, item, giver)
            IsSpecialEventActive = is_special_event_active
        end
        UpvalueHacker.SetUpvalue(inst.components.trader.onaccept, on_accept_fn, "ontradeforgold")
    end)
end)
