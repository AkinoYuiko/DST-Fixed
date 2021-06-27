local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local UIAnim = require "widgets/uianim"

local MyItemTile = Class(Widget, function(self, itemt)
    Widget._ctor(self, "Tipbox")
    self.t = itemt

    self.isactivetile = false
    self.ispreviewing = false
    self.movinganim = nil
    self.ignore_stacksize_anim = nil

    self.bg = self:AddChild(Image())
    self.bg:SetTexture(HUD_ATLAS, "inv_slot_spoiled.tex")
    self.bg:Hide()
    self.bg:SetClickable(false)
    self.basescale = 1

    self.spoilage = self:AddChild(UIAnim())
    self.spoilage:GetAnimState():SetBank("spoiled_meter")
    self.spoilage:GetAnimState():SetBuild("spoiled_meter")
    self.spoilage:Hide()
    self.spoilage:SetClickable(false)

    self.wetness = self:AddChild(UIAnim())
    self.wetness:GetAnimState():SetBank("wet_meter")
    self.wetness:GetAnimState():SetBuild("wet_meter")
    self.wetness:GetAnimState():PlayAnimation("idle")
    self.wetness:Hide()
    self.wetness:SetClickable(false)

	-- Fix spiced foods texture
    if self.t.nameoverride ~= nil then
		local inv_image_bg = { image = self.t.nameoverride ..".tex" }
		inv_image_bg.atlas = GetInventoryItemAtlas(inv_image_bg.image)
        self.imagebg = self:AddChild(Image(inv_image_bg.atlas, inv_image_bg.image, "default.tex"))
        self.imagebg:SetClickable(false)
		self.imagebg:Hide()
    end

    self.image = self:AddChild(Image(self.t.atlas or GetInventoryItemAtlas(self.t.image), self.t.image, "default.tex"))
	self.image:Hide()

    if self.t.prefab == "spoiled_food" or self.t.spoil then
        self.bg:Show()
    end

    if self.t.spoil then
        self.spoilage:Show()
    end

    self:Refresh()
end)

function MyItemTile:Refresh()
    self.ispreviewing = false
    self.ignore_stacksize_anim = nil

    if self.movinganim == nil and self.t.stack ~= nil then
        self:SetQuantity(self.t.stack)
    end

    if self.t.fuel ~= nil then
        self:SetPercent(self.t.fuel)
    end

    if self.t.uses ~= nil then
        self:SetPercent(self.t.uses)
    end

    if self.t.perish ~= nil then
        if self.t.spoil then
            self:SetPerishPercent(self.t.perish)
        else
            self:SetPercent(self.t.perish)
        end
    end

    if self.t.armor ~= nil then
        self:SetPercent(self.t.armor)
    end

    if not self.isactivetile then
        if self.t.iswet then
            self.wetness:Show()
        else
            self.wetness:Hide()
        end
    end

	if self.imagebg then
		self.imagebg:Show()
	end
    self.image:Show()
end

function MyItemTile:SetQuantity(quantity)
    if not self.quantity then
        self.quantity = self:AddChild(Text(NUMBERFONT, 42))
        self.quantity:SetPosition(2,16,0)
    end
    -- if quantity > 1 then
        self.quantity:SetString(tostring(quantity))
    -- end
end

function MyItemTile:SetPerishPercent(percent)
    self.spoilage:GetAnimState():SetPercent("anim", 1 - percent)
end

function MyItemTile:SetPercent(percent)

    if not self.percent then
        self.percent = self:AddChild(Text(NUMBERFONT, 42))
        if JapaneseOnPS4() then
            self.percent:SetHorizontalSqueeze(0.7)
        end
        self.percent:SetPosition(5,-32+15,0)
    end
    local val_to_show = percent*100
    if val_to_show > 0 and val_to_show < 1 then
        val_to_show = 1
    end
    self.percent:SetString(string.format("%2.0f%%", val_to_show))

end

function MyItemTile:SetBaseScale(sc)
    self.basescale = sc
    self:SetScale(sc)
end


return MyItemTile
