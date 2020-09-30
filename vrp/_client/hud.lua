local mission = nil
local job = nil

function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

function tvRP.SetGUI(hunger,thirst)
    SendNUIMessage({thirst = 100-thirst,hunger = 100-hunger,survival = true})
end
  
function tvRP.setGUIMoney(value1,value2,value3)
    if value1 then
        SendNUIMessage({pmoney = value1})
    end
    if value2 then
        SendNUIMessage({bmoney = value2})
    end
    if value3 then
        SendNUIMessage({gifts = value3})
    end
end
  
function tvRP.setGUIInfo(value)
    SendNUIMessage({info = value})
end
  
function tvRP.setGUIMission(value)
    mission = value
end

function tvRP.setGUIJob(value)
    job = value
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        SendNUIMessage({job = job,mission = mission})
    end
end)

AddEventHandler("login_stop",function()
    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            TriggerServerEvent("vRP:updateInfo")
        end
    end)
end)

Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO', 'BRE Times | discord.io/bretimes')
    AddTextEntry('PM_PANE_LEAVE', 'Vezi lista de servere')
    AddTextEntry('PM_PANE_QUIT', 'Inchide jocul')
    AddTextEntry('PM_SCR_MAP', 'Harta')
    AddTextEntry('PM_SCR_GAM', 'Joc')
    AddTextEntry('PM_SCR_INF', 'Informatii')
    AddTextEntry('PM_SCR_SET', 'Setari')
    AddTextEntry('PM_SCR_STA', 'Statistici')
    AddTextEntry('PM_SCR_RPL', 'Editor ∑')
  end)
  
