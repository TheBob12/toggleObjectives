
local tObjF = CreateFrame("Frame", "tObjFrame")
local MSG_PREFIX = "tObj"
local success = C_ChatInfo.RegisterAddonMessagePrefix(MSG_PREFIX)

local inDungeon = false

tObjFrame:RegisterEvent("CHAT_MSG_ADDON")
tObjFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
tObjFrame:RegisterEvent("ADDON_LOADED")
tObjFrame:RegisterEvent("CHALLENGE_MODE_START")
tObjFrame:RegisterEvent("CHALLENGE_MODE_COMPLETED")

function tObjFrame:CHALLENGE_MODE_START(event,...)
	inDungeon = true
	toggle()
end
function tObjFrame:CHALLENGE_MODE_COMPLETED(event,...)
	inDungeon = false
	toggle()
end



tObjFrame:SetScript("OnEvent", function(self, event_name, ...)
	if self[event_name] then
		return self[event_name](self, event_name, ...)
	end
end)

function toggle()
	local is = tObjDB.frameVisible
	
	if is then 
		if not inDungeon then
			ObjectiveTrackerFrame:Hide() 
		else 
			ObjectiveTrackerFrame:Show() 
			for i = GetNumQuestWatches(), 1, -1 do 
				RemoveQuestWatch(GetQuestIndexForWatch(i)) 
			end
		end
	else 
		ObjectiveTrackerFrame:Show() 
	end
end

function tObjFrame:ADDON_LOADED(event,addon)
	
	if not tObjDB then
		tObjDB = {
			frameVisible = true
		}
	else
		toggle()
	end
	
end

SLASH_TOBJ1 = "/tobj"

SlashCmdList["TOBJ"] = function(msg,editBox)
	tObjDB.frameVisible = not tObjDB.frameVisible
	toggle()
end
