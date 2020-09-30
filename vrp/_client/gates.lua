local listDoors = {}
local closed = {}
local text = nil

function tvRP.setDoors(doors)
    Citizen.CreateThread(function()
        listDoors = doors
        for i,v in pairs(listDoors) do
            closed[i] = GetEntityCoords(GetClosestObjectOfType(v.coords[1],v.coords[2],v.coords[3], 5.0, v.hash, false, false, false))
            tvRP.setStatusDoor(i,v.status)
        end
        while true do
            Wait(0)
            for i,v in pairs(listDoors) do
                if not v.status then
                    text = "Pentru a interactiona cu portile: ~g~/poarta~w~\n[~g~Poarta deschisa~w~]"
                else
                    text = "Pentru a interactiona cu portile: ~g~/poarta~w~\n[~r~Poarta inchisa~w~]"
                end
                if Vdist(v.coords[1],v.coords[2],v.coords[3],GetEntityCoords(GetPlayerPed(-1))) < 15.0 then
                    tvRP.setStatusDoor(i,v.status)
                    DrawText3D(v.coords[1],v.coords[2],v.coords[3],text)
                end
            end
        end
    end)
end

function tvRP.setStatusDoor(id,status)
    listDoors[id].status = status
    local coords = listDoors[id].coords
    local hash = listDoors[id].hash
    local closestDoor = GetClosestObjectOfType(coords[1],coords[2],coords[3], 5.0, hash, false, false, false)
    SetEntityHealth(closestDoor, 1000)
    ClearEntityLastDamageEntity(closestDoor)
    SetEntityCanBeDamaged(closestDoor, false)
    DoorControl(hash,coords[1],coords[2],coords[3],status,0.0,50.0,0.0)
    if status then
        SetEntityCoordsNoOffset(closestDoor,closed[id].x,closed[id].y,closed[id].z, 0, 0, 0)
    end
    FreezeEntityPosition(closestDoor,status)
end
