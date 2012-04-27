
local _, ns = ...
local cfg = ns.cfg.SKIP_GOSSIP

--
-- Adds a small static button to the bottom of the gossip frame 
-- for advancing dialog
--

if cfg["ENABLED"] then

  local SkipGossipButton = CreateFrame("Button", nil, GossipGreetingScrollFrame)
  SkipGossipButton:SetPoint("BOTTOMRIGHT", -10, 4)
  SkipGossipButton:SetSize(18,18)
  SkipGossipButton:SetFrameLevel(50)
  SkipGossipButton:SetText("Next >>")
  SkipGossipButton:SetNormalTexture("Interface\\GossipFrame\\GossipGossipIcon")
  SkipGossipButton:GetNormalTexture():SetVertexColor(.43,.55,.43)
  SkipGossipButton:SetHighlightTexture("Interface\\GossipFrame\\GossipGossipIcon")
  SkipGossipButton:RegisterEvent("GOSSIP_SHOW")
  SkipGossipButton:SetScript("OnClick", function()
    _G["GossipTitleButton1"]:Click()
  end)
  SkipGossipButton:SetScript("OnEvent", function()
    if GetNumGossipOptions() == 1 then
      SkipGossipButton:Show()
    else
      SkipGossipButton:Hide()
    end
  end)

end
