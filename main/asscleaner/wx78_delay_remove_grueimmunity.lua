GLOBAL.setfenv(1, GLOBAL)

local function nightvision_onworldstateupdate(wx)
	local turnon = TheWorld.state.isnight and not TheWorld.state.isfullmoon
	if turnon then
		wx:SetForcedNightVision(turnon)
	else
		wx:DoTaskInTime(1, function(inst)
			inst:SetForcedNightVision(turnon)
		end)
	end
end

local function nightvision_activate(inst, wx)
	wx._nightvision_modcount = (wx._nightvision_modcount or 0) + 1

	if wx._nightvision_modcount == 1 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
		if TheWorld:HasTag("cave") then
			wx:SetForcedNightVision(true)
		else
			wx:WatchWorldState("isnight", nightvision_onworldstateupdate)
			wx:WatchWorldState("isfullmoon", nightvision_onworldstateupdate)
			nightvision_onworldstateupdate(wx)
		end
	end
end

local function nightvision_deactivate(inst, wx)
	wx._nightvision_modcount = math.max(0, wx._nightvision_modcount - 1)

	if wx._nightvision_modcount == 0 and TheWorld ~= nil and wx.SetForcedNightVision ~= nil then
		if TheWorld:HasTag("cave") then
			wx:SetForcedNightVision(false)
		else
			wx:StopWatchingWorldState("isnight", nightvision_onworldstateupdate)
			wx:StopWatchingWorldState("isfullmoon", nightvision_onworldstateupdate)
			wx:SetForcedNightVision(false)
		end
	end
end

local wx78_moduledefs = require("wx78_moduledefs")
for _, module in ipairs(wx78_moduledefs.module_definitions) do
	if module.name == "nightvision" then
		module.activatefn = nightvision_activate
		module.deactivatefn = nightvision_deactivate
	end
end
