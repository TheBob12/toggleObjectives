
local tObjF = CreateFrame("Frame", "tObjFrame")

tObjFrame:RegisterEvent("ZONE_CHANGED")
tObjFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
tObjFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")


tObjFrame:SetScript("OnEvent", function(self, event_name, ...)
	--[[if self[event_name] then
		return self[event_name](self, event_name, ...)
	end--]]
	
    local currentMapID = C_Map.GetBestMapForUnit("player") or WorldMapFrame:GetMapID()
    local currentMapInfo = C_Map.GetMapInfo(currentMapID)
    local currentMapName = currentMapInfo.name
    
    local questList = C_QuestLog.GetQuestsOnMap(currentMapID)
    local questListID = {}
    
    for k,v in pairs(questList) do 
        
        if questList[k].questID ~= nil then
            questListID[questList[k].questID] = true
            
        end
    end
    
    
    local dontHide = false
    
    for i=1,GetNumQuestLogEntries() do
        local title, _, _, isHeader, _, _, _, questID, _, _, IsOnMap = GetQuestLogTitle(i);
        
        if isHeader then 
            dontHide = ((title) == (currentMapName))
        end
        
        if dontHide then
            if IsQuestWatched(i) ~= true then QuestMapQuestOptions_TrackQuest(questID) end
        else
            
            if IsQuestWatched(i) and questListID[questID] == nil then QuestObjectiveTracker_UntrackQuest(nil, questID); end
            if IsQuestWatched(i) ~= true and questListID[questID] then QuestMapQuestOptions_TrackQuest(questID); end 
        end
        
    end
	
end)


