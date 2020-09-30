jobs["Taietor de lemne"] = function(config)
    Citizen.CreateThread(function()
        tvRP.CreateNPC("cs_floyd",-584.20379638672,5358.7504882813,70.234245300293, -15.0)
        tvRP.addBlip(-582.89849853516,5359.7685546875,70.241989135742,501,17,"Fabrica de cherestea")
        while true do
            Wait(0)
            if tvRP.IsPlayerInRadius(-582.89849853516,5359.7685546875,70.241989135742,25.0) then
                if not tvRP.IsJobActive() then
                    DrawText3D(-582.89849853516,5359.7685546875,70.241989135742 + 1.0, "~r~[~w~Fabrica de cherestea~r~]")
                    DrawMarker(22, -582.89849853516,5359.7685546875,70.241989135742 , 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,250, 250, 250, 150, 1, 1, 0, 1, 0, 0, 0)
                    DrawMarker(6, -582.89849853516,5359.7685546875,70.241989135742 , 0, 0, 0, 0, 0, 0, 1.0001,1.0001,1.0001,250, 0, 0, 150, 1, 1, 0, 1, 0, 0, 0)
                    
                    if tvRP.IsPlayerInRadius(-582.89849853516,5359.7685546875,70.241989135742,5.0) then
                        drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a vorbi cu seful de echipa!", 255, 255, 255, 255)
                        if not tvRP.IsJobActive() and IsControlJustPressed(0,51) then
                            tvRP.StartJob()
                            FreezeEntityPosition(GetPlayerPed(-1), true)
                            text = "George: ~r~Nu mai veneai?"
                            Wait(2500)
                            text = "Eu: ~b~Umm, trebuia?"
                            Wait(2500)
                            text = "George: ~r~Hai la treaba, du-te si prelucreaza niste lemn..."
                            Wait(2500)
                            text = "Eu: ~b~Dar nu am echipamentul."
                            Wait(2500)
                            text = "George: ~r~Crezi ca imi pasa? HAI ODATA..."
                            Wait(2500)
                            FreezeEntityPosition(GetPlayerPed(-1), false)
                            text = nil
                            local coords = {
                                {-531.88909912109,5373.5268554688,70.399124145508},
                                {-554.83282470703,5370.4658203125,70.280197143555},
                                {-494.5419921875,5295.63671875,80.610122680664},
                                {-489.84268188477,5298.0126953125,80.610038757324},
                                {-492.66644287109,5299.458984375,80.610038757324},
                                {-474.88195800781,5318.2124023438,80.61011505127}
                            }
                            shuffle(coords)
                            local blips = {}
                            for i,v in pairs(coords) do
                                local x,y,z = table.unpack(v)
                                local mission = tvRP.setBlipMission(x,y,z)
                                local started = false
                                while true do
                                    Wait(0)
                                    if tvRP.IsPlayerInRadius(x,y,z,5.0) then
                                        if tvRP.IsJobActive() then
                                            drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a incepe prelucrarea!", 255, 255, 255, 255)
                                        else
                                            text = nil
                                            break
                                        end
                                        if not started and IsControlJustPressed(0,51) then
                                            started = true
                                            FreezeEntityPosition(GetPlayerPed(-1), true)
                                            for sec=1,60 do
                                                if tvRP.IsJobActive() then
                                                    if tvRP.IsPlayerInRadius(x,y,z,5.0) then
                                                        text = "~y~Asteapta sa prelucrezi tot lemnul!\n( "..tostring(60-sec).." secunde )"
                                                        Wait(1000)
                                                    else
                                                        tvRP.StopJob()
                                                        started = false
                                                        break
                                                    end
                                                else
                                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                                    text = nil
                                                    break
                                                end
                                            end
                                            tvRP.removeJobBlips()
                                            FreezeEntityPosition(GetPlayerPed(-1), false)
                                            text = "Du-te la urmatorea serie de busteni!"
                                            break
                                        end
                                    end
                                end
                            end
                            text = "Du-te la ~g~George~w~ sa iti dea altceva de facut!"
                            local started2 = false
                            while true do
                                Wait(0)
                                if tvRP.IsJobActive() then
                                    if tvRP.IsPlayerInRadius(-582.89849853516,5359.7685546875,70.241989135742,5.0) then
                                        text = nil
                                        drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a vorbi cu seful de echipa!", 255, 255, 255, 255)
                                        if not started2 and IsControlJustPressed(0,51) then
                                            if tvRP.IsJobActive() then
                                                started2 = true
                                                text = "George: ~r~Wow, ai reusit sa termini?"
                                                Wait(2500)
                                                text = "Eu: ~b~Da."
                                                Wait(2000)
                                                text = "George: ~r~Ma mir..."
                                                Wait(2500)
                                                text = "Eu: ~b~Pot sa..."
                                                Wait(1000)
                                                text = "George: ~r~HAAAI SI SLEFUIESTE LEMNUL."
                                                Wait(2500)
                                                text = "Eu: ~b~Ma mor.."
                                                Wait(1000)
                                                text = "George: ~r~Ai zis ceva?"
                                                Wait(2500)
                                                text = "Eu: ~b~Nu,sefule!\n( MORTII TAI DE HANDICAPAT!! )"
                                                Wait(2000)
                                                text = nil
                                                local started = false
                                                local blip = tvRP.setBlipMission(-552.26831054688,5328.0712890625,73.639198303223)
                                                while true do
                                                    Wait(0)
                                                    if tvRP.IsJobActive() then
                                                        if tvRP.IsPlayerInRadius(-552.26831054688,5328.0712890625,73.639198303223,5.0) then
                                                            drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a incepe slefuirea!", 255, 255, 255, 255)
                                                            if not started and IsControlJustPressed(0,51) then
                                                                tvRP.removeJobBlips()
                                                                started = true
                                                                FreezeEntityPosition(GetPlayerPed(-1), true)
                                                                for sec=1,60 do
                                                                    if tvRP.IsJobActive() then
                                                                        if tvRP.IsPlayerInRadius(-552.26831054688,5328.0712890625,73.639198303223,5.0) then
                                                                            text = "~y~Asteapta sa slefuiesti tot lemnul!\n( "..tostring(60-sec).." secunde )"
                                                                            Wait(1000)
                                                                        else
                                                                            FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                            started = false
                                                                            break
                                                                        end
                                                                    else
                                                                        break
                                                                    end
                                                                end
                                                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                text = "Du-te la ~g~George~w~ sa te plateasca pentru ce ai muncit azi!"
                                                                break
                                                            end
                                                        end
                                                    else
                                                        FreezeEntityPosition(GetPlayerPed(-1), false)
                                                        text = nil
                                                        break
                                                    end
                                                end
                                                while true do
                                                    Wait(0)
                                                    if tvRP.IsJobActive() then
                                                        if tvRP.IsPlayerInRadius(-582.89849853516,5359.7685546875,70.241989135742,5.0) then
                                                            drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a vorbi cu seful de echipa!", 255, 255, 255, 255)
                                                            if IsControlJustPressed(0,51) then
                                                                if tvRP.IsJobActive() then
                                                                    local salary = math.random(2500,4000)
                                                                    FreezeEntityPosition(GetPlayerPed(-1), true)
                                                                    text = "George: ~r~Gata munca?"
                                                                    Wait(2500)
                                                                    text = "Eu: ~b~Da, sefule."
                                                                    Wait(2000)
                                                                    text = "George: ~r~Hai ia-ti banii.\n~g~ + "..salary.."$"
                                                                    Wait(2500)
                                                                    text = "Eu: ~b~Multumesc, ne vedem maine!"
                                                                    Wait(2000)
                                                                    text = "George: ~r~Hai salut!"
                                                                    Wait(1500)
                                                                    text = nil
                                                                    tvRP.StopJob()
                                                                    TriggerServerEvent("vRP:getSalary",salary)
                                                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                    break
                                                                else
                                                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                                                    text = nil
                                                                    break
                                                                end
                                                            end
                                                        end
                                                        
                                                    else
                                                        FreezeEntityPosition(GetPlayerPed(-1), false)
                                                        text = nil
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                else
                                    FreezeEntityPosition(GetPlayerPed(-1), false)
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

Citizen.CreateThread(function()
	while true do
        Wait(0)
        if Vdist(GetEntityCoords(GetPlayerPed(-1)),-584.20379638672,5358.7504882813,70.234245300293) < 20.0 then
            DrawText3D(-584.20379638672,5358.7504882813,70.234245300293, "~t~[~w~GEORGE~t~]")
        end
	end
end)