local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)
local UpvalueUtil = require("upvalueutil")

local function disable_components(inst)
    inst:RemoveComponent("equippable")
end

local function on_projectile_launched(inst, attacker, target, proj)
    if proj then
        inst:DoTaskInTime(4 * FRAMES, function(inst)
            inst.components.finiteuses:Use(1)
        end)
    end
end

local function SetOnProjectileLaunched(inst)
    if inst.components.weapon then
        inst.components.weapon:SetOnProjectileLaunched(on_projectile_launched)
    end
end

AddPrefabPostInit("staff_lunarplant", function(inst)
    if not TheWorld.ismastersim then return end
    UpvalueUtil.SetUpvalue(inst.components.finiteuses.onfinished, "onbroken.DisableComponents", disable_components)

    SetOnProjectileLaunched(inst)
    inst.components.finiteuses:SetIgnoreCombatDurabilityLoss(true)
    inst:ListenForEvent("percentusedchange", function()
        SetOnProjectileLaunched(inst)
    end)
end)

local FiniteUses = require("components/finiteuses")
local set_uses = FiniteUses.SetUses
function FiniteUses:SetUses(val)
    val = type(val) == "number" and math.clamp(val, 0, self.total) or val
    set_uses(self, val)
end
