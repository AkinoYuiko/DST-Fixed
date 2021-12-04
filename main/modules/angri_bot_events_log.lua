local AddPrefabPostInit = AddPrefabPostInit
local AddSimPostInit = AddSimPostInit
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
    STALKER_ATRIUM = {
        "中庭",
        "钟婷",
    },
    MALBATROSS = {
        "邪天翁",
        "屑天翁",
    },
    DEERCLOPS = "巨鹿",
    KLAUS = "克劳斯",
    TOADSTOOL = "小蛤蟆",
    TOADSTOOL_DARK = "大蛤蟆",
    ANTLION = "蚁狮",
    EYEOFTERROR = "小眼",
    TWINMANAGER = "双眼",
}

local function add_zero(day)
    if not type(day) == "number" then return end
    local day_str = day % 1000
    if day_str == 0 then
        return day % 10000
    elseif math.floor(day_str / 10) == 0 then
        return "00" .. day_str
    elseif math.floor(day_str / 100) == 0 then
        return "0" .. day_str
    else
        return day_str
    end
end

local function get_nearby_players(inst)
    local players = {}
    for _, v in ipairs(AllPlayers) do
        if inst:GetDistanceSqToInst(v) < 3600 then
            table.insert(players, UserToName(v.userid) .. "(" .. STRINGS.NAMES[string.upper(v.prefab)] .. ")")
            table.insert(players, ", ")
        end
    end
    if #players >= 2 then table.remove(players) end
    return table.concat(players)
end

local function get_cycles_seg(delay)
    if not TheWorld then return end

    local cycles = TheWorld.state.cycles + 1
    local seg = TheWorld.state.time * 16 + 0.5
    local delay_segs = ( type(delay) == "number" and delay or 0 ) * 16
    seg = math.floor(seg + delay_segs)
    while seg >= 16 do
        day = day + 1
        seg = seg - 16
    end
    return cycles, seg
end

local function get_date(delay)
    local cycles, seg = get_cycles_seg(delay)
    return add_zero(cycles) .. "(" .. seg .. ")"
end

local function death_fn(inst, msg, delay)
    local prefab = type(msg) == "table" and msg[math.random(1, #msg)] or msg
    local date = get_date(delay)
    print("angri_BOT", "EPIC", prefab, date, get_nearby_players(inst))
end

local function common_death_fn(delay_days)
    return function(inst) death_fn(inst, ANGRI_DEATH[string.upper(inst.prefab)], delay_days) end
end

local epics = 
{
    stalker_atrium = common_death_fn(0.5),
    dragonfly = common_death_fn(),
    toadstool = common_death_fn(),
    toadstool_dark = common_death_fn(),
    malbatross = common_death_fn(),
    antlion = common_death_fn(),
    eyeofterror = common_death_fn(),
    klaus = function(inst)
        if not TheWorld.ismastersim then return end

        if inst:IsUnchained() then death_fn(inst, ANGRI_DEATH.KLAUS) end
    end,
    crabking = function(inst)
        if not TheWorld.ismastersim then return end

        local num = inst:countgems().pearl
        local type = num == 9 and "MAX" or
                    (num > 0 and "PEARL") or
                    "GENERAL"
        death_fn(inst, ANGRI_DEATH.CRABKING[type])
    end,
    deerclops = function(inst)
        if not TheWorld.ismastersim then return end

        local date = get_date()
        local season = ZH_SEASON[TheWorld.state.season]
        local day = TheWorld.state.elapseddaysinseason + 1

        print("angri_BOT", "EPIC", ANGRI_DEATH[string.upper(inst.prefab)], date , season .. day, get_nearby_players(inst))
    end,
}

for prefab, fn in pairs(epics) do 
    AddPrefabPostInit(prefab, function(inst)
        if not TheWorld.ismastersim then return end
        inst:ListenForEvent("death", fn)
    end)
end

-- Twin of Terror --
AddPrefabPostInit("twinmanager", function(inst)
    if not TheWorld.ismastersim then return end

    local function check_end_fight()
        local et = inst.components.entitytracker
        local t1 = et:GetEntity("twin1")
        local t2 = et:GetEntity("twin2")
        if (t1 == nil or t1.components.health:IsDead()) and (t2 == nil or t2.components.health:IsDead()) then
            death_fn(inst, ANGRI_DEATH.TWINMANAGER, -1/32)
        end
    end

    inst:ListenForEvent("arrive", function(inst)
        inst:DoTaskInTime(0, function(inst)
            local et = inst.components.entitytracker
            local t1 = et:GetEntity("twin1")
            local t2 = et:GetEntity("twin2")

            inst:ListenForEvent("death", check_end_fight, t1)
            inst:ListenForEvent("death", check_end_fight, t2)
        end)
    end)
end)

AddSimPostInit(function()
    if not TheWorld.ismastersim then return end
    TheWorld:ListenForEvent("cycleschanged", function(inst, data)
        local cycles = get_cycles_seg()
        local season = ZH_SEASON[TheWorld.state.season]
        local day = TheWorld.state.elapseddaysinseason + 1
        if not TheWorld:HasTag("cave") then
            print("angri_BOT", "CYCLES", cycles, season .. day)
        end
    end)
end)