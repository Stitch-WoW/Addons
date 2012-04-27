--
-- Random mount summon button
-- very incomplete, does not handle low level chars and many situations
--


local MountUp = CreateFrame("Frame",nil,UIParent)
MountUp:RegisterEvent("PLAYER_ENTERING_WORLD")
MountUp:RegisterEvent("ZONE_CHANGED_INDOORS")
MountUp:SetScript("OnEvent", function(self,event,...)
  self[event](self,event,...)
end)

MountUp.FlyingMounts = {}
MountUp.GroundMounts = {}

MountUp.VendorMount = 61447
MountUp.BlackList = { 25953, 26054, 26055, 26056 }

SLASH_MU1 = "/mountup"
function SlashCmdList.MU(msg)
  if msg == "ground" then
    for k,v in pairs(GroundMounts) do
      local _,_,spellID = GetCompanionInfo("MOUNT", v)
      local link = GetSpellLink(spellID)
      print(link)
    end
  elseif msg == "flying" then
    for k,v in pairs(FlyingMounts) do
      local _,_,spellID = GetCompanionInfo("MOUNT", v)
      local link = GetSpellLink(spellID)
      print(link)
    end
  else
    if IsOutdoors() then
      if IsFlyableArea() then
        MountUp_SummonFlying()
      else
        MountUp_SummonGround()
      end
    end
  end
end

function MountUp:ListMounts(type)

end

function MountUp:SummonRandomGroundMount()
  CallCompanion("MOUNT", GroundMounts[random(1,#GroundMounts)])
end

function MountUp:SummonRandomFlyingMount()
  CallCompanion("MOUNT", FlyingMounts[random(1,#FlyingMounts)])
end

function MountUp:SummonVendorMount()
  CallCompanion("MOUNT", VendorMount)
end

function MountUp:PLAYER_ENTERING_WORLD()
  for i=1,GetNumCompanions("MOUNT") do
    local _,_,spellID,_,_,flags = GetCompanionInfo("MOUNT",i)

    if bit.band(flags, 0x02) == 0x02 then
      tinsert(self.FlyingMounts, i)
    else
      if not tContains(self.BlackList, spellID) then
        tinsert(self.GroundMounts, i)
      end
      if spellID == self.VendorMount then
        self.VendorMount = i
      end
    end
  end
end

function MountUp:ZONE_CHANGED_INDOORS()
end

function MountUp:OnClick(self, button)
  if IsOutdoors() and button == "LeftButton" then
    if IsFlyableArea() then
      self:SummonRandomFlyingMount()
    else
      self:SummonRandomGroundMount()
    end
  else
    if IsModifierKeyDown() then
      self:SummonVendorMount()
    else
      self:SummonRandomGroundMount()
    end
  end
end

