modimport("main/actions/repairable_equipment.lua")

local function MakeRepairable(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    if not inst.components.inventoryitem then return end
    -- if table.contains(block_list,inst.prefab) then return end

    if inst.components.finiteuses or inst.components.fueled or inst.components.armor
      or (inst.components.perishable and inst.components.equippable)
      then
        inst:AddComponent("sewingnew")
        inst.components.sewingnew:AddRepairMap(inst.prefab)
    end
end

AddPrefabPostInitAny(MakeRepairable)


AddComponentPostInit("playercontroller", function(self)
  local old_DoActionAutoEquip = self.DoActionAutoEquip
  self.DoActionAutoEquip = function(self, buffaction, ...)
    if buffaction.action == GLOBAL.ACTIONS.SEWINGNEW then return end
    return old_DoActionAutoEquip(self, buffaction, ...)
  end
end)
