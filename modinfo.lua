local zh = locale == "zh"
local boolean = {
    {description = zh and "启用" or "Yes", data = true},
    {description = zh and "禁用" or "No",  data = false}
}

version = "2.4.5"
name = zh and "纯净辅助" or "DST Fixed"
author = zh and "丁香女子学校" or "Civi, Tony"
description = zh and "版本: "..version..[[

更新内容:
- 恢复 GetSpecialCharacterString.
- 移除 GetDescriptionCode.

- 新增 GetActionFailStringCode 用于角色动作失败的自定义文本.
- 修复了一个崩溃.
- 尝试修改 Talker.Say
- 新模块【玩家相关 - 检查文本跟随客户端语言】.
]]
or
"[Version: "..version..[[]

Changelog:
- Restore GetSpecialCharacterString.
- Remove GetDescriptionCode.

- Add GetActionFailStringCode for custom actionfail strings.
- Fix crash on talking nil.
- Try modifying Talker.Say
- New Module (The Player): Description Follows Client Language.
]]

api_version = 10
dst_compatible = true
all_clients_require_mod = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

priority = 17

folder_name = folder_name or "workshop-"
if not folder_name:find("workshop-") then
    name = name .. " - DEV"
end

local function AddTitle(title)
    return {
        label = title,
        name = "",
        hover = "",
        options = {{description = "", data = 0}},
        default = 0
    }
end

configuration_options = {
    AddTitle(zh and "默认开启" or "Default On"),
    {
        name = "BUNDLE",
        label = zh and "显示包裹内容" or "Show Bundle",
        hover = zh and "鼠标放在包裹上时显示里面的内容" or "Show bundles and gifts' content on mouse hover.",
        options = boolean,
        default = true
    },
    AddTitle(zh and "玩家相关" or "The Player"),
    {
        name = "ATKSPEED",
        label = zh and "不限制玩家攻速" or "Enable Quick Attack",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "SMARTUNWRAP",
        label = zh and "拆包进物品栏" or "Inventory Unwrap",
        options = boolean,
        default = false
    },
    {
        name = "CHECKSKINOWNERSHIP",
        label = zh and "皮肤套用优化" or "Extended Player Skins",
        hover = zh and "玩家可以套用其他角色的皮肤" or "Players can use other characters' skin",
        options = boolean,
        default = false
    },
    {
        name = "SITEMOTE",
        label = zh and "固定坐下表情" or "Static Sit Emote",
        hover = "Static anim for /sit",
        options = boolean,
        default = false
    },

    {
        name = "CUSTOMFAILSTR",
        label = zh and "个性化动作失败台词" or "Custom Action Fail String",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "NOGHOSTHOUNDED",
        label = zh and "禁用灵魂来狗" or "Disable Ghost Hounded",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "LOCALIZEDESC",
        label = zh and "检查文本跟随客户端语言（新）" or "desc follows client lang (NEW)",
        hover = zh and "大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用" or "Make most descriptions follow client language.\n Testing func. Use at your own risk.",
        options = boolean,
        default = false
    },

    AddTitle(zh and "装备相关" or "The Equipment"),
    {
        name = "EQUIPMENT",
        label = zh and "装备耐久合并" or "Combinable Equipment",
        hover = zh and "同类装备可以互相合并耐久" or "Enable equipment combination.",
        options = boolean,
        default = false
    },
    {
        name = "LUNARCROWN",
        label = zh and "强化启迪之冠" or "Enhanced Enlightened Crown",
        hover = zh and "启迪之冠可放入月亮碎片" or "Moon Shard into Enlightened Crown",
        options = boolean,
        default = false
    },
    {
        name = "SANDSTONE",
        label = zh and "强化沙之石" or "Enhanced Sand Stone",
        hover = zh and "右键使用沙之石生成一次性临时沙塔" or "Use Sand stone in inventory to generate a temp Lazy Deserter.",
        options = boolean,
        default = false
    },
    {
        name = "NAMEABLE_WATCHES",
        label = zh and "表可以命名" or "Nameable Backtrek Watch",
        options = boolean,
        default = false
    },
    {
        name = "NODARTWASTE",
        label = zh and "吹箭不浪费" or "No Blow Dart Waste",
        hover = "No blow dart waste when hitting a dead target",
        options = boolean,
        default = false
    },
    {
        name = "POCKETRESKIN",
        label = zh and "物品栏换皮肤" or "Reskin From Inventory",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENHAT",
        label = zh and "禁用蜂王冠鞠躬" or "No bowing for Bee Queen Crown",
        hover = zh and "玩家不会对其他戴着蜂王冠的玩家鞠躬" or "",
        options = boolean,
        default = false
    },
    {
        name = "MHATS",
        label = zh and "蘑菇帽可以发光" or "Glowing Mushroom Hats",
        hover = "",
        options = boolean,
        default = false
    },
    AddTitle(zh and "建筑相关" or "The Builder"),
    {
        name = "BETTERFOSSIL",
        label = zh and "修骨架必定成功" or "Better Fossil Repairing",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "FIREFLIES",
        label = zh and "萤火虫放进蘑菇灯" or "Fireflies in lamps",
        hover = zh and "萤火虫可以放进萤菇灯与炽菇灯(永亮)" or "Enable fireflies into lamps",
        options = boolean,
        default = false
    },
    {
        name = "SISTURN",
        label = zh and "魔改姐妹骨灰盒" or "Enhanced Sisturn",
        hover = zh and "姐妹骨灰盒可以放骨片和哀悼荣耀" or "Allows bone shards and Mourning glory into Sisturn.",
        options = boolean,
        default = false
    },
    {
        name = "GLOMMER",
        label = zh and "可修复格罗姆雕像" or "Glommer Statue Repairing",
        hover = zh and "可以用大理石修复格罗姆雕像" or "Enable Glommer Statue repairing with marbles.",
        options = boolean,
        default = false
    },
    {
        name = "COOKPOT",
        label = zh and "红锅不便携" or "No Dismantle Crockpots",
        hover = zh and "厨师的红锅只能用锤子敲" or "Disable Portable Crockpot's Dismantle(Hammers only).",
        options = boolean,
        default = false
    },
    {
        name = "LUREPLANT",
        label = zh and "食人花无间距" or "Classic Lure Plants",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "ENDTABLE",
        label = zh and "漂浮的烧毁茶几" or "Floating burnt End Table",
        hover = "",
        options = boolean,
        default = false
    },
    AddTitle(zh and "生物相关" or "The Mob"),
    {
        name = "BIRD",
        label = zh and "鸟不睡觉" or "Birds no sleeping",
        hover = zh and "鸟儿晚上不睡觉" or "Disable Birds' sleep at night.",
        options = boolean,
        default = false
    },
    {
        name = "BLOCKABLEPOOPING",
        label = zh and "堵住牛屁股" or "Block Pooping From Beefalos",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "TENTACLE",
        label = zh and "大触手无掉落物" or "Tentacle Pillars no Looting",
        hover = zh and "大触手不再掉落任何东西(减少垃圾产生)" or "Removes Tentacle pillar's loottable",
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENGIFTWRAP",
        label = zh and "蜂后掉落彩纸蓝图" or "Bee Queen Extra Drops",
        hover = zh and "杀死蜂后掉落彩纸的蓝图" or "Bee Queen drops Giftwrap Blueprint",
        options = boolean,
        default = false
    },
    AddTitle(zh and "世界相关" or "The World"),
    {
        name = "SEED",
        label = zh and "种子腐烂消失" or "Seeds Disappear on Perished",
        hover = zh and "仅普通种子(闸种)在腐烂的时候消失而不是生成腐烂食物" or "Normal seeds disappear on perished.",
        options = boolean,
        default = false
    },
    {
        name = "FLOWER",
        label = zh and "保护恶魔花" or "No Picking Evil Flowers",
        hover = zh and "恶魔花不能摘只能用铲子铲起来" or "Disable Evil Flowers picking(DIG instead).",
        options = boolean,
        default = false
    },
    {
        name = "NOOCEANTREESTRIKEDROP",
        label = zh and "巨树被劈无掉落" or "No Ocean Tree Strike Drops",
        options = boolean,
        default = false
    },
    {
        name = "SUMMONMAGIC",
        label = zh and "异世界召唤魔法" or "Isekai Summon Magic",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "HONORMOUND",
        label = zh and "哀悼荣耀填坟" or "Mourning Glory into Grave",
        options = boolean,
        default = false
    },
    {
        name = "BAT",
        label = zh and "眼球塔增强" or "Enhanced Eyeturrets",
        hover = zh and "眼球塔主动攻击蝙蝠" or "Eyeturrets target bats.",
        options = boolean,
        default = false
    },
    {
        name = "GATHERMOONGLASS",
        label = zh and "月相盘在出生门掉落" or "Gather Moon Dial's Glass",
        hover = zh and "风暴事件结束时月相盘在出生门处掉落玻璃碎片." or "Moon Glass dropped from Moon Dials will be teleported to Celestial Portal.",
        options = boolean,
        default = false
    },
    {
        name = "PIGKINGMOONGLASS",
        label = zh and "猪王给月亮碎片" or "Pig King Reward Moonglass",
        hover = zh and "月亮风暴期间猪王给月亮碎片." or "Pig King reward Moon Glass during Moonstorm.",
        options = boolean,
        default = false
    },
    {
        name = "NOFORESTRESOURCEREGEN",
        label = zh and "禁用森林资源再生" or "Disable Forest Resouces Regen",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "HALLOWEEN",
        label = zh and "禁用万圣节猪王糖果" or "No Halloween Candies",
        hover = zh and "万圣节期间猪王不会给糖果(减少垃圾产生)." or "Disable halloween candies on trading with Pig King.",
        options = boolean,
        default = false
    },
    AddTitle(zh and "配方相关" or "The Recipe"),
    {
        name = "RANDOMLIGHTS",
        label = zh and "随机彩灯合成" or "Random Winter Lights",
        hover = zh and "新增彩灯配方, 合成时会随机给一种款式的彩灯" or "Enable recipe for RANDOM winter lights",
        options = boolean,
        default = false
    },
    {
        name = "CROWNFRAGMENT",
        label = zh and "启迪之冠碎片" or "Enlightened Crown Shard",
        hover = "",
        options = boolean,
        default = false
    },
    {
        name = "TURFARCHIVE",
        label = zh and "档案馆地皮" or "Archive Turf",
        options = boolean,
        default = false
    },
    {
        name = "PROPSIGN",
        label = zh and "拍人小木牌" or "Prop Sign",
        hover = "",
        options = boolean,
        default = false
    },
    -- AddTitle(zh and "未来可能移除的" or "To Be Removed"),
    -- {
    -- 	name = "STAFF",
    -- 	label = zh and "星杖/月杖增强" or "Enhanced Star & Monn Caller Staff",
    -- 	hover = zh and "装备星杖月杖可以右键装备栏原地使用" or "Star/Moon Caller Staff use with right-click on equipped.",
    -- 	options = boolean,
    -- 	default = false
    -- },
    -- {
    -- 	name = "BEEFALO",
    -- 	label = zh and "驯好的牛不打招呼" or "Beefalos No Greeting",
    -- 	hover = zh and "驯好的牛不会跑过来向玩家打招呼" or "Disable beefalos' greeting to players",
    -- 	options = boolean,
    -- 	default = false
    -- },
}
