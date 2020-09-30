Citizen.CreateThread(function()
    while true do
        Wait(0)
        if Vdist(-258.23587036133,-1618.5063476563,-153.04895019531,GetEntityCoords(GetPlayerPed(-1))) < 15.5 then
            DrawText3D(-258.23587036133,-1618.5063476563,-153.04895019531,"Fa o ~g~cerere~w~ pentru viza!")
            DrawMarker(22,-258.23587036133,-1618.5063476563,-153.04895019531, 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,250, 250, 250, 150, 1, 1, 0, 1, 0, 0, 0)
            if Vdist(-258.23587036133,-1618.5063476563,-153.04895019531,GetEntityCoords(GetPlayerPed(-1))) < 2.5 then
                help("Apasa ~r~[E]~w~ pentru a face cerere pentru viza!")
                if IsControlJustPressed(0,51) then
                    TriggerServerEvent("vRP:cerere_viza")
                end
            end
        end
    end
end)

function help(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*130
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.2*scale, 0.5*scale)
        SetTextFont(1)
        SetTextProportional(1)
    	SetTextColour( 255,255,255, 150 )
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
      World3dToScreen2d(x,y,z, 0) --Added Here
        DrawText(_x,_y)
    end
end
