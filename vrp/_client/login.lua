loggedIn = false

function tvRP.isloggedIn()
	return loggedIn
end

function tvRP.logInPlayer()
	loggedIn = true
end

RegisterNUICallback('login', function(data, cb)
    if data.username ~= "" or data.password ~= "" then
		TriggerServerEvent("vRP:Request", "login", data.username, data.password, nil)
    else
        tvRP.notify("Not any value introduced!")
	end
	cb('ok')
end)

RegisterNUICallback('register', function(data, cb)
	if data.username ~= "" or data.password ~= "" or data.email ~= "" then
        TriggerServerEvent("vRP:Request", "register", data.username, data.password, data.email)
    else
        tvRP.notify("Not any value introduced!")
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
	if not loggedIn then
		SetNuiFocus(true, true)
	else
		TriggerServerEvent("vRPcli:playerSpawn")
	end
end)

Citizen.CreateThread(function()
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    local mhash = GetHashKey("mp_m_freemode_01")
	
    if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
            RequestModel(mhash)
            Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
            SetPlayerModel(PlayerId(), mhash)
            SetModelAsNoLongerNeeded(mhash)
            
            ClearAllPedProps(GetPlayerPed(-1))
            ClearPedDecorations(GetPlayerPed(-1))
            SetPedDefaultComponentVariation(GetPlayerPed(-1))
        end
    end
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
        if loggedIn then
            SendNUIMessage({action = "logFormFadeOut"})
            SendNUIMessage({action = "loggedIn"})
            DisplayRadar(true)
            Wait(2500)
            FreezeEntityPosition(GetPlayerPed(-1), false)
            Wait(500)
            SetNuiFocus(false, false)
            SetEntityInvincible(GetPlayerPed(-1), false)
            SetEntityVisible(GetPlayerPed(-1), true, false)
            NetworkSetEntityInvisibleToNetwork(GetPlayerPed(-1), true)
            tvRP.stopAnyCamera()
            break
        end
    end
end)