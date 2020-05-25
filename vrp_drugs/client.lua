local vRP = Proxy.getInterface("vRP")

--TP
local interiors = {
    {{-428.26931762695,6162.6806640625,31.478212356567},{1088.6359863281,-3187.4694824219,-38.993480682373}},
    {{-354.5625,6066.5151367188,31.498605728149},{1066.3956298828,-3183.3798828125,-39.163772583008}},
}

local prafuri = {
    {1090.1872558594,-3194.8247070313,-38.993480682373},
    {1092.7683105469,-3194.8334960938,-38.993480682373},
    {1095.2348632813,-3194.8208007813,-38.993480682373},
    {1095.6242675781,-3196.6506347656,-38.993465423584},
    {1092.9930419922,-3196.66796875,-38.993465423584},
    {1090.5682373047,-3196.6076660156,-38.993465423584}
}

local ierburi = {
    {1057.42578125,-3196.7351074219,-39.161304473877},
    {1057.1529541016,-3190.2502441406,-39.127742767334},
    {1051.1341552734,-3201.9731445313,-39.134822845459},
    {1060.607421875,-3203.1889648438,-39.1611328125}
}

Citizen.CreateThread(function()
    FreezeEntityPosition(GetPlayerPed(-1), false)
    while true do
        Wait(0)
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

        for i,v in pairs(prafuri) do
            if Vdist(x,y,z,table.unpack(v)) < 15.0 then
                DrawText3D(v[1],v[2],v[3]+0.53, "~g~[ ~w~Slot "..i.." ~g~]")
                DrawMarker(2,v[1],v[2],v[3],0, 0, 0, 0, 0, 0, 0.25001,0.25001,0.25001,255,255,255,200,0,0,0,true)
                if Vdist(x,y,z,table.unpack(v)) < 1.0 then
                    DrawText3D(x,y,z, "Apasa ~g~[E] ~w~pentru a incepe sa prelucrezi!")
                    if IsControlJustPressed(0, 54) then
                        TriggerServerEvent("vRP:prelucruPrafuri")
                    end
                end
            end
        end

        for i,v in pairs(ierburi) do
            if Vdist(x,y,z,table.unpack(v)) < 15.0 then
                DrawText3D(v[1],v[2],v[3]+0.53, "~g~[ ~w~Slot "..i.." ~g~]")
                DrawMarker(2,v[1],v[2],v[3],0, 0, 0, 0, 0, 0, 0.25001,0.25001,0.25001,255,255,255,200,0,0,0,true)
                if Vdist(x,y,z,table.unpack(v)) < 1.0 then
                    DrawText3D(x,y,z, "Apasa ~g~[E] ~w~pentru a incepe sa prelucrezi!")
                    if IsControlJustPressed(0, 54) then
                        TriggerServerEvent("vRP:prelucruIerburi")
                    end
                end
            end
        end

        for i,v in pairs(interiors) do
            if Vdist(x,y,z,table.unpack(v[1])) < 15.0 then
                DrawText3D(v[1][1],v[1][2],v[1][3]+0.53, "~g~[ ~w~Laborator ~g~]\n~g~[ ~w~Intrare ~g~]")
                DrawMarker(2,v[1][1],v[1][2],v[1][3],0, 0, 0, 0, 0, 0, 1.001,1.001,1.001,255,255,255,200,0,0,0,true)
                if Vdist(x,y,z,table.unpack(v[1])) < 2.5 then
                    DrawText3D(x,y,z, "Apasa ~g~[E] ~w~pentru a intra!")
                    if IsControlJustPressed(0, 54) then
                        vRP.teleport({v[2][1],v[2][2],v[2][3]})
                    end
                end
            end
            if Vdist(x,y,z,table.unpack(v[2])) < 15.0 then
                DrawText3D(v[2][1],v[2][2],v[2][3]+0.53, "~g~[ ~w~Laborator ~g~]\n~g~[ ~w~Iesire ~g~]")
                DrawMarker(2,v[2][1],v[2][2],v[2][3],0, 0, 0, 0, 0, 0, 1.001,1.001,1.001,255,255,255,200,0,0,0,true)
                if Vdist(x,y,z,table.unpack(v[2])) < 2.5 then
                    DrawText3D(x,y,z, "Apasa ~g~[E] ~w~pentru a iesi!")
                    if IsControlJustPressed(0, 54) then
                        vRP.teleport({v[1][1],v[1][2],v[1][3]})
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("vRP:processDrugs")
AddEventHandler("vRP:processDrugs", function(boolean)
    SetEntityInvincible(GetPlayerPed(-1), boolean)
    NetworkSetFriendlyFireOption((not boolean))
    FreezeEntityPosition(GetPlayerPed(-1), boolean)
end)

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
		SetTextColour( 255,255,255, 255 )
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
