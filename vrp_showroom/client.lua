vRP = Proxy.getInterface("vRP")

local vehs = {}

RegisterNetEvent("showroom:get_vehicles")
AddEventHandler("showroom:get_vehicles",function(vehicles)
  vehs = {}
  for i,v in pairs(vehicles) do
      table.insert(vehs,{v[1],v[2],i})
  end

  table.sort(vehs,function(a,b) return a[1] < b[1] end)

  for i,v in pairs(vehs) do
    SendNUIMessage({vehicle = i,name = v[1],price = v[2]})
  end
  SetNuiFocus(true,true)
  SendNUIMessage({showroom = true})
end)

local opened = false

Citizen.CreateThread(function()
  local ped3 = vRP.CreateNPC({"a_m_y_business_02",124.90341949463,6411.9487304688,31.322937011719, 0.0})
  local ped2 = vRP.CreateNPC({"a_m_y_business_02",1728.0665283203,3709.7019042969,34.230560302734, 0.0})
  local ped1 = vRP.CreateNPC({"a_m_y_business_02",-31.28026008606,-1106.9884033203,26.422353744507, 0.0})
  
  local showrooms = {{126.38246154785,6413.2719726563,31.32227897644},{1728.736328125,3711.2507324218,34.233856201172},{-29.611316680908,-1104.5124511718,26.422355651856}}
  FreezeEntityPosition(GetPlayerPed(-1),false)
  SetNuiFocus( false, false )
  while true do
    if Vdist(GetEntityCoords(GetPlayerPed(-1)),124.90341949463,6411.9487304688,31.322937011719) < 2.5 or Vdist(GetEntityCoords(GetPlayerPed(-1)),1728.0665283203,3709.7019042969,34.230560302734) < 2.5 or Vdist(GetEntityCoords(GetPlayerPed(-1)),-29.858381271362,-1104.5050048828,26.422342300415) < 2.5 then
      DisplayHelpText("~g~Apasa ~INPUT_PICKUP~ pentru a vedea masinile.")
      if not opened and IsControlJustPressed(1, 38) then
        TriggerServerEvent("showroom:get_vehicles")
        opened = true
      end
    end

    for i,v in pairs(showrooms) do
      
    end
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  local blip = AddBlipForCoord(-31.28026008606,-1106.9884033203,26.422353744507)
  SetBlipSprite(blip, 524)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 45)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(tostring("Showroom"))
  EndTextCommandSetBlipName(blip)
end)
  
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(1728.0665283203,3709.7019042969,34.230560302734)
  SetBlipSprite(blip, 524)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 45)
  BeginTextCommandSetBlipName("STRING");
  AddTextComponentString(tostring("Showroom"))
  EndTextCommandSetBlipName(blip)
end)
  
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(124.90341949463,6411.9487304688,31.322937011719)
  SetBlipSprite(blip, 524)
  SetBlipAsShortRange(blip, true)
  SetBlipColour(blip, 45)
  BeginTextCommandSetBlipName("STRING");
  AddTextComponentString(tostring("Showroom"))
  EndTextCommandSetBlipName(blip)
end)

function drawTxt(width,height,scale, text, r,g,b,a, outline)
  SetTextFont(0)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  if(outline)then
    SetTextOutline()
end
  SetTextEntry("STRING")
  AddTextComponentString(text)
  SetTextWrap(0.0,1.0)
  SetTextCentre(true)
  DrawText(1.0 - width/2, 1.0-0.075)
end

RegisterNUICallback('view', function(data, cb)
  SetNuiFocus( false, false )
  SendNUIMessage({showroom = false})
  opened = false

  for i,v in pairs(vehs) do
    if v[1] == data.vehicle then
      TriggerEvent('showroom:view',v[3])
    end
  end
  cb('ok')
end)

RegisterNUICallback('buy', function(data, cb)
  if opened then
    SetNuiFocus( false, false )
    SendNUIMessage({showroom = false})
    opened = false
    for i,v in pairs(vehs) do
      if v[1] == data.vehicle then
        TriggerServerEvent('showroom:buy',v[3], v[2])
        break
      end
    end
  end

  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  SetNuiFocus( false, false )
  SendNUIMessage({showroom = false})
  opened = false
  cb('ok')
end)

RegisterNetEvent("showroom:close")
AddEventHandler("showroom:close", function()
  SetNuiFocus( false, false )
  SendNUIMessage({showroom = false})
  opened = false
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNetEvent('showroom:view')
AddEventHandler('showroom:view',function(model)
  Citizen.CreateThread(function()
    local history = GetEntityCoords(GetPlayerPed(-1))
    vRP.notify({"Asteapta ca vehiculul sa se incarce pentru a-l vizualiza!"})
      RequestModel( GetHashKey(model) )
      local i = 0
      local loaded = true
      while ( not HasModelLoaded( GetHashKey(model) ) ) do
          Citizen.Wait( 1 )
          i = i+1
          if i == 5000 then
              loaded = false
              vRP.notify({"Vehiculul nu s-a incarcat..."})
              break
          end
      end
      if HasModelLoaded( GetHashKey(model)) then
        local vehicle = CreateVehicle(GetHashKey(model), 195.30084228516,-1003.3665771484,-99.99, 0.0, false, false)
        SetEntityInvincible(vehicle,true)
        SetVehicleNumberPlateText(vehicle, "SHOWROOM")
        SetVehicleHasBeenOwnedByPlayer(vehicle,true)
        SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
        FreezeEntityPosition(vehicle,true)
        TriggerEvent("rotateVehicle",vehicle)
        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(cam, 199.58831787109,-998.79364013672,-98.5)
        DisplayRadar(false)
        SetCamRot(cam, 0.0, 0.0, 120.0, 0)
        RenderScriptCams(1, 1, 0, 1, 1)
        SetEntityInvincible(GetPlayerPed(-1), true)
        FreezeEntityPosition(GetPlayerPed(-1),true)
        SetEntityVisible(GetPlayerPed(-1), false, false)
        while true do
            Wait(0)
            drawTxt(1.0, 1.0, 0.4, "~w~Apasa ~r~[E] ~w~inchide vizualizarea.", 255, 255, 255, 255)
            if IsControlJustPressed(0,51) then
              local playerPed = GetPlayerPed(-1)
              local coords = GetEntityCoords(GetPlayerPed(-1))
              local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
              DoScreenFadeIn(800) --- Fade In Showing the Screen
              FreezeEntityPosition(playerPed, false) -- unfreeze
              DestroyCam(createdCamera, 0)
              DestroyCam(createdCamera, 0)
              RenderScriptCams(0, 0, 1000, 1, 1)
              createdCamera = 0
              ClearTimecycleModifier("scanline_cam_cheap")
              DeleteVehicle(vehicle)
              SetFocusEntity(GetPlayerPed(PlayerId()))
              SetEntityVisible(GetPlayerPed(-1), true, true)
              DisplayRadar(true)
              local showrooms = {{126.38246154785,6413.2719726563,31.32227897644},{1728.736328125,3711.2507324218,34.233856201172},{-29.611316680908,-1104.5124511718,26.422355651856}}

              local closest = showrooms[1]
              
              for i,v in pairs(showrooms) do
                if Vdist(history,table.unpack(v)) < Vdist(history,table.unpack(closest)) then
                  closest = v
                end
              end
              local x,y,z = table.unpack(closest)
              SetEntityCoordsNoOffset(GetPlayerPed(-1),x,y,z,0,0,0)
              break
            end
        end
      end
  end)
end)

RegisterNetEvent("rotateVehicle")
AddEventHandler("rotateVehicle",function(vehicle)
    while true do
        Wait(10)
        if vehicle and DoesEntityExist(vehicle) then
            SetEntityHeading(vehicle, GetEntityHeading(vehicle) + 0.5)
        else
          break
        end
    end
end)
