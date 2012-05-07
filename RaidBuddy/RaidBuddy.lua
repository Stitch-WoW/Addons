--
-- Simple solo raid forming
--


-- CONFIG
local CHAR_TO_INVITE = { 
  ["Horde"]    = "Raidbuddy",
  ["Alliance"] = "Raidbud",
}
          
local LOGOUT_ALT = true

local Leader = nil

if UnitName("player") ~= CHAR_TO_INVITE then
  Leader = true
end

local RaidBuddy = CreateFrame("Frame", nil, UIParent)
RaidBuddy:RegisterEvent("PLAYER_LOGIN")
RaidBuddy:SetScript("OnEvent", function(self,event,...)
  self[event](self,event,...)
end)

function RaidBuddy.PLAYER_LOGIN(self, event)
  if Leader then
    self:RegisterEvent("PARTY_CONVERTED_TO_RAID")
    self:RegisterEvent("PARTY_MEMBERS_CHANGED")
  else
    self:RegisterEvent("PARTY_CONVERTED_TO_RAID")
    self:RegisterEvent("PARTY_INVITE_REQUEST")
  end
end

function RaidBuddy:Enable()
  self:SetScript("OnEvent", function(self,event,...)
    self[event](self,event,...)
  end)

  local faction = UnitFactionGroup("player")
  CHAR_TO_INVITE = CHAR_TO_INVITE[faction]
end

function RaidBuddy:Disable()
  self:SetScript("OnEvent", nil)
end

function RaidBuddy:PARTY_INVITE_REQUEST()
  _G["StaticPopup1Button1"]:Click()
end

function RaidBuddy:PARTY_MEMBERS_CHANGED()
  if UnitInParty(CHAR_TO_INVITE) then
    ConvertToRaid()
  end
end

function RaidBuddy:PARTY_CONVERTED_TO_RAID()
  if Leader and UnitInParty(CHAR_TO_INVITE) then
    SetLootMethod("freeforall")
    self:Disable()
  end

  if not Leader and LOGOUT_ALT then
    ForceQuit()
  end
end

function RaidBuddy:StartRaid()
  if GetNumPartyMembers() == 0 then
    InviteUnit(CHAR_TO_INVITE)
  end
end

SLASH_RB1 = "/raidbuddy"
function SlashCmdList.RB(msg)
  if Leader then
    RaidBuddy:Enable()
    RaidBuddy:StartRaid()
  end
end
