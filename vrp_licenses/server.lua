local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_permis")

RegisterServerEvent("examen:permis")
AddEventHandler("examen:permis",function(type)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})

    vRP.giveDriveLicenseTypeA({user_id})
end)
