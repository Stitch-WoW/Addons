

local _, ns = ...
local cfg = ns.cfg.TOOLTIPS

-- Changes a few item tooltip texts to use less space
-- "Transmogrified to:\nITEM" --> "<ITEM>"
-- "Raid Finder" --> "ITEM <LFR>"
-- "Season #" --> "ITEM <S#>"

if cfg["ENABLED"] then

  local function OnTooltipSetItem(self)
    if self:GetItem() then
      for i = 1, select("#", self:GetRegions()) do
        local region = select(i, self:GetRegions())
        if region and region:GetObjectType() == "FontString" then
          local TTText = region:GetText()
          if TTText and TTText ~= " " then
            -- Transmog
            local TransText = strmatch(TTText, "Transmogrified to:\n(.*)")
            if TransText then
              region:SetText("<"..TransText..">")
            end
            -- Raid Finder
            local RaidFinderText = strmatch(TTText, "Raid Finder")
            if RaidFinderText then
              region:SetText("")
              local pregion = select(i-2, self:GetRegions())
              pregion:SetText(pregion:GetText().." |cff00ff00<LFR>|r")
            end
            -- Season
            local SeasonText = strmatch(TTText, "Season (.*)")
            if SeasonText then
              region:SetText("")
              local pregion = select(i-2, self:GetRegions())
              pregion:SetText(pregion:GetText().." |cff00ff00<S"..SeasonText..">|r")
            end
          end
        end
      end
    end
  end

  GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
  ShoppingTooltip1:HookScript("OnTooltipSetItem", OnTooltipSetItem)
  ShoppingTooltip2:HookScript("OnTooltipSetItem", OnTooltipSetItem)
  ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)

end
