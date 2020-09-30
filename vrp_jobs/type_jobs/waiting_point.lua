jobs["Pescar"] = function(config)
    Citizen.CreateThread(function()
        tvRP.CreateNPC("s_m_m_linecook",1733.9929199219,6420.3471679688,35.037231445313, -15.0)
        tvRP.addBlip(-277.09408569336,6639.0107421875,7.5454254150391,317,26,"Pescarie")
        while true do
            Wait(0)
            if tvRP.IsPlayerInRadius(-277.09408569336,6639.0107421875,7.5454254150391,25.0) then
                if not tvRP.IsJobActive() then
                    DrawText3D(-277.09408569336,6639.0107421875,7.5454254150391 + 1.0, "~b~[~w~Pescarie~b~]")
                    DrawMarker(22, -277.09408569336,6639.0107421875,7.5454254150391 , 0, 0, 0, 0, 0, 0, 0.7001,0.7001,0.7001,250, 250, 250, 150, 1, 1, 0, 1, 0, 0, 0)
                    DrawMarker(6, -277.09408569336,6639.0107421875,7.5454254150391 , 0, 0, 0, 0, 0, 0, 1.0001,1.0001,1.0001,0, 0, 250, 150, 1, 1, 0, 1, 0, 0, 0)
                    
                    if tvRP.IsPlayerInRadius(-277.09408569336,6639.0107421875,7.5454254150391,5.0) then
                        drawTxt(1.0, 1.0, 0.4, "Apasa ~b~[E]~w~ pentru a pescui!", 255, 255, 255, 255)
                        if not tvRP.IsJobActive() and IsControlJustPressed(0,51) then
                            tvRP.StartJob()
                            FreezeEntityPosition(GetPlayerPed(-1), true)
                            local rod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
                            for sec=1,60 do
                                if tvRP.IsJobActive() then
                                    PlayAnim(GetPlayerPed(-1),'amb@world_human_stand_fishing@base','base',4,1000)
                                    PlayAnim(GetPlayerPed(-1),'amb@world_human_stand_fishing@idle_a','idle_c',1,0)
                                    text = "~y~Pescuiesti...\n( "..tostring(60-sec).." secunde )"
                                    Wait(1000)
                                else
                                    text = nil
                                    break
                                end
                            end
                            StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
                            StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
                            StopAnimTask(GetPlayerPed(-1), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
                            FreezeEntityPosition(GetPlayerPed(-1), false)
                            DetachEntity(rod,false,true)
                            DeleteEntity(rod)
                            if tvRP.IsJobActive() then
                                local pesti = math.random(5,15)
                                text = "Eu: ~b~Pfuuu, am prins "..pesti.."!"
                                Wait(2500)
                                text = "Eu: ~b~Hai la Mitica sa vand pestii astia, fac si eu un ban!"
                                Wait(5000)
                                text = nil
                                local x,y,z = 1741.6872558594,6420.1010742188,35.042613983154-0.5
                                local mission = tvRP.setBlipMission(x,y,z)
                                while true do
                                    Wait(0)
                                    if tvRP.IsJobActive() then
                                        if tvRP.IsPlayerInRadius(1741.6872558594,6420.1010742188,35.042613983154,1.5) then
                                            tvRP.removeJobBlips()
                                            FreezeEntityPosition(GetPlayerPed(-1), true)
                                            for sec=1,30 do
                                                if tvRP.IsJobActive() then
                                                    text = "~y~Lasi pestele in camara...\n( "..tostring(30-sec).." secunde )"
                                                    Wait(1000)
                                                else
                                                    text = nil
                                                    break
                                                end
                                            end
                                            if tvRP.IsJobActive() then
                                                text = nil
                                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                                local x,y,z = 1733.9929199219,6420.3471679688,35.037231445313
                                                local mission = tvRP.setBlipMission(x,y,z)
                                                while true do
                                                    Wait(0)
                                                    if tvRP.IsJobActive() then
                                                        if tvRP.IsPlayerInRadius(x,y,z,2.5) then
                                                            text = nil
                                                            drawTxt(1.0, 1.0, 0.4, "Apasa ~b~[E]~w~ pentru a vorbi cu macelarul ~r~MITICA~w~!", 255, 255, 255, 255)
                                                            if IsControlJustPressed(0,51) then
                                                                tvRP.removeJobBlips()
                                                                FreezeEntityPosition(GetPlayerPed(-1), true)
                                                                text = "Mitica: ~r~Ai dus peste, cumetre?"
                                                                Wait(2500)
                                                                text = "Eu: ~b~Da, cumetre, hai ca l-am lasat in spate."
                                                                Wait(2000)
                                                                text = "Mitica: ~r~Ia aici niste bani, ca ai muncit saptamana asta!"
                                                                Wait(2000)
                                                                text = nil
                                                                tvRP.StopJob()
                                                                TriggerServerEvent("vRP:getSalary",math.random(100,500))
                                                                FreezeEntityPosition(GetPlayerPed(-1), false)
                                                            end
                                                        end
                                                    else
                                                        text = nil
                                                        break
                                                    end
                                                end
                                                text = nil
                                                break
                                            else
                                                text = nil
                                                break
                                            end
                                        end
                                    else
                                        text = nil
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function PlayAnim(ped,base,sub,nr,time)
	Citizen.CreateThread(function() 
		RequestAnimDict(base) 
		while not HasAnimDictLoaded(base) do 
			Citizen.Wait(1) 
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped) 
		else 
			for i = 1,nr do 
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0) 
				Citizen.Wait(time) 
			end 
		end 
	end) 
end

function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPlayerPed(-1), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPlayerPed(-1),2))
	AttachEntityToEntity(obj,  GetPlayerPed(-1),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end
