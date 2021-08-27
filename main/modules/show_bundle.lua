local _G = GLOBAL
local Vector3 = _G.Vector3

local SB = {}
_G.SB = SB

modimport("main/util.lua")
modimport("main/showbundle_widgetcreation.lua")

-- Default Values:
-- pos:         Vector3(0, 95)
-- scale:       0.52, 0.6 will be as same as normal slot size)
-- slot_scale:  1
-- bg_scale:    1

SB.supported_items = {
    bundle = {},
    gift = {},
    redpouch = {},
    redpouch_yotp = {},
    redpouch_yotc = {},
    redpouch_yotb = {},
    myth_bundle = {}, -- For Myth mod
    alterguardianhat = {
        prefab = "showbundle_alterguardianhat"
    }
}

local Tipbox = require("widgets/tipbox")

local function make_itemdata(items)
    local itemdata = {}
    for slot, item in _G.orderedPairs(items) do
        local data = {}
        if item.components and item.replica then
            local c = item.components

            data.prefab = item.prefab

            data.image = (c.inventoryitem and c.inventoryitem.imagename or data.prefab) .. ".tex"
            if c.inventoryitem then
                if c.inventoryitem.atlasname ~= _G.GetInventoryItemAtlas(data.image, true) then
                    data.atlas = c.inventoryitem.atlasname
                end
            else
                data.atlas = _G.GetInventoryItemAtlas(data.image, true)
            end

            data.iswet = item:GetIsWet() or nil
            if c.stackable then
                data.stack = c.stackable:StackSize()
            end
            if c.fueled then
                data.fuel = c.fueled:GetPercent()
            end
            if c.finiteuses then
                data.uses = c.finiteuses:GetPercent()
            end
            if c.armor then
                data.armor = c.armor:GetPercent()
            end
            if c.perishable then
                data.perish = c.perishable:GetPercent()
            end

            -- spoil check
            if item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled") then
                if item:HasTag("show_spoilage") then
                    data.spoil = true
                end
                for _, t in pairs(_G.FOODTYPE) do
                    if item:HasTag("edible_"..t) then
                        data.spoil = true
                    end
                end
            end

            -- Fix spiced foods
            if c.edible and c.edible.spice ~= nil and item.nameoverride then
                --print(item.nameoverride)
                data.nameoverride = item.nameoverride
            end
        end
        table.insert(itemdata, data)
    end
    return itemdata
end

local function handle_redpouch_data(target, data)
    if not (target and string.find(target.prefab, "redpouch")) then return end
    local nugget_count = 0
    for _, v in ipairs(data) do
        if v.prefab == "lucky_goldnugget" then
            nugget_count = nugget_count + (v.stack or 1)
        else
            return
        end
    end
    return nugget_count ~= 0 and {
        {
            prefab = "lucky_goldnugget",
            image = "lucky_goldnugget.tex",
            stack = nugget_count,
        }
    }
end

local function make_itemdata_for_unwrappable(unwrappable)
    -- print("make_itemdata_for", unwrappable.inst)
    if unwrappable and unwrappable.itemdata ~= nil then
        local items = {}
        local creator = unwrappable.origin ~= nil and _G.TheWorld.meta.session_identifier ~= unwrappable.origin and { sessionid = unwrappable.origin } or nil
        for i, v in ipairs(unwrappable.itemdata) do
            local item = _G.SpawnPrefab(v.prefab, v.skinname, v.skin_id, creator)
            if item ~= nil and item:IsValid() then
                item:SetPersistData(v.data)
                table.insert(items, item)
            end
        end
        unwrappable.itemdata.showbundle_itemdata = make_itemdata(items)
        for _, v in ipairs(items) do
            v:Remove()
        end
    end
end

local function refresh_all_bundle_data()
    for _, ent in pairs(_G.Ents) do
        local unwrappable = ent.components.unwrappable
        make_itemdata_for_unwrappable(unwrappable)
    end
end

-- Override Unwrappable:WrapItems() to record extra data while making bundle
local Unwrappable = require("components/unwrappable")

local wrap_items = Unwrappable.WrapItems
function Unwrappable:WrapItems(items, doer, ...)
    wrap_items(self, items, doer, ...)
    if #items > 0 and self.itemdata then
        self.itemdata.showbundle_itemdata = make_itemdata(items)
    end
end

local onload = Unwrappable.OnLoad or function() end
function Unwrappable:OnLoad(data, ...)
    local ret = onload(self, data, ...)
    if self.itemdata and not self.itemdata.showbundle_itemdata then
        make_itemdata_for_unwrappable(self)
    end
    return ret
end

local last_update = {
    target = nil,
    time = 0
}

local function draw_tipbox(data, target)
    if SB.tipbox then
        if target then
            SB.tipbox:WidgetSetup(SB.supported_items[target.prefab])
        end
        SB.tipbox:SetData(data)
        if target and target.replica.container and (not data or _G.IsTableEmpty(data)) then
            SB.tipbox:Hide()
        elseif not SB.tipbox.shown or target ~= last_update.target then
            SB.tipbox:Show()
        end
   end
end

local function send_showbundle_request(target)
    SendModRPCToServer(MOD_RPC[modname]["ShowBundle"], target)
    last_update.target = target
    last_update.time = _G.GetTime()
end

local function show_tip(target)
    if last_update.target and last_update.target.replica.container
            and (target == nil or target ~= last_update.target) then -- If it's a container, clear showbundle_itemdata so we'll always try to send_showbundle_request when mouse focus on it again
        last_update.target.showbundle_itemdata = {}
        last_update.target = nil
    end
    if target and SB.supported_items[target.prefab]
            and not (target.replica.container and target.replica.container:IsOpenedBy(_G.ThePlayer)) then
        if target.showbundle_itemdata then
            draw_tipbox(target.showbundle_itemdata, target)
            if last_update.target ~= target
                    or (target.replica.container and _G.GetTime() - last_update.time >= 1) then
                send_showbundle_request(target)
            end
            return
        end
        send_showbundle_request(target)
    end
    SB.tipbox:Hide()
end

AddClassPostConstruct("widgets/controls", function(self)
    if self.owner ~= nil and self.owner == _G.ThePlayer then
        SB.tipbox = Tipbox()
        self.showbundle_tipbox = self:AddChild(SB.tipbox)
    end

    local set_hud_size = self.SetHUDSize
    self.SetHUDSize = function(self, ...)
        if self.showbundle_tipbox then
            self.showbundle_tipbox:ChangeScale(_G.TheFrontEnd:GetHUDScale())
        end
        return set_hud_size(self, ...)
    end
end)

AddClassPostConstruct("widgets/hoverer", function(self)
    local onshow = self.text.OnShow
    self.text.OnShow = function(_self, ...)
        local player = _G.ThePlayer
        if player then
            local hoverinst = _G.TheInput.hoverinst
            local target = hoverinst and hoverinst.entity:IsValid() and hoverinst.entity:IsVisible()
                and (
                    hoverinst.Transform and hoverinst or
                    hoverinst.widget and hoverinst.widget.parent and hoverinst.widget.parent.item
                )
            show_tip(target)
        end
        return onshow(_self, ...)
    end

    local onhide = self.text.OnHide
    self.text.OnHide = function(_self, ...)
        show_tip(nil)
        return onhide(_self, ...)
    end
end)

-- RPC data handler
AddClientModRPCHandler(modname, "ShowBundleCallback", function(target, data)
    target.showbundle_itemdata = SB.unserialize(data) or {}
    draw_tipbox(target.showbundle_itemdata, target)
end)

AddModRPCHandler(modname, "ShowBundle", function (player, target)
    if not _G.checkentity(target) then
        print(string.format("Invalid %s RPC from (%s) %s", "ShowBundle", player.userid or "", player.name or ""))
        return
    end
    local itemdata = {}
    local showbundle_itemdata = target.components.unwrappable
                            and target.components.unwrappable.itemdata
                            and target.components.unwrappable.itemdata.showbundle_itemdata
    if showbundle_itemdata then
        itemdata = showbundle_itemdata
    elseif target.components.container then
        itemdata = make_itemdata(target.components.container.slots)
    end
    itemdata = handle_redpouch_data(target, itemdata) or itemdata
    SendModRPCToClient(CLIENT_MOD_RPC[modname]["ShowBundleCallback"], player.userid, target, SB.serialize(itemdata))
end)

local ShowMe_Hint = _G.MOD_RPC.ShowMeSHint and _G.MOD_RPC.ShowMeSHint.Hint
if ShowMe_Hint then
    local Old_SendModRPCToServer = _G.SendModRPCToServer
    _G.SendModRPCToServer = function(id_table, GUID, ...)
        local ent = _G.Ents[GUID]
        if id_table == ShowMe_Hint
                and ent and (ent.prefab == "bundle" or ent.prefab == "gift") then
            return
        end
        return Old_SendModRPCToServer(id_table, GUID, ...)
    end
end

SB.make_itemdata = make_itemdata
SB.make_itemdata_for_unwrappable = make_itemdata_for_unwrappable
SB.refresh_all_bundle_data = refresh_all_bundle_data
SB.send_showbundle_request = send_showbundle_request
