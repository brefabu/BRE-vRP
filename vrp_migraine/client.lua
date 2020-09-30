local migraine = false

Citizen.CreateThread(function()
		if GetEntityHealth(GetPlayerPed(-1)) <= 120 then
			migraine = true
		else
			migraine = false
		end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if migraine then
            if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
                RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
                while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
                    Citizen.Wait(0)
                end
            end
            
            SetPedIsDrunk(GetPlayerPed(-1), true)
            ShakeGameplayCam("DRUNK_SHAKE", 1.0)
            SetPedConfigFlag(GetPlayerPed(-1), 100, true)
            SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", 1.0)
        else
            SetPedIsDrunk(GetPlayerPed(-1), false)
            ShakeGameplayCam("DRUNK_SHAKE", 0.0)
            ResetPedMovementClipset(GetPlayerPed(-1), 0.0)
        end
    end
end)
