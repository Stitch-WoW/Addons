--
-- Simple tracking of the current session's reputation, honor and money gains
--

-- CONFIG
local ENABLED = true
-- END CONFIG

local SessionWatch = CreateFrame("Frame",nil,UIParent)
SessionWatch:RegisterEvent("PLAYER_LOGIN")
SessionWatch:SetScript("OnEvent", function(self,event,...)
  self[event](self,event,...)
end)

function SessionWatch.PLAYER_LOGIN(self,event,...)
  if ENABLED then
    SLASH_SW1 = "/session"
    SlashCmdList["SW"] = SessionWatch.SlashCmd
    self:Enable()
  end
end

function SessionWatch:Enable()
  self:RegisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
  self:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
  self:RegisterEvent("PLAYER_ENTERING_WORLD")
  self:RegisterEvent("PLAYER_MONEY")
end

function SessionWatch:Disable()
  self:UnregisterEvent("CHAT_MSG_COMBAT_FACTION_CHANGE")
  self:UnregisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
  self:UnregisterEvent("PLAYER_MONEY")
end

function SessionWatch:PLAYER_ENTERING_WORLD()
  self:NewSession()
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function SessionWatch:CHAT_MSG_COMBAT_FACTION_CHANGE(event, msg)
  local _,_,faction,direction,value = strfind(msg, "with (.*) (%w+) by (%d+)")

  if not self.RepList[faction] then self.RepList[faction] = 0 end

  if direction == "decreased" then value = "-"..value end

  self.RepList[faction] = self.RepList[faction] + tonumber(value)
end

function SessionWatch:CHAT_MSG_COMBAT_HONOR_GAIN(event, msg)
  local _,_,value = strfind(msg, "awarded (.*) honor")
  if not value then
    local _,_,value = strfind(msg, "Honor Points: (.*)\)")
  end

  if value then
    self.HonorGained = self.HonorGained + tonumber(value)
  end
end

function SessionWatch:PLAYER_MONEY(event, msg)
  local GoldDiff = GetMoney() - self.CurrentGold

  if GoldDiff > 0 then
    self.GoldEarned = self.GoldEarned + GoldDiff
  else
    self.GoldSpent = self.GoldSpent + abs(GoldDiff)
  end

  self.CurrentGold = GetMoney()
end

function SessionWatch:NewSession()
  self.CurrentGold = GetMoney()
  self.GoldEarned = 0
  self.GoldSpent = 0
  self.HonorGained = 0
  if self.RepList then
    wipe(self.RepList)
  else
    self.RepList = {}
  end
end

function SessionWatch:ListRep()
  local count = 0
  for k,v in pairs(self.RepList) do
    self:Print(k..": ",v)
    count = count +1
  end
  if count == 0 then self:Print("No rep gained this session") end
end

function SessionWatch:ListGold()
  if self.GoldSpent  > 0 then self:Print("Gold Spent:  ", GetCoinTextureString(self.GoldSpent)) end
  if self.GoldEarned > 0 then self:Print("Gold Earned: ", GetCoinTextureString(self.GoldEarned)) end
end

function SessionWatch:ListHonor()
  if self.HonorGained > 0 then self:Print("Honor earned: ", self.HonorGained) end
end

function SessionWatch.SlashCmd(msg)
  if msg == "gold" then
    SessionWatch:ListGold()
  elseif msg == "rep" then
    SessionWatch:ListRep()
  elseif msg == "honor" then
    -- TODO
  elseif msg == "reset" then
    SessionWatch:NewSession()
  end
end

function SessionWatch:Print(l, r)
  print("|c0033AAFF"..l.."|r", r or "")
end
