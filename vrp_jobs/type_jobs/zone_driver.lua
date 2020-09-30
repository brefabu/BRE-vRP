jobs["Fermier"] = function(config)
    Citizen.CreateThread(function()
        tvRP.CreateNPC("a_m_m_hasjew_01",2306.3347167969,4882.732421875,41.808261871338, -15.0)
        tvRP.addBlip(2306.3347167969,4882.732421875,41.808261871338,569,66,"Ferma")
        while true do
            Wait(0)
            if tvRP.IsPlayerInRadius(2306.3347167969,4882.732421875,41.808261871338,25.0) then
                if not tvRP.IsJobActive() then
                    DrawText3D(2306.3347167969,4882.732421875,41.808261871338 + 1.0, "~y~[~w~Ferma~y~]")
                    DrawMarker(22, 2306.3347167969,4882.732421875,41.808261871338 , 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,250, 250, 250, 150, 1, 1, 0, 1, 0, 0, 0)
                    DrawMarker(6, 2306.3347167969,4882.732421875,41.808261871338, 0, 0, 0, 0, 0, 0, 1.0001,1.0001,1.0001,250, 215, 0, 150, 1, 1, 0, 1, 0, 0, 0)

                    if tvRP.IsPlayerInRadius(2306.3347167969,4882.732421875,41.808261871338,2.5) then
                        drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a vorbi cu seful!", 255, 255, 255, 255)
                        if not tvRP.IsJobActive() and IsControlJustPressed(0,51) then
                            tvRP.StartJob()
                            local vehicle = tvRP.spawnJobVehicle("Tractor2",2307.8452148438,4887.3120117188,41.808219909668,0.0)
                            text = "~y~Du-te si condu tractorul!"
                            while true do
                                Wait(0)
                                if tvRP.IsJobActive() then
                                    if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                        text = "~g~Bravo, acum poti incepe!"
                                        Wait(2000)
                                        text = nil
                                        break
                                    end
                                else
                                    text = nil
                                    break
                                end
                            end
                            text = nil
                            local coords = {
                                {2145.5964355469,5173.2421875,55.301326751709 ,55.0},
                                {2231.064453125,5082.02734375,48.463249206543, 65.0},
                                {2032.3198242188,4877.4931640625,42.980655670166, 25.0},
                                {2005.8795166016,4903.5219726563,42.99263381958, 25.0},
                                {2044.5280761719,4943.5463867188,41.220176696777, 25.0},
                                {2071.6567382813,4918.0517578125,41.179363250732, 25.0},
                                {2300.3603515625,5129.6416015625,50.885940551758, 40.0}
                            }
                            shuffle(coords)
                            local x,y,z,r = table.unpack(coords[math.random(1,#coords)])
                            local mission = tvRP.setBlipMission(x,y,z)
                            while true do
                                Wait(0)
                                if tvRP.IsJobActive() then
                                    if tvRP.IsPlayerInRadius(x,y,z,r) then
                                        if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                            tvRP.removeJobBlips()
                                            local radius = AddBlipForRadius(x,y,z,r)
                                            SetBlipColour(radius,16)
                                            SetBlipAlpha(radius,100)
                                            local i = 1
                                            while true do
                                                Wait(1000)
                                                if tvRP.IsJobActive() then
                                                    if GetEntitySpeed(vehicle) > 5 and IsPedInVehicle(GetPlayerPed(-1),vehicle,false) and tvRP.IsPlayerInRadius(x,y,z,r+2.5) then
                                                        i = i + 1
                                                    end
                                                    timer = 8*60*1000 - i*1000
                                                    min = math.floor(timer/60000)
                                                    sec = math.ceil(math.floor(timer-min*60000)/1000)
                                                    if sec < 10 then
                                                        sec = "0"..sec
                                                    end
                                                    if min < 10 then
                                                        min = "0"..min
                                                    end
                                                    text = "~y~Ara campul...\n( "..min..":"..sec.." )"
                                                    if timer == 0 then break end
                                                else
                                                    text = nil
                                                    break
                                                end
                                            end
                                            text = "~g~Ai terminat de arat, du-te si ia-ti salariul!"
                                            RemoveBlip(radius)
                                            local blip = tvRP.setBlipMission(2306.3347167969,4882.732421875,41.808261871338)
                                            while true do
                                                Wait(0)
                                                if tvRP.IsJobActive() then
                                                    if tvRP.IsPlayerInRadius(2306.3347167969,4882.732421875,41.808261871338,5.0) then
                                                        text = nil
                                                        if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                            drawTxt(1.0, 1.0, 0.4, "~r~Da-te jos din tractor!", 255, 255, 255, 255)
                                                        else
                                                            drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a primi salariul!", 255, 255, 255, 255)
                                                        end
                                                        if not IsPedInVehicle(GetPlayerPed(-1),vehicle,false) and IsControlJustPressed(0,51) then
                                                            DeleteVehicle(vehicle)
                                                            tvRP.removeJobBlips()
                                                            text = nil
                                                            tvRP.StopJob()
                                                            TriggerServerEvent("vRP:getSalary",math.random(500,1000))
                                                            FreezeEntityPosition(GetPlayerPed(-1), false)
                                                            break
                                                        end
                                                    end
                                                else
                                                    text = nil
                                                    break
                                                end
                                            end
                                            text = nil
                                            break
                                        end
                                    end
                                else
                                    text = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
