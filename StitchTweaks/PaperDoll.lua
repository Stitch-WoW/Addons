
local _, ns = ...
local cfg = ns.cfg.PAPER_DOLL

if cfg["ENABLED"] then
  local tickIcon = "Interface\\GuildFrame\\GuildChallenges"
  local tickCoords = { 0.00097656,0.02832031,0.00781250,0.19531250 }
  
  -- Helm
  local head = CreateFrame("Button", nil, PaperDollFrame)
  head:SetToplevel(true)
  head:SetSize(21,18)
  head:SetPoint("LEFT", CharacterHeadSlot, "RIGHT", 9, 0)
  head:SetFrameLevel(50)
  head:SetNormalTexture(tickIcon)
  local htex = head:GetNormalTexture()
  htex:SetTexCoord(unpack(tickCoords))
  if not ShowingHelm() then htex:SetDesaturated(1) end
  head:RegisterEvent("UNIT_MODEL_CHANGED")
  head:SetScript("OnEvent", function(self, event, unit)
    if unit == "player" then
      if not ShowingHelm() then
        htex:SetDesaturated(1)
      else
        htex:SetDesaturated(0)
      end
    end
  end)
  head:SetScript("OnClick", function()
    ShowHelm(not ShowingHelm())
  end)

  -- Cloak
  local cloak = CreateFrame("Button", nil, PaperDollFrame)
  cloak:SetToplevel(true)
  cloak:SetSize(21,18)
  cloak:SetPoint("LEFT", CharacterBackSlot, "RIGHT", 9, 0)
  cloak:SetFrameLevel(50)
  cloak:SetNormalTexture(tickIcon)
  local ctex = cloak:GetNormalTexture()
  ctex:SetTexCoord(unpack(tickCoords))
  if not ShowingCloak() then ctex:SetDesaturated(1) end
  cloak:RegisterEvent("UNIT_MODEL_CHANGED")
  cloak:SetScript("OnEvent", function(self, event, unit)
    if unit == "player" then
      if not ShowingCloak() then
        ctex:SetDesaturated(1)
      else
        ctex:SetDesaturated(0)
      end
    end
  end)
  cloak:SetScript("OnClick", function()
    ShowCloak(not ShowingCloak())
  end)
  
  -- Spec Swap
  local spec = CreateFrame("Button", nil, PaperDollFrame)
  spec:SetToplevel(true)
  spec:SetSize(32,32)
  spec:SetPoint("LEFT", CharacterWristSlot, "RIGHT", 16, 0)
  spec:SetFrameLevel(50)
  spec:SetNormalTexture("Interface\\FriendsFrame\\UI-Toast-ChatInviteIcon")
  spec:SetScript("OnClick", function()
    SetActiveTalentGroup(GetActiveTalentGroup()%2+1)
  end)
end
