local vehicles = {}

local enumerator = {
  __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function getEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
      disposeFunc(iter)
      return
    end
    
    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, enumerator)
    
    local next = true
    repeat
    coroutine.yield(id)
    next, id = moveFunc(iter)
    until not next
  
    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

local function getVehicles()
  return getEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function tvRP.CreateVehicle(name,x,y,z,h)
  local i = 0
  while not HasModelLoaded(GetHashKey(name)) and i < 1000 do
    RequestModel(GetHashKey(name))
    Citizen.Wait(10)
    i = i+1
  end
  if HasModelLoaded(GetHashKey(name)) then
    local vehicle = CreateVehicle(GetHashKey(name), x,y,z+0.5, h, true, false)
    SetEntityInvincible(vehicle,false)
    SetVehicleNumberPlateText(vehicle, "THE WALL")
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    SetVehicleDoorsLocked(vehicle,2)
    SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), true)
    
    return vehicle
  end
end

local faction = nil
function tvRP.spawnFactionVehicle(name)
  local vehicle = nil
  if not IsPedInAnyVehicle(GetPlayerPed(-1),false) then
    local mhash = GetHashKey(name)
    RequestModel(mhash)
    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      Citizen.Wait(10)
      i = i+1
    end
    if HasModelLoaded(mhash) then
      x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
      vehicle = CreateVehicle(mhash, x, y, z+0.5, GetEntityHeading(GetPlayerPed(-1)), true, true)
      SetEntityInvincible(vehicle,false)
      SetVehicleNumberPlateText(vehicle, "FACTIUNE")
      SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
      SetVehicleColours(vehicle, 121, 121)
      SetVehicleFixed(vehicle)
    end
  else
    vRP.notify("Esti deja intr-o masina!")
  end
  
  faction = vehicle
  return vehicle
end

function tvRP.spawnBuyedVehicle(model,plate,pos)
  local x,y,z = table.unpack(pos)
  RequestModel( GetHashKey(model) )
  while ( not HasModelLoaded( GetHashKey(model) ) ) do
    Citizen.Wait( 1 )
  end
  if HasModelLoaded(GetHashKey(model)) then
    local vehicle = CreateVehicle(GetHashKey(model), x,y,z, 0.0, true, true)
    SetVehicleOnGroundProperly(vehicle)
    SetVehicleNumberPlateText(vehicle, plate)
    SetEntityInvincible(vehicle,false)
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
    SetVehicleHasBeenOwnedByPlayer(vehicle,true)
    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 326)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip,45)
    TriggerEvent("setTuning",vehicle,tuning)
    vehicles[plate] = {}
    vehicles[plate].vehicle = vehicle
    vehicles[plate].tuning = tuning
    return vehicle
  end
end

function tvRP.spawnVehicle(name,plate,tuning,x,y,z,h)
  for veh in getVehicles() do
    if plate == GetVehicleNumberPlateText(veh) and DoesEntityExist(veh) then
      print(plate,": masinuta de sters!!")
      NetworkRequestControlOfEntity(veh)
      tvRP.despawnVehicle(veh)
    end
  end

  local i = 0
  while not HasModelLoaded(GetHashKey(name)) and i < 1000 do
    RequestModel(GetHashKey(name))
    Citizen.Wait(10)
    i = i+1
  end
  if HasModelLoaded(GetHashKey(name)) then
    local vehicle = CreateVehicle(GetHashKey(name), x,y,z+0.5, h, true, true)
    SetEntityInvincible(vehicle,false)
    SetVehicleNumberPlateText(vehicle, plate)
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    SetVehicleDoorsLocked(vehicle,2)
    SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), true)
    tvRP.updateVehicleDetails(plate,vehicle)
    local blip = AddBlipForEntity(vehicle)
    SetBlipSprite(blip, 326)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip,45)
    TriggerEvent("setTuning",vehicle,tuning)
    vehicles[plate] = {}
    vehicles[plate].model = name
    vehicles[plate].vehicle = vehicle
    vehicles[plate].tuning = tuning
    return vehicle
  end
end

AddEventHandler("login_stop",function()
  Wait(30000)
  Citizen.CreateThread(function()
    while true do
      Wait(0)
      if #vehicles > 0 then
        for i,v in pairs(vehicles) do
          if (not IsVehicleDriveable(v.vehicle,true)) or GetVehicleEngineHealth(v.vehicle) == -4000 then
            TriggerServerEvent("impoundVehicle",i)
            tvRP.despawnVehicle(v.vehicle)
            vehicles[i] = nil
          end
        end
      end
    end
  end)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if faction and DoesEntityExist(faction) then
      if not IsPedInVehicle(GetPlayerPed(-1),faction,false) then
        Wait(900000)
        if not IsPedInVehicle(GetPlayerPed(-1),faction,false) then
          tvRP.despawnVehicle(faction)
        end
      end
    end
  end
end)

function tvRP.unregisterVehicle(plate)
  RemoveBlip(GetBlipFromEntity(vehicles[plate].veh))
  vehicles[plate] = nil
end

function tvRP.registerVehicle(plate)
  vehicles[plate] = {}
  for veh in getVehicles() do
    print(GetVehicleNumberPlateText(veh))
    if plate == GetVehicleNumberPlateText(veh) and DoesEntityExist(veh) then
      NetworkRequestControlOfEntity(veh)
      RemoveBlip(GetBlipFromEntity(veh))
      local blip = AddBlipForEntity(veh)
      SetBlipSprite(blip, 326)
      SetBlipAsShortRange(blip, true)
      SetBlipColour(blip,45)
      vehicles[plate].vehicle = veh
    end
  end
end

function tvRP.despawnVehicleInRadius(max_range)
  local vehicle = faction
  if vehicle and DoesEntityExist(vehicle) then
    if Vdist(GetEntityCoords(vehicle),GetEntityCoords(GetPlayerPed(-1))) < max_range then
      Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true)
      SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
      Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
      tvRP.notify("Vehiculul depozitat.")
    else
      tvRP.notify("Prea departe de vehicul.")
    end
  end
end

function tvRP.despawnVehicle(vehicle)
  if vehicle and DoesEntityExist(vehicle) then
    Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true)
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
  end
end

function tvRP.despawnPersonalVehicle(plate)
  for i,v in pairs(vehicles) do
    if i == plate then
      tvRP.despawnVehicle(v.vehicle)
      vehicles[i] = nil
    end
  end
end

function tvRP.isVehicleUsed(entity)
  return IsPedInVehicle(GetPlayerPed(-1),entity,true)
end

function tvRP.getEntityCoords(entity)
  local x,y,z = table.unpack(GetEntityCoords(entity))
  local h = GetEntityHeading(entity)

  return x,y,z,h
end

function tvRP.getPlayerCoords()
  local entity = GetPlayerPed(-1)
  local x,y,z = table.unpack(GetEntityCoords(entity))
  local h = GetEntityHeading(entity)

  return x,y,z,h
end

function tvRP.getNearestVehicle(radius)
  local x,y,z = tvRP.getPosition()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end
    return veh
  end
end

function tvRP.getNearestOwnedVehicle(radius)
  local px,py,pz = tvRP.getPosition()

  for k,v in pairs(vehicles) do
    print(k)
    for veh in getVehicles() do
      print(GetVehicleNumberPlateText(veh))
      if k == GetVehicleNumberPlateText(veh) and DoesEntityExist(veh) then
        NetworkRequestControlOfEntity(veh)
        RemoveBlip(GetBlipFromEntity(veh))
        local blip = AddBlipForEntity(veh)
        SetBlipSprite(blip, 326)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip,45)
        v.vehicle = veh
        local x,y,z = table.unpack(GetEntityCoords(veh))
        print(x,y,z,px,py,pz)
        if Vdist(x,y,z,px,py,pz) <= radius+0.0001 then return true,k,veh end
      end
    end
  end

  return false,"",""
end

function tvRP.fixeNearestVehicle(radius)
  local vehicle = tvRP.getNearestVehicle(radius)
  FreezeEntityPosition(vehicle, true)
  DisableControlAction(0, 75)
  tvRP.notify("~y~Asteapta sa repari vehiculul!")
  Wait(math.random(45000,60000))
  tvRP.notify("~g~Ai reparat vehiculul!")
  if IsEntityAVehicle(vehicle) then
    SetVehicleFixed(vehicle)
    FreezeEntityPosition(vehicle, false)
    EnableControlAction(0,75,true)
  end
end

function tvRP.replaceNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleOnGroundProperly(veh)
  end
end

function tvRP.ejectVehicle()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    local veh = GetVehiclePedIsIn(ped,false)
    TaskLeaveVehicle(ped, veh, 4160)
  end
end

function tvRP.vc_openDoor(plate, door_index)
  local vehicle = vehicles[plate].vehicle
	if vehicle and DoesEntityExist(vehicle) then
    SetVehicleDoorOpen(vehicle,door_index,0,false)
  end
end

function tvRP.vc_closeDoor(plate, door_index)
  local vehicle = vehicles[plate].vehicle
	if vehicle and DoesEntityExist(vehicle) then
    SetVehicleDoorShut(vehicle,door_index)
  end
end

function tvRP.vc_toggleEngine(plate)
  local vehicle = vehicles[plate].vehicle
	if vehicle and DoesEntityExist(vehicle) then
    local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle)
    SetVehicleEngineOn(vehicle,not running,true,true)
    if running then
      SetVehicleUndriveable(vehicle,true)
    else
      SetVehicleUndriveable(vehicle,false)
    end
  end
end

function tvRP.vc_toggleLock(plate)
  local vehicle = vehicles[plate].vehicle
  local locked = "descuiata"
  
	if vehicle and DoesEntityExist(vehicle) then
		if GetVehicleDoorLockStatus(vehicle) >= 2 then
			SetVehicleDoorsLockedForAllPlayers(vehicle, false)
			SetVehicleDoorsLocked(vehicle,1)
			SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
		else
			locked = "incuiata"
			SetVehicleDoorsLocked(vehicle,2)
			SetVehicleDoorsLockedForAllPlayers(vehicle, true)
		end
		tvRP.notify("Masina este ~g~"..locked.."~w~!")
	end
end

RegisterNetEvent("setTuning")
AddEventHandler("setTuning",function(nveh,tuning)
  if type(tuning) =='string' and (tuning ~= '' or  tuning ~= ' ' or tuning ~= nil) then
    local a = string.find(tuning, ":")
    local ct = 0
    SetVehicleModKit(nveh,0)

    while tuning ~= nil do
      local b
      if a ~= nil then
        b = tuning:sub(0,a-1)
        tuning = tuning:sub(a+1)
        a = string.find(tuning, ":")
      else
        b = tuning
        tuning = nil
      end
      local u = string.find(b, ",")
      if u and ct == 0 then
        local u1 = b:sub(0,u-1)
        local u2 = b:sub(u+1)
        SetVehicleColours(nveh,tonumber(u1),tonumber(u2))
      elseif ct == 1 then
        local u1 = b:sub(0,u-1)
        local u2 = b:sub(u+1)
        SetVehicleExtraColours(nveh,tonumber(u1),tonumber(u2))
      elseif ct == 2 then
        local u1 = b:sub(0,u-1)
        local u2 = b:sub(u+1)
        local spl = string.find(u2, ",")
        local u3 = u2:sub(spl+1)
        u2 = u2:sub(0,spl-1)
        SetVehicleNeonLightsColour(nveh,tonumber(u1),tonumber(u2),tonumber(u3))
      elseif ct == 3 then
        local bl = false
        if tostring(b) == "true" then bl = true end
        SetVehicleNeonLightEnabled(nveh,0,bl)
        SetVehicleNeonLightEnabled(nveh,1,bl)
        SetVehicleNeonLightEnabled(nveh,2,bl)
        SetVehicleNeonLightEnabled(nveh,3,bl)
      elseif ct == 4 then
        local u1 = b:sub(0,u-1)
        local u2 = b:sub(u+1)
        local spl = string.find(u2, ",")
        local u3 = u2:sub(spl+1)
        u2 = u2:sub(0,spl-1)
        SetVehicleTyreSmokeColor(nveh,tonumber(u1),tonumber(u2),tonumber(u3))
      elseif ct == 5 then
        SetVehicleNumberPlateTextIndex(nveh,tonumber(b))
      elseif ct == 6 then
        SetVehicleWindowTint(nveh,tonumber(b))
      elseif ct == 7 then
        SetVehicleWheelType(nveh,tonumber(b))
      elseif ct == 8 then
        local bl = false
        if tostring(b) == "true" then bl = true end
        SetVehicleTyresCanBurst(nveh,bl)
      elseif ct == 9 then
        local c = string.find(b, ";")
        while b ~= nil do
          local d
          if c ~= nil then
            d = b:sub(0,c-1)
            b = b:sub(c+1)
            c = string.find(b, ";")
          else
            d = b
            b = nil
          end
          
          if d ~= nil then
            local u = string.find(d, ",")
            local u1 = d:sub(0,u-1)
            local u2 = d:sub(u+1)
            local spl = string.find(u2, ",")
            local u3 = u2:sub(spl+1)
            u2 = u2:sub(0,spl-1)
            local bl = false
            if tostring(u3) == "true" then bl = true end
            if tonumber(u1) == 18 or tonumber(u1) == 22  or tonumber(u1) == 20 then
              ToggleVehicleMod(nveh,tonumber(u1),bl)
              SetVehicleMod(nveh,tonumber(u1),tonumber(u2),bl)
            else
              SetVehicleMod(nveh,tonumber(u1),tonumber(u2),bl)
            end
          end
        end
      end
      ct = ct+1
    end
  end
end)
