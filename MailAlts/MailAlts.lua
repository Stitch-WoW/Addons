--
-- Send mail auto completion priority for your alts
--

local availableAlts
local realmName = GetRealmName()
local playerName = UnitName("player")
local faction = UnitFactionGroup("player")

local OrigMailEdit_OnChar = SendMailNameEditBox:GetScript("OnChar")
SendMailNameEditBox:SetScript("OnChar", function(self, ...)
  local text = self:GetText()
  local len = strlen(text)

  for alt in pairs(availableAlts) do
    if (strfind(strupper(alt), strupper(text), 1, 1) == 1) then
      SendMailNameEditBox:SetText(alt)
      SendMailNameEditBox:HighlightText(len, -1)
      return
    end
  end

  if OrigMailEdit_OnChar then
    return OrigMailEdit_OnChar(self, ...)
  end
end)

local function MailAlts_OnLoad()
  -- Load DB and register new char if needed
  if not MailAltsDB then MailAltsDB = {} end
  if not MailAltsDB[realmName..'/'..faction] then
    MailAltsDB[realmName..'/'..faction] = {}
  end
  availableAlts = MailAltsDB[realmName..'/'..faction]
  availableAlts[playerName] = true
end

local frame = CreateFrame("Frame", nil, nil, nil)
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", MailAlts_OnLoad)
