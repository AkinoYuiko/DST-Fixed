local AddPrefabPostInit = AddPrefabPostInit
local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

local portal_moonrock
local spawn_moonglass_task
local glassed_moondials = 0

local MOONGLASS_MUSTTAGS = {"moonglass_piece"}
local function spawn_moonglass(inst)
    spawn_moonglass_task = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    for _, ent in ipairs(TheSim:FindEntities(x, y, z, 4, MOONGLASS_MUSTTAGS)) do
        if not ent.components.stackable:IsFull() then
            local stackable = ent.components.stackable
            local roomleft = stackable:RoomLeft()
            local after_delta = glassed_moondials - roomleft
            if after_delta <= 0 then
                stackable:SetStackSize(stackable:StackSize() + glassed_moondials)
                glassed_moondials = 0
                return
            end
            stackable:SetStackSize(stackable.maxsize)
            glassed_moondials = after_delta
        end
    end
    repeat
        local moonglass = SpawnPrefab("moonglass")
        local stackable = moonglass.components.stackable
        local after_delta = glassed_moondials - stackable.maxsize
        if after_delta <= 0 then
            stackable:SetStackSize(stackable:StackSize() + glassed_moondials - 1)
        else
            moonglass.components.stackable:SetStackSize(stackable.maxsize)
        end
        glassed_moondials = after_delta
        inst.components.lootdropper:FlingItem(moonglass)
    until glassed_moondials <= 0
    glassed_moondials = 0
end

local function schedule_spawn_moonglass()
    glassed_moondials = glassed_moondials + 1
    if not spawn_moonglass_task then
        spawn_moonglass_task = portal_moonrock:DoTaskInTime(0, spawn_moonglass)
    end
end

local function on_portal_remove(inst)
    if portal_moonrock == inst then
        portal_moonrock = nil
    end
end

AddPrefabPostInit("multiplayer_portal_moonrock", function(inst)
    if not TheWorld.ismastersim then return end
    portal_moonrock = inst
    inst:ListenForEvent("remove", on_portal_remove)
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end
end)

local hooked = false
AddPrefabPostInit("moondial", function(inst)
    if hooked or not TheWorld.ismastersim then return end
    local _onalterawake, i, prev = UpvalueHacker.GetUpvalue(inst.OnLoad, "onalterawake")
    if not _onalterawake then return end
    local function onalterawake_fn(inst, awake, ...)
        if portal_moonrock and inst.is_glassed and not awake and (POPULATING or not inst.entity:IsAwake()) then
            inst.sg:GoToState("idle")
            schedule_spawn_moonglass()
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

AddStategraphPostInit("moondial", function(self)
    self.states["glassed_pst"].timeline = {
        TimeEvent(10 * FRAMES, function(inst)
            if portal_moonrock then
                schedule_spawn_moonglass()
            else
                inst.components.lootdropper:FlingItem(SpawnPrefab("moonglass"))
            end
            inst.is_glassed = false
        end),
    }
end)
