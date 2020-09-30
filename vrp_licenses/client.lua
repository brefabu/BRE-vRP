local route = {
    {-424.44625854492,6037.7685546875,31.37103843689},
    {-425.28897094727,5954.046875,31.149339675903},
    {-486.62963867188,5870.9731445313,32.966281890869},
    {-540.95336914063,5768.9267578125,35.244724273682},
    {-681.81115722656,5556.9370117188,37.675792694092},
    {-757.443359375,5509.3784179688,34.744205474854},
    {-783.00964355469,5524.33203125,33.672794342041},
    {-772.73071289063,5656.5737304688,23.233882904053},
    {-738.68713378906,5746.9990234375,18.430835723877},
    {-677.52996826172,5908.73828125,15.835531234741},
    {-652.79797363281,6028.4243164063,8.3377866744995},
    {-601.01525878906,6082.8696289063,8.092077255249},
    {-548.30731201172,6050.9643554688,21.11254119873},
    {-485.54486083984,6063.6391601563,28.697546005249},
    {-451.01000976563,6071.3549804688,30.785507202148},
    {-430.32769775391,6058.7163085938,30.852743148804},
    {-394.14761352539,6017.6196289063,30.775617599487},
    {-369.51913452148,6005.9487304688,30.726446151733},
    {-334.06402587891,6034.466796875,30.552949905396},
    {-252.20539855957,6116.51171875,30.605497360229},
    {-211.2960357666,6157.0708007813,30.636690139771},
    {-177.91630554199,6189.423828125,30.603008270264},
    {-132.46017456055,6235.8237304688,30.580768585205},
    {-110.84633636475,6266.8374023438,30.576066970825},
    {-105.88233184814,6294.298828125,30.714469909668},
    {-160.97996520996,6349.9638671875,30.876804351807},
    {-161.80731201172,6369.1640625,30.863399505615},
    {-118.37735748291,6409.2426757813,30.779773712158},
    {-121.73872375488,6431.8989257813,30.897504806519},
    {-161.31005859375,6472.8276367188,29.869861602783},
    {-186.36599731445,6466.3940429688,29.967931747437},
    {-251.61521911621,6398.1303710938,30.435808181763},
    {-352.60589599609,6320.3076171875,29.331029891968},
    {-414.16430664063,6241.458984375,30.379173278809},
    {-399.3879699707,6178.8984375,31.039936065674},
    {-392.92114257813,6147.7631835938,30.978515625},
    {-433.62860107422,6096.3129882813,30.985980987549},
    {-439.48937988281,6065.0161132813,30.74808883667},
    {-439.15518188477,6040.3291015625,30.724306106567},
    {-455.99157714844,6001.861328125,30.729438781738}
}

local errs = {actual = 0,max = 3}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	local blip = AddBlipForCoord(-440.09594726563,6004.5942382813,31.716424942017)
	SetBlipSprite(blip,408)
	SetBlipColour(blip,11)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Test Auto')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	local npc = CreateNPC("S_M_M_Marine_01",-440.09594726563,6004.5942382813,31.716424942017,70.0)
	while true do
		Citizen.Wait(0)
		if Vdist(-440.09594726563,6004.5942382813,31.716424942017,GetEntityCoords(GetPlayerPed(-1))) < 5.0 then
			Draw3DText(-440.09594726563,6004.5942382813,31.716424942017+0.53, "~g~[ ~w~Instructor AUTO ~g~]\n~g~[ ~w~Marcel ~g~]", 0.05, 0.05)
			Draw3DText(-442.2326965332,6006.5610351563,31.716440200806+0.53, "~g~[ ~w~Examen AUTO ~g~]", 0.05, 0.05)
			Draw3DText(-442.2326965332,6006.5610351563,31.716440200806+0.43, "~g~[ ~w~Buna ziua , doriti sa sustineti examenul auto? ~g~]", 0.05, 0.05)
			DrawMarker(36,-442.2326965332,6006.5610351563,31.716440200806,0, 0, 0, 0, 0, 0, 1.001,1.001,1.001,255,255,255,200,0,0,0,true)
		end
		if Vdist(-440.09594726563,6004.5942382813,31.716424942017,GetEntityCoords(GetPlayerPed(-1))) < 2.75 then
			help("Apasa pe ~g~[E] ~w~pentru a da examenul AUTO!")
			if IsControlJustReleased(1, 38) then
				openGui()
			end
		end
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

RegisterNUICallback('notify', function(data, cb)
	notify(data.text)
  	cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
	closeGui()
	if not data.failed then
		errs.actual = 0
		RequestModel(GetHashKey(data.vehicle))
		while not HasModelLoaded(GetHashKey(data.vehicle)) do
			Wait(1)
		end
		plate = math.random(100, 900)
		local vehicle = CreateVehicle(GetHashKey(data.vehicle), -471.84915161133,6019.1640625,31.340538024902,60.0, true, false)
		SetVehicleColours(vehicle,4,5)
		SetEntityHeading(vehicle, 317.64)
		SetVehicleOnGroundProperly(vehicle)
		SetPedIntoVehicle(GetPlayerPed(-1), vehicle, - 1)
		SetModelAsNoLongerNeeded(GetHashKey(data.vehicle))
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(vehicle))
		CruiseControl = 0
		DTutOpen = false
		SetEntityVisible(GetPlayerPed(-1), true)
		SetVehicleDoorsLocked(vehicle, 4)
		FreezeEntityPosition(GetPlayerPed(-1), false)
		for i,v in pairs(route) do
			local blip = AddBlipForCoord(v[1],v[2],v[3])
			SetBlipRoute(blip,true)
			while true do
				Wait(0)
				if Vdist(GetEntityCoords(GetPlayerPed(-1)),v[1],v[2],v[3]) < 10.0 then
					SetBlipRoute(false)
					RemoveBlip(blip)
					break
				end
				if health ~= GetEntityHealth(vehicle) then
					errs.actual = errs.actual + 1
				end
				health = GetEntityHealth(vehicle)
			end
			if i == #route then
				if vehicle and DoesEntityExist(vehicle) then
				  Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true)
				  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
				  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
				end
				notify("Ai reusit sa obtii permisul, bravo!")
				TriggerServerEvent("examen:permis",data.type)
			end
			if errs.actual == errs.max then
				if vehicle and DoesEntityExist(vehicle) then
				  Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle, false, true)
				  SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle))
				  Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
				end
				notify("Ai facut prea multe erori, ai picat!")
				break
			end
		end
	end
  	cb('ok')
end)

function openGui()
	local active = true
  SetNuiFocus(active,active)
  SendNUIMessage({open = active})
  DisableControlAction(0, 1, active)
  DisableControlAction(0, 2, active)
  DisablePlayerFiring(GetPlayerPed(-1), active)
  DisableControlAction(0, 142, active)
  DisableControlAction(0, 106, active)
end

function closeGui()
  local active = false
  SetNuiFocus(active,active)
  SendNUIMessage({open = active})
  DisableControlAction(0, 1, active)
  DisableControlAction(0, 2, active)
  DisablePlayerFiring(GetPlayerPed(-1), active)
  DisableControlAction(0, 142, active)
  DisableControlAction(0, 106, active)
end

function help(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function notify(msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(true, false)
end

function drawTxt(width,height,scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if(outline)then
	  SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	SetTextWrap(0.0,1.0)
	SetTextCentre(true)
	DrawText(1.0 - width/2, 1.0-0.125)
end

function Draw3DText(x,y,z, text) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*1.0
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(1)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
