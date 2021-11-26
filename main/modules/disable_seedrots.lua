local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local remove_table = {
	seeds = TUNING.PERISH_SUPERSLOW,
	lightbulb = TUNING.PERISH_FAST,
	roe = TUNING.PERISH_FAST
}

local function add_prefab_post_init(prefab, perish_time)
	AddPrefabPostInit(prefab, function(inst)
		if inst.components.perishable then
			inst.components.perishable:SetPerishTime(perish_time)
			inst.components.perishable:StartPerishing()
			inst.components.perishable:SetOnPerishFn(function(inst) inst:Remove() end)
		end
	end)
end

for prefab, time in pairs(remove_table) do
	add_prefab_post_init(prefab, time)
end