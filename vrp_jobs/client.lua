vRP = Proxy.getInterface("vRP")
----------------------------------------------------------------------------
--Blips Functions

local blips = {}

Citizen.CreateThread(function()
    for i,v in pairs(jobs) do
        local coords = v._coords["city"].get
        local blip = AddBlipForCoord(coords[1]+0.001,coords[2]+0.001,coords[3]+0.001)
        SetBlipSprite(blip, v._blip.model)
        SetBlipAsShortRange(blip, true)
        SetBlipColour(blip,v._blip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v._name)
        EndTextCommandSetBlipName(blip)

        local coords2 = v._coords["county"].get
        local blip2 = AddBlipForCoord(coords2[1]+0.001,coords2[2]+0.001,coords2[3]+0.001)
        SetBlipSprite(blip2, v._blip.model)
        SetBlipAsShortRange(blip2, true)
        SetBlipColour(blip2,v._blip.color)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v._name)
        EndTextCommandSetBlipName(blip2)
    end
end)

function setBlipMission(x,y,z)
    local blip = AddBlipForCoord(x,y,z)
    SetBlipRoute(blip,true)
    blips[blip] = true
    TriggerEvent("mission:drawmarker",x,y,z+1.0)
    return blip
end

function removeJobBlips()
    for i,v in pairs(blips) do
        SetBlipRoute(i,false)
        RemoveBlip(i)
    end
end

----------------------------------------------------------------------------
--JOB Functions

local job = false
local jobvehs = {}

function StartJob()
    job = true
end

function StopJob()
    for i,v in pairs(blips) do
        SetBlipRoute(i,false)
        RemoveBlip(i)
    end
    
    for i,v in pairs(jobvehs) do
        DeleteVehicle(v)
    end

    text = nil
    job = false
end

function IsJobActive()
    return job
end

----------------------------------------------------------------------------
--Vehicle Function

function spawnJobVehicle(model,x,y,z,h)
    local mhash = GetHashKey(model)
    RequestModel(mhash)
    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      Citizen.Wait(10)
      i = i+1
    end
    local vehicle = nil
    if HasModelLoaded(mhash) then
        vehicle = CreateVehicle(mhash, x, y, z+0.5, h, true, true)
        SetVehicleFuelLevel(vehicle,100)
        table.insert(jobvehs,vehicle)
        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
        SetEntityHeading(vehicle,h)
        SetVehicleDoorsLocked(vehicle,1)
        SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
        SetEntityInvincible(vehicle,false)
        SetVehicleNumberPlateText(vehicle, "JOBS")
        SetVehicleFixed(vehicle)
    end
  
    return vehicle
end

----------------------------------------------------------------------------
--Shuffle Table

function shuffle(t)
    local rand = math.random
  
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
  end
  
----------------------------------------------------------------------------
--Comma Thread


-- Citizen.CreateThread(function()
--     while true do
--         Wait(0)
--         if text then
--             drawTxt(1.0, 1.0, 0.4, text, 255, 255, 255, 255)
--         end
--         if tvRP.isInComa() and tvRP.IsJobActive() then
--             tvRP.StopJob()
--         end
--     end
-- end)

----------------------------------------------------------------------------
--Drawmarker & DrawText3D Function

local drawtext = nil

function OnPlayerDrawText(text)
    drawtext = text
end

function ClearPlayerDrawText()
    drawtext = nil
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if drawtext ~= nil then
            local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
            DrawText3D(x,y,z, drawtext) 
        end
    end
end)

function DrawText3D(x,y,z, text) 
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
  
	local scale = (1/dist)*2
	local fov = (1/GetGameplayCamFov())*130
	local scale = scale*fov
	
	if onScreen then
		SetTextScale(0.5*scale, 0.7*scale)
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
		World3dToScreen2d(x,y,z, 0)
		DrawText(_x,_y)
	end
end
