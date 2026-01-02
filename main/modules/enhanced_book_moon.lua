local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("book_moon", function(inst)
	if not TheWorld.ismastersim then
		return
	end

	local onread = inst.components.book.onread
	inst.components.book.onread = function(inst, reader, ...)
		local success, reason = onread(inst, reader, ...)
		if not success and reason == "ALREADYFULLMOON" then
			TheWorld:PushEvent("ms_setmoonphase", { moonphase = "new", iswaxing = true })
			if not TheWorld.state.isnight then
				reader.components.talker:Say(GetString(reader, "ANNOUNCE_BOOK_MOON_DAYTIME"))
			end
			return true
		end
		return success, reason
	end
end)
