local comma = false
local health = 200

local equipment = {
    ["S_M_Y_Chef_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["s_m_m_prisguard_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["S_M_M_Marine_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["s_m_m_ciasec_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["s_m_m_fibsec_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["s_m_m_paramedic_01"] = {
        'WEAPON_STUNGUN'
    },
    ["S_M_M_HighSec_01"] = {
        'WEAPON_STUNGUN'
    },
    ["S_M_Y_Valet_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
    ["s_m_y_swat_01"] = {
        'WEAPON_PISTOL',
        'WEAPON_COMBATPISTOL',
        'WEAPON_APPISTOL',
        'WEAPON_ASSAULTSHOTGUN',
        'WEAPON_STUNGUN',
        'WEAPON_NIGHTSTICK'
    },
}

function tvRP.removeAllWeapons()
    RemoveAllPedWeapons(GetPlayerPed(-1),true)
end

function tvRP.SetPedModel(model)
    if model then
        local mhash = GetHashKey(model)
        if mhash ~= nil then
            local i = 0
            while not HasModelLoaded(mhash) and i < 10000 do
                RequestModel(mhash)
                Citizen.Wait(10)
            end
    
            if HasModelLoaded(mhash) then
                SetPlayerModel(PlayerId(), mhash)
                SetModelAsNoLongerNeeded(mhash)
                if equipment[model] then
                    local weapons = equipment[model]
                    
                    for i,v in pairs(weapons) do
                        local weaponHash = GetHashKey(v)
                    
                        GiveWeaponToPed(GetPlayerPed(-1), weaponHash, 1, false)
                        local gotMaxAmmo, maxAmmo = GetMaxAmmo(GetPlayerPed(-1), weaponHash)
                        if not gotMaxAmmo then maxAmmo = 99999 end
                        SetAmmoInClip(GetPlayerPed(-1), weaponHash, GetWeaponClipSize(weaponHash))
                        AddAmmoToPed(GetPlayerPed(-1), weaponHash, maxAmmo) 
                    end
                end
            end
        end
    end
end

RegisterNetEvent("vRP:set_health")
AddEventHandler("vRP:set_health",function(value)
    Citizen.CreateThread(function()
        if not comma then
            health = math.floor(value + 100)
            SetPlayerInvincible(GetPlayerPed(-1),false)
            SetEntityHealth(GetPlayerPed(-1),math.floor(health))
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(2500)
        SetPlayerHealthRechargeMultiplier(PlayerId(), 0)

        if health > GetEntityHealth(GetPlayerPed(-1)) then
            health = GetEntityHealth(GetPlayerPed(-1))
            TriggerServerEvent("vRP:setHealth",GetEntityHealth(GetPlayerPed(-1)) - 100)
            SetEntityHealth(GetPlayerPed(-1),math.floor(health))
        end
    end
end)

function tvRP.isInComa()
    return comma
end

Citizen.CreateThread(function()
    while true do
        Wait(100)
        if GetEntityHealth(GetPlayerPed(-1)) <= 105 then
            comma = true
        else
            comma = false
        end

        if comma then
            if IsEntityDead(GetPlayerPed(-1)) then
                local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                NetworkResurrectLocalPlayer(x, y, z, true, true, false)
            end

            health = 105
            SetEntityHealth(GetPlayerPed(-1), 105)
            SetEntityInvincible(GetPlayerPed(-1),true)
            SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
              TaskLeaveVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1),false), 4160)
            end
        end
    end
end)

Citizen.CreateThread(function()
    local comma_time = 2.5 * 60
    while true do
        Wait(1000)
        if comma then
            comma_time = comma_time - 1

            if IsEntityInWater(GetPlayerPed(-1)) then
                Wait(10000)
                comma = false
                health = 200
                SetEntityHealth(GetPlayerPed(-1), health)
                SetEntityInvincible(GetPlayerPed(-1),false)
                TriggerServerEvent("vRP:resetHealth")
                TriggerEvent("vRP:stop_migrane")
                SetEntityCoordsNoOffset(GetPlayerPed(-1),-242.14944458008, 6325.5693359375, 32.413940429688)
                comma_time = 2.5 * 60
            end

            if comma_time == 0 then
                comma = false
                health = 200
                SetEntityHealth(GetPlayerPed(-1), health)
                SetEntityInvincible(GetPlayerPed(-1),false)
                TriggerServerEvent("vRP:resetHealth")
                TriggerEvent("vRP:stop_migrane")
                SetEntityCoordsNoOffset(GetPlayerPed(-1),-242.14944458008, 6325.5693359375, 32.413940429688)
                comma_time = 2.5 * 60
            end
        else
            SetEntityInvincible(GetPlayerPed(-1),false)
            comma_time = 2.5 * 60
        end
    end
end)

local migrane = false
Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if migrane then
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

RegisterNetEvent("vRP:start_migrane")
AddEventHandler("vRP:start_migrane",function()
    migrane = true
end)

RegisterNetEvent("vRP:stop_migrane")
AddEventHandler("vRP:stop_migrane",function()
    migrane = false
end)
