local _G = GLOBAL
local UpvalueHacker = require("tools/upvaluehacker")

-- local containers = require("containers")
-- local params = containers.params
-- params.alterguardianhat.type = "head_inv"
-- params.alterguardianhat.widget.pos = _G.Vector3(106,150,0)
-- params.alterguardianhat.widget.pos = _G.Vector3(394,-238,0)
-- _G.PlayerHud.controls.inv.hand_inv:AddChild("alterguardianhat")
-- function params.alterguardianhat.itemtestfn(container, item, slot)
--     return (item:HasTag("alterguardianhatbattery") or item:HasTag("spore"))
-- end

AddPrefabPostInit("alterguardianhat", function(inst)
	local function alterguardianhat_test_fn(container, item, slot)
		return (item:HasTag("alterguardianhatbattery") or item:HasTag("spore"))
	end

    if not _G.TheWorld.ismastersim then
        inst.OnEntityReplicated = function(inst)
            if inst.replica.container then
				-- inst.replica.container.type = "head_inv"
				inst.replica.container.acceptsstacks = true
				inst.replica.container.itemtestfn=alterguardianhat_test_fn
            end
        end
        return inst
    end

	local container = inst.components.container
    _G.removesetter(container, "acceptsstacks")
    _G.removesetter(container, "itemtestfn")
    _G.removesetter(container, "type")
	container.type = "head_inv"
	inst.components.container.acceptsstacks = true
    container.itemtestfn = alterguardianhat_test_fn
	if inst.replica.container ~= nil then
		-- inst.replica.container.type = "head_inv"
		inst.replica.container.acceptsstacks = true
		inst.replica.container.itemtestfn = alterguardianhat_test_fn
	end
	_G.makereadonly(container, "acceptsstacks")
	_G.makereadonly(container, "itemtestfn")
	_G.makereadonly(container, "type")

	local function new_spawngestalt_fn(inst, owner, data)
		if not inst._is_active then
			return
		end

		if owner ~= nil and (owner.components.health == nil or not owner.components.health:IsDead()) then
		    local target = data.target
			if target and target ~= owner and target:IsValid() and (target.components.health == nil or not target.components.health:IsDead() and not target:HasTag("structure") and not target:HasTag("wall")) then

                -- In combat, this is when we're just launching a projectile, so don't spawn a gestalt yet
                if data.weapon ~= nil and data.projectile == nil 
                        and (data.weapon.components.projectile ~= nil
                            or data.weapon.components.complexprojectile ~= nil
                            or data.weapon.components.weapon:CanRangedAttack()) then
                    return
                end

				local x, y, z = target.Transform:GetWorldPosition()

				local gestalt = _G.SpawnPrefab("alterguardianhat_projectile")
				if owner.components.combat and inst.components.container:Has("moonglass", 1) then
                    -- local props = {"damagemultiplier", "externaldamagemultipliers", "damagebonus", "customdamagemultfn"}
                    local props = {"externaldamagemultipliers", "damagebonus"}
                    for _, v in ipairs(props) do
                        gestalt.components.combat[v] = owner.components.combat[v]
                    end
					gestalt.components.combat.damagemultiplier = math.max(1,(owner.components.combat.damagemultiplier or 1))
                    if owner.components.electricattacks then
                        gestalt:AddComponent("electricattacks")
						gestalt:ListenForEvent("onattackother", function(_inst, _data)
							local target = _data.target
							if _inst:IsValid() and target ~= nil and target:IsValid() then
								_G.SpawnPrefab("electrichitsparks"):AlignToTarget(target, _inst, true)
							end
						end)
                    end
                end
				local r = _G.GetRandomMinMax(3, 5)
				local delta_angle = _G.GetRandomMinMax(-90, 90)
				local angle = (owner:GetAngleToPoint(x, y, z) + delta_angle) * _G.DEGREES
				gestalt.Transform:SetPosition(x + r * math.cos(angle), y, z + r * -math.sin(angle))
				gestalt:ForceFacePoint(x, y, z)
				gestalt:SetTargetPosition(_G.Vector3(x, y, z))
				gestalt.components.follower:SetLeader(owner)

				if owner.components.sanity ~= nil then
					if inst.components.container:Has("moonglass",1) then
						if math.random() < 0.33 then
							inst.components.container:ConsumeByName("moonglass",1)
						end
					else
						owner.components.sanity:DoDelta(-1, true) -- using overtime so it doesnt make the sanity sfx every time you attack
					end
				end
			end
		end
	end

    local function new_onequip(inst, owner, ...)

		local open_fn
		if inst.components.container then
			open_fn = inst.components.container.Open
			inst.components.container.Open = function() --[[ Disabled ]] end
		end

		local rt = inst._old_equip(inst, owner, ...)
		inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, owner)

		inst.new_spawngestalt_fn = function(_owner, _data) new_spawngestalt_fn(inst, _owner, _data) end
		inst:ListenForEvent("onattackother", inst.new_spawngestalt_fn, owner)

		if open_fn and inst.components.container then
			inst.components.container.Open = open_fn
		end

		if owner then owner.AnimState:ClearOverrideSymbol("swap_hat") end

		return rt
    end

    local function new_onunequip(inst, owner, ...)
		local rt = inst._old_unequip(inst, owner, ...)
		inst:RemoveEventCallback("onattackother", inst.new_spawngestalt_fn, owner)
		return rt
    end

	if inst.components.equippable then
		inst._old_equip = inst.components.equippable.onequipfn
		inst._old_unequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnEquip(new_onequip)
		inst.components.equippable:SetOnUnequip(new_onunequip)
	end

	local _deactivate = UpvalueHacker.GetUpvalue(inst._old_equip, "alterguardian_onsanitydelta", "alterguardian_deactivate")
	local function new_deactivate_fn(inst)
		_deactivate(inst)
		if inst._task ~= nil then
			inst._task:Cancel()
			inst._task = nil
		end
	end
	UpvalueHacker.SetUpvalue(inst._old_equip, new_deactivate_fn, "alterguardian_onsanitydelta", "alterguardian_deactivate")
end)

AddPrefabPostInit("moonglass", function(inst)
	inst:AddTag("alterguardianhatbattery")
end)

