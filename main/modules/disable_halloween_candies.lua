local UpvalueUtil = require("upvalueutil")
local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("pigking", function(inst)
    if not TheWorld.ismastersim then return end
    inst:DoTaskInTime(0, function(inst) -- Compatible with Mio the Nightmare Eater
        local on_trade_for_gold = UpvalueUtil.GetUpvalue(inst.components.trader.onaccept, "ontradeforgold")

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
        UpvalueUtil.SetUpvalue(inst.components.trader.onaccept, "ontradeforgold", on_accept_fn)
    end)
end)
