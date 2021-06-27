local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

ENV.AddPrefabPostInit("moondial", function(inst)
    if not TheWorld.ismastersim then return end
    local _onalterawake = UpvalueHacker.GetUpvalue(inst.OnLoad, "onalterawake") or function() end

    -- local function OnLoad(inst, data)
    --     inst.is_glassed = nil
    --     if data ~= nil and data.is_glassed then
    --         onalterawake(inst, true)
    --     end
    -- end
    local function new_onalterawake(inst, awake, ...)
        local portal_moonrock = nil
        for _, ent in pairs(Ents) do
            if ent.prefab == "multiplayer_portal_moonrock" then
                portal_moonrock = ent
                print("find PORTAL")
                -- break
            end
        end
        if not portal_moonrock then
            print("no portal_moonrock")
            return _onalterawake(inst, awake, ...)
        end

        local was_glassed = inst.is_glassed
        print("wasglassed", was_glassed)
        if not was_glassed and awake then
            inst.is_glassed = true
            inst.sg:GoToState((POPULATING or not inst.entity:IsAwake()) and "glassed_idle" or "glassed_pre")
        elseif was_glassed and not awake then
            print("awake", awake)
            print("POPULATING", POPULATING)
            print("inst.entity:IsAwake()", inst.entity:IsAwake())
            if POPULATING or not inst.entity:IsAwake() then
                inst.sg:GoToState("idle")
                local pos = portal_moonrock:GetPosition()
                print("pos", pos)
                local x, y, z = pos:Get()
                local moonglass = TheSim:FindEntities(x, y, z, 4, {"moonglass_piece"} )[1]
                if moonglass ~= nil and not moonglass.components.stackable:IsFull() then
                    moonglass.components.stackable:SetStackSize(moonglass.components.stackable:StackSize() + 1)
                    print("stack moonglass", pos)
                else
                    inst.components.lootdropper:FlingItem(SpawnPrefab("moonglass"), pos)
                    print("spawn moonglass", pos)
                end
                inst.is_glassed = false
            else
                inst.sg:GoToState("glassed_pst")
            end
        end
    end

	inst.OnLoad = function(inst, data)
        inst.is_glassed = nil
        if data ~= nil and data.is_glassed then
            new_onalterawake(inst, true)
        end
    end

    inst:StopWatchingWorldState("isalterawake", _onalterawake)
    inst:WatchWorldState("isalterawake", new_onalterawake)

end)
