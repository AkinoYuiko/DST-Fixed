table.insert(PrefabFiles, "moonglass_blow_proj")

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local params = require("containers").params
params.houndstooth_blowpipe.widget.slotbg = nil

AddPrefabPostInit("moonglass", function(inst)
    inst:AddTag("blowpipeammo")
    inst:AddTag("reloaditem_ammo") -- Action string.
end)

local function auto_refill(inst, prev_item_prefab)
    if not inst.components.container:IsEmpty() then
        return
    end
    local owner = inst.components.inventoryitem.owner
    local inv = owner.components.inventory
    local container = inst.components.container
    local hat = inv and inv:GetEquippedItem(EQUIPSLOTS.HEAD)
    local hat_container = hat and hat.prefab == "alterguardianhat" and hat.components.container
    local item_fn = function(item) return item.prefab == prev_item_prefab end
    local new_item = inv and inv:FindItem(item_fn)
    if new_item then
        inv:RemoveItem(new_item, true)
        container:GiveItem(new_item)
    elseif hat_container then
        local new_hat_item = hat_container:FindItem(item_fn)
        if new_hat_item then
            hat_container:RemoveItem(new_hat_item, true)
            container:GiveItem(new_hat_item)
        end
    end
end

AddPrefabPostInit("houndstooth_blowpipe", function(inst)
    if not TheWorld.ismastersim then return end

    inst:RemoveEventCallback("itemget", inst.OnAmmoLoaded)
    local OnAmmoLoaded = inst.OnAmmoLoaded
    inst.OnAmmoLoaded = function(inst, data)
        OnAmmoLoaded(inst, data)
        local weapon = inst.components.weapon
        if weapon and data and data.item and data.item.prefab == "moonglass" then
            weapon:SetProjectile("moonglass_blow_proj")
        end
    end

    inst:ListenForEvent("itemget", inst.OnAmmoLoaded)

    local OnProjectileLaunched = inst.components.weapon.onprojectilelaunched
    inst.components.weapon:SetOnProjectileLaunched(function(_inst, attacker, target)
        if _inst.components.container ~= nil then
            local ammo_stack = _inst.components.container:GetItemInSlot(1)
            local item_prefab = ammo_stack and ammo_stack.prefab

            OnProjectileLaunched(_inst, attacker, target)

            if _inst.components.container:IsEmpty() and item_prefab ~= nil then
                auto_refill(_inst, item_prefab)
            end
        end
    end)
end)
