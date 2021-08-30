GLOBAL.setfenv(1, GLOBAL)

local Unwrappable = require("components/unwrappable")

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

function Unwrappable:Unwrap(doer)
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
                    local container = doer and (doer.components.container or doer.components.inventory)
                    local owner = self.inst.components.inventoryitem and self.inst.components.inventoryitem:GetGrandOwner()
                    if container and owner then
                        container:GiveItem(item, nil, owner:GetPosition())
                    else
                        item.components.inventoryitem:OnDropped(true, .5)
                    end
                end
                -- Changed Part

            end
        end
        self.itemdata = nil
    end
    if self.onunwrappedfn ~= nil then
        self.onunwrappedfn(self.inst, pos, doer)
    end
end
