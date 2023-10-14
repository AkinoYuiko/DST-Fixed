local function zheng(zh, en)
    local LOC = {
        zh = zh,
        zht = zh,
    }
    return LOC[locale] or en
end

version = "2.18.4"
name = zheng("纯净辅助", "DST Fixed")
author = zheng("鸭子乐园", "Ducklantis")

local new_modules = {
    SCRATCHEMOTE = true,
}

changelog = zheng([[
- 【强化启迪之冠】伤害从42.5调整为34。

- 【强化启迪之冠】现在无视位面实体抵抗了。
]], [[
- <Enhanced Enlightened Crown> changed damage from 42.5 to 34.

- <Enhanced Enlightened Crown> now ignores Planar Entity Protection.
]])
description = zheng("版本: ", "Version: ") .. version ..
    zheng("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog

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

local function AddTitle(title, hover)
    return {
        name = title,
        hover = hover,
        options = {{description = "", data = false}},
        default = false
    }
end

local boolean = {
    {description = zheng("启用", "Yes"), data = true},
    {description = zheng("禁用", "No"),  data = false}
}


configuration_options = {
    AddTitle(zheng("默认开启", "Default On")),
    {
        name = "BUNDLE",
        label = zheng("显示包裹内容", "Show Bundle"),
        hover = zheng("鼠标放在包裹上时显示里面的内容", "Show bundles and gifts' content on mouse hover."),
        options = boolean,
        default = true
    },
    AddTitle(zheng("玩家相关","The Player")),
    {
        name = "ATKSPEED",
        label = zheng("解除玩家攻速限制", "Enable Quick Attack"),
        options = boolean,
        default = false
    },
    {
        name = "SMARTUNWRAP",
        label = zheng("拆包裹进物品栏", "Inventory Unwrap"),
        hover = zheng("拆开包裹会进物品栏或箱子而不是掉落在地上"),
        options = boolean,
        default = false
    },
    {
        name = "CHECKSKINOWNERSHIP",
        label = zheng("皮肤套用优化", "Extended Player Skins"),
        hover = zheng("玩家可以套用其他角色的皮肤", "Players can use other characters' skin"),
        options = boolean,
        default = false
    },
    {
        name = "SITEMOTE",
        label = zheng("固定坐下表情", "Static Sit Emote"),
        hover = zheng("输入/sit时一定会坐下", "Static anim for /sit"),
        options = boolean,
        default = false
    },
    {
        name = "SCRATCHEMOTE",
        label = zheng("挠头表情", "Scratch Emote"),
        options = boolean,
        default = false
    },

    {
        name = "CUSTOMFAILSTR",
        label = zheng("个性化动作失败台词", "Custom Action Fail String"),
        hover = zheng("每个角色都会使用自己的动作失败台词而不是威尔逊的 \"我做不到。\"", "Characters use theis own actionfail strings instead of \"I can't do that.\""),
        options = boolean,
        default = false
    },
    {
        name = "NOGHOSTHOUNDED",
        label = zheng("禁用灵魂来狗", "Disable Ghost Hounded"),
        hover = zheng("灵魂状态的玩家在猎犬袭击开始时不会被统计进去", "Ghost players won't be stat on hounds-attack start."),
        options = boolean,
        default = false
    },
    {
        name = "LOCALIZEDESC",
        label = zheng("检查文本跟随客户端语言", "Enhanced Localized Description"),
        hover = zheng("大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用", "Make most descriptions follow client language.\n Testing func. Use at your own risk."),
        options = boolean,
        default = false
    },
    {
        name = "WORTOXTIMETRAVEL",
        label = zheng("沃托克斯时间旅行", "Wortox the Time Traveler"),
        -- hover = zh_en("大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用", "Make most descriptions follow client language.\n Testing func. Use at your own risk.",
        options = boolean,
        default = false
    },
    {
        name = "EVERYONEMAGICHAT",
        label = zheng("人人皆是魔术师", "Magic Hat for Everyone"),
        hover = zheng("所有玩家都可以使用魔术帽", ""),
        options = boolean,
        default = false
    },
    {
        name = "FTKMEMES",
        label = zheng("为了吾王经典台词", "FTK Memes"),
        hover = zheng("FTK 阴间笑话", "Replace some strings with FTK strings."),
        options = boolean,
        default = false
    },

    AddTitle(zheng("装备相关", "The Equipment")),
    {
        name = "BLINK_MAP",
        label = zheng("橙杖地图传送", "Orange Staff Map Blink"),
        hover = zheng("懒人魔杖可以使用地图传送", "Players can teleproof on map with The Lazy Explorer."),
        options = boolean,
        default = false
    },
    {
        name = "EQUIPMENT",
        label = zheng("装备耐久合并", "Combinable Equipment"),
        hover = zheng("同类装备可以互相合并耐久", "Enable equipment combination."),
        options = boolean,
        default = false
    },
    {
        name = "HIDELUNARCROWN",
        label = zheng("隐藏未激活启迪之冠", "Hide Inactive Enlightened Crown"),
        -- hover = zh_en("", "Moon Shard into Enlightened Crown",
        options = boolean,
        default = false
    },
    {
        name = "LUNARCROWN",
        label = zheng("强化启迪之冠", "Enhanced Enlightened Crown"),
        hover = zheng("启迪之冠可放入月亮碎片代替攻击时的精神消耗\n月灵被替换为另一种特效，且可以享受玩家的倍率（不会小于1倍率）和增益加成", "Moon Shard into Enlightened Crown"),
        options = boolean,
        default = false
    },
    {
        name = "BOOKMOON",
        label = zheng("强化月之魔典", "Enhanced Lunar Grimoire"),
        hover = zheng("月之魔典在月圆的时候读会月黑", "Read Lunar Grimoire on full moon will change it to new moon"),
        options = boolean,
        default = false
    },
    {
        name = "SANDSTONE",
        label = zheng("强化沙之石", "Enhanced Sand Stone"),
        hover = zheng("右键使用沙之石生成一次性临时沙塔", "Use Sand stone in inventory to generate a temp Lazy Deserter."),
        options = boolean,
        default = false
    },
    {
        name = "NAMEABLE_WATCHES",
        label = zheng("表可以命名", "Nameable Backtrek Watch"),
        hover = zheng("旺达的溯源表和裂缝表可以用羽毛笔命名"),
        options = boolean,
        default = false
    },
    {
        name = "NODARTWASTE",
        label = zheng("吹箭不浪费", "No Blow Dart Waste"),
        hover = zheng("吹箭打在无效目标上面时会掉落而不是消失", "No blow dart waste when hitting a dead target"),
        options = boolean,
        default = false
    },
    {
        name = "POCKETRESKIN",
        label = zheng("物品栏换皮肤", "Reskin From Inventory"),
        hover = zheng("扫把可以对物品栏内的物品使用（手杖除外）", "Clean Sweeper can sweep inventory items (Cane not included)"),
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENHAT",
        label = zheng("禁用蜂王冠鞠躬", "No bowing for Bee Queen Crown"),
        hover = zheng("玩家不会对其他戴着蜂王冠的玩家鞠躬"),
        options = boolean,
        default = false
    },
    {
        name = "MHATS",
        label = zheng("蘑菇帽可以发光", "Glowing Mushroom Hats"),
        options = boolean,
        default = false
    },
    AddTitle(zheng("建筑相关", "The Builder")),
    {
        name = "BETTERFOSSIL",
        label = zheng("修骨架必定成功", "Better Fossil Repairing"),
        options = boolean,
        default = false
    },
    {
        name = "FIREFLIES",
        label = zheng("萤火虫放进蘑菇灯", "Fireflies in lamps"),
        hover = zheng("萤火虫可以放进萤菇灯与炽菇灯实现永亮", "Enable fireflies into lamps"),
        options = boolean,
        default = false
    },
    {
        name = "SISTURN",
        label = zheng("魔改姐妹骨灰盒", "Enhanced Sisturn"),
        hover = zheng("姐妹骨灰盒可以放骨片或哀悼荣耀", "Allows bone shards and Mourning glory into Sisturn."),
        options = boolean,
        default = false
    },
    {
        name = "GLOMMER",
        label = zheng("可修复格罗姆雕像", "Glommer Statue Repairing"),
        hover = zheng("可以用大理石修复格罗姆雕像", "Enable Glommer Statue repairing with marbles."),
        options = boolean,
        default = false
    },
    {
        name = "COOKPOT",
        label = zheng("红锅不便携", "No Dismantle Crockpots"),
        hover = zheng("厨师的红锅只能用锤子敲", "Disable Portable Crockpot's Dismantle(Hammers only)."),
        options = boolean,
        default = false
    },
    {
        name = "LUREPLANT",
        label = zheng("食人花无间距", "Classic Lure Plants"),
        hover = zheng("恢复旧版食人花的放置距离为 \"无限制放置\""),
        options = boolean,
        default = false
    },
    {
        name = "ENDTABLE",
        label = zheng("漂浮的烧毁茶几", "Floating burnt End Table"),
        hover = zheng("移除茶几烧毁动画（参考旧版本龙蝇皮肤茶几）"),
        options = boolean,
        default = false
    },
    {
        name = "FIREPITCHARCOAL",
        label = zheng("火堆不掉木炭", "No Firepit Charcoal"),
        options = boolean,
        default = false
    },

    AddTitle(zheng("生物相关", "The Mob")),
    {
        name = "BIRD",
        label = zheng("鸟晚上不睡觉", "Birds no sleeping"),
        options = boolean,
        default = false
    },
    {
        name = "BLOCKABLEPOOPING",
        label = zheng("橡胶塞堵住牛屁股", "Block Pooping With a Bung"),
        hover = zheng("橡胶塞可以堵住牛屁股使其不拉屎"),
        options = boolean,
        default = false
    },
    {
        name = "TENTACLE",
        label = zheng("大触手无掉落物", "Tentacle Pillars no Looting"),
        hover = zheng("大触手不再掉落任何东西（减少垃圾产生）", "Removes Tentacle pillar's loottable"),
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENGIFTWRAP",
        label = zheng("蜂后掉落彩纸蓝图", "Bee Queen Extra Drops"),
        hover = zheng("杀死蜂后掉落彩纸的蓝图", "Bee Queen drops Giftwrap Blueprint"),
        options = boolean,
        default = false
    },
    AddTitle(zheng("世界相关", "The World")),
    {
        name = "SEED",
        label = zheng("普通种子腐烂后消失", "Seeds Disappear on Perished"),
        hover = zheng("【仅】普通种子在腐烂的时候消失而不是生成腐烂食物", "Normal seeds disappear on perished."),
        options = boolean,
        default = false
    },
    {
        name = "FLOWER",
        label = zheng("保护恶魔花", "No Picking Evil Flowers"),
        hover = zheng("恶魔花不能摘只能用铲子铲起来", "Disable Evil Flowers picking(DIG instead)."),
        options = boolean,
        default = false
    },
    {
        name = "NOOCEANTREESTRIKEDROP",
        label = zheng("巨树被劈无掉落", "No Ocean Tree Strike Drops"),
        hover = zheng("人工种植的巨树被雷劈后不会掉落草和树枝", "Ocean Tress won't drop cutgrass, twigs on thunder strike."),
        options = boolean,
        default = false
    },
    {
        name = "SUMMONMAGIC",
        label = zheng("异世界召唤魔法", "Isekai Summon Magic"),
        hover = "https://www.bilibili.com/video/BV1bo4y1S736",
        options = boolean,
        default = false
    },
    {
        name = "HONORMOUND",
        label = zheng("哀悼荣耀填坟", "Mourning Glory into Dug Grave"),
        hover = zheng("哀悼荣耀可以恢复被挖掉的坟"),
        options = boolean,
        default = false
    },
    {
        name = "BAT",
        label = zheng("眼球塔增强", "Enhanced Eyeturrets"),
        hover = zheng("眼球塔主动攻击蝙蝠", "Eyeturrets target bats."),
        options = boolean,
        default = false
    },
    {
        name = "GATHERMOONGLASS",
        label = zheng("月相盘在出生门掉落", "Gather Moon Dial's Glass"),
        hover = zheng("风暴事件结束时月相盘在出生门处掉落玻璃碎片", "Moon Glass dropped from Moon Dials will be teleported to Celestial Portal."),
        options = boolean,
        default = false
    },
    {
        name = "PIGKINGMOONGLASS",
        label = zheng("猪王给月亮碎片", "Pig King Reward Moonglass"),
        hover = zheng("月亮风暴期间猪王给月亮碎片", "Pig King reward Moon Glass during Moonstorm."),
        options = boolean,
        default = false
    },
    {
        name = "NOFORESTRESOURCEREGEN",
        label = zheng("禁用森林资源再生", "Disable Forest Resouces Regen"),
        hover = zheng("使草、树枝、浆果丛等不会再生"),
        options = boolean,
        default = false
    },
    {
        name = "HALLOWEEN",
        label = zheng("禁用万圣节猪王糖果", "No Halloween Candies"),
        hover = zheng("万圣节期间猪王不会给糖果（减少垃圾产生）", "Disable halloween candies on trading with Pig King."),
        options = boolean,
        default = false
    },
    {
        name = "WINTERSFEASTLOOTS",
        label = zheng("减少冬季盛宴掉落", "Less Loots in Winter's Feast"),
        hover = zheng("禁用冬季盛宴期间小玩意儿和零食的掉落，但不影响BOSS的挂饰（减少垃圾产生）", "Disable most loots in Winter's Feast, eipcs not included."),
        options = boolean,
        default = false
    },
    AddTitle(zheng("配方相关", "The Crafting")),
    {
        name = "RANDOMLIGHTS",
        label = zheng("随机彩灯合成", "Random Winter Lights"),
        hover = zheng("【照明栏解锁】新增彩灯配方, 合成时会随机给一种款式的彩灯", "Enable recipe for RANDOM winter lights"),
        options = boolean,
        default = false
    },
    {
        name = "CROWNFRAGMENT",
        label = zheng("启迪之冠碎片", "Enlightened Crown Shard"),
        hover = zheng("【合成栏解锁】新增启迪之冠碎片的合成配方"),
        options = boolean,
        default = false
    },
    {
        name = "PROPSIGN",
        label = zheng("拍人小木牌", "Prop Sign"),
        hover = zheng("【魔法栏解锁】新增拍人小木拍配方"),
        options = boolean,
        default = false
    },
    {
        name = "CLASSICBOOKGARDENING",
        label = zheng("经典园艺学", "Classic Applied Horticulture"),
        hover = zheng("经典园艺学，但是新版配方", "Classic Applied Horticulture, butt new recipe"),
        options = boolean,
        default = false
    },
}


local NEWSTR = zheng("（新）", " (New)")
for i = 1, #configuration_options do
    if configuration_options[i].name and new_modules[configuration_options[i].name] and configuration_options[i].label then
        configuration_options[i].label = configuration_options[i].label .. NEWSTR
    end
end
