local function fn(inst)
    if not GLOBAL.TheWorld.ismastersim then return end
    inst.disable_charcoal = false
end

local firepits = {
    "firepit",
    "campfire",
}

for _, firepit in ipairs(firepits) do
    AddPrefabPostInit(firepit, fn)
end
