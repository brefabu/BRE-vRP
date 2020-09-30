function round(n)
  return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function transform(n)
  if n < 1 then
    return transform(n*10)
  else
    return n
  end
end

function tvRP.updateVehicleDetails(plate,vehicle)
    Citizen.CreateThread(function()
        while true do
            Wait(5000)
            if DoesEntityExist(vehicle) and IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                local fuel = GetVehicleFuelLevel(vehicle)
                local speed = GetEntitySpeed(vehicle)*3.78

                pos1 = GetEntityCoords(vehicle)
                Wait(5000)
                pos2 = GetEntityCoords(vehicle)
                distance = Vdist(pos1,pos2)*3.78

                vRPserver.updateVehicleDetails({plate,fuel,speed,distance})
            end
            if not DoesEntityExist(vehicle) then
              break
            end
        end
    end)
end
