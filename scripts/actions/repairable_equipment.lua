local _G = GLOBAL
local Action = _G.Action
local ACTIONS = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local STRINGS = _G.STRINGS
local TUNING = _G.TUNING

local SEWINGNEW = Action({mount_valid=true})
SEWINGNEW.id = "SEWINGNEW"
SEWINGNEW.str = ACTIONS.REPAIR.str

SEWINGNEW.fn = function ( act )
    local sewtool = act.invobject
    local item = act.target
    if sewtool and sewtool.components.sewingnew and item and (item.components.perishable or item.components.finiteuses or item.components.fueled or item.components.armor) then
        sewtool.components.sewingnew:DoSewing(item, act.doer)
    end
    return true
end


AddAction(SEWINGNEW)

function SetupActionSewingnew( inst, doer, target, actions, right)
    -- local sewingnew = inst.components.sewingnew
    if not inst:HasTag("sewingnew") then return end
    -- if not right then return end
    if right then
        -- for k,v in pairs(sewingnew.repair_maps) do
            -- if type(v) == "table" then
            --     if v[1] == target.prefab then
            --         table.insert(actions, 1,ACTIONS.SEWINGNEW)
            --     end
            -- elseif type(v) == "string" then
            if inst.prefab == target.prefab then
                table.insert(actions, 1,ACTIONS.SEWINGNEW)
            end
            -- end
        -- end
    end
end


AddComponentAction("USEITEM", "sewingnew", SetupActionSewingnew)

AddStategraphActionHandler("wilson", ActionHandler(SEWINGNEW, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(SEWINGNEW, "dolongaction"))
