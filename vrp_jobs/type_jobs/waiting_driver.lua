Citizen.CreateThread(function()
    local bacsis = 0

    while true do
        Wait(0)
        for i,v in pairs(jobs) do
            if v._type == "waiting_driver" then
                for zone, coords in pairs(v._coords) do
                    local x,y,z = table.unpack(coords.get)
                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 25.0 then
                        if not IsJobActive() then
                            DrawText3D(x,y,z + 1.0, "~b~[~w~"..v._name.."~b~]")
                            DrawMarker(22,x,y,z, 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,255, 255, 255, 150, 0, 1, 0, 1, 0, 0, 0)
                            DrawMarker(6,x,y,z, 0, 0, 0, 0, 0, 0,1.001,1.001,1.001,0, 215, 255, 150, 0, 1, 0, 1, 0, 0, 0)
                            
                            if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 5.0 then
                                OnPlayerDrawText("~w~Apasa ~b~[E]~w~ pentru a te angaja aici!")
                                
                                if not IsJobActive() and IsControlJustPressed(0,51) then
                                    ClearPlayerDrawText()
                                    StartJob()
                                    OnPlayerDrawText("~w~Du-te si condu ~b~vehiculul~w~!")
                                    
                                    local x,y,z,h = table.unpack(coords.vehicles[math.random(1,#coords.vehicles)])
                                    local vehicle = spawnJobVehicle(v._vehicle.model,x,y,z,h)
                                    local blip = setBlipMission(x,y,z)

                                    while true do
                                        Wait(0)
                                        if IsJobActive() then
                                            if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                removeJobBlips()
                                                Wait(2000)
                                                ClearPlayerDrawText()
                                                break
                                            end
                                        else
                                            ClearPlayerDrawText()
                                            break
                                        end
                                    end
                                    ClearPlayerDrawText()

                                    shuffle(coords.delivery)
                                    for i,v in pairs(coords.delivery) do
                                        if IsJobActive() then
                                            shuffle(coords.restaurants)
                                            OnPlayerDrawText("~w~Asteapta sa primesti o comanda!")
                                            Wait(math.random(1000,30000))

                                            for j,k in pairs(coords.restaurants) do
                                                if IsJobActive() then
                                                    local x,y,z = table.unpack(k)
                                                    blip = setBlipMission(x,y,z)
                                                    OnPlayerDrawText("~y~Ai primit o comanda! Du-te la restaurantul "..j.." si livreaza mancarea clientului!")

                                                    while true do
                                                        Wait(0)
                                                        if IsJobActive() then
                                                            if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 2.5 then
                                                                if not IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                                    OnPlayerDrawText("~y~Asteapta sa primesti comanda...")
                                                                    Wait(2500)
                                                                    
                                                                    if IsJobActive() then
                                                                        if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 2.5 then
                                                                            removeJobBlips()
                                                                            OnPlayerDrawText("~g~Ai primit comanda!")
                                                                            Wait(2500)
                                                                            ClearPlayerDrawText()
                                                                            break
                                                                        else
                                                                            OnPlayerDrawText("~r~Nu te grabii! Du-te inapoi...")
                                                                            Wait(2500)
                                                                            ClearPlayerDrawText()
                                                                        end
                                                                    else
                                                                        break
                                                                    end
                                                                else
                                                                    OnPlayerDrawText("~w~Nu trebuie sa fii pe motor...")
                                                                    Wait(2500)
                                                                    ClearPlayerDrawText()
                                                                end
                                                            end
                                                        else
                                                            break
                                                        end
                                                    end

                                                    if IsJobActive() then
                                                        OnPlayerDrawText("~y~Du-te la client si livreaza mancarea!")
                                                        local x,y,z = table.unpack(v)
                                                        local blip = setBlipMission(x,y,z)

                                                        while true do
                                                            Wait(0)
                                                            if IsJobActive() then
                                                                if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 5.0 then
                                                                    if not IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                                        OnPlayerDrawText("~y~Asteapta sa deschida usa...")
                                                                        Wait(2500)
                                                                        if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 5.0 then
                                                                            bacsis = bacsis + math.random(10,25)
                                                                            OnPlayerDrawText("~g~Ti-ai primit bacsisul! ( + "..bacsis.." Euro )")
                                                                            Wait(2500)
                                                                            ClearPlayerDrawText()
                                                                            removeJobBlips()
                                                                            break
                                                                        else
                                                                            OnPlayerDrawText("~r~Nu te grabii! Du-te inapoi...")
                                                                            Wait(2500)
                                                                            ClearPlayerDrawText()
                                                                        end
                                                                    else
                                                                        OnPlayerDrawText("~w~Nu trebuie sa fii pe motor...")
                                                                        Wait(2500)
                                                                        ClearPlayerDrawText()
                                                                    end
                                                                end
                                                            else
                                                                break
                                                            end
                                                        end
                                                    end
                                                else
                                                    break
                                                end
                                            end
                                            if i == #coords.delivery then
                                                local x,y,z = table.unpack(coords.finish)
                                                local blip = setBlipMission(x,y,z)
                                                while true do
                                                    Wait(0)
                                                    if IsJobActive() then
                                                        if IsPlayerInRadius(x,y,z,5.0) then
                                                            if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                                OnPlayerDrawText("~g~Ai finalizat job-ul cu succes!")
                                                                Wait(2500)
                                                                ClearPlayerDrawText()
                                                                removeJobBlips()
                                                                DeleteVehicle(vehicle)
                                                                StopJob()
                                                                break
                                                            end
                                                        end
                                                    else
                                                        break
                                                    end
                                                end
                                            end
                                        else
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)    
