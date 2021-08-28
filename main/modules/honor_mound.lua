local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local BURRYMOUND = Action()

BURRYMOUND.id = "BURRYMOUND"
BURRYMOUND.str = "Burry"

-- BURRYMOUND.stroverridefn = function(act)
-- 	if act.invobject ~= nil then
-- 		return act.invobject:GetIsWet() and STRINGS.ACTIONS.ADDWETFUEL or STRINGS.ACTIONS.ADDFUEL
-- 	end
-- end

BURRYMOUND.fn = function(act)
    local item = act.doer.components.inventory:RemoveItem(act.invobject)
    if act.target.AnimState:IsCurrentAnimation("dug") then
        local mound = SpawnPrefab("honor_mound")
        mound.Transform:SetPosition(act.target:GetPosition():Get())
        SpawnPrefab("sand_puff").entity:SetParent(mound.entity)
        act.target:Remove()
        item:Remove()
        return true
    end
end

ENV.AddAction(BURRYMOUND)

ENV.AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right)
    if inst.prefab == "ghostflower" and target.prefab == "mound" and target.AnimState:IsCurrentAnimation("dug") then
        table.insert(actions, ACTIONS.BURRYMOUND)
    end
end)

local handler = ActionHandler(ACTIONS.BURRYMOUND, "dolongaction")
ENV.AddStategraphActionHandler("wilson", handler)
ENV.AddStategraphActionHandler("wilson_client", handler)

STRINGS.NAMES.HONOR_MOUND = STRINGS.NAMES.MOUND
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HONOR_MOUND = STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOUND.GENERIC