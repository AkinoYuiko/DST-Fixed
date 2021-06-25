local _G = GLOBAL

AddPrefabPostInit("birdcage", function(inst)
	local function DoWakeUp(inst)
		if inst.components.sleeper then
			inst.components.sleeper:WakeUp()
			inst:RemoveComponent("sleeper")
		end
	end

	inst:DoPeriodicTask(1, DoWakeUp)
	DoWakeUp(inst)
end)