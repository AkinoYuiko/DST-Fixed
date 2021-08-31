local ENV = env
GLOBAL.setfenv(1, GLOBAL)

-- Well, I really don't like overriding this much,
-- but I can't think of a better way ):

local Unwrappable = require("components/unwrappable")

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local Unwrap = Unwrappable.Unwrap
function Unwrappable:Unwrap(doer, ...)

    local doer_container = doer and (doer.components.container or doer.components.inventory)
    local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner()
    if not (doer_container and owner) then
        return Unwrap(self, doer, ...)
    end

    local owner_container = self.inst.components.inventoryitem:GetContainer()
    local removed_from_inv = false
    
    local pos = self.inst:GetPosition()
    pos.y = 0
    if self.itemdata ~= nil then
        if doer ~= nil and
            self.inst.components.inventoryitem ~= nil and
            self.inst.components.inventoryitem:GetGrandOwner() == doer then
            local doerpos = doer:GetPosition()
            local offset = FindWalkableOffset(doerpos, doer.Transform:GetRotation() * DEGREES, 1, 8, false, true, NoHoles)
            if offset ~= nil then
                pos.x = doerpos.x + offset.x
                pos.z = doerpos.z + offset.z
            else
                pos.x, pos.z = doerpos.x, doerpos.z
            end
        end

        -- Changed Part
        local owner_pos = owner:GetPosition()
        removed_from_inv = self.inst.components.inventoryitem:RemoveFromOwner(true) ~= nil
        -- Changed Part

        local creator = self.origin ~= nil and TheWorld.meta.session_identifier ~= self.origin and { sessionid = self.origin } or nil
        for i, v in ipairs(self.itemdata) do
            local item = SpawnPrefab(v.prefab, v.skinname, v.skin_id, creator)
            if item ~= nil and item:IsValid() then
                if item.Physics ~= nil then
                    item.Physics:Teleport(pos:Get())
                else
                    item.Transform:SetPosition(pos:Get())
                end
                item:SetPersistData(v.data)
                -- Changed Part
                if item.components.inventoryitem ~= nil then
                    doer_container:GiveItem(item, nil, owner_pos)
                end
                -- Changed Part
            end
        end
        self.itemdata = nil
    end
    if self.onunwrappedfn ~= nil then
        self.onunwrappedfn(self.inst, pos, doer, true) -- Added a new param: should_drop
    end

    if removed_from_inv and self.inst:IsValid() and owner:IsValid() then
        owner_container:GiveItem(self.inst)
    end
end

ENV.AddPrefabPostInit("bundle", function(inst)
    if not TheWorld.ismastersim then return end

    local onunwrappedfn = inst.components.unwrappable.onunwrappedfn
    inst.components.unwrappable:SetOnUnwrappedFn(function(inst, pos, doer, should_drop) -- Last param is from our overrided Unwrappable.Unwrap
        if not should_drop then
            return onunwrappedfn(inst, pos, doer)
        end

        if inst.burnt then
            SpawnPrefab("ash").Transform:SetPosition(pos:Get())
        else
            local moisture = inst.components.inventoryitem:GetMoisture()
            local iswet = inst.components.inventoryitem:IsWet()
            local item = SpawnPrefab("waxpaper")
            if item ~= nil then
                local doer_container = doer ~= nil and (doer.components.container or doer.components.inventory)
                if doer_container then
                    doer_container:GiveItem(item, nil, pos)
                elseif item.Physics ~= nil then
                    item.Physics:Teleport(pos:Get())
                else
                    item.Transform:SetPosition(pos:Get())
                end
                if item.components.inventoryitem ~= nil then
                    item.components.inventoryitem:InheritMoisture(moisture, iswet)
                end
            end
            SpawnPrefab("bundle_unwrap").Transform:SetPosition(pos:Get())
        end
        if doer ~= nil and doer.SoundEmitter ~= nil then
            doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
        end
        inst:Remove()
    end)
end)
