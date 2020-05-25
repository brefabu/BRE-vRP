local cars = {
  {"Diablous",-83.044479370117,6344.5493164063,31.490367889404,100},
}
----------------------------------------------------------------------------------
local once = false
----------------------------------------------------------------------------------
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    for i,v in pairs(cars) do
      if Vdist(GetEntityCoords(GetPlayerPed(-1)),v[2],v[3],v[4]) < 20.0 then
        DrawMarker(6,v[2],v[3],v[4]+0.25,0,0,0,0,0,0,1.0,1.0,1.0,30,30,30,200,1,1,0,1,0,0,0)
        DrawMarker(36,v[2],v[3],v[4]+0.25,0,0,0,0,0,0,1.0,1.0,1.0,255,255,255,200,1,1,0,1,0,0,0)
        text_overflow(v[2],v[3],v[4] + 1,"Price: "..v[5].." RON | 10 Minute")
        text_overflow(v[2],v[3],v[4] + 1.25,v[1].." | Autovit.ro")

        if Vdist(v[2],v[3],v[4], GetEntityCoords(GetPlayerPed(-1))) < 3.0 then
          SetTextComponentFormat("STRING")
          AddTextComponentString("Apasa ~INPUT_CONTEXT~ pentru a inchiria un vehicul!")
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          
          if not once and IsControlJustPressed(1, 51) then
            once = true
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
              SetNotificationTextEntry("STRING")
              AddTextComponentString("Esti deja intr-un vehicul!")
              SetNotificationMessage("CHAR_CARSITE", "CHAR_CARSITE", true, 1, "Autovit.ro | Cumpara acum!")
              DrawNotification(false, true)
            else
              TriggerServerEvent('vRP_rent: payment',v[1],v[5])
            end
          end
        end
      end
    end
  end
end)
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
RegisterNetEvent('vRP_Rent: spawncar')
AddEventHandler('vRP_Rent: spawncar', function(model)
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey(model)

  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end

  local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
  local spawned_car = CreateVehicle(vehicle, coords, GetEntityHeading(myPed), true, false)

  SetVehicleOnGroundProperly(spawned_car)
  SetVehicleNumberPlateText(spawned_car, "RENT")
  SetModelAsNoLongerNeeded(vehicle)
  SetPedIntoVehicle(myPed,spawned_car,-1)

  Citizen.Wait(10*60*1000)
  if DoesEntityExist(spawned_car) then
    DeleteVehicle(spawned_car)
    once = false
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString(  "Timpul inchiriat s-a terminat!" )
    DrawNotification( false, false )
  end
end)

function text_overflow(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*130
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.2*scale, 0.5*scale)
        SetTextFont(6)
        SetTextProportional(1)
    SetTextColour( 255, 255, 255, 255 )
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        World3dToScreen2d(x,y,z, 0)
        DrawText(_x,_y)
    end
end