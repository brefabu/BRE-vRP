
local noclip = false
local noclip_speed = 5.0

function tvRP.toggleNoclip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- set
    SetEntityInvincible(ped, true)
    SetEntityVisible(ped, false, false)
  else -- unset
    SetEntityInvincible(ped, false)
    SetEntityVisible(ped, true, false)
  end
end

function tvRP.isNoclip()
  return noclip
end

RegisterNetEvent("vRP:requestSpectate")
AddEventHandler('vRP:requestSpectate', function(playerId)
	local playerId = GetPlayerFromServerId(playerId)
	spectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
end)

function spectatePlayer(targetPed,target,name)
	local playerPed = PlayerPedId() -- yourself
	if targetPed == playerPed then enable = false end

	local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	RequestCollisionAtCoord(targetx,targety,targetz)
	NetworkSetInSpectatorMode(true, targetPed)
	ShowNotification("Supraveghezi pe cineva!")

	Citizen.CreateThread(function()
		while true do
			Wait(0)
			drawTxt(1.0, 1.0, 0.4, "Apasa ~r~[E]~w~ pentru a opri supravegherea!", 255, 255, 255, 255)
			if IsControlJustPressed(0,51) then
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
				ShowNotification("Nu mai supraveghezi pe nimeni!")
				break
			end
		end
	end)
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(0,1)
end

-- noclip/invisibility
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if noclip then
      local ped = GetPlayerPed(-1)
      local x,y,z = tvRP.getPosition()
      local dx,dy,dz = tvRP.getCamDirection()
      local speed = noclip_speed

      -- reset velocity
      SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

      -- forward
      if IsControlPressed(0,32) then -- MOVE UP
        x = x+speed*dx
        y = y+speed*dy
        z = z+speed*dz
      end

      -- backward
      if IsControlPressed(0,269) then -- MOVE DOWN
        x = x-speed*dx
        y = y-speed*dy
        z = z-speed*dz
      end

      SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
    end
  end
end)

function tvRP.toggleFreeze(freeze)
	 if freeze then
	   FreezeEntityPosition(GetPlayerPed(-1), true)
	 else
	   FreezeEntityPosition(GetPlayerPed(-1), false)
	 end
 end

function tvRP.teleportToWaypoint()
	local targetPed = GetPlayerPed(-1)
	local targetVeh = GetVehiclePedIsUsing(targetPed)
	if(IsPedInAnyVehicle(targetPed))then
		targetPed = targetVeh
    end

	if(not IsWaypointActive())then
		tvRP.notify("~r~Nu am gasit locatia, boss.")
		return
	end

	local waypointBlip = GetFirstBlipInfoId(8)
	local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 

	local ground
	local groundFound = false
	local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0}

	for i,height in ipairs(groundCheckHeights) do
		SetEntityCoordsNoOffset(targetPed, x,y,height, 0, 0, 1)
		Wait(10)

		ground,z = GetGroundZFor_3dCoord(x,y,height)
		if(ground) then
			z = z + 3
			groundFound = true
			break;
		end
	end

	if(not groundFound)then
		z = 1000
		GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
	end

	SetEntityCoordsNoOffset(targetPed, x,y,z, 0, 0, 1)
	tvRP.notify("~g~Gata, sefule!")
end

function tvRP.spawnAdminVehicle(name)
	local i = 0
	while not HasModelLoaded(GetHashKey(name)) and i < 1000 do
	  RequestModel(GetHashKey(name))
	  tvRP.notify("Se incarca modelul cerut...")
	  Citizen.Wait(10)
	  i = i+1
	end

	if not HasModelLoaded(GetHashKey(name)) then 
		tvRP.notify("~r~Nu s-a putut incarca!")
	end

	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	local h = GetEntityHeading(GetPlayerPed(-1))
	if HasModelLoaded(GetHashKey(name)) then
		tvRP.notify("~g~S-a spawnat vehiculul cerut!")
	  local vehicle = CreateVehicle(GetHashKey(name), x,y,z+0.5, h, true, false)
	  SetEntityInvincible(vehicle,false)
	  SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
	  SetVehicleNumberPlateText(vehicle, "ADMIN")
	end
  end
