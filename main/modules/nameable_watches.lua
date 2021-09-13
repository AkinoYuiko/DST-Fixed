local ENV = env
GLOBAL.setfenv(1, GLOBAL)

local UpvalueHacker = require("tools/upvaluehacker")
local writeables = require("writeables")
local kinds = UpvalueHacker.GetUpvalue(writeables.makescreen, "kinds")
if not kinds then
    print("Warning! Nameable CAN NOT gets kinds from writeables!")
    return
end

local SUPPORTED_WATCHES = {
    "pocketwatch_portal",
    "pocketwatch_recall"
}

local data = {
    prompt = "", -- Unused
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = {
        text = STRINGS.BEEFALONAMING.MENU.CANCEL,
        cb = nil,
        control = CONTROL_CANCEL
    },

    acceptbtn = {
        text = STRINGS.BEEFALONAMING.MENU.ACCEPT,
        cb = nil,
        control = CONTROL_ACCEPT
    },
}
for _, v in ipairs(SUPPORTED_WATCHES) do
    kinds[v] = data
end


local RENAME_WATCH = Action({ mount_valid = true })

RENAME_WATCH.id = "RENAME_WATCH"

RENAME_WATCH.str = STRINGS.ACTIONS.WRITE

RENAME_WATCH.fn = function(act)
    if act.target.components.writeable then
        act.target.components.writeable:BeginWriting(act.doer)
        act.invobject:Remove()
        return true
    end
end

ENV.AddAction(RENAME_WATCH)

ENV.AddComponentAction("USEITEM", "drawingtool", function(inst, doer, target, actions, right)
    if right and table.contains(SUPPORTED_WATCHES, target.prefab) and target.watch_record_name then
        table.insert(actions, ACTIONS.RENAME_WATCH)
    end
end)

ENV.AddStategraphActionHandler("wilson", ActionHandler(RENAME_WATCH, "doshortaction"))
ENV.AddStategraphActionHandler("wilson_client", ActionHandler(RENAME_WATCH, "doshortaction"))


local function OnWritten(inst, text)
    inst.watch_record_name:set(text and text ~= "" and table.concat({"(", text, ")"}) or "nil")
end

local function WatchPostInit(inst)
    inst.watch_record_name = net_string(inst.GUID, "watch_record_name")

    local displaynamefn = inst.displaynamefn
    inst.displaynamefn = function(inst, ...)
        local name = inst.watch_record_name:value()
        if name ~= "" then
            return table.concat({STRINGS.NAMES[string.upper(inst.prefab)], " ", name})
        end
        if displaynamefn then
            return displaynamefn(inst, ...)
        else
            return STRINGS.NAMES[string.upper(inst.prefab)]
        end
    end

    if not TheWorld.ismastersim then return end

    if not inst.components.writeable then
        inst:AddComponent("writeable")
        inst.components.writeable:SetDefaultWriteable(false)
        inst.components.writeable:SetAutomaticDescriptionEnabled(false)
        inst.components.writeable:SetOnWrittenFn(OnWritten)
    end

    local on_save = inst.OnSave
    inst.OnSave = function(inst, data, ...)
        local watch_record_name = inst.watch_record_name:value()
        data.watch_record_name = watch_record_name ~= "" and watch_record_name or nil
        if on_save then
            return on_save(inst, data, ...)
        end
    end

    local on_load = inst.OnLoad
    inst.OnLoad = function(inst, data, ...)
        if data and data.watch_record_name then
            inst.watch_record_name:set(data.watch_record_name)
        end
        if on_load then
            return on_load(inst, data, ...)
        end
    end
end

for _, v in ipairs(SUPPORTED_WATCHES) do
    ENV.AddPrefabPostInit(v, WatchPostInit)
end
