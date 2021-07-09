version = "1.43"

name = locale == "zh" and "纯净辅助" or "DST Fixed"
author = locale == "zh" and "丁香女子学校" or "Civi, Tony"
description = locale == "zh" and "版本: "..version..[[

更新内容:
- 调整模块: 强化启迪之冠月灵范围缩小.
- 新模块: 合成拍人小木牌 (魔法二本).
]]
or
"Version: "..version..[[

Changelog: 
- Adjust Module: Gestalt Range is smaller on Enlightened Crown.
- New Module: Craftable Prop Sign (Magic Tab).
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
local boolean = {
	{description = locale == "zh" and "启用" or "Yes", data = true},
	{description = locale == "zh" and "禁用" or "No",  data = false}
}

configuration_options = {
	{
		name = "BUNDLE",
		label = locale == "zh" and "显示包裹内容" or "Show Bundle",
		hover = locale == "zh" and "鼠标放在包裹上时显示里面的内容" or "Show bundles and gifts' content on mouse hover.",
		options = boolean,
		default = true
	},
	{
		name = "EQUIPMENT",
		label = locale == "zh" and "装备耐久合并" or "Combinable Equipment",
		hover = locale == "zh" and "同类装备可以互相合并耐久" or "Enable equipment combination.",
		options = boolean,
		default = true
	},
	{
		name = "SEED",
		label = locale == "zh" and "种子腐烂消失" or "Seeds Disappear on Perished",
		hover = locale == "zh" and "仅普通种子(闸种)在腐烂的时候消失而不是生成腐烂食物" or "Normal seeds disappear on perished.",
		options = boolean,
		default = false
	},
	{
		name = "SISTURN",
		label = locale == "zh" and "魔改姐妹骨灰盒" or "Enhanced Sisturn",
		hover = locale == "zh" and "姐妹骨灰盒可以放骨片和哀悼荣耀" or "Allows bone shards and Mourning glory into Sisturn.",
		options = boolean,
		default = false
	},
	{
		name = "FLOWER",
		label = locale == "zh" and "保护恶魔花" or "No Picking Evil Flowers",
		hover = locale == "zh" and "恶魔花不能摘只能用铲子铲起来" or "Disable Evil Flowers picking(DIG instead).",
		options = boolean,
		default = false
	},
	{
		name = "BIRD",
		label = locale == "zh" and "鸟不睡觉" or "Birds no sleeping",
		hover = locale == "zh" and "鸟儿晚上不睡觉" or "Disable Birds' sleep at night.",
		options = boolean,
		default = false
	},
	{
		name = "BAT",
		label = locale == "zh" and "眼球塔增强" or "Enhanced Eyeturrets",
		hover = locale == "zh" and "眼球塔主动攻击蝙蝠" or "Eyeturrets target bats.",
		options = boolean,
		default = false
	},
	{
		name = "STAFF",
		label = locale == "zh" and "星杖/月杖增强" or "Enhanced Star/Monn Caller Staff",
		hover = locale == "zh" and "装备星杖月杖可以右键装备栏原地使用" or "Star/Moon Caller Staff use with right-click on equipped.",
		options = boolean,
		default = false
	},
	{
		name = "FIREFLIES",
		label = locale == "zh" and "萤火虫放进蘑菇灯" or "Fireflies in lamps",
		hover = locale == "zh" and "萤火虫可以放进萤菇灯与炽菇灯(永亮)" or "Enable fireflies into lamps",
		options = boolean,
		default = false
	},
	{
		name = "RANDOMLIGHTS",
		label = locale == "zh" and "随机彩灯合成" or "Winter Lights Recipe",
		hover = locale == "zh" and "新增彩灯配方, 合成时会随机给一种款式的彩灯" or "Enable recipe for RANDOM winter lights",
		options = boolean,
		default = false
	},
	{
		name = "GLOMMER",
		label = locale == "zh" and "可修复格罗姆雕像" or "Glommer Statue Repairing",
		hover = locale == "zh" and "可以用大理石修复格罗姆雕像" or "Enable Glommer Statue repairing with marbles.",
		options = boolean,
		default = false
	},
	{
		name = "MHATS",
		label = locale == "zh" and "蘑菇帽可以发光" or "Glowing Mushroom Hats",
		hover = "",
		options = boolean,
		default = false
	},
	{
		name = "BEEFALO",
		label = locale == "zh" and "驯好的牛不打招呼" or "Beefalos No Greeting",
		hover = locale == "zh" and "驯好的牛不会跑过来向玩家打招呼" or "Disable beefalos' greeting to players",
		options = boolean,
		default = false
	},
	{
		name = "COOKPOT",
		label = locale == "zh" and "红锅不便携" or "No Dismantle Crockpots",
		hover = locale == "zh" and "厨师的红锅只能用锤子敲" or "Disable Portable Crockpot's Dismantle(Hammers only).",
		options = boolean,
		default = false
	},
	{
		name = "TENTACLE",
		label = locale == "zh" and "大触手无掉落物" or "Tentacle pillars no Looting",
		hover = locale == "zh" and "大触手不再掉落任何东西(减少垃圾产生)" or "Removes Tentacle pillar's loottable",
		options = boolean,
		default = false
	},
	{
		name = "SANDSTONE",
		label = locale == "zh" and "更好用的沙之石" or "Enhanced Sand Stone",
		hover = locale == "zh" and "右键使用沙之石生成一次性临时沙塔" or "Use Sand stone in inventory to generate a temp Lazy Deserter.",
		options = boolean,
		default = false
	},
	{
		name = "CHECKSKINOWNERSHIP",
		label = locale == "zh" and "玩家拥有原皮" or "Players OWN Default Skins",
		hover = locale == "zh" and "(MOD向) 玩家套其他角色原始皮肤重新上线不会掉皮" or "(For MODS)Players can keep other characters' default skin on re-login",
		options = boolean,
		default = false
	},
	{
		name = "HALLOWEEN",
		label = locale == "zh" and "禁用万圣节猪王糖果" or "No Halloween Candies",
		hover = locale == "zh" and "万圣节期间猪王不会给糖果(减少垃圾产生)" or "Disable halloween candies on trading with Pig King.",
		options = boolean,
		default = false
	},
	{
		name = "BEEQUEENHAT",
		label = locale == "zh" and "禁用蜂王冠鞠躬" or "No bowing for Bee Queen Crown",
		hover = locale == "zh" and "玩家不会对其他戴着蜂王冠的玩家鞠躬" or "",
		options = boolean,
		default = false
	},
	{
		name = "BEEQUEENGIFTWRAP",
		label = locale == "zh" and "蜂后掉落彩纸蓝图" or "Bee Queen Extra Drops",
		hover = locale == "zh" and "杀死蜂后掉落彩纸的蓝图" or "Bee Queen drops Giftwrap Blueprint",
		options = boolean,
		default = false
	},
	{
		name = "ATKSPEED",
		label = locale == "zh" and "不限制玩家攻速" or "Enable Quick Attack",
		hover = "",
		options = boolean,
		default = false
	},
	{
		name = "LUREPLANT",
		label = locale == "zh" and "食人花无间距" or "Classic Lure Plants",
		hover = "",
		options = boolean,
		default = false
	},
    {
        name = "LUNARCROWN",
        label = locale == "zh" and "强化启迪之冠" or "Enhanced Enlightened Crown",
        hover = locale == "zh" and "启迪之冠可放入月亮碎片" or "Moon Shard into Enlightened Crown",
        options = boolean,
        default = false
    },
	{
        name = "CROWNFRAGMENT",
        label = locale == "zh" and "启迪之冠碎片配方" or "Enlightened Crown Shard's Recipe",
        hover = "",
        options = boolean,
        default = false
    },
	{
        name = "BLOCKABLEPOOPING",
        label = locale == "zh" and "堵住牛屁股" or "Block Pooping From Beefalos",
        hover = "",
        options = boolean,
        default = false
    },
	{
        name = "NOFORESTRESOURCEREGEN",
        label = locale == "zh" and "禁用森林资源再生" or "Disable Forest Resouces Regen",
        hover = "",
        options = boolean,
        default = false
    },
	{
        name = "POCKETRESKIN",
        label = locale == "zh" and "物品栏换皮肤" or "Reskin From Inventory",
        hover = "",
        options = boolean,
        default = false
    },
	{
        name = "NOGHOSTHOUNDED",
        label = locale == "zh" and "禁用灵魂来狗" or "Disable Ghost Hounded",
        hover = "",
        options = boolean,
        default = false
    },
	{
		name = "SITEMOTE",
		label = locale == "zh" and "固定坐下表情" or "Static Sit Emote",
        hover = "Static anim for /sit",
        options = boolean,
        default = false
	},
	{
		name = "NODARTWASTE",
		label = locale == "zh" and "吹箭不浪费" or "No Blow Dart Waste",
        hover = "No blow dart waste when hitting a dead target",
        options = boolean,
        default = false
	},
	{
		name = "GATHERMOONGLASS",
		label = locale == "zh" and "月相盘在出生门掉落" or "Gather Moon Dial's Glass",
        hover = "Moon Glass dropped from Moon Dials will be teleported to Celestial Portal.",
        options = boolean,
        default = false
	},
	{
		name = "CUSTOMFAILSTR",
		label = locale == "zh" and "个性化动作失败台词" or "Custom Action Fail String",
        hover = "",
        options = boolean,
        default = false
	},
	{
		name = "ENDTABLE",
		label = locale == "zh" and "漂浮的烧毁茶几" or "Floating burnt End Table",
		hover = "",
		options = boolean,
		default = false
	},
	{
		name = "PROPSIGN",
		label = locale == "zh" and "合成拍人小木牌" or "Craftable Prop Sign",
		hover = "",
		options = boolean,
		default = false
	}

}
