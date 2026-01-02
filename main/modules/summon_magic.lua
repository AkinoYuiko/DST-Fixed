local AddComponentAction = AddComponentAction
local AddPrefabPostInit = AddPrefabPostInit
local AddShardModRPCHandler = AddShardModRPCHandler
GLOBAL.setfenv(1, GLOBAL)

local RPC_NAMESPACE = "summon_magic"
local CAN_SUMMON_HAND_ITEMS = {
	["cane"] = true,
	["orangestaff"] = true,
}

AddShardModRPCHandler(RPC_NAMESPACE, "Summon", function(shardid, summoner_id, x, z)
	for _, player in ipairs(AllPlayers) do
		if player:IsValid() then
			local hand_item = player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			if hand_item and CAN_SUMMON_HAND_ITEMS[hand_item.prefab] then
				TheWorld:PushEvent("ms_playerdespawnandmigrate", {
					player = player,
					worldid = shardid,
					x = x,
					y = 0,
					z = z,
				})
				SendModRPCToShard(SHARD_MOD_RPC[RPC_NAMESPACE]["Feedback"], shardid, summoner_id, "Hahahaha")
				return
			end
		end
	end
	SendModRPCToShard(SHARD_MOD_RPC[RPC_NAMESPACE]["Feedback"], shardid, summoner_id, "nope")
end)

AddShardModRPCHandler(RPC_NAMESPACE, "Feedback", function(shardid, summoner_id, str)
	for _, player in ipairs(AllPlayers) do
		if player.userid == summoner_id then
			player.components.talker:Say(str)
			return
		end
	end
end)

AddComponentAction("EQUIPPED", "spellcaster", function(inst, doer, target, actions, right)
	if right and inst.prefab == "telestaff" and not TheWorld:HasTag("cave") and target:HasTag("telebase") then
		table.insert(actions, ACTIONS.CASTSPELL)
	end
end)

local function can_summon_to(caster, target)
	return table.contains(AllPlayers, caster)
		and not TheWorld:HasTag("cave")
		and TheShard:GetSecondaryShardPlayerCounts(USERFLAGS.IS_GHOST) > 0
		and target
		and target:HasTag("telebase")
		and target.canteleto
		and target:canteleto()
end

local function GetFirstShardID()
	for id in pairs(Shard_GetConnectedShards()) do
		return id
	end
end

AddPrefabPostInit("telestaff", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local can_cast_fn = inst.components.spellcaster.can_cast_fn
	inst.components.spellcaster:SetCanCastFn(function(doer, target, ...)
		if can_summon_to(doer, target) and GetFirstShardID() then
			return true
		elseif can_cast_fn then
			return can_cast_fn(doer, target, ...)
		end
	end)

	local spell = inst.components.spellcaster.spell
	inst.components.spellcaster:SetSpellFn(function(inst, target, ...)
		local worldid = GetFirstShardID()
		local caster = inst.components.inventoryitem.owner
		if worldid and can_summon_to(caster, target) then
			local x, _, z = target.Transform:GetWorldPosition()
			SendModRPCToShard(SHARD_MOD_RPC[RPC_NAMESPACE]["Summon"], worldid, caster.userid, x, z)

			TheWorld:PushEvent("ms_sendlightningstrike", Vector3(x, 0, z))
			TheWorld:PushEvent("ms_deltamoisture", TUNING.TELESTAFF_MOISTURE)

			inst.components.finiteuses:Use(1)

			if caster.components.sanity then
				caster.components.sanity:SetPercent(0)
			end

			if target.onteleto then
				target:onteleto()
			end
			return
		end
		return spell(inst, target, ...)
	end)
end)
