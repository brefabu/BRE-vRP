-- load config items
local config = module("config/items")

local items = config.items

function vRP.getItemName(idname)
  return items[idname][1] or " "
end

function vRP.getItemWeight(idname)
  return items[idname][4] or 0
end

function vRP.getItemDescription(idname)
  return items[idname][2] or " "
end

function vRP.playerUseItem(user_id,idname)
  if items[idname][3] ~= nil then
    items[idname][3](user_id)
  end
end

function vRP.registerItem(idname,name,description,use,weight)
  items[idname] = {name,description,use,weight}
end
