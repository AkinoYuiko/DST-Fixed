table.insert(PrefabFiles, "moonglass_blow_proj")

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local params = require("containers").params
params.houndstooth_blowpipe.widget.slotbg = nil

AddPrefabPostInit("moonglass", function(inst)
    inst:AddTag("blowpipeammo")
    inst:AddTag("reloaditem_ammo") -- Action string.
end)

AddPrefabPostInit("houndstooth_blowpipe", function(inst)
    if not TheWorld.ismastersim then return end

    local OnAmmoLoaded = inst.OnAmmoLoaded

    inst:RemoveEventCallback("itemget", inst.OnAmmoLoaded)

    inst.OnAmmoLoaded = function(inst, data)
        OnAmmoLoaded(inst, data)
        local weapon = inst.components.weapon
        if weapon and data and data.item and data.item.prefab == "moonglass" then
            weapon:SetProjectile("moonglass_blow_proj")
        end
    end

    inst:ListenForEvent("itemget", inst.OnAmmoLoaded)
end)
