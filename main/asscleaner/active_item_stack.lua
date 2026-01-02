GLOBAL.setfenv(1, GLOBAL)

-- Fix active_item's stack-lost when swimming
local Inventory = require("components/inventory")
function Inventory:DropActiveItem()
	if self.activeitem then
		local active_item = self:DropItem(self.activeitem, true) -- Do whole stack
		self:SetActiveItem(nil)
		return active_item
	end
end
