local AddPrefabPostInit = AddPrefabPostInit
local UpvalueHacker = require("tools/upvaluehacker")
GLOBAL.setfenv(1, GLOBAL)

local function ontradeforglass(inst, item, giver, ...)
    if (giver and giver.prefab == "miotan") or not TheWorld.state.isalterawake then
        return inst.ontradeforgold_prefns["dst-fixed"](inst, item, giver, ...)
    end
    local launchitem = inst.launchitem_fn or function() end

    -- copied from pigking.lua --
    AwardPlayerAchievement("pigking_trader", giver)

    local x, y, z = inst.Transform:GetWorldPosition()
    y = 4.5

    local angle
    if giver ~= nil and giver:IsValid() then
        angle = 180 - giver:GetAngleToPoint(x, 0, z)
    else
        local down = TheCamera:GetDownVec()
        angle = math.atan2(down.z, down.x) / DEGREES
        giver = nil
    end

    -- MODIFIED PART --
    local nug = SpawnPrefab("moonglass")
    nug.Transform:SetPosition(x, y, z)
    launchitem(nug, angle)
    -- end --

    if item.components.tradable.tradefor ~= nil then
        for _, v in pairs(item.components.tradable.tradefor) do
            local item = SpawnPrefab(v)
            if item ~= nil then
                item.Transform:SetPosition(x, y, z)
                launchitem(item, angle)
            end
        end
    end

    if IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) then
        -- pick out up to 3 types of candies to throw out
        local candytypes = { math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY), math.random(NUM_HALLOWEENCANDY) }
        local numcandies = (item.components.tradable.halloweencandyvalue or 1) + math.random(2) + 2

        -- only people in costumes get a good amount of candy!
        if giver ~= nil and giver.components.skinner ~= nil then
            for _, item in pairs(giver.components.skinner:GetClothing()) do
                if DoesItemHaveTag(item, "COSTUME") or DoesItemHaveTag(item, "HALLOWED") then
                    numcandies = numcandies + math.random(4) + 2
                    break
                end
            end
        end

        for k = 1, numcandies do
            local candy = SpawnPrefab("halloweencandy_"..GetRandomItem(candytypes))
            candy.Transform:SetPosition(x, y, z)
            launchitem(candy, angle)
        end
    end
    -- copy end --
end

AddPrefabPostInit("pigking", function(inst)
    if not TheWorld.ismastersim then return end
    inst.ontradeforgold_prefns = inst.ontradeforgold_prefns or {}
    inst.launchitem_fn = inst.launchitem_fn or UpvalueHacker.GetUpvalue(inst.components.trader.onaccept, "ontradeforgold.launchitem")
    -- inst.launchitem_fn = UpvalueHacker.GetUpvalue(inst.components.trader.onaccept, "ontradeforgold.launchitem")
    inst.ontradeforgold_prefns["dst-fixed"] = UpvalueHacker.GetUpvalue(inst.components.trader.onaccept, "ontradeforgold")
    UpvalueHacker.SetUpvalue(inst.components.trader.onaccept, "ontradeforgold", ontradeforglass)
end)
