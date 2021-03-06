
local _, ns = ...
local cfg = ns.cfg.GROUP_INVITES

-- Play LFG,LFR and BG invite sound effects when sound is muted

if cfg["ENABLED"] then

  local function PlayInviteSound()
    if GetCVarBool("Sound_EnableSFX") then
      if GetCVarBool("Sound_EnableAllSound") then
        return
      end
    end
    PlaySound("ReadyCheck", "Master")
  end

  local function IsBGInvite()
    if StaticPopup1.which == "CONFIRM_BATTLEFIELD_ENTRY" then
      PlayInviteSound()
    end
  end
  StaticPopup1:HookScript("OnShow", IsBGInvite)
  LFGDungeonReadyPopup:HookScript("OnShow", PlayInviteSound)

end
