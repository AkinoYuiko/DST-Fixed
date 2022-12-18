local function fn(inst)
    inst.disable_charcoal = false
end

local firepits = {
    "firepit",
    "campfire",
}
for _, firepit in ipairs(firepits) do
    AddPrefabPostInit(firepit, fn)
end
