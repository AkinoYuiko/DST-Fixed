table.insert(PrefabFiles, "gestalt_flash")

local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")

local function super_spawngestalt_fn(inst, owner, data)
	if not inst._is_active then
		return
	end

	if owner and (owner.components.health == nil or not owner.components.health:IsDead()) then
		local target = data.target
		if target and target ~= owner and target:IsValid() and
			(target.components.health == nil or not target.components.health:IsDead() and
			(target:HasTag("spiderden") or not target:HasTag("structure")) and
			not target:HasTag("wall"))
			then

			-- In combat, this is when we're just launching a projectile, so don't spawn a gestalt yet
			if data.weapon and data.projectile == nil 
					and (data.weapon.components.projectile
						or data.weapon.components.complexprojectile
						or data.weapon.components.weapon:CanRangedAttack()) then
				return
			end

			local has_moonglass = inst.components.container:Has("moonglass", 1)

			if has_moonglass then
				local gestalt = SpawnPrefab("gestalt_flash"):SetTarget(owner, target)
			else
				local x, y, z = target.Transform:GetWorldPosition()

				local gestalt = SpawnPrefab("alterguardianhat_projectile")
				local r = GetRandomMinMax(3, 5)
				local delta_angle = GetRandomMinMax(-90, 90)
				local angle = (owner:GetAngleToPoint(x, y, z) + delta_angle) * DEGREES
				gestalt.Transform:SetPosition(x + r * math.cos(angle), y, z + r * -math.sin(angle))
				gestalt:ForceFacePoint(x, y, z)
				gestalt:SetTargetPosition(Vector3(x, y, z))
				gestalt.components.follower:SetLeader(owner)
			end

			if owner.components.sanity then
				if has_moonglass then
				-- if has_moonglass and not (target:HasTag("shadowcreature") or target:HasTag("nightmarecreature")) then
					if math.random() < 0.25 then
						inst.components.container:ConsumeByName("moonglass", 1)
					end
				else
					owner.components.sanity:DoDelta(-1, true) -- using overtime so it doesnt make the sanity sfx every time you attack
				end
			end
		end
	end
end

local function alterguardianhat_test_fn(container, item, slot)
	return item:HasTag("alterguardianhatbattery") or item:HasTag("spore")
end

local function new_onequip(inst, owner, ...)

	local open_fn
	if inst.components.container then
		open_fn = inst.components.container.Open
		inst.components.container.Open = function() --[[ Disabled ]] end
	end

	local rt = inst.old_equip(inst, owner, ...)
	inst:RemoveEventCallback("onattackother", inst.alterguardian_spawngestalt_fn, owner)

	inst.new_spawngestalt_fn = function(_owner, _data) super_spawngestalt_fn(inst, _owner, _data) end
	inst:ListenForEvent("onattackother", inst.new_spawngestalt_fn, owner)

	if open_fn and inst.components.container then
		inst.components.container.Open = open_fn
	end

	if owner then owner.AnimState:ClearOverrideSymbol("swap_hat") end

	return rt
end

local function new_onunequip(inst, owner, ...)
	inst.old_unequip(inst, owner, ...)
	inst:RemoveEventCallback("onattackother", inst.new_spawngestalt_fn, owner)
end

local function OnEntityReplicated(inst)
	if inst.replica.container then
		-- inst.replica.container.type = "head_inv"
		inst.replica.container.acceptsstacks = true
		inst.replica.container.itemtestfn = alterguardianhat_test_fn
	end
end

AddPrefabPostInit("alterguardianhat", function(inst)

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated
		return
    end

	local container = inst.components.container
    removesetter(container, "acceptsstacks")
    removesetter(container, "itemtestfn")
    removesetter(container, "type")
	container.type = "head_inv"
	inst.components.container.acceptsstacks = true
    container.itemtestfn = alterguardianhat_test_fn
	if inst.replica.container then
		-- inst.replica.container.type = "head_inv"
		inst.replica.container.acceptsstacks = true
		inst.replica.container.itemtestfn = alterguardianhat_test_fn
	end
	makereadonly(container, "acceptsstacks")
	makereadonly(container, "itemtestfn")
	makereadonly(container, "type")

	local hackpath = "alterguardian_onsanitydelta.alterguardian_deactivate"
	local old_deactivate = UpvalueHacker.GetUpvalue(inst.components.equippable.onequipfn, hackpath)
	local function new_deactivate_fn(inst)
		old_deactivate(inst)
		if inst._task then
			inst._task:Cancel()
			inst._task = nil
		end
	end
	UpvalueHacker.SetUpvalue(inst.components.equippable.onequipfn, hackpath, new_deactivate_fn)

	if inst.components.equippable then
		inst.old_equip = inst.components.equippable.onequipfn
		inst.old_unequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnEquip(new_onequip)
		inst.components.equippable:SetOnUnequip(new_onunequip)
	end
end)

AddPrefabPostInit("moonglass", function(inst)
	inst:AddTag("alterguardianhatbattery")
end)


