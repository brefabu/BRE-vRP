local grills = {}
local anim = false

function tvRP.unpackGrill(hash,x,y,z,h)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait( 1 )
    end

    grill = CreateObject(hash, x, y, z-1, true,false,false)
    table.insert(grills,grill)
    SetEntityHeading(grill, h+180)
    SetModelAsNoLongerNeeded(hash)
    SetEntityInvincible(grill, true)
    FreezeEntityPosition(grill, true)

    return grill
end

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if not anim then
            local pos = GetEntityCoords(GetPlayerPed(-1))
            for i, v in pairs(grills) do
                if Vdist(GetEntityCoords(v),GetEntityCoords(GetPlayerPed(-1))) < 1.5 then
                    help("Apasa ~INPUT_CONTEXT~ pentru a deschide meniul gratarului!")
                    if IsControlJustReleased(1, 51) then
                        TriggerServerEvent("faby:menu_grill",grill)
                    end
                end
            end
        end
	end
end)

function tvRP.deleteEntity(v)
    if(IsEntityAnObject(v))then
        DeleteEntity(v)
    end
end

function tvRP.setGrillAnim(bool)
    anim = bool
end