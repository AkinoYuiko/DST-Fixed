local AddAction = AddAction
local AddComponentAction = AddComponentAction
local AddStategraphActionHandler = AddStategraphActionHandler
local AddStategraphState = AddStategraphState
GLOBAL.setfenv(1, GLOBAL)

local JUMPINWATCH = Action({rmb = true})
JUMPINWATCH.id = "JUMPINWATCH"
JUMPINWATCH.str = ACTIONS.JUMPIN.str
JUMPINWATCH.fn = function(act)
    -- local item =
	-- local dest = act:GetActionPoint()
    if act.doer
        and act.doer.sg
        and act.doer.sg.currentstate.name == "wortox_pocketwatch_jumpin_pre"
        and act.target
        and act.target.components.pocketwatch
        and act.doer.components.inventory
        and act.doer.components.inventory:Has("wortox_soul", 1)
        and act.target.components.pocketwatch:CastSpell(act.doer) then

        act.doer.components.inventory:ConsumeByName("wortox_soul", 1)
        act.doer.sg:GoToState("wortox_pocketwatch_jumpin")

            -- return true
        -- act.target.components.pocketwatch:CastSpell(act.doer, act.target, act:GetActionPoint())
    end
    return true
end

AddAction(JUMPINWATCH)
AddComponentAction("SCENE", "pocketwatch", function(inst, doer, actions, right)
    if right
        and inst.prefab == "pocketwatch_recall"
        and inst:HasTag("pocketwatch_inactive")
        and not inst:HasTag("recall_unmarked")
        and doer:HasTag("souleater") then

        table.insert(actions, ACTIONS.JUMPINWATCH)
    end
end)

for _, stage in ipairs({"wilson", "wilson_client"}) do
    AddStategraphActionHandler("wilson", ActionHandler(JUMPINWATCH, "wortox_pocketwatch_jumpin_pre"))
end

local function ToggleOnPhysics(inst)
    inst.sg.statemem.isphysicstoggle = nil
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
end

local function ToggleOffPhysics(inst)
    inst.sg.statemem.isphysicstoggle = true
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.GROUND)
end

local function DoWortoxPortalTint(inst, val)
    if val > 0 then
        inst.components.colouradder:PushColour("portaltint", 154 / 255 * val, 23 / 255 * val, 19 / 255 * val, 0)
        val = 1 - val
        inst.AnimState:SetMultColour(val, val, val, 1)
    else
        inst.components.colouradder:PopColour("portaltint")
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
end

local TIMEOUT = 2
AddStategraphState("wilson_client", {
    name = "wortox_pocketwatch_jumpin_pre",
    tags = { "busy" },

    onenter = function(inst)
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("wortox_portal_jumpin_pre")
        inst.AnimState:PushAnimation("wortox_portal_jumpin_lag", false)

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.pos ~= nil then
                inst:ForceFacePoint(buffaction:GetActionPoint():Get())
            end
        end

        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst)
        if inst:HasTag("busy") then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,
})

AddStategraphState("wilson", {

    name = "wortox_pocketwatch_jumpin_pre",
    tags = { "busy" },

    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("wortox_portal_jumpin_pre")

        local buffaction = inst:GetBufferedAction()
        if buffaction ~= nil and buffaction.pos ~= nil then
            inst:ForceFacePoint(buffaction:GetActionPoint():Get())
        end
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() and not inst:PerformBufferedAction() then
                inst.sg:GoToState("idle")
            end
        end),
    }
})

AddStategraphState("wilson", {
    name = "wortox_pocketwatch_jumpin",
    tags = { "busy", "pausepredict", "nodangle", "nomorph" },

    onenter = function(inst, dest)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("wortox_portal_jumpin")
        local x, y, z = inst.Transform:GetWorldPosition()
        SpawnPrefab("wortox_portal_jumpin_fx").Transform:SetPosition(x, y, z)
        inst.sg:SetTimeout(11 * FRAMES)
        if dest ~= nil then
            inst.sg.statemem.dest = dest
            inst:ForceFacePoint(dest:Get())
        else
            inst.sg.statemem.dest = Vector3(x, y, z)
        end

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
    end,

    onupdate = function(inst)
        if inst.sg.statemem.tints ~= nil then
            DoWortoxPortalTint(inst, table.remove(inst.sg.statemem.tints))
            if #inst.sg.statemem.tints <= 0 then
                inst.sg.statemem.tints = nil
            end
        end
    end,

    timeline =
    {
        TimeEvent(FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/infection_post", nil, .7)
            inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/spawn", nil, .5)
        end),
        TimeEvent(2 * FRAMES, function(inst)
            inst.sg.statemem.tints = { 1, .6, .3, .1 }
            PlayFootstep(inst)
        end),
        TimeEvent(4 * FRAMES, function(inst)
            inst.sg:AddStateTag("noattack")
            inst.components.health:SetInvincible(true)
            inst.DynamicShadow:Enable(false)
        end),
    },

    ontimeout = function(inst)
        inst.sg.statemem.portaljumping = true
        inst.sg:GoToState("wortox_pocketwatch_jumpout", inst.sg.statemem.warpback)
    end,

    onexit = function(inst)
        if not inst.sg.statemem.portaljumping then
            inst.components.health:SetInvincible(false)
            inst.DynamicShadow:Enable(true)
            DoWortoxPortalTint(inst, 0)
        end
    end,
})

AddStategraphState("wilson", {
    name = "wortox_pocketwatch_jumpout",
    tags = { "busy", "nopredict", "nomorph", "noattack", "nointerrupt" },

    onenter = function(inst, dest)
        ToggleOffPhysics(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("wortox_portal_jumpout")
        if dest ~= nil then
            inst.Physics:Teleport(dest:Get())
        else
            dest = inst:GetPosition()
        end
        SpawnPrefab("wortox_portal_jumpout_fx").Transform:SetPosition(dest:Get())
        inst.DynamicShadow:Enable(false)
        inst.sg:SetTimeout(14 * FRAMES)
        DoWortoxPortalTint(inst, 1)
        inst.components.health:SetInvincible(true)
        inst:PushEvent("soulhop")
    end,

    onupdate = function(inst)
        if inst.sg.statemem.tints ~= nil then
            DoWortoxPortalTint(inst, table.remove(inst.sg.statemem.tints))
            if #inst.sg.statemem.tints <= 0 then
                inst.sg.statemem.tints = nil
            end
        end
    end,

    timeline =
    {
        TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/characters/wortox/soul/hop_out") end),
        TimeEvent(5 * FRAMES, function(inst)
            inst.sg.statemem.tints = { 0, .4, .7, .9 }
        end),
        TimeEvent(7 * FRAMES, function(inst)
            inst.components.health:SetInvincible(false)
            inst.sg:RemoveStateTag("noattack")
            inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
        end),
        TimeEvent(8 * FRAMES, function(inst)
            inst.DynamicShadow:Enable(true)
            ToggleOnPhysics(inst)
        end),
    },

    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)
    end,

    onexit = function(inst)
        inst.components.health:SetInvincible(false)
        inst.DynamicShadow:Enable(true)
        DoWortoxPortalTint(inst, 0)
        if inst.sg.statemem.isphysicstoggle then
            ToggleOnPhysics(inst)
        end
    end,
})
