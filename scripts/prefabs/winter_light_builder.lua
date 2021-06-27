local prefab = {
    "winter_ornament_light1",
    "winter_ornament_light2",
    "winter_ornament_light3",
    "winter_ornament_light4",
    "winter_ornament_light5",
    "winter_ornament_light6",
    "winter_ornament_light7",
	"winter_ornament_light8",
}

-------------------------------
local function onbuilt(inst, builder)
	-- if builder and builder.prefab == "dummy" and builder.components.inventory then
        local num = math.random(1,8)
		local item = SpawnPrefab("winter_ornament_light"..num)
		item.Transform:SetPosition(builder.Transform:GetWorldPosition())
	    builder.components.inventory:GiveItem(item,nil,item:GetPosition())
	-- end
  	inst:Remove()
end

local function MakeBuilder(prefab)
	-- body
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()

        inst:AddTag("CLASSIFIED")

        --[[Non-networked entity]]
        inst.persists = false

        --Auto-remove if not spawned by builder
        inst:DoTaskInTime(0, inst.Remove)

        if not TheWorld.ismastersim then
          return inst
        end

        inst.OnBuiltFn = onbuilt

        return inst
    end

    return Prefab(prefab.."_builder", fn)
end

---------------------------------------


return MakeBuilder("winter_light")