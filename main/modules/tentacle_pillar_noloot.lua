local AddPrefabPostInit = env.AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("tentacle_pillar",function(inst)
	SetSharedLootTable("tentacle_pillar",{})
end)
