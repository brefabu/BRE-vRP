Citizen.CreateThread(function()
	local npc = CreateNPC("S_M_M_Marine_01",-449.0885925293,6007.1860351563,36.509620666504,70.0)
	while true do
        if Vdist(GetEntityCoords(GetPlayerPed(-1)),-446.55722045898,6008.5981445313,36.50707244873) < 5.0 then
			DrawText3D(-449.0885925293,6007.1860351563,36.509620666504+0.53, "~g~[ ~w~Asigurator AUTO ~g~]\n~g~[ ~w~Alex ~g~]", 0.05, 0.05)
			DrawText3D(-446.55722045898,6008.5981445313,36.50707244873+0.53, "~g~[ ~w~Asigurari ~g~]", 0.05, 0.05)
			DrawText3D(-446.55722045898,6008.5981445313,36.50707244873+0.43, "~g~[ ~w~Buna ziua , doriti sa cumparati asigurare ? ~g~]", 0.05, 0.05)
			DrawMarker(36,-446.55722045898,6008.5981445313,36.50707244873,0, 0, 0, 0, 0, 0, 1.001,1.001,1.001,255,255,255,200,0,0,0,true)
		end
        Citizen.Wait(0)
    end
end)  

function CreateNPC(hash,x,y,z,h)
	RequestModel(hash)
	while not HasModelLoaded(hash) do Citizen.Wait( 1 ) end
  
	local npc = CreatePed(4,hash,x,y,z-1,h, false, true)
	SetModelAsNoLongerNeeded()
	SetEntityHeading(npc, h)
	FreezeEntityPosition(npc, true)
	SetEntityInvincible(npc, true)
	SetBlockingOfNonTemporaryEvents(npc, true)
  
	return npc
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
