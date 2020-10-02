loggedin = false

RegisterNetEvent("vRP:playerLetIn")
AddEventHandler("vRP:playerLetIn",function()
	loggedin = true
end)

function tvRP.isLoggedIn()
	return loggedin
end

RegisterNUICallback('login', function(data, cb)
	local username = data.username
	local pass = data.password
	if username ~= "" and pass ~= "" then
		TriggerServerEvent("vRP:checkLogin", username, pass)
	end
	cb('ok')
end)

RegisterNUICallback('register', function(data, cb)
	local username = data.username
	local pass = data.password
	if username ~= "" and pass ~= "" then
		TriggerServerEvent("vRP:checkRegister", username, pass)
	end
	cb('ok')
end)

-- events
AddEventHandler("onPlayerDied",function(player,reason)
	TriggerServerEvent("vRPcli:playerDied")
end)

AddEventHandler("onPlayerKilled",function(player,killer,reason)
	TriggerServerEvent("vRPcli:playerDied")
end)

	AddEventHandler("playerSpawned",function()
	if not loggedin then
		SetNuiFocus(true, true)
	else
		TriggerServerEvent("vRPcli:playerSpawn")
	end
end)

--AddEventHandler("playerSpawned",function()
	Citizen.CreateThread(function()
		local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		DisplayRadar(false)
		SetNuiFocus(true, true)
		SetEntityInvincible(GetPlayerPed(-1), true)
		SetEntityVisible(GetPlayerPed(-1), false, false)
		SetCamCoord(cam, -1710.0, -1390.0, 120.0)
		RenderScriptCams(1, 1, 0, 1, 1)
		NetworkSetFriendlyFireOption(true)
		SetCanAttackFriendly(GetPlayerPed(-1), true, true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		SetDispatchCopsForPlayer(PlayerId(), false)
		FreezeEntityPosition(GetPlayerPed(-1), true)
		while true do
			Wait(1)
			if loggedin then
				TriggerServerEvent("vRP:playerLoggedIn")
				SendNUIMessage({loginSuccesful = true,hud_show = true})
				Wait(2500)
				FreezeEntityPosition(GetPlayerPed(-1), false)
				Wait(500)
				SetNuiFocus(false, false)
				SetEntityInvincible(GetPlayerPed(-1), false)
				SetEntityVisible(GetPlayerPed(-1), true, false)
				tvRP.stopAnyCamera()
				DisplayRadar(true)
				break
			end
		end
	end)
--end)
