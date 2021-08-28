local assets =
{
    Asset("ANIM", "anim/gravestones.zip"),
}

local prefabs =
{
    "mound",
    "sand_puff",
}

local function OnCyclesChanged(inst)
    print("OnCyclesChanged", inst)
    local mound = SpawnPrefab("mound")
    local sand_fx = SpawnPrefab("sand_puff")
    mound.Transform:SetPosition(inst:GetPosition():Get())
    SpawnPrefab("sand_puff").entity:SetParent(mound.entity)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("gravestone")
    inst.AnimState:SetBuild("gravestones")
    inst.AnimState:PlayAnimation("gravedirt")

    -- inst:AddTag("grave")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:WatchWorldState("cycles", OnCyclesChanged)

    return inst
end

return Prefab("honor_mound", fn, assets, prefabs)
