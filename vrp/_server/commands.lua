local commands = {}

function vRP.registerCommand(rawcmd, role, class, desc, func)
    commands[rawcmd] = {class = class,role = role,description = desc,func = func}
end

function vRP.getCommandClass(rawcmd)
    return commands[rawcmd].class
end

function vRP.getCommandDescription(rawcmd)
    return commands[rawcmd].description
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    for i,v in pairs(commands) do
    RegisterCommand(i, function(player,args)
            local user_id = vRP.getUserId(player)

            if vRP.hasUserRole(user_id, v.role) then
                v.func(player,args)
            end
        end)
    end
end)

--------------------------------------------------------------------------------------------
--COMMANDS


-- HELPER
vRP.registerCommand("fix", "Helper", "Helper", "Repair the nearest vehicle!", function(player,args)
    local user_id = vRP.getUserId(player)
    local vehicle = args[1]
  
    vRPclient.fixeNearestVehicle(player,{5.0})
end)
  
vRP.registerCommand("veh", "Helper", "Helper", "Spawn the requested vehicle!", function(player,args)
    local user_id = vRP.getUserId(player)
    local vehicle = args[1]
  
    vRPclient.spawnAdminVehicle(player,{vehicle})
end)
  
vRP.registerCommand("dv", "Helper", "Helper", "Despawn the nearest vehicle!", function(player,args)
    local user_id = vRP.getUserId(player)
  
    vRPclient.getNearestVehicle(player,{5.0},function(vehicle)
      if vehicle then
        vRPclient.despawnVehicle(player,{vehicle})
        vRPclient.notify(player,{"It was despawned!"})
      else
        vRPclient.notify(player,{"Didn't found any vehicle!"})
      end
    end)
end)
