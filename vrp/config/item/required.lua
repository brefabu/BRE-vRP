
local items = {}

items["medkit"] = {"Medical Kit","Used to reanimate unconscious people.",nil,0.5}
items["dirty_money"] = {"Dirty money","Illegally earned money.",nil,0}
items["parcels"] = {"Parcels","Parcels to deliver",nil,0.10}

-- -- repairkit
-- items["repairkit"] = {
--   "Kit reparatii","Folosit pentru a repara vehicule...",
--   function(user_id)
--       if user_id ~= nil then
--         local amount = vRP.getInventoryItemAmount(user_id, "repairkit")
--         if vRP.tryGetInventoryItem(user_id, "repairkit", 1, true) then
--           vRPclient.fixeNearestVehicle(player,{5.0})
--           vRP.closeMenu(player)
--         end
--       end
--   end,10.0
-- }

return items
