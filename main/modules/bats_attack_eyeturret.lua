local AddPrefabPostInit = env.AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("bat",function(inst)
	local function MakeTeam(inst, attacker)
	    local leader = SpawnPrefab("teamleader")
	    leader.components.teamleader:SetUp(attacker, inst)
	    leader.components.teamleader:BroadcastDistress(inst)
	end

	local RETARGET_CANT_TAGS = {"bat"}
	local RETARGET_ONEOF_TAGS = {"character", "monster"}
	local function NewRetarget(inst)
	    local ta = inst.components.teamattacker

	    local newtarget = FindEntity(inst, TUNING.BAT_TARGET_DIST, function(guy)
				return inst.components.combat:CanTarget(guy) or
						guy:HasTag("eyeturret")
	        end,
	        nil,
	        RETARGET_CANT_TAGS,
	        RETARGET_ONEOF_TAGS
	    )

	    if newtarget and not ta.inteam and not ta:SearchForTeam() then
	        MakeTeam(inst, newtarget)
	    end

	    if ta.inteam and not ta.teamleader:CanAttack() then
	        return newtarget
	    end
	end

	if inst.components.combat then
	    inst.components.combat:SetRetargetFunction(3, NewRetarget)
	end
end)

AddPrefabPostInit("eyeturret",function(inst)
	local RETARGET_MUST_TAGS = { "_combat" }
	local RETARGET_CANT_TAGS = { "INLIMBO", "player" }

	local function NewRetargetfn(inst)
	    local playertargets = {}
	    local AllPlayers= AllPlayers
		for i = 1, #AllPlayers do
			local v = AllPlayers[i]
	        if v.components.combat.target ~= nil then
	            playertargets[v.components.combat.target] = true
	        end
	    end

        return FindEntity(inst, TUNING.EYETURRET_RANGE + 3,
        function(guy)
            return (playertargets[guy] or (guy.components.combat.target ~= nil and guy.components.combat.target:HasTag("player"))) 
					and inst.components.combat:CanTarget(guy) or
	                	guy:HasTag("bat")
        end,
        RETARGET_MUST_TAGS, --see entityreplica.lua
        RETARGET_CANT_TAGS
    )
	end

	if inst.components.combat then
    	inst.components.combat:SetRetargetFunction(1, NewRetargetfn)
	end
end)