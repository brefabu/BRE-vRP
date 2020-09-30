Citizen.CreateThread(function()
    while true do
        Wait(0)
        for i,v in pairs(jobs) do
            if v._type == "iteration_driver" then
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
                                                        
                                    if IsJobActive() then
                                        for a,b in pairs(coords.route) do
                                            local x,y,z = table.unpack(b)
                                            local mission = setBlipMission(x,y,z)
                                            local created = false

                                            while true do
                                                Wait(0)
                                                if IsJobActive() then
                                                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 25.0 then
                                                        DrawMarker(1,x,y,z-1.0, 0, 0, 0, 0, 0, 0, 2.0001,2.0001,2.0001,100, 215, 100, 150, 0, 1, 0, 1, 0, 0, 0)
                                                        if v._carrybox then
                                                            if IsJobActive() then
                                                                if not IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                                    vRP.playAnim({true, {{"anim@heists@box_carry@", "idle", 1}}, true})
                                                                    
                                                                    if not created then
                                                                        objectModel = GetHashKey("v_ind_cf_chckbox1")
                                                                        local pos = GetEntityCoords(GetPlayerPed(-1), true)
                                                                        bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
                                                                        Citizen.CreateThread(function()
                                                                            RequestModel(objectModel)
                                                                            myObject = CreateObject(objectModel, pos.x, pos.y, pos.z, true, true, false)
                                                                            AttachEntityToEntity(myObject, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                                        end)
                                                                        created = true
                                                                    end

                                                                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 2.6 then
                                                                        OnPlayerDrawText(v._texts.wait)
                                                                        Wait(2500)
                                                                        if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 2.6 then
                                                                            OnPlayerDrawText(v._texts.next)
                                                                            Wait(2500)
                                                                            removeJobBlips()
                                                                            vRP.stopAnim({false})
                                                                            DeleteEntity(myObject)
                                                                            ClearPlayerDrawText()
                                                                            break
                                                                        else
                                                                            OnPlayerDrawText(v._texts.miss)
                                                                            Wait(2500)
                                                                            ClearPlayerDrawText()
                                                                        end
                                                                    end
                                                                end
                                                            else
                                                                break
                                                            end
                                                        else
                                                            if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 10.0 then
                                                                if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                                    OnPlayerDrawText(v._texts.wait)
                                                                    Wait(2500)
                                                                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 5.0 then
                                                                        OnPlayerDrawText(v._texts.next)
                                                                        Wait(2500)
                                                                        removeJobBlips()
                                                                        ClearPlayerDrawText()
                                                                        break
                                                                    else
                                                                        OnPlayerDrawText(v._texts.miss)
                                                                        Wait(2500)
                                                                        ClearPlayerDrawText()
                                                                    end
                                                                else
                                                                    OnPlayerDrawText("~r~Ai esuat!")
                                                                    removeJobBlips()
                                                                    DeleteVehicle(vehicle)
                                                                    StopJob()

                                                                    Wait(1000)
                                                                    ClearPlayerDrawText()
                                                                    break
                                                                end
                                                            end
                                                        end
                                                    end
                                                else
                                                    text = nil
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    if IsJobActive() then
                                        local x,y,z = table.unpack(coords.finish)
                                        local finish = setBlipMission(x,y,z)
                                        while true do
                                            Wait(0)
                                            if Vdist(GetEntityCoords(GetPlayerPed(-1)),x,y,z) < 5.0 then
                                                if IsPedInVehicle(GetPlayerPed(-1),vehicle,false) then
                                                    OnPlayerDrawText("~g~Ai finalizat job-ul cu succes!")
                                                    RemoveBlip(finish)
                                                    DeleteVehicle(vehicle)
                                                    StopJob()

                                                    Wait(1000)
                                                    ClearPlayerDrawText()
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
        end
    end
end)
