AddComponentPostInit("forestresourcespawner", function(self, inst)
    local listeners = inst.event_listeners and inst.event_listeners["ms_enableresourcerenewal"]
    if listeners then
        for listener, fns in pairs(listeners) do
            if listener == inst then
                for _, fn in ipairs(fns) do
                    inst:RemoveEventCallback("ms_enableresourcerenewal", fn)
                end
                break
            end
        end
    end
end)
