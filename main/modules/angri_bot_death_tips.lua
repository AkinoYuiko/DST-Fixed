local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local ZH_SEASON =
{
    spring = "春",
    summer = "夏",
    autumn = "秋",
    winter = "冬",
}

local ANGRI_DEATH =
{
    DRAGONFLY = {
        "龙蝇",
        "龙嘤",
    },
    CRABKING = {
        GENERAL = "小螃蟹",
        PEARL = "大螃蟹",
        MAX = "大闸蟹",
    },
    STALKER_ARTRIUM = {
        "中庭",
        "钟婷"
    },
    DEERCLOPS = "巨鹿",
    KLAUS = "克劳斯",

}
-- local test_fn = function()
--     c_spawn"dragonfly" c_findnext"dragonfly":PushEvent("death")
-- end

local function add_zero(day)
    local day_rec = day % 1000
    if day_rec == 0 then
        return day % 10000
    elseif math.floor(day_rec / 10) == 0 then
        return "00" .. day_rec
    elseif math.floor(day_rec / 100) == 0 then
        return "0" .. day_rec
    else
        return day_rec
    end
end

local function death_fn(msg, delay)
    if not TheWorld.ismastersim then return end

    local day = (TheWorld.state.cycles + 1) % 1000
    local seg = TheWorld.state.time * 16 + 0.5
    seg = delay and math.floor(seg + delay * 16) or math.floor(seg)
    while seg > 16 do
        day = day + 1
        seg = seg - 16
    end
    day = add_zero(day)
    local time = seg == 0 and day or (day .. "(" .. seg .. ")")
    local prefab = type(msg) == "table" and msg[math.random(1, #msg)] or msg

    print("angri_BOT", time, prefab)
end

local function common_death_fn(delay)
    return function(inst) death_fn(ANGRI_DEATH[string.upper(inst.prefab)], delay) end
end

local epics = 
{
    stalker_atrium = common_death_fn(0.5),
    dragonfly = common_death_fn(0),
    klaus = common_death_fn(0),
    crabking = function(inst)
        if not TheWorld.ismastersim then return end

        local num = inst:countgems().pearl
        local type = num == 9 and "MAX" or
                    (num > 0 and "PEARL") or
                    "GENERAL"
        death_fn(ANGRI_DEATH.CRABKING[type])
    end,
    deerclops = function(inst)
        if not TheWorld.ismastersim then return end

        local season = ZH_SEASON[TheWorld.state.season]
        local day = TheWorld.state.elapseddaysinseason + 1
        print("angri_BOT", season .. day, ANGRI_DEATH[string.upper(inst.prefab)])
    end,
}

for prefab, fn in pairs(epics) do 
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("death", fn)
    end)
end