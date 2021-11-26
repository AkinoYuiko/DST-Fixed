local AddStategraphPostInit = AddStategraphPostInit
GLOBAL.setfenv(1, GLOBAL)

local function find_sit_anim(data)
    if data and data.anim and type(data.anim) == "table" then
        for _, v in ipairs(data.anim) do
            if type(v) == "table" then
                if table.contains(v, "emote_pre_sit2") then
                    return true
                end
            else
                return false
            end
        end
    end
end

AddStategraphPostInit("wilson", function(self)
    local onenter = self.states["emote"].onenter
    self.states["emote"].onenter = function(inst, data, ...)
        if find_sit_anim(data) then
            data.anim = { "emote_pre_sit2", "emote_loop_sit2" }
            data.randomanim = nil
        end
        return onenter(inst, data, ...)
    end
end)
