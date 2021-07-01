AddPrefabPostInit("birdcage", function(inst)
	if not GLOBAL.TheWorld.ismastersim then return end
	local function DoWakeUp(inst)
		if inst.components.sleeper then
			inst.components.sleeper:WakeUp()
			inst:RemoveComponent("sleeper")
		end
	end

	inst:DoPeriodicTask(1, DoWakeUp)
	DoWakeUp(inst)
end)
