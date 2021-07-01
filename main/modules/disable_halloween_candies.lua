local _G = GLOBAL

local function getval(fn, path)
    local val = fn
    for entry in path:gmatch("[^%.]+") do
        local i = 1
        while true do
            local name, value = _G.debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    return val
end

local function setval(fn, path, new)
    local val = fn
    local prev = nil
    local i
    for entry in path:gmatch("[^%.]+") do
        i = 1
        prev = val
        while true do
            local name, value = _G.debug.getupvalue(val, i)
            if name == entry then
                val = value
                break
            elseif name == nil then
                return
            end
            i = i + 1
        end
    end
    _G.debug.setupvalue(prev, i, new)
end

AddPrefabPostInit("pigking", function(inst)
    if not _G.TheWorld.ismastersim then return inst end
    inst:DoTaskInTime(0, function(inst) -- Compatible with Mio the Nightmare Eater
        local ontradeforgold = getval(inst.components.trader.onaccept, "ontradeforgold")
        setval(inst.components.trader.onaccept, "ontradeforgold", function(inst, item, giver)
            local _IsSpecialEventActive = _G.IsSpecialEventActive
            _G.IsSpecialEventActive = function(event)
                if event == _G.SPECIAL_EVENTS.HALLOWED_NIGHTS then
                    return false
                end
                return _IsSpecialEventActive(event)
            end
            ontradeforgold(inst, item, giver)
            _G.IsSpecialEventActive = _IsSpecialEventActive
        end)
    end)
end)