jobs["Fabrica de pui"] = function(config)
    Citizen.CreateThread(function()
        local x,y,z = -69.44034576416,6255.787109375,31.090127944946
        local job_blip = tvRP.addBlip(x,y,z,514,60,"Fabrica de pui")
        tvRP.CreateNPC("a_m_m_hasjew_01",-80.389190673828,6270.390625,31.379190444946, -15.0)
        tvRP.CreateNPC("csb_prolsec",-68.514213562012,6253.6103515625,31.090160369873, -15.0)
        while true do
            Wait(0)
            if tvRP.IsPlayerInRadius(x,y,z,25.0) then
                if not tvRP.IsJobActive() then
                    DrawText3D(x,y,z + 1.0, "~y~[~w~Fabrica de pui~y~]")
                    DrawMarker(22, x,y,z, 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,250, 250, 250, 150, 1, 1, 0, 1, 0, 0, 0)
                    DrawMarker(6, x,y,z, 0, 0, 0, 0, 0, 0, 1.0001,1.0001,1.0001,250, 215, 0, 150, 1, 1, 0, 1, 0, 0, 0)

                    if tvRP.IsPlayerInRadius(x,y,z,2.5) then
                        drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a vorbi cu seful de paza!", 255, 255, 255, 255)
                        if not tvRP.IsJobActive() and IsControlJustPressed(0,51) then
                            tvRP.StartJob()
                            FreezeEntityPosition(GetPlayerPed(-1), true)
                            text = "Ilie: ~g~Oooo, prietenas, ai dat si tu pe la munca?"
                            Wait(2500)
                            text = "Eu: ~b~Eh, hai ca nu am lipsit asa mult!"
                            Wait(2500)
                            text = "Ilie: ~g~Hai ca sefu' vrea sa muti niste cutii pe aici, vezi ce faci!"
                            Wait(2500)
                            text = "Eu: ~b~Pfuuu, ma apuc de treaba... Sa nu faca iara scandal!"
                            Wait(2500)
                            text = "Ilie: ~g~Hai noroc!"
                            Wait(2500)
                            FreezeEntityPosition(GetPlayerPed(-1), false)
                            text = nil
                            local coords = {
                                {-64.120475769043,6240.4946289063,31.090553283691},
                                {-64.268348693848,6235.5805664063,31.090536117554},
                                {-83.295310974121,6231.4306640625,31.091390609741},
                                {-90.963684082031,6239.98828125,31.089923858643},
                                {-92.622406005859,6236.1186523438,31.089895248413},
                                {-89.556602478027,6211.5415039063,31.061403274536},
                                {-97.280151367188,6206.00390625,31.025043487549},
                                {-108.12933349609,6195.0205078125,31.2467918396},
                                {-108.89593505859,6182.908203125,31.024932861328},
                                {-118.36085510254,6174.1313476563,31.015880584717},
                                {-136.89677429199,6155.3828125,31.206182479858}
                            }
                            local boxes = {}
                            for i,v in pairs(coords) do
                                local objectModel = GetHashKey("v_ind_cf_chckbox1")
                                Citizen.CreateThread(function()
                                    RequestModel(objectModel)
                                    local myObject = CreateObject(objectModel, v[1],v[2],v[3]-1.0, true, true, false)
                                    SetEntityInvincible(myObject, true)
                                    boxes[i] = myObject
                                end)
                            end
                            shuffle(coords)
                            for i,v in pairs(coords) do
                                if tvRP.IsJobActive() then
                                    local x,y,z = table.unpack(v)
                                    local mission = tvRP.setBlipMission(x,y,z)
                                    local started = false
                                    while true do
                                        Wait(0)
                                        if tvRP.IsJobActive() then
                                            if tvRP.IsPlayerInRadius(x,y,z,2.5) then
                                                text = "Apasa ~r~[E]~w~ pentru a ridica cutia!"
                                                box = boxes[1]
                                                for i,v in pairs(boxes) do
                                                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(v)) < Vdist(GetEntityCoords(GetPlayerPed(-1)),GetEntityCoords(box)) then
                                                        box = v
                                                    end
                                                end
                                            else
                                                text = nil
                                            end
                                            if not started and IsControlJustPressed(0,51) then
                                                tvRP.removeJobBlips()
                                                started = true
                                                while true do
                                                    Wait(0)
                                                    if tvRP.IsJobActive() then
                                                        if tvRP.IsPlayerInRadius(x,y,z,2.0) then
                                                            local mission = tvRP.setBlipMission(-154.01657104492,6142.4541015625,32.335124969482)
                                                            bone = GetPedBoneIndex(GetPlayerPed(-1), 28422)
                                                            AttachEntityToEntity(box, GetPlayerPed(-1), bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
                                                            tvRP.playAnim(true, {{"anim@heists@box_carry@", "idle", 1}}, true)
                                                            while true do
                                                                if tvRP.IsJobActive() then
                                                                    tvRP.playAnim(true, {{"anim@heists@box_carry@", "idle", 1}}, true)
                                                                    text = "~y~Du cutia in spatiul de stocare!"
                                                                    Wait(1000)
                                                                    if Vdist(GetEntityCoords(GetPlayerPed(-1)),-154.01657104492,6142.4541015625,32.335124969482) < 2.0 then
                                                                        text = "~g~Bravo, acum hai sa ambalezi cutia!"
                                                                        Wait(2000)
                                                                        tvRP.removeJobBlips()
                                                                        FreezeEntityPosition(GetPlayerPed(-1), true)
                                                                        for j=1,30 do
                                                                            text = "~y~Ambalezi cutia!\n( "..tostring(30-j).." secunde )"
                                                                            Wait(1000)
                                                                        end
                                                                        FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                        tvRP.stopAnim(false)
                                                                        DeleteEntity(box)
                                                                        break
                                                                    end
                                                                else
                                                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                    tvRP.stopAnim(false)
                                                                    DeleteEntity(box)
                                                                    break
                                                                end
                                                            end
                                                            break
                                                        end
                                                    end
                                                end
                                                text = "Du-te la urmatorea cutie!"
                                                break
                                            end
                                        else
                                            text = nil
                                            break
                                        end
                                    end
                                else
                                    text = nil
                                    break
                                end
                            end
                            text = nil
                            local blip = tvRP.setBlipMission(-80.389190673828,6270.390625,31.379190444946)
                            while true do
                                Wait(0)
                                if tvRP.IsJobActive() then
                                    if tvRP.IsPlayerInRadius(-80.389190673828,6270.390625,31.379190444946,2.0) then
                                        text = "Apasa ~r~[E]~w~ pentru a vorbi cu patronul!"
                                        if IsControlJustPressed(0,51) then
                                            tvRP.removeJobBlips()
                                            salary = math.random(3000,5000)
                                            FreezeEntityPosition(GetPlayerPed(-1), true)
                                            text = "Patron: ~r~Gata munca?"
                                            Wait(2500)
                                            text = "Eu: ~b~Da, sefule."
                                            Wait(2000)
                                            text = "Patron: ~r~Hai ia-ti banii.\n~g~ + "..salary.."$"
                                            Wait(2500)
                                            text = "Eu: ~b~Multumesc, ne vedem maine!"
                                            Wait(2000)
                                            text = "Patron: ~r~Hai salut!"
                                            Wait(1500)
                                            text = nil
                                            tvRP.StopJob()
                                            FreezeEntityPosition(GetPlayerPed(-1), false)
                                            TriggerServerEvent("vRP:getSalary",salary)
                                            break
                                        end
                                    else
                                        text = nil
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
	while true do
        Wait(0)
        if Vdist(GetEntityCoords(GetPlayerPed(-1)),-80.389190673828,6270.390625,31.379190444946) < 20.0 then
            DrawText3D(-80.389190673828,6270.390625,31.379190444946, "~t~[~w~PATRON~t~]")
        end
        if Vdist(GetEntityCoords(GetPlayerPed(-1)),-68.514213562012,6253.6103515625,31.090160369873) < 20.0 then
            DrawText3D(-68.514213562012,6253.6103515625,31.090160369873, "~t~[~w~ILIE~t~]")
        end
	end
end)