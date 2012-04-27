-- TODO: Fix these broken ones and give own files

--[[
-- Achievement Link Compare {{{
-------------------------------
local function OnTooltipSetAchievement(self, link)
  if not self:GetItem() then
    if not self:GetSpell() then
      if not self:GetUnit() then
        if self:IsShown() then
          local IRT3 = _G["ItemRefTooltipTextLeft3"]
          local _,_,player = strfind(IRT3:GetText(), "earned by (%w+) on")
          if player ~= GetUnitName("player") then
            local _,_,AID = strfind(link, "achievement:([0-9]*):")
            local _,_,_,complete,m,d,y = GetAchievementInfo(AID)

            local playerStatus = ""
            if complete then
              playerStatus = "|cFF00FF00Achievement earned on "..m.."/"..d.."/"..y
            else
              playerStatus = "|cFFFFFF00Achievement in progress"
            end

            IRT3:SetText(IRT3:GetText().."\n"..playerStatus)
            self:Show()
          end
        end
      end
    end
  end
end
hooksecurefunc(ItemRefTooltip, "SetHyperlink", OnTooltipSetAchievement)
-- }}}
--]]
