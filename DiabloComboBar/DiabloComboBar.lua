--
-- Standalone combo point bar like oUF_Diablo, using rTextures
-- 90% oUF_Diablo and NugComboBar code, all credit to their authors
--

-- Config
local anchor = "PitBull4_Frames_target"
local offset = { x = 0, y = "-70" }
local scale = 0.55
-- End Config

local DiabloComboBar = CreateFrame("Frame",nil,UIParent)
DiabloComboBar:RegisterEvent("PLAYER_LOGIN")
DiabloComboBar:SetScript("OnEvent" , function(self, event, ...)
  self[event](self, event, ...)
end)

function DiabloComboBar.PLAYER_LOGIN(self, event)
  local _,class = UnitClass("player")
  if class == "ROGUE" or class == "DRUID" then
    print("DiabloComboBar loading")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("UNIT_COMBO_POINTS")
    
    self:CreateComboBar()
  end
end

function DiabloComboBar:PLAYER_TARGET_CHANGED(event, unit)
  self:UpdateCombos(self, event, unit)
end

function DiabloComboBar:UNIT_COMBO_POINTS(event, unit)
  self:UpdateCombos(self, event, unit)
end

function DiabloComboBar:CreateComboBar()
  self.CPoints = {}
  local w = 64*(MAX_COMBO_POINTS+2)
  local h = 64

  self:SetPoint("CENTER", anchor, "CENTER", offset.x or 0, offset.y or 0)
  self:SetSize(w,h)

  local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetSize(64,64)
  t:SetPoint("LEFT",0,0)
  t:SetTexture("Interface\\AddOns\\rTextures\\combo_left")
  self.leftedge = t

  t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetSize(64,64)
  t:SetPoint("RIGHT",0,0)
  t:SetTexture("Interface\\AddOns\\rTextures\\combo_right")
  self.rightedge = t

  self.back = {}
  self.filling = {}
  self.glow = {}
  self.gloss = {}

  for i = 1, MAX_COMBO_POINTS do
    local back = "back"..i
    self.back[i] = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    self.back[i]:SetSize(64,64)
    self.back[i]:SetPoint("LEFT",i*64,0)
    self.back[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_back")
    self.back[i]:SetAlpha(0.7)

    self.filling[i] = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    self.filling[i]:SetSize(64,64)
    self.filling[i]:SetPoint("LEFT",i*64,0)
    self.filling[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_fill")
    self.filling[i]:SetVertexColor(0.9,0.59,0,1)
    self.filling[i]:SetBlendMode("ADD")

    self.glow[i] = self:CreateTexture(nil,"BACKGROUND",nil,-6)
    self.glow[i]:SetSize(64*1.25,64*1.25)
    self.glow[i]:SetPoint("CENTER", self.filling[i], "CENTER", 0, 0)
    self.glow[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_glow")
    self.glow[i]:SetBlendMode("ADD")
    self.glow[i]:SetVertexColor(0.9,0.59,0,1)

    self.gloss[i] = self:CreateTexture(nil,"BACKGROUND",nil,-5)
    self.gloss[i]:SetSize(64,64)
    self.gloss[i]:SetPoint("LEFT",i*64,0)
    self.gloss[i]:SetTexture("Interface\\AddOns\\rTextures\\combo_highlight")
    self.gloss[i]:SetBlendMode("ADD")

--    bar.color = self.cfg.combobar.color
    self.CPoints[i] = self.filling[i]
  end

  self:SetScale(scale)
  self:Hide()
end

function DiabloComboBar:UpdateCombos(self, event, unit)
  if unit == "pet" then return end

  local cp = 0
  if(UnitExists("vehicle") and GetComboPoints("vehicle") >= 1) then
    cp = GetComboPoints("vehicle")
  else
    cp = GetComboPoints("player")
  end

  if cp < 1 then
    self:Hide()
  else
    self:Show()
  end

  for i=1, MAX_COMBO_POINTS do
    local adjust = cp/MAX_COMBO_POINTS
    if(i <= cp) then
      if adjust == 1 then
        self.filling[i]:SetVertexColor(60/255,220/255,20/255,1)
        self.glow[i]:SetVertexColor(60/255,220/255,20/255,1)
      else
        self.filling[i]:SetVertexColor(0.9,0.59,0,1)
        self.glow[i]:SetVertexColor(0.9,0.59,0,1)
      end
      self.filling[i]:Show()
      self.glow[i]:Show()
    else
      self.filling[i]:Hide()
      self.glow[i]:Hide()
    end
  end
end
