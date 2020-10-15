
local tObjF = CreateFrame("Frame", "tObjFrame")

tObjFrame:RegisterEvent("ZONE_CHANGED")
tObjFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
tObjFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

tObjFrame:SetScript("OnEvent", function(self, event_name, ...)
	
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
    
    for i=1,C_QuestLog.GetNumQuestLogEntries() do
        local title = C_QuestLog.GetTitleForLogIndex(i);
        local questID = C_QuestLog.GetQuestIDForLogIndex(i) 
        local isHeader = C_QuestLog.GetTitleForLogIndex(i) == 0 and true or false
        local IsQuestWatched = C_QuestLog.GetQuestWatchType(questID)

        print(IsQuestWatched)

        if isHeader then 
            dontHide = ((title) == (currentMapName))
        end
        
        if dontHide then
            if IsQuestWatched ~= true then QuestMapQuestOptions_TrackQuest(questID) end
        else
            
            if IsQuestWatched and questListID[questID] == nil then QuestObjectiveTracker_UntrackQuest(nil, questID); end
            if IsQuestWatched ~= true and questListID[questID] then QuestMapQuestOptions_TrackQuest(questID); end 
        end
        
    end
	
end)
