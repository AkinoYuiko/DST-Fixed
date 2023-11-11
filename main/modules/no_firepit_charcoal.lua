local function fn(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    inst.disable_charcoal = true
end

local firepits = {
    "firepit",
    "campfire",
    "cotl_tabernacle_level3",
}

for _, firepit in ipairs(firepits) do
    AddPrefabPostInit(firepit, fn)
end
