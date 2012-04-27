
local _, ns = ...
local cfg = ns.cfg.INSPECT_ILVL

if cfg["ENABLED"] then

  if not IsAddOnLoaded("Blizzard_InspectUI") then
    LoadAddOn("Blizzard_InspectUI")
  end
  
  local ilvlText = _G["InspectPaperDollFrame"]:CreateFontString("$parentILVL",nil,"GameFontNormalSmall")
  ilvlText:SetJustifyH("CENTER")
  ilvlText:SetSize(100,25)
  ilvlText:SetPoint("TOP", 0, -36)

  local function GetAverageILVL()
    local count, sum  = 0, 0
    if GetInventoryItemLink("target", 17) then
      count = 17
    else
      count = 16
    end

    for i=1, 18 do
      if i ~= 4 then
        local iLevel, iLink
        iLink = GetInventoryItemLink("target", i)
        if iLink then
          iLevel = select(4, GetItemInfo(iLink)) or 0
          if iLevel then
            sum = sum + iLevel
          end
        end
      end
    end
    
    ilvlText:SetText(string.format("%.1f", sum / count))
  end

  local dummy = CreateFrame("Frame")
  dummy:RegisterEvent("INSPECT_READY")
  dummy:SetScript("OnEvent", function()
    GetAverageILVL()
  end)

end
