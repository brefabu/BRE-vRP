local vRP = Proxy.getInterface("vRP")

RegisterNetEvent("uber:setUberPassanger")
AddEventHandler("uber:setUberPassanger",function(pickup, finish, price)
    local uber = {finish = finish, pickup = pickup}
    local x,y,z = table.unpack(uber.pickup)
    z = 0

    Citizen.CreateThread(function()
        local blip = AddBlipForCoord(x,y,z)
        SetBlipRoute(blip,true)

        while true do
            Wait(0)
            local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
            if Vdist(px,py,0,x,y,0) <= 10.0 then
                SetBlipRoute(blip,false)
                RemoveBlip(blip)

                vRP.notify({"Wait him to enter!"})

                local x,y,z = table.unpack(uber.finish)
                print(x,y,z)
                local blip = AddBlipForCoord(x,y,z)
                SetBlipRoute(blip,true)

                Citizen.CreateThread(function()
                    while true do
                        Wait(0)
                        local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                        if Vdist(px,py,0,x,y,0) <= 10.0 then
                            SetBlipRoute(blip,false)
                            RemoveBlip(blip)
                            vRP.notify({"Wow, you're done!"})

                            TriggerServerEvent("vRP:payUber",price + 10)
                            
                            break
                        end
                    end
                end)

                break
            end
        end
    end)
end)
