local _G = GLOBAL
local Action = _G.Action
local ACTIONS = _G.ACTIONS
local ActionHandler = _G.ActionHandler

local ENHANCEDSANDSTONE = Action()

ENHANCEDSANDSTONE.id = "ENHANCEDSANDSTONE"

ENHANCEDSANDSTONE.str = _G.STRINGS.ACTIONS.USEITEM

ENHANCEDSANDSTONE.fn = function(act)
    if not act.invobject.AnimState:IsCurrentAnimation("inactive") then return false end
    local doer = act.doer
    if doer.components.inventory then
        local portal = _G.SpawnPrefab("townportal_shadow")
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

AddStategraphActionHandler("wilson", ActionHandler(ENHANCEDSANDSTONE, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ENHANCEDSANDSTONE, "dolongaction"))

AddPrefabPostInit("townportaltalisman",function(inst)
    if _G.TheWorld.ismastersim then
        inst:AddComponent("enhancedsandstone")
    end
end)
