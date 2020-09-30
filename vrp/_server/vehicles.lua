MySQL.createCommand("vRP/add_vehicle","INSERT IGNORE INTO vehicles(owner,vehicle,vehicle_plate,data) VALUES(@owner,@vehicle,@vehicle_plate,@data)")
MySQL.createCommand("vRP/remove_vehicle","DELETE FROM vehicles WHERE vehicle_plate = @vehicle_plate")
MySQL.createCommand("vRP/get_vehicles","SELECT * FROM vehicles WHERE owner = @user_id")
MySQL.createCommand("vRP/get_all_vehicles","SELECT * FROM vehicles")
MySQL.createCommand("vRP/get_vehicle","SELECT * FROM vehicles WHERE vehicle_plate = @vehicle_plate")
MySQL.createCommand("vRP/update_vehicle","UPDATE vehicles SET data = @data WHERE vehicle_plate = @vehicle_plate")

local vehicles = module("config/vehicles")

vRP.vehicles = {}

function vRP.getVehicles()
  return vehicles
end

function vRP.getVehPrice(vehicle)
  return vehicles[vehicle][2] or 0
end

function vRP.getVehName(vehicle)
  return vehicles[vehicle][1] or vehicle
end

function vRP.getVehicle(plate)
  return vRP.vehicles[plate]
end

function vRP.getPlayerVehicles(user_id)
  local vehicles = {}

  for i,v in paris(vRP.vehicles) do
    if v.owner == user_id then
      table.insert(vehicles,v)
    end
  end

  return vehicles
end

function vRP.updateUpsVehicle(plate,ups)
  vRP.vehicles[plate].data.ups = ups
end

function vRP.getUpsVehicle(plate)
  return vRP.vehicles[plate].data.ups
end

function vRP.buyVehicle(vehicle, vehicle_plate, owner_id)
  vRP.vehicles[vehicle_plate] = {data = {position = {x = 0, y = 0, z = 0, h = 0}, ups = " ", insurance = false, odometer = 0, consumption = 0}, owner = owner_id}
  MySQL.execute("vRP/add_vehicle",{vehicle = vehicle, vehicle_plate = vehicle_plate, owner = owner_id,data = json.encode(vRP.vehicles[vehicle_plate].data)})
end

function vRP.registerVehicle(plate,vehicle)
  vRP.vehicles[plate].vehicle = vehicle
end

AddEventHandler("vRP:playerLoggedIn", function(player, user_id, data)
  if player ~= nil then
    for i,v in pairs(vRP.vehicles) do
      if v.owner == user_id then
        vRPclient.despawnVehicle(-1,{i})
        vRP.vehicles[i] = nil
      end
    end

    MySQL.query("vRP/get_vehicles",{user_id = user_id},function(result,affected)
      for i,v in pairs(result) do
        local data = json.decode(v.data)

        if ( data.position.x ~= 0 and data.position.y ~= 0 and data.position.z ~= 0 ) then
          vRPclient.spawnVehicle(player,{v.vehicle,v.vehicle_plate,data.ups,data.position.x,data.position.y,data.position.z,data.position.h},function(vehicle)
            vRP.vehicles[v.vehicle_plate] = {data = data, owner = v.owner}
            vRP.registerVehicle(v.vehicle_plate,vehicle)
          end)
        end
      end
    end)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(15000)
    for i,v in pairs(vRP.vehicles) do
      if vRP.getUserSource(v.owner) == nil then
        vRPclient.despawnPersonalVehicle(-1,{v.vehicle})
      end
    end
  end
end)

AddEventHandler("vRP:save",function()
  for i,v in pairs(vRP.vehicles) do
    local user_id = v.owner
    local player = vRP.getUserSource(user_id)
    if player then
      vRPclient.getEntityCoords(player,{v.vehicle},function(x,y,z,h)
        if ( x ~= 0 and y ~= 0 and z ~= 0 ) then
          v.data.position.x = x
          v.data.position.y = y
          v.data.position.z = z
          v.data.position.h = h
          MySQL.execute("vRP/update_vehicle",{vehicle_plate = i,data = json.encode(v.data)})
        end
      end)
    end
  end
end)

local veh_actions = {}

veh_actions["Trunk"] = {function(user_id,player,plate)
  
  if not vRP.checkInventory(string.lower("v:"..plate)) then
    vRP.addInventory(string.lower("v:"..plate),50)
  end

  vRP.buildMenu("trunk_menu", {user_id = user_id, player = player, plate = plate}, function(menu)
    menu.name="Trunk"
    menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

    menu["Get"] = {function(player,choice)
      vRP.buildMenu("trunk", {user_id = user_id, player = player, plate = plate}, function(trunk)
        trunk.name="Trunk"
        trunk.css={top="75px",header_color="rgba(255,125,0,0.75)"}

        local data = vRP.getInventory(string.lower("v:"..plate))

        local weight = vRP.getInventoryWeight(string.lower("v:"..plate))

        trunk[weight.." / "..vRP.getInventoryMaxWeight(string.lower("v:"..plate)).." Kg"] = {nil}

        for i,v in pairs(data.items) do
          trunk[vRP.getItemName(i)] = {function(player,choice)
            if vRP.tryGetInventoryItem(string.lower("v:"..plate), i, v) then
              vRP.giveInventoryItem("player:"..user_id, i, v)
            end
          end,"Quantity: "..v.."<br>Description: "..vRP.getItemDescription(i)}
        end

        vRP.openMenu(player,trunk)
      end)
    end}

    menu["Put"] = {function(player,choice)
      vRP.buildMenu("inventory_p", {user_id = user_id, player = player, plate = plate}, function(inventory)
        inventory.name="Trunk"
        inventory.css={top="75px",header_color="rgba(255,125,0,0.75)"}

        local data = vRP.getInventory("player:"..user_id)

        local weight = vRP.getInventoryWeight("player:"..user_id)

        inventory[weight.." / "..vRP.getInventoryMaxWeight("player:"..user_id).." Kg"] = {nil}

        for i,v in pairs(data.items) do
          inventory[vRP.getItemName(i)] = {function(player,choice)
            if vRP.tryGetInventoryItem("player:"..user_id, tostring(i), parseInt(v)) then
              vRP.giveInventoryItem(string.lower("v:"..plate), tostring(i), parseInt(v))
            end
          end,"Quantity: "..v.."<br>Description: "..vRP.getItemDescription(i)}
        end

        vRP.openMenu(player,inventory)
      end)
    end}

    vRP.openMenu(player,menu)
  end)
end}

veh_actions["Lock / Unlock"] = {function(user_id,player,plate)
  vRPclient.vc_toggleLock(player, {plate})
end}

veh_actions["On / Off engine"] = {function(user_id,player,plate)
  vRPclient.vc_toggleEngine(player, {plate})
end}

local function ch_vehicle(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestOwnedVehicle(player,{5},function(ok,plate,vehicle)
      if ok then
        vRP.buildMenu("vehicle", {user_id = user_id, player = player, plate = plate}, function(menu)
          menu.name="vehicle"
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}

          for k,v in pairs(veh_actions) do
            menu[k] = {function(player,choice) v[1](user_id,player,plate) end, v[2]}
          end

          vRP.openMenu(player,menu)
        end)
      else
        vRPclient.notify(player,{"No owned vehicle near!"})
      end
    end)
  end
end

local function ch_asktrunk(player,choice)
  vRPclient.getNearestPlayers(player,{5},function(nplayers)
    usrList = ""
    for k,v in pairs(nplayers) do
      usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
    end
    if usrList ~= "" then
      vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
        if nuser_id ~= nil and nuser_id ~= "" then 
          local nplayer = vRP.getUserSource(tonumber(nuser_id))
          if nplayer ~= nil then
            vRPclient.notify(player,{"Ask for trunk!"})
            vRP.request(nplayer,"Open the trunk?",15,function(nplayer,ok)
              if ok then
                vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,plate,vehicle)
                  if ok then  
                    if not vRP.checkInventory(string.lower("v:"..plate)) then
                      vRP.addInventory(string.lower("v:"..plate),50)
                    end
                      vRP.buildMenu("trunk", {user_id = user_id, player = player, plate = plate}, function(trunk)
                        trunk.name="trunk"
                        trunk.css={top="75px",header_color="rgba(255,125,0,0.75)"}
                
                        local data = vRP.getInventory("v:"..plate)
                
                        local weight = vRP.getInventoryWeight("v:"..plate)
                
                        trunk[weight.." / "..vRP.getInventoryMaxWeight("v:"..plate).." Kg"] = {nil}
                
                        for i,v in pairs(data.items) do
                          trunk[vRP.getItemName(i)] = {nil,"Quantity: "..v.."<br>Description: "..vRP.getItemDescription(i)}
                        end
                
                        vRP.openMenu(player,trunk)
                      end)
                  else
                    vRPclient.notify(player,{"No owned vehicle near!"})
                    vRPclient.notify(nplayer,{"No owned vehicle near!"})
                  end
                end)
              else
                vRPclient.notify(player,{"Ask refused!"})
              end
            end)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end

local function ch_repair(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vRP.tryGetInventoryItem(user_id,"repairkit",1,true) then
      vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        vRPclient.fixeNearestVehicle(player,{7})
        vRPclient.stopAnim(player,{false})
      end)
    end
  end
end

local function ch_replace(player,choice)
  vRPclient.replaceNearestVehicle(player,{7})
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    choices["Vehicle"] = {ch_vehicle}

    add(choices)
  end
end)

vRP.registerMenuBuilder("interaction", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}

    choices["Ask for trunk"] = {ch_asktrunk}

    add(choices)
  end
end)
