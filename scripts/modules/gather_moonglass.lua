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

local _onalterawake = nil
ENV.AddPrefabPostInit("moondial", function(inst)
    if not TheWorld.ismastersim then return end
    if not _onalterawake then
        _onalterawake = UpvalueHacker.GetUpvalue(inst.OnLoad, "onalterawake")
        if not _onalterawake then return end
    end
    UpvalueHacker.SetUpvalue(inst.OnLoad, function(inst, awake, ...)
        local portal_moonrock = find_portal()
        if not portal_moonrock then
            return _onalterawake(inst, awake, ...)
        end

        local was_glassed = inst.is_glassed
        if not was_glassed and awake then
            inst.is_glassed = true
            inst.sg:GoToState((POPULATING or not inst.entity:IsAwake()) and "glassed_idle" or "glassed_pre")
        elseif was_glassed and not awake then
            if POPULATING or not inst.entity:IsAwake() then
                inst.sg:GoToState("idle")
                local pos = portal_moonrock:GetPosition()
                local x, y, z = pos:Get()
                local moonglass = TheSim:FindEntities(x, y, z, 4, {"moonglass_piece"} )[1]
                if moonglass ~= nil and not moonglass.components.stackable:IsFull() then
                    moonglass.components.stackable:SetStackSize(moonglass.components.stackable:StackSize() + 1)
                else
                    inst.components.lootdropper:FlingItem(SpawnPrefab("moonglass"), pos)
                end
                inst.is_glassed = false
            else
                inst.sg:GoToState("glassed_pst")
            end
        end
    end, "onalterawake")
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