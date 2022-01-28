local zh = locale == "zh"
local boolean = {
    {description = zh and "启用" or "Yes", data = true},
    {description = zh and "禁用" or "No",  data = false}
}

version = "2.7.4"
name = zh and "纯净辅助" or "DST Fixed"
author = zh and "丁香女子学校" or "Civi, Tony"
description = zh and "[版本: "..version..[[]

更新内容:
- 修复稿纸可能导致的崩溃。

- 修复【蜂后掉落彩纸蓝图】导致的崩溃。
- 调整了强化启迪之冠的消耗率。
- 修复 ipairs 在 SUPPORTED_WATCHES 中不起作用的问题。
- 重构了部分模块的代码以提升性能。

]]
or
"[Version: "..version..[[]

Changelog:
- Fix crash on sketches.

- Fix crash on "Bee Queen Extra Drops".
- Tweak moonglass consume rate with enhanced alterguardianhat.
- Fix issue that ipairs is not working in SUPPORTED_WATCHES.
- Improve code performance for most modules.

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
        label = zh and "解除玩家攻速限制" or "Enable Quick Attack",
        options = boolean,
        default = false
    },
    {
        name = "SMARTUNWRAP",
        label = zh and "拆包裹进物品栏" or "Inventory Unwrap",
        hover = zh and "拆开包裹会进物品栏或箱子而不是掉落在地上",
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
        hover = zh and "输入/sit时一定会坐下" or "Static anim for /sit",
        options = boolean,
        default = false
    },

    {
        name = "CUSTOMFAILSTR",
        label = zh and "个性化动作失败台词" or "Custom Action Fail String",
        hover = zh and "每个角色都会使用自己的动作失败台词而不是威尔逊的 \"我做不到。\"" or "Characters use theis own actionfail strings instead of \"I can't do that.\"",
        options = boolean,
        default = false
    },
    {
        name = "NOGHOSTHOUNDED",
        label = zh and "禁用灵魂来狗" or "Disable Ghost Hounded",
        hover = zh and "灵魂状态的玩家在猎犬袭击开始时不会被统计进去" or "Ghost players won't be stat on hounds-attack start.",
        options = boolean,
        default = false
    },
    {
        name = "LOCALIZEDESC",
        label = zh and "检查文本跟随客户端语言" or "Enhanced Localized Description",
        hover = zh and "大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用" or "Make most descriptions follow client language.\n Testing func. Use at your own risk.",
        options = boolean,
        default = false
    },
    {
        name = "WORTOXTIMETRAVEL",
        label = zh and "沃托克斯时间旅行" or "Wortox the Time Traveler",
        -- hover = zh and "大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用" or "Make most descriptions follow client language.\n Testing func. Use at your own risk.",
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
        name = "HIDELUNARCROWN",
        label = zh and "隐藏未激活启迪之冠（新）" or "Hide Inactive Enlightened Crown (New)",
        -- hover = zh and "" or "Moon Shard into Enlightened Crown",
        options = boolean,
        default = false
    },
    {
        name = "LUNARCROWN",
        label = zh and "强化启迪之冠" or "Enhanced Enlightened Crown",
        hover = zh and "启迪之冠可放入月亮碎片代替攻击时的精神消耗\n月灵被替换为另一种特效，且可以享受玩家的倍率（不会小于1倍率）和增益加成" or "Moon Shard into Enlightened Crown",
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
        hover = zh and "旺达的溯源表和裂缝表可以用羽毛笔命名",
        options = boolean,
        default = false
    },
    {
        name = "NODARTWASTE",
        label = zh and "吹箭不浪费" or "No Blow Dart Waste",
        hover = zh and "吹箭打在无效目标上面时会掉落而不是消失" or "No blow dart waste when hitting a dead target",
        options = boolean,
        default = false
    },
    {
        name = "POCKETRESKIN",
        label = zh and "物品栏换皮肤" or "Reskin From Inventory",
        hover = zh and "扫把可以对物品栏内的物品使用（手杖除外）" or "Clean Sweeper can sweep inventory items (Cane not included)",
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENHAT",
        label = zh and "禁用蜂王冠鞠躬" or "No bowing for Bee Queen Crown",
        hover = zh and "玩家不会对其他戴着蜂王冠的玩家鞠躬",
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
        hover = zh and "萤火虫可以放进萤菇灯与炽菇灯实现永亮" or "Enable fireflies into lamps",
        options = boolean,
        default = false
    },
    {
        name = "SISTURN",
        label = zh and "魔改姐妹骨灰盒" or "Enhanced Sisturn",
        hover = zh and "姐妹骨灰盒可以放骨片或哀悼荣耀" or "Allows bone shards and Mourning glory into Sisturn.",
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
        hover = zh and "恢复旧版食人花的放置距离为 \"无限制放置\"",
        options = boolean,
        default = false
    },
    {
        name = "ENDTABLE",
        label = zh and "漂浮的烧毁茶几" or "Floating burnt End Table",
        hover = zh and "移除茶几烧毁动画（参考旧版本龙蝇皮肤茶几）",
        options = boolean,
        default = false
    },
    AddTitle(zh and "生物相关" or "The Mob"),
    {
        name = "BIRD",
        label = zh and "鸟晚上不睡觉" or "Birds no sleeping",
        options = boolean,
        default = false
    },
    {
        name = "BLOCKABLEPOOPING",
        label = zh and "橡胶塞堵住牛屁股" or "Block Pooping From Beefalos",
        hover = zh and "橡胶塞可以堵住牛屁股使其不拉屎",
        options = boolean,
        default = false
    },
    {
        name = "TENTACLE",
        label = zh and "大触手无掉落物" or "Tentacle Pillars no Looting",
        hover = zh and "大触手不再掉落任何东西（减少垃圾产生）" or "Removes Tentacle pillar's loottable",
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
        label = zh and "普通种子腐烂后消失" or "Seeds Disappear on Perished",
        hover = zh and "【仅】普通种子在腐烂的时候消失而不是生成腐烂食物" or "Normal seeds disappear on perished.",
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
        hover = zh and "人工种植的巨树被雷劈后不会掉落草和树枝" or "Ocean Tress won't drop cutgrass or twigs on thunder strike.",
        options = boolean,
        default = false
    },
    {
        name = "SUMMONMAGIC",
        label = zh and "异世界召唤魔法" or "Isekai Summon Magic",
        hover = "https://www.bilibili.com/video/BV1bo4y1S736",
        options = boolean,
        default = false
    },
    {
        name = "HONORMOUND",
        label = zh and "哀悼荣耀填坟" or "Mourning Glory into Dug Grave",
        hover = zh and "哀悼荣耀可以恢复被挖掉的坟",
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
        hover = zh and "风暴事件结束时月相盘在出生门处掉落玻璃碎片" or "Moon Glass dropped from Moon Dials will be teleported to Celestial Portal.",
        options = boolean,
        default = false
    },
    {
        name = "PIGKINGMOONGLASS",
        label = zh and "猪王给月亮碎片" or "Pig King Reward Moonglass",
        hover = zh and "月亮风暴期间猪王给月亮碎片" or "Pig King reward Moon Glass during Moonstorm.",
        options = boolean,
        default = false
    },
    {
        name = "NOFORESTRESOURCEREGEN",
        label = zh and "禁用森林资源再生" or "Disable Forest Resouces Regen",
        hover = zh and "使草、树枝、浆果丛等不会再生",
        options = boolean,
        default = false
    },
    {
        name = "HALLOWEEN",
        label = zh and "禁用万圣节猪王糖果" or "No Halloween Candies",
        hover = zh and "万圣节期间猪王不会给糖果（减少垃圾产生）" or "Disable halloween candies on trading with Pig King.",
        options = boolean,
        default = false
    },
    {
        name = "WINTERSFEASTLOOTS",
        label = zh and "减少冬季盛宴掉落" or "Less Loots in Winter's Feast",
        hover = zh and "禁用冬季盛宴期间小玩意儿和零食的掉落，但不影响BOSS的挂饰（减少垃圾产生）" or "Disable most loots in Winter's Feast, eipcs not included.",
        options = boolean,
        default = false
    },
    AddTitle(zh and "配方相关" or "The Recipe"),
    {
        name = "RANDOMLIGHTS",
        label = zh and "随机彩灯合成" or "Random Winter Lights",
        hover = zh and "【照明栏解锁】新增彩灯配方, 合成时会随机给一种款式的彩灯" or "Enable recipe for RANDOM winter lights",
        options = boolean,
        default = false
    },
    {
        name = "CROWNFRAGMENT",
        label = zh and "启迪之冠碎片" or "Enlightened Crown Shard",
        hover = zh and "【合成栏解锁】新增启迪之冠碎片的合成配方，无法用绿杖分解",
        options = boolean,
        default = false
    },
    {
        name = "TURFARCHIVE",
        label = zh and "档案馆地皮" or "Archive Turf",
        hover = zh and "【夯土机制作】新增档案馆地皮配方",
        options = boolean,
        default = false
    },
    {
        name = "PROPSIGN",
        label = zh and "拍人小木牌" or "Prop Sign",
        hover = zh and "【魔法栏解锁】新增拍人小木拍配方",
        options = boolean,
        default = false
    },
}
