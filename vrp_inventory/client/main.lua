local show = false
local temp_inventory = nil
local temp_weight = nil
local temp_maxWeight = nil
local cooldown = 0

function openGui(inventory, weight, maxWeight)
  if show == false then
    show = true
    SetNuiFocus(true, true)
    SendNUIMessage({show = true,inventory = inventory,weight = weight,maxWeight = maxWeight})
  end
end

function closeGui()
  show = false
  SetNuiFocus(false)
  SendNUIMessage({show = false})
end

RegisterNetEvent("vRP:openInventoryGui")
AddEventHandler("vRP:openInventoryGui",function()
  if cooldown > 0 and temp_inventory ~= nil and temp_weight ~= nil and temp_maxWeight ~= nil then
    openGui(temp_inventory, temp_weight, temp_maxWeight)
  else
    TriggerServerEvent("vRP:openInventoryGui")
  end
end)

RegisterNetEvent("vRP:updateInventory")
AddEventHandler("vRP:updateInventory",function(inventory, weight, maxWeight)
  cooldown = Config.AntiSpamCooldown
  temp_inventory = inventory
  temp_weight = weight
  temp_maxWeight = maxWeight
  openGui(temp_inventory, temp_weight, temp_maxWeight)
end)

RegisterNetEvent("vRP:UINotification")
AddEventHandler("vRP:UINotification",function(type, title, message)
  show = true
  SetNuiFocus(true, true)
  SendNUIMessage({show = true,notification = true,type = type,title = title,message = message})
end)

RegisterNetEvent("vRP:closeGui")
AddEventHandler("vRP:closeGui",function()
  closeGui()
end)

RegisterNetEvent("vRP:objectForAnimation")
AddEventHandler("vRP:objectForAnimation",function(type)
  local ped = GetPlayerPed(-1)
  DeleteObject(object)
  bone = GetPedBoneIndex(ped, 60309)
  coords = GetEntityCoords(ped)
  modelHash = GetHashKey(type)

  RequestModel(modelHash)
  object = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, false)
  AttachEntityToEntity(object, ped, bone, 0.1, 0.0, 0.0, 1.0, 1.0, 1.0, 1, 1, 0, 0, 2, 1)
  Citizen.Wait(2500)
  DeleteObject(object)
end)

RegisterNUICallback("close",function(data)
  closeGui()
end)

RegisterNUICallback("useItem",function(data)
  cooldown = 0
  closeGui()
  TriggerServerEvent("vRP:useItem", data)
end)

RegisterNUICallback("dropItem",function(data)
  cooldown = 0
  closeGui()
  TriggerServerEvent("vRP:dropItem", data)
end)

RegisterNUICallback("giveItem",function(data)
  cooldown = 0
  closeGui()
  TriggerServerEvent("vRP:giveItem", data)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if cooldown > 0 then 
      cooldown = cooldown - 1
    end
  end
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsControlJustPressed(0, 303) then
      TriggerEvent("vRP:openInventoryGui")
    end
  end
end)

AddEventHandler("onResourceStop",function(resource)
  if resource == GetCurrentResourceName() then
    closeGui()
  end
end)
