--
-- Standalone rune bar with oUF_Diablo combo point appearance, using rTextures
--

-- CONFIG
local anchor = "PitBull4_Frames_target"
local offset = { x = 0, y = "-70" }
local scale = 0.55
local only_in_combat = true
-- END CONFIG

-- CONSTANTS
local RUNE_IDS = { 1, 2, 5, 6, 3, 4 }
local NUM_RUNES = #RUNE_IDS

local RUNETYPE_BLOOD  = 1
local RUNETYPE_UNHOLY = 2
local RUNETYPE_FROST  = 3
local RUNETYPE_DEATH  = 4

local RUNE_NAMES = _G["runeMapping"] or {
  [RUNETYPE_BLOOD]  = "BLOOD",
  [RUNETYPE_UNHOLY] = "UNHOLY",
  [RUNETYPE_FROST]  = "FROST",
  [RUNETYPE_DEATH]  = "DEATH",
}

local RUNE_COLOR = {
  [RUNETYPE_BLOOD]  = { 1, 0, 0 },
  [RUNETYPE_UNHOLY] = { 0,.5, 0 },
  [RUNETYPE_FROST]  = { 0, 1, 1 },
  [RUNETYPE_DEATH]  = {.8,.1, 1 },
}

local ICON_BACK   = [[Interface\AddOns\rTextures\combo_back]]
local ICON_FILL   = [[Interface\AddOns\rTextures\combo_fill]]
local ICON_GLOW   = [[Interface\AddOns\rTextures\combo_glow]]
local ICON_HLIGHT = [[Interface\AddOns\rTextures\combo_highlight]]

local ICON_SIZE = 64
-- END CONSTANTS

local DiabloRuneBar = CreateFrame("Frame",nil,UIParent)
DiabloRuneBar:RegisterEvent("PLAYER_LOGIN")
DiabloRuneBar:SetScript("OnEvent" , function(self, event, ...)
  self[event](self, event, ...)
end)

function DiabloRuneBar.PLAYER_LOGIN(self, event, ...)
  local _,class = UnitClass("player")
  if class == "DEATHKNIGHT" then
    self:RegisterEvent("RUNE_POWER_UPDATE")
    self:RegisterEvent("RUNE_TYPE_UPDATE")
    self:RegisterEvent("PLAYER_REGEN_ENABLED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:CreateRuneBar()

    RuneFrame:UnregisterAllEvents()
    RuneFrame:Hide()
    -- Refuses to stay hidden, lets move it off the bottom of the screen
    RuneFrame:SetScript("OnShow", function()
      RuneFrame:ClearAllPoints()
      RuneFrame:SetPoint("TOP", UIParent, "BOTTOM", 0, -50)
    end)
  end
end

function DiabloRuneBar:PLAYER_REGEN_ENABLED(event)
  if only_in_combat then
    if UnitExists("target") and not UnitIsFriend("target", "player") then
      self:Show()
--    elseif not self:AllRunesReady() then
--      self:Show()
    else
      self:Hide()
    end   
  end
end

function DiabloRuneBar:PLAYER_REGEN_DISABLED(event)
  self:Show()
end

function DiabloRuneBar:PLAYER_TARGET_CHANGED(event)
  if UnitAffectingCombat("player") then
    return
  end

  if UnitExists("target") and not UnitIsFriend("target", "player") then
    self:Show()
  else
    self:Hide()
  end
end
--[[
function DiabloRuneBar:AllRunesReady()
  for i=1,NUM_RUNES do
    local _,_,ready = GetRuneCooldown(i)
    if not ready then
      return
    end
  end
  return 1
end
]]--

function DiabloRuneBar:RUNE_POWER_UPDATE(event, rune_id, usable)
  if rune_id < 1 or rune_id > NUM_RUNES then
    return
  end
  local rune = self.Runes[rune_id]
  if rune then
    self:UpdateRuneTextures(rune)
    self:UpdateRuneCooldown(rune)
  end
end

function DiabloRuneBar:RUNE_TYPE_UPDATE(event, rune_id)
  if rune_id < 1 or rune_id > NUM_RUNES then
    return
  end
  local rune = self.Runes[rune_id]
  if rune then
    self:UpdateRuneTextures(rune)
    self:UpdateRuneCooldown(rune)
  end
end

function DiabloRuneBar:CreateRuneBar()
  self.Runes = {}
  local w = ICON_SIZE*8
  local h = ICON_SIZE

  self:SetPoint("CENTER", anchor, "CENTER", offset.x or 0, offset.y or 0)
  self:SetSize(w,h)

  -- end caps
  local t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetSize(ICON_SIZE,ICON_SIZE)
  t:SetPoint("LEFT",0,0)
  t:SetTexture("Interface\\AddOns\\rTextures\\combo_left")
  self.leftedge = t

  t = self:CreateTexture(nil,"BACKGROUND",nil,-8)
  t:SetSize(ICON_SIZE,ICON_SIZE)
  t:SetPoint("RIGHT",0,0)
  t:SetTexture("Interface\\AddOns\\rTextures\\combo_right")
  self.rightedge = t

  -- runes
  for i=1, NUM_RUNES do
    local id = RUNE_IDS[i]
    local rune = CreateFrame("Frame")

    rune:ClearAllPoints()
    rune:SetPoint("LEFT",DiabloRuneBar,"LEFT",i*ICON_SIZE,0)

    rune.back = self:CreateTexture(nil,"BACKGROUND",nil,-8)
    rune.back:SetSize(ICON_SIZE,ICON_SIZE)
    rune.back:SetPoint("LEFT",i*ICON_SIZE,0)
    rune.back:SetTexture(ICON_BACK)
    rune.back:SetAlpha(.7)

    rune.fill = self:CreateTexture(nil,"BACKGROUND",nil,-7)
    rune.fill:SetSize(ICON_SIZE,ICON_SIZE)
    rune.fill:SetPoint("LEFT",i*ICON_SIZE,0)
    rune.fill:SetTexture(ICON_FILL)
    rune.fill:SetBlendMode("ADD")
    
    rune.glow = self:CreateTexture(nil,"BACKGROUND",nil,-6)
    rune.glow:SetSize(ICON_SIZE,ICON_SIZE)
    rune.glow:SetPoint("CENTER",rune.fill,"CENTER",0,0)
    rune.glow:SetTexture(ICON_GLOW)
    rune.glow:SetBlendMode("ADD")

    rune.hlight = self:CreateTexture(nil,"BACKGROUND",nil,-5)
    rune.hlight:SetSize(ICON_SIZE,ICON_SIZE)
    rune.hlight:SetPoint("LEFT",i*ICON_SIZE,0)
    rune.hlight:SetBlendMode("ADD")

    rune.id = id
    self.Runes[id] = rune
    self:UpdateRuneTextures(rune)
    self:UpdateRuneCooldown(rune)
  end

  self:SetScale(scale)
  self:Hide()
end

function DiabloRuneBar:UpdateRuneTextures(rune)
  -- Swapping from original to death and vice versa
  local rune_type = GetRuneType(rune.id)
  if rune.rune_type == rune_type then
    return
  end

  local old_rune_type = rune.rune_type
  rune.rune_type = rune_type

  rune.fill:SetVertexColor(unpack(RUNE_COLOR[rune.rune_type]))
  rune.glow:SetVertexColor(unpack(RUNE_COLOR[rune.rune_type]))
end

function DiabloRuneBar:UpdateRuneCooldown(rune)
  local start,duration,active = GetRuneCooldown(rune.id)
  if active then
    rune.fill:SetAlpha(1)
    rune.glow:Show()
  else
    rune.fill:SetAlpha(.3)
    rune.glow:Hide()
  end
end
