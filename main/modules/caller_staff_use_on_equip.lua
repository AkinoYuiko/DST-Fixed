local _G = GLOBAL

local function newcreatelight(staff, target, pos)
    local light = _G.SpawnPrefab(staff.prefab == "opalstaff" and "staffcoldlight" or "stafflight")
    if pos == nil then
    	if target == nil then
    		pos = staff:GetPosition()
    	else
    		pos = target:GetPosition()
    	end
    end

    light.Transform:SetPosition(pos:Get())

    -- light.Transform:SetPosition(pos:Get())
    staff.components.finiteuses:Use(1)

    local caster = staff.components.inventoryitem.owner
    if caster ~= nil and caster.components.sanity ~= nil then
        caster.components.sanity:DoDelta(-_G.TUNING.SANITY_MEDLARGE)
    end
end

-- local function light_reticuletargetfn()
--     return Vector3(ThePlayer.entity:LocalToWorldSpace(5, 0.001, 0)) -- raised this off the ground a touch so it wont have any z-fighting with the ground biome transition tiles.
-- end

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