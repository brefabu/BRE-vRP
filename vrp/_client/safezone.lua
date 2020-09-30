
local zones = {
	{-94.526374816895,6330.8032226563,33.404117584229},
	{1727.3775634766,3714.9743652344,34.164302825928},
	{-47.79525756836,-1107.7963867188,26.437969207764}
}
local inSafeZone = false

Citizen.CreateThread(function()
	while true do
		Wait(0)
		local sfz = false
		for i, v in pairs(zones)do
			if Vdist(v[1],v[2],v[3],GetEntityCoords(GetPlayerPed(-1))) < 50.0 then
				sfz = true
			end
		end
		inSafeZone = sfz
	end
end)

function DrawSafeAlert(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if (inSafeZone == true)then
			DisableControlAction(1, 37, true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,47,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			tvRP.notify("~w~Esti intr-un ~y~SafeZone~w~!")
			SetEntityInvincible(GetPlayerPed(-1), true)
            SetPlayerInvincible(PlayerId(), true)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
            SetEntityCanBeDamaged(GetPlayerPed(-1), false)
        else
            SetEntityInvincible(GetPlayerPed(-1), false)
            SetPlayerInvincible(PlayerId(), false)
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
		end
	end
end)
