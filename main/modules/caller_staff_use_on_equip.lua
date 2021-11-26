local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function newcreatelight(staff, target, pos)
    local light = SpawnPrefab(staff.prefab == "opalstaff" and "staffcoldlight" or "stafflight")
    if pos == nil then
    	if target == nil then
    		pos = staff:GetPosition()
    	else
    		pos = target:GetPosition()
    	end
    end

    light.Transform:SetPosition(pos:Get())

    staff.components.finiteuses:Use(1)

    local caster = staff.components.inventoryitem.owner
    if caster ~= nil and caster.components.sanity ~= nil then
        caster.components.sanity:DoDelta(-TUNING.SANITY_MEDLARGE)
    end
end

AddPrefabPostInit("yellowstaff", function(inst)
	if inst.components.spellcaster then
    	inst.components.spellcaster:SetSpellFn(newcreatelight)
	    inst.components.spellcaster.canusefrominventory = true
	end
end)

AddPrefabPostInit("opalstaff", function(inst)
	if inst.components.spellcaster then
    	inst.components.spellcaster:SetSpellFn(newcreatelight)
	    inst.components.spellcaster.canusefrominventory = true
	end
end)