local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

-- Fix abandon ship board invalid
AddStategraphPostInit("wilson", function(self)
	local onenter = self.states["abandon_ship_pre"].onenter
	self.states["abandon_ship_pre"].onenter = function(inst, ...)
		if inst.bufferedaction and inst.bufferedaction.action == ACTIONS.ABANDON_SHIP then
			inst.sg.statemem.action = inst.bufferedaction
		end
		if onenter then
			return onenter(inst, ...)
		end
	end

	local onexit = self.states["abandon_ship_pre"].onexit
	self.states["abandon_ship_pre"].onexit = function(inst, ...)
		local bufferedaction = inst.sg.statemem.action
		if bufferedaction and bufferedaction:IsValid() then
			bufferedaction:Do()
		end
		if onexit then
			return onexit(inst, ...)
		end
	end
end)
