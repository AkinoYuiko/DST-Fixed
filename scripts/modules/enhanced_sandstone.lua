local _G = GLOBAL
local Action = _G.Action
local ACTIONS = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local STRINGS = _G.STRINGS
local TUNING = _G.TUNING

local ENHANCEDSANDSTONE = Action()

ENHANCEDSANDSTONE.id = "ENHANCEDSANDSTONE"

ENHANCEDSANDSTONE.str = STRINGS.ACTIONS.USEITEM

ENHANCEDSANDSTONE.fn = function(act)
    if not act.invobject.AnimState:IsCurrentAnimation("inactive") then return false end
    local _d = act.doer
    if _d.components.inventory then
        local portal = _G.SpawnPrefab("townportal_shadow")
        portal.entity:SetParent(_d.entity)
        if _d.sg then
            _d.sg:AddStateTag("prechanneling")
            if portal.components.channelable then
                portal.components.channelable:StartChanneling(_d)
            end
        end
        local _i = _d.components.inventory:RemoveItem(act.invobject)
        _i:Remove()
        return true
    end
end

AddAction(ENHANCEDSANDSTONE)

function SetupActionSandstone(inst, doer, actions, right)
    if inst.AnimState:IsCurrentAnimation("inactive") then
        table.insert(actions, 1,ACTIONS.ENHANCEDSANDSTONE)
    end
end

AddComponentAction("INVENTORY","enhancedsandstone",SetupActionSandstone)

AddStategraphActionHandler("wilson", ActionHandler(ENHANCEDSANDSTONE, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(ENHANCEDSANDSTONE, "dolongaction"))

AddPrefabPostInit("townportaltalisman",function(inst)
    if not _G.TheWorld.ismastersim then return inst end
    inst:AddComponent("enhancedsandstone")
end)