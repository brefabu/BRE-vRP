local config = module("config/roles")

function vRP.getUserRole(id)
  return vRP.users[vRP.getUserSource(id)].data.role
end

function vRP.hasUserRole(id,role)
  if vRP.getRoleIterator(role) <= vRP.getRoleIterator(vRP.getUserRole(id)) then
    return true
  else
      return false
  end
end

function vRP.setUserRole(id,role)
  for i,v in pairs(config) do
      if v:lower() == role:lower() then
          vRP.users[vRP.getUserSource(id)].data.role = v
      end
  end
end

function vRP.getRoleIterator(role)
  for i,v in pairs(config) do
      if v:lower() == role:lower() then
          return i
      end
  end
end

vRP.registerMenuBuilder("admin", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
      local choices = {}
      if vRP.hasUserRole(user_id,"Administrator") or vRP.hasUserRole(user_id,"Owner") then
        choices["Set role"] = {function(player,data)
          vRP.prompt(player, "User ID:", "", function(player, nuser_id)
            nuser_id = tonumber(nuser_id)
            local target = vRP.getUserSource(nuser_id)
            if target then
              vRP.prompt(player, "Rol:", "", function(player, role)
                if role ~= " " and role ~= nil then
                  vRP.setUserRole(nuser_id,role)
                  vRPclient.notify(player,{"You setted the role!"})
                end
              end)
            else
              vRPclient.notify(player,{"Is offline!"})
            end
          end)
        end}

        choices["Reset role"] = {function(player,data)
          vRP.prompt(player, "User ID:", "", function(player, nuser_id)
            nuser_id = tonumber(nuser_id)
            local target = vRP.getUserSource(nuser_id)
            if target then
              vRP.setUserRole(nuser_id, "Player")
              vRPclient.notify(player,{"You resetted the role!"})
            else
              vRPclient.notify(player,{"Is offline!"})
            end
          end)
        end}
      end
      add(choices)
  end
end)
