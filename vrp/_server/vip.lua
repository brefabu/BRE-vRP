local config = module("config/vip")

function vRP.getUserVip(id)
  return vRP.users[vRP.getUserSource(id)].data.vip
end

function vRP.hasUserVip(id,vip)
  if vRP.getVipIterator(vip) <= vRP.getVipIterator(vRP.getUserVip(id)) then
    return true
  else
      return false
  end
end

function vRP.setUserVip(id,vip)
  if vip == nil then
    vRP.users[vRP.getUserSource(id)].data.vip = nil
  else
    for i,v in pairs(config) do
        if v:lower() == vip:lower() then
            vRP.users[vRP.getUserSource(id)].data.vip = v
        end
    end
  end
end

function vRP.getVipIterator(vip)
  for i,v in pairs(config) do
      if v:lower() == vip:lower() then
          return i
      end
  end
end

vRP.registerMenuBuilder("admin", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
      local choices = {}
      if vRP.hasUserVip(user_id,"Administrator") or vRP.hasUserVip(user_id,"Fondator") then
        choices["Set vip"] = {function(player,data)
          vRP.prompt(player, "User ID:", "", function(player, nuser_id)
            nuser_id = tonumber(nuser_id)
            local target = vRP.getUserSource(nuser_id)
            if target then
              vRP.prompt(player, "VIP:", "", function(player, vip)
                if vip ~= " " and vip ~= nil then
                  vRP.setUserVip(nuser_id,vip)
                  vRPclient.notify(player,{"Setted vip!"})
                end
              end)
            else
              vRPclient.notify(player,{"Is offline!"})
            end
          end)
        end}

        choices["Reset vip"] = {function(player,data)
          vRP.prompt(player, "User ID:", "", function(player, nuser_id)
            nuser_id = tonumber(nuser_id)
            local target = vRP.getUserSource(nuser_id)
            if target then
              vRP.setUserVip(nuser_id, nil)
              vRPclient.notify(player,{"Resetted vip!"})
            else
              vRPclient.notify(player,{"Is offline!"})
            end
          end)
        end}
      end
      add(choices)
  end
end)
