
local _, ns = ...
local cfg = ns.cfg.ENCHANT_PREVIEW

-- Slash command to easily preview a weapon with a certain enchant
-- Only handles a few enchants, and has no error checks, usage:
-- /enchant [itemlink] enchantname

if cfg["ENABLED"] then

  ENCHANT_IDS = {
    ["landslide"]   = 4099,
    ["torrent"]     = 4097,
    ["heartsong"]   = 4084,
    ["executioner"] = 3225,
    ["mongoose"]    = 2673,
  }
  
  SLASH_ENCHANT1 = "/enchant"
  function SlashCmdList.ENCHANT(msg)
    local item, enchant = msg:match("^(.*\124r)%s*(.*)$")
    local enchantid = ENCHANT_IDS[enchant]

    if item and enchantid then
      local newitem = item:gsub("(.*Hitem:%d+:)%d+(:.*)", "%1"..enchantid.."%2")
      DEFAULT_CHAT_FRAME:AddMessage("|c0033AAFFEnchanted:|r "..newitem)
    else
      DEFAULT_CHAT_FRAME:AddMessage("|c0033AAFFInvalid item link or enchant name")
    end
  end

end
