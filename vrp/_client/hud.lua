function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

RegisterNetEvent("vRP:updateMoney")
AddEventHandler("vRP:updateMoney", function(value)
    SendNUIMessage({money = value})
end)

RegisterNetEvent("vRP:updateSlots")
AddEventHandler("vRP:updateSlots", function(value)
    SendNUIMessage({slots = value})
end)

RegisterNetEvent("vRP:updateSurvival")
AddEventHandler("vRP:updateSurvival", function(value)
    SendNUIMessage({hunger = value.hunger,thirst = value.thirst})
end)

Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO', 'vRP Modified by brefabu')

    local esc = false
    local delay = false
    while true do
        Wait(0)
        if IsPauseMenuActive() then
            esc = true
            delay = true
        else
            esc = false
            delay = true
        end

        if esc then
            if delay then
                delay = false
                SendNUIMessage({action = "hide-body"})
            end
        else
            if delay then
                delay = false
                SendNUIMessage({action = "show-body"})
            end
        end
    end
end)
    
  
  
