local vRP = Proxy.getInterface("vRP")

RegisterNetEvent("uber:setBlipMission")
AddEventHandler("uber:setBlipMission",function(x,y,z,cb)
    local blip = AddBlipForCoord(x,y,z)
    SetBlipRoute(blip,true)
    cb(blip)
end)

RegisterNetEvent("uber:removeBlipMission")
AddEventHandler("uber:removeBlipMission",function(blip)
    SetBlipRoute(blip,false)
    RemoveBlip(blip)
end)
