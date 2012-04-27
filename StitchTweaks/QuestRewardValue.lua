
local _, ns = ...
local cfg = ns.cfg.QUEST_REWARD_VALUE

-- Highlights the most valueable quest reward for vendoring

if cfg["ENABLED"] then

  local function getMostValuable()
    local maxValue,bestItem;
    for i=1,GetNumQuestChoices() do
      local link = GetQuestItemLink("choice", i)
      if link then
        local value = select(11, GetItemInfo(link)) or 0;
        if not maxValue or value > maxValue then
          maxValue = value
          bestItem = i
        end
      end
    end
    if bestItem then
      return bestItem
    end
  end

  local valueFrame = CreateFrame("Frame",nil)
  valueFrame:SetSize(12,12)
  valueFrame:SetPoint("BOTTOMRIGHT")
  local goldIcon = valueFrame:CreateTexture("$parentTexture", "ARTWORK")
  goldIcon:SetAllPoints()
  goldIcon:SetTexture("Interface\\MONEYFRAME\\UI-GoldIcon") 
  valueFrame:Hide()
  
  valueFrame:RegisterEvent("QUEST_COMPLETE")
  valueFrame:SetScript("OnEvent", function(self,event,...)
    if event == "QUEST_COMPLETE" then
      local item = getMostValuable()
      if item then
        valueFrame:SetParent(_G["QuestInfoItem"..item])
        valueFrame:ClearAllPoints()
        valueFrame:SetPoint("BOTTOMRIGHT", -4,4)
        valueFrame:Show()
      else
        valueFrame:Hide()
      end
    end
  end)

end
