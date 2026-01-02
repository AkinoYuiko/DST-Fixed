local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("birdcage", function(inst)
	if not TheWorld.ismastersim then
		return
	end
	local function DoWakeUp(inst)
		if inst.components.sleeper then
			inst.components.sleeper:WakeUp()
			inst:RemoveComponent("sleeper")
		end
	end

	inst:DoPeriodicTask(1, DoWakeUp)
	DoWakeUp(inst)
end)
