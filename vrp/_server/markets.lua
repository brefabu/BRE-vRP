local config = module("config/markets")
local market_types = config.market_types
local markets = config.markets

local function build_client_markets(source)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    for k,v in pairs(markets) do
      local gtype,x,y,z = table.unpack(v)

      local function market_enter()
        local user_id = vRP.getUserId(source)
        if user_id ~= nil then
          vRP.buildMenu("market", {user_id = user_id, player = player}, function(menu)
            menu.name= "Market"
            menu.css={top="75px",header_color="rgba(25525,0,0.75)"}

            for item,price in pairs(market_types[gtype]._items) do
                menu[vRP.getItemName(item)] = {function(player,choice)
                vRP.prompt(player,"How many ("..vRP.getItemName(item)..")?","",function(player,amount)
                  local amount = parseInt(amount)
                  if amount > 0 then
                    -- weight check
                    local new_weight = vRP.getInventoryWeight("player:"..user_id)+vRP.getItemWeight(item)*amount
                    if new_weight <= vRP.getInventoryMaxWeight("player:"..user_id) then
                      -- payment
                      if vRP.tryPayment(user_id,amount*price) then
                        vRP.giveInventoryItem("player:"..user_id,item,amount)
                        vRPclient.notify(player,{"~g~You paid "..amount*price.." EURO!"})
                      else
                        vRPclient.notify(player,{"~r~You're poor af!"})
                      end
                    else
                      vRPclient.notify(player,{"~r~Not having space in inventory!"})
                    end
                  else
                    vRPclient.notify(player,{"~r~Invalid value!"})
                  end
                end)
              end,"PRICE: "..price.." EURO<br> Description: "..vRP.getItemDescription(item)}
            end

            vRP.openMenu(source,menu) 
          end)
        end
      end

      local function market_leave()
        vRP.closeMenu(source)
      end

      vRPclient.addBlip(source,{x,y,z,market_types[gtype]._config.blipid,market_types[gtype]._config.blipcolor,gtype})
      vRPclient.addMarker(source,{x,y,z-1,0.7,0.7,0.5,0,255,125,125,150})

      vRP.setArea(source,"vRP:market"..k,x,y,z,1,1.5,market_enter,market_leave)
    end
  end
end

AddEventHandler("vRP:playerLoggedIn",function(player, user_id, data)
  if player ~= nil and user_id ~= nil and data ~= nil then
    build_client_markets(player)
  end
end)
