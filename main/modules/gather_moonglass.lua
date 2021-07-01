local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

local function find_portal()
    for _, ent in pairs(Ents) do
        if ent.prefab == "multiplayer_portal_moonrock" then
            return ent
        end
    end
end

local hooked = false
ENV.AddPrefabPostInit("moondial", function(inst)
    if hooked or not TheWorld.ismastersim then return end
    local _onalterawake, i, prev = UpvalueHacker.GetUpvalue(inst.OnLoad, "onalterawake")
    if not _onalterawake then return end
    local function onalterawake_fn(inst, awake, ...)
        local portal_moonrock = find_portal()
        if portal_moonrock and inst.is_glassed and not awake and (POPULATING or not inst.entity:IsAwake()) then
            inst.sg:GoToState("idle")
            local pos = portal_moonrock:GetPosition()
            local x, y, z = pos:Get()
            local moonglass = TheSim:FindEntities(x, y, z, 4, {"moonglass_piece"})[1]
            if moonglass ~= nil and not moonglass.components.stackable:IsFull() then
                moonglass.components.stackable:SetStackSize(moonglass.components.stackable:StackSize() + 1)
            else
                inst.components.lootdropper:FlingItem(SpawnPrefab("moonglass"), pos)
            end
            inst.is_glassed = false
        else
            return _onalterawake(inst, awake, ...)
        end
    end
    inst:StopWatchingWorldState("isalterawake", _onalterawake)
    inst:WatchWorldState("isalterawake", onalterawake_fn)
    debug.setupvalue(prev, i, onalterawake_fn)
    hooked = true
end)

ENV.AddStategraphPostInit("moondial", function(self)
    self.states["glassed_pst"].timeline = {
        TimeEvent(10 * FRAMES, function(inst)
            local portal_moonrock = find_portal()
            inst.components.lootdropper:FlingItem(SpawnPrefab("moonglass"), portal_moonrock and portal_moonrock:GetPosition())
            inst.is_glassed = false
        end),
    }
end)