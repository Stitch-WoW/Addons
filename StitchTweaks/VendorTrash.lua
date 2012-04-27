

local _, ns = ...
local cfg = ns.cfg.VENDOR_TRASH

if cfg["ENABLED"] then
  local junkFrame = CreateFrame("Frame",nil,nil)
  junkFrame:RegisterEvent("MERCHANT_SHOW")
  junkFrame:SetScript("OnEvent", function()
    local bagSlots
    local moneyTally = 0
    for b=0,4 do
      bagSlots = GetContainerNumSlots(b)
      if bagSlots then
        for i=1,bagSlots do
          local itemLink = GetContainerItemLink(b,i)
          if itemLink then
            local itemName,_,itemQuality,_,_,_,_,_,_,_,itemValue = GetItemInfo(itemLink)
            if itemQuality == 0 then
              --print("|c0033AAFFJunk:|r",itemName,"-",itemValue)
              moneyTally = moneyTally + itemValue
              UseContainerItem(b,i)
            end
          end
        end
      end
    end
    if moneyTally > 0 then
      print("|c0033AAFFJunk sold for|r", GetCoinTextureString(moneyTally))
    end
  end)
end
