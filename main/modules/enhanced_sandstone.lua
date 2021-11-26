local AddAction, AddComponentAction, AddStategraphActionHandler, AddPrefabPostInit = AddAction, AddComponentAction, AddStategraphActionHandler, AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local ENHANCEDSANDSTONE = Action()

ENHANCEDSANDSTONE.id = "ENHANCEDSANDSTONE"
ENHANCEDSANDSTONE.str = STRINGS.ACTIONS.USEITEM
ENHANCEDSANDSTONE.fn = function(act)
    if not act.invobject.AnimState:IsCurrentAnimation("inactive") then return false end
    local doer = act.doer
    if doer.components.inventory then
        local portal = SpawnPrefab("townportal_shadow")
        portal.entity:SetParent(doer.entity)
        if doer.sg then
            doer.sg:AddStateTag("prechanneling")
            if portal.components.channelable then
                portal.components.channelable:StartChanneling(doer)
            end
        end
        local item = doer.components.inventory:RemoveItem(act.invobject)
        item:Remove()
        return true
    end
end

AddAction(ENHANCEDSANDSTONE)

AddComponentAction("INVENTORY", "enhancedsandstone", function(inst, doer, actions, right)
    if inst.AnimState:IsCurrentAnimation("inactive") then
        table.insert(actions, 1, ACTIONS.ENHANCEDSANDSTONE)
    end
end)

local handler = ActionHandler(ENHANCEDSANDSTONE, "dolongaction")
AddStategraphActionHandler("wilson", handler)
AddStategraphActionHandler("wilson_client", handler)

AddPrefabPostInit("townportaltalisman",function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("enhancedsandstone")
    end
end)
