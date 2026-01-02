local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local function classic_deploy_postinit(inst)
	if not TheWorld.ismastersim then
		return
	end

	if inst.components.deployable then
		inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
		inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
	end
end

local classic_deploy_prefabs = {
	"lureplantbulb",
	"spidereggsack",
	"fossil_piece",
}

for i = 1, #classic_deploy_prefabs do
	AddPrefabPostInit(classic_deploy_prefabs[i], classic_deploy_postinit)
end
