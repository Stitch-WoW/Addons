
local _, ns = ...
local cfg = ns.cfg.AUTO_REPAIR

local repairFrame = CreateFrame("Frame")
repairFrame:RegisterEvent("MERCHANT_SHOW")
repairFrame:SetScript("OnEvent", function()
  if not cfg["ENABLED"] then
    print("|c0033AAFFAuto repairs disabled.")
  else
    local repairCost, repairAvail = GetRepairAllCost()
    if repairAvail then
      if cfg["GUILD_REPAIRS"] and CanGuildBankRepair() then
        RepairAllItems(1)
        print("|c0033AAFFItems repaired for|r", GetCoinTextureString(repairCost), "|c0033AAFF(Guild)|r")
      else
        if repairCost <= GetMoney() then
          RepairAllItems()
          print("|c0033AAFFItems repaired for|r", GetCoinTextureString(repairCost))
        else
          print("|c0033AAFFUnable to repair your items. Not enough money.")
        end
      end
    end
  end
end)
