local function loc(t)
    t.zhr = t.zh
    t.zht = t.zht or t.zh
    t.ch = t.ch or t.zh
    return t[locale] or t.en
end

local function zh_en(a, b)
    return loc({
        zh = a,
        en = b
    })
end

version = "2.11.3"
name = zh_en("纯净辅助", "DST Fixed")
author = zh_en("丁香女子学校", "Civi, Tony")

local new_modules = {
    CLASSICBOOKGARDENING = true
}

changelog = zh_en([[
- 临时给Klei修复机器人夜视模块在有洞穴服务器存在BUG的问题。

- 移除启迪之冠碎片配方对IA的兼容。
- 更新了recipe2util。
]], [[
- Fix issue with WX78's night vision module in dedicated servers for Klei, temporarily.

- Remove compatibility work for Island Adventures.
- Update RecipeUtil(pwd: utils/recipe2util).
]])
description = zh_en("版本: ", "Version: ") .. version ..
    zh_en("\n\n更新内容:\n", "\n\nChangelog:\n") .. changelog

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
    {description = zh_en("启用", "Yes"), data = true},
    {description = zh_en("禁用", "No"),  data = false}
}


configuration_options = {
    AddTitle(zh_en("默认开启", "Default On")),
    {
        name = "BUNDLE",
        label = zh_en("显示包裹内容", "Show Bundle"),
        hover = zh_en("鼠标放在包裹上时显示里面的内容", "Show bundles and gifts' content on mouse hover."),
        options = boolean,
        default = true
    },
    AddTitle(zh_en("玩家相关","The Player")),
    {
        name = "ATKSPEED",
        label = zh_en("解除玩家攻速限制", "Enable Quick Attack"),
        options = boolean,
        default = false
    },
    {
        name = "SMARTUNWRAP",
        label = zh_en("拆包裹进物品栏", "Inventory Unwrap"),
        hover = zh_en("拆开包裹会进物品栏或箱子而不是掉落在地上"),
        options = boolean,
        default = false
    },
    {
        name = "CHECKSKINOWNERSHIP",
        label = zh_en("皮肤套用优化", "Extended Player Skins"),
        hover = zh_en("玩家可以套用其他角色的皮肤", "Players can use other characters' skin"),
        options = boolean,
        default = false
    },
    {
        name = "SITEMOTE",
        label = zh_en("固定坐下表情", "Static Sit Emote"),
        hover = zh_en("输入/sit时一定会坐下", "Static anim for /sit"),
        options = boolean,
        default = false
    },

    {
        name = "CUSTOMFAILSTR",
        label = zh_en("个性化动作失败台词", "Custom Action Fail String"),
        hover = zh_en("每个角色都会使用自己的动作失败台词而不是威尔逊的 \"我做不到。\"", "Characters use theis own actionfail strings instead of \"I can't do that.\""),
        options = boolean,
        default = false
    },
    {
        name = "NOGHOSTHOUNDED",
        label = zh_en("禁用灵魂来狗", "Disable Ghost Hounded"),
        hover = zh_en("灵魂状态的玩家在猎犬袭击开始时不会被统计进去", "Ghost players won't be stat on hounds-attack start."),
        options = boolean,
        default = false
    },
    {
        name = "LOCALIZEDESC",
        label = zh_en("检查文本跟随客户端语言", "Enhanced Localized Description"),
        hover = zh_en("大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用", "Make most descriptions follow client language.\n Testing func. Use at your own risk."),
        options = boolean,
        default = false
    },
    {
        name = "WORTOXTIMETRAVEL",
        label = zh_en("沃托克斯时间旅行", "Wortox the Time Traveler"),
        -- hover = zh_en("大部分检查文本将跟随客户端语言\n测试性功能，谨慎使用", "Make most descriptions follow client language.\n Testing func. Use at your own risk.",
        options = boolean,
        default = false
    },
    {
        name = "FTKMEMES",
        label = zh_en("为了吾王经典台词", "FTK Memes"),
        hover = zh_en("FTK 阴间笑话", "Replace some strings with FTK strings."),
        options = boolean,
        default = false
    },

    AddTitle(zh_en("装备相关", "The Equipment")),
    {
        name = "EQUIPMENT",
        label = zh_en("装备耐久合并", "Combinable Equipment"),
        hover = zh_en("同类装备可以互相合并耐久", "Enable equipment combination."),
        options = boolean,
        default = false
    },
    {
        name = "HIDELUNARCROWN",
        label = zh_en("隐藏未激活启迪之冠", "Hide Inactive Enlightened Crown"),
        -- hover = zh_en("", "Moon Shard into Enlightened Crown",
        options = boolean,
        default = false
    },
    {
        name = "LUNARCROWN",
        label = zh_en("强化启迪之冠", "Enhanced Enlightened Crown"),
        hover = zh_en("启迪之冠可放入月亮碎片代替攻击时的精神消耗\n月灵被替换为另一种特效，且可以享受玩家的倍率（不会小于1倍率）和增益加成", "Moon Shard into Enlightened Crown"),
        options = boolean,
        default = false
    },
    {
        name = "SANDSTONE",
        label = zh_en("强化沙之石", "Enhanced Sand Stone"),
        hover = zh_en("右键使用沙之石生成一次性临时沙塔", "Use Sand stone in inventory to generate a temp Lazy Deserter."),
        options = boolean,
        default = false
    },
    {
        name = "NAMEABLE_WATCHES",
        label = zh_en("表可以命名", "Nameable Backtrek Watch"),
        hover = zh_en("旺达的溯源表和裂缝表可以用羽毛笔命名"),
        options = boolean,
        default = false
    },
    {
        name = "NODARTWASTE",
        label = zh_en("吹箭不浪费", "No Blow Dart Waste"),
        hover = zh_en("吹箭打在无效目标上面时会掉落而不是消失", "No blow dart waste when hitting a dead target"),
        options = boolean,
        default = false
    },
    {
        name = "POCKETRESKIN",
        label = zh_en("物品栏换皮肤", "Reskin From Inventory"),
        hover = zh_en("扫把可以对物品栏内的物品使用（手杖除外）", "Clean Sweeper can sweep inventory items (Cane not included)"),
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENHAT",
        label = zh_en("禁用蜂王冠鞠躬", "No bowing for Bee Queen Crown"),
        hover = zh_en("玩家不会对其他戴着蜂王冠的玩家鞠躬"),
        options = boolean,
        default = false
    },
    {
        name = "MHATS",
        label = zh_en("蘑菇帽可以发光", "Glowing Mushroom Hats"),
        options = boolean,
        default = false
    },
    AddTitle(zh_en("建筑相关", "The Builder")),
    {
        name = "BETTERFOSSIL",
        label = zh_en("修骨架必定成功", "Better Fossil Repairing"),
        options = boolean,
        default = false
    },
    {
        name = "FIREFLIES",
        label = zh_en("萤火虫放进蘑菇灯", "Fireflies in lamps"),
        hover = zh_en("萤火虫可以放进萤菇灯与炽菇灯实现永亮", "Enable fireflies into lamps"),
        options = boolean,
        default = false
    },
    {
        name = "SISTURN",
        label = zh_en("魔改姐妹骨灰盒", "Enhanced Sisturn"),
        hover = zh_en("姐妹骨灰盒可以放骨片或哀悼荣耀", "Allows bone shards and Mourning glory into Sisturn."),
        options = boolean,
        default = false
    },
    {
        name = "GLOMMER",
        label = zh_en("可修复格罗姆雕像", "Glommer Statue Repairing"),
        hover = zh_en("可以用大理石修复格罗姆雕像", "Enable Glommer Statue repairing with marbles."),
        options = boolean,
        default = false
    },
    {
        name = "COOKPOT",
        label = zh_en("红锅不便携", "No Dismantle Crockpots"),
        hover = zh_en("厨师的红锅只能用锤子敲", "Disable Portable Crockpot's Dismantle(Hammers only)."),
        options = boolean,
        default = false
    },
    {
        name = "LUREPLANT",
        label = zh_en("食人花无间距", "Classic Lure Plants"),
        hover = zh_en("恢复旧版食人花的放置距离为 \"无限制放置\""),
        options = boolean,
        default = false
    },
    {
        name = "ENDTABLE",
        label = zh_en("漂浮的烧毁茶几", "Floating burnt End Table"),
        hover = zh_en("移除茶几烧毁动画（参考旧版本龙蝇皮肤茶几）"),
        options = boolean,
        default = false
    },
    AddTitle(zh_en("生物相关", "The Mob")),
    {
        name = "BIRD",
        label = zh_en("鸟晚上不睡觉", "Birds no sleeping"),
        options = boolean,
        default = false
    },
    {
        name = "BLOCKABLEPOOPING",
        label = zh_en("橡胶塞堵住牛屁股", "Block Pooping From Beefalos"),
        hover = zh_en("橡胶塞可以堵住牛屁股使其不拉屎"),
        options = boolean,
        default = false
    },
    {
        name = "TENTACLE",
        label = zh_en("大触手无掉落物", "Tentacle Pillars no Looting"),
        hover = zh_en("大触手不再掉落任何东西（减少垃圾产生）", "Removes Tentacle pillar's loottable"),
        options = boolean,
        default = false
    },
    {
        name = "BEEQUEENGIFTWRAP",
        label = zh_en("蜂后掉落彩纸蓝图", "Bee Queen Extra Drops"),
        hover = zh_en("杀死蜂后掉落彩纸的蓝图", "Bee Queen drops Giftwrap Blueprint"),
        options = boolean,
        default = false
    },
    AddTitle(zh_en("世界相关", "The World")),
    {
        name = "SEED",
        label = zh_en("普通种子腐烂后消失", "Seeds Disappear on Perished"),
        hover = zh_en("【仅】普通种子在腐烂的时候消失而不是生成腐烂食物", "Normal seeds disappear on perished."),
        options = boolean,
        default = false
    },
    {
        name = "FLOWER",
        label = zh_en("保护恶魔花", "No Picking Evil Flowers"),
        hover = zh_en("恶魔花不能摘只能用铲子铲起来", "Disable Evil Flowers picking(DIG instead)."),
        options = boolean,
        default = false
    },
    {
        name = "NOOCEANTREESTRIKEDROP",
        label = zh_en("巨树被劈无掉落", "No Ocean Tree Strike Drops"),
        hover = zh_en("人工种植的巨树被雷劈后不会掉落草和树枝", "Ocean Tress won't drop cutgrass, twigs on thunder strike."),
        options = boolean,
        default = false
    },
    {
        name = "SUMMONMAGIC",
        label = zh_en("异世界召唤魔法", "Isekai Summon Magic"),
        hover = "https://www.bilibili.com/video/BV1bo4y1S736",
        options = boolean,
        default = false
    },
    {
        name = "HONORMOUND",
        label = zh_en("哀悼荣耀填坟", "Mourning Glory into Dug Grave"),
        hover = zh_en("哀悼荣耀可以恢复被挖掉的坟"),
        options = boolean,
        default = false
    },
    {
        name = "BAT",
        label = zh_en("眼球塔增强", "Enhanced Eyeturrets"),
        hover = zh_en("眼球塔主动攻击蝙蝠", "Eyeturrets target bats."),
        options = boolean,
        default = false
    },
    {
        name = "GATHERMOONGLASS",
        label = zh_en("月相盘在出生门掉落", "Gather Moon Dial's Glass"),
        hover = zh_en("风暴事件结束时月相盘在出生门处掉落玻璃碎片", "Moon Glass dropped from Moon Dials will be teleported to Celestial Portal."),
        options = boolean,
        default = false
    },
    {
        name = "PIGKINGMOONGLASS",
        label = zh_en("猪王给月亮碎片", "Pig King Reward Moonglass"),
        hover = zh_en("月亮风暴期间猪王给月亮碎片", "Pig King reward Moon Glass during Moonstorm."),
        options = boolean,
        default = false
    },
    {
        name = "NOFORESTRESOURCEREGEN",
        label = zh_en("禁用森林资源再生", "Disable Forest Resouces Regen"),
        hover = zh_en("使草、树枝、浆果丛等不会再生"),
        options = boolean,
        default = false
    },
    {
        name = "HALLOWEEN",
        label = zh_en("禁用万圣节猪王糖果", "No Halloween Candies"),
        hover = zh_en("万圣节期间猪王不会给糖果（减少垃圾产生）", "Disable halloween candies on trading with Pig King."),
        options = boolean,
        default = false
    },
    {
        name = "WINTERSFEASTLOOTS",
        label = zh_en("减少冬季盛宴掉落", "Less Loots in Winter's Feast"),
        hover = zh_en("禁用冬季盛宴期间小玩意儿和零食的掉落，但不影响BOSS的挂饰（减少垃圾产生）", "Disable most loots in Winter's Feast, eipcs not included."),
        options = boolean,
        default = false
    },
    AddTitle(zh_en("配方相关", "The Crafting")),
    {
        name = "RANDOMLIGHTS",
        label = zh_en("随机彩灯合成", "Random Winter Lights"),
        hover = zh_en("【照明栏解锁】新增彩灯配方, 合成时会随机给一种款式的彩灯", "Enable recipe for RANDOM winter lights"),
        options = boolean,
        default = false
    },
    {
        name = "CROWNFRAGMENT",
        label = zh_en("启迪之冠碎片", "Enlightened Crown Shard"),
        hover = zh_en("【合成栏解锁】新增启迪之冠碎片的合成配方"),
        options = boolean,
        default = false
    },
    {
        name = "TURFARCHIVE",
        label = zh_en("档案馆地皮", "Archive Turf"),
        hover = zh_en("【夯土机制作】新增档案馆地皮配方"),
        options = boolean,
        default = false
    },
    {
        name = "PROPSIGN",
        label = zh_en("拍人小木牌", "Prop Sign"),
        hover = zh_en("【魔法栏解锁】新增拍人小木拍配方"),
        options = boolean,
        default = false
    },
    {
        name = "CLASSICBOOKGARDENING",
        label = zh_en("经典园艺学", "Classic Applied Horticulture"),
        hover = zh_en("经典园艺学，但是新版配方", "Classic Applied Horticulture, butt new recipe"),
        options = boolean,
        default = false
    },
}


local NEWSTR = zh_en("（新）", " (New)")
for i = 1, #configuration_options do
    if configuration_options[i].name and new_modules[configuration_options[i].name] and configuration_options[i].label then
        configuration_options[i].label = configuration_options[i].label .. NEWSTR
    end
end
