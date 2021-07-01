local _G = GLOBAL
local Action = _G.Action
local ACTIONS = _G.ACTIONS
local ActionHandler = _G.ActionHandler
local STRINGS = _G.STRINGS
local TUNING = _G.TUNING

local STATUEGLOMMERREPAIR = Action({mount_valid=false})
STATUEGLOMMERREPAIR.id = "STATUEGLOMMERREPAIR"
STATUEGLOMMERREPAIR.str = STRINGS.ACTIONS.REPAIR.GENERIC

STATUEGLOMMERREPAIR.fn = function(act)
    local _d = act.doer
    local _t = act.target
    if _d.components.inventory then
	    local _i = _d.components.inventory:RemoveItem(act.invobject)
    	if _t.components.workable == nil then
    		local statue = _G.SpawnPrefab("statueglommer")
    		statue.Transform:SetPosition(_t.Transform:GetWorldPosition())
    		if statue.components.workable then
    			statue.components.workable.workleft = 2
				statue.AnimState:PlayAnimation("med")
			end
			_t:Remove()
		else
			local _w = _t.components.workable.workleft
			_t.components.workable.workleft = math.min(6, (_w + 2))
			_t.AnimState:PlayAnimation(_w < 3 and "med" or "full")
		end
		_i:Remove()
		return true
	end
end

AddAction(STATUEGLOMMERREPAIR)

function SetupActionMarbleRepairing(inst, doer, target, actions, right)
	if target.prefab == "statueglommer" then
		if target.components.workable == nil then
			table.insert(actions,1,ACTIONS.STATUEGLOMMERREPAIR)
		else
			if target.components.workable.workleft < 6 then
				table.insert(actions,1,ACTIONS.STATUEGLOMMERREPAIR)
			end
		end
	else
		return
	end
end

AddComponentAction("USEITEM","marblerepair",SetupActionMarbleRepairing)

AddStategraphActionHandler("wilson", ActionHandler(STATUEGLOMMERREPAIR, "dolongaction"))
AddStategraphActionHandler("wilson_client", ActionHandler(STATUEGLOMMERREPAIR, "dolongaction"))

AddPrefabPostInit("marble",function(inst) inst:AddComponent("marblerepair") end)



