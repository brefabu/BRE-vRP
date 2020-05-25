local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_uber")
vRP = Proxy.getInterface("vRP")

function Vdist(x1,y1,z1,x2,y2,z2)
    return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
  end

uber_drivers = {}

AddEventHandler("vRP:playerSpawn",function(user_id,player,first_spawn)
    uber_drivers[user_id] = {}
    uber_drivers[user_id].onduty = false
    uber_drivers[user_id].free = false
end)

AddEventHandler("vRP:playerLeave",function(user_id,player)
    uber_drivers[user_id] = nil
end)

ch_uber = function(player,choice)
    local user_id = vRP.getUserId({player})

    if user_id then
        uber_drivers[user_id].onduty = not uber_drivers[user_id].onduty
        if uber_drivers[user_id].onduty then
            uber_drivers[user_id].free = true
            vRPclient.notify(player,{"Ai deschis aplicatia UBER!"})
        else
            uber_drivers[user_id].free = false
            vRPclient.notify(player,{"Ai inchis aplicatia UBER!"})
        end
    end
end

ch_calluber = function(player,choice)
    local user_id = vRP.getUserId({player})

    if user_id then
        vRPclient.getWaypointCoords(player,{},function(x,y)
            local coords_player = GetEntityCoords(GetPlayerPed(player))
            local price = math.floor(Vdist(x,y,0,coords_player.x,coords_player.y,0)/10*0.75+10)

            if vRP.getMoney({user_id}) >= price then
                if (x + y ~= 0) then
                    vRPclient.notify(player,{"Cautam cel mai apropiat UBER!"})
                    local uber = false
                    local driver = 0

                    local minim_dist = 300
                    local minim_driver = 0
                    for i,v in pairs(uber_drivers) do
                        if v.free then
                            driver = vRP.getUserSource({i})
                            local coords_driver = GetEntityCoords(GetPlayerPed(driver))
                            local coords_player = GetEntityCoords(GetPlayerPed(player))
                            
                            if Vdist(coords_driver.x, coords_driver.y, coords_driver.z, coords_player.x, coords_player.y, coords_player.z) < minim_dist then
                                minim_dist = Vdist(coords_driver.x, coords_driver.y, coords_driver.z, coords_player.x, coords_player.y, coords_player.z)
                                minim_driver = driver
                            end

                            uber = true
                            v.free = false
                            driver = vRP.getUserSource({i})
                        end
                    end

                    if uber then
                        Citizen.Wait(math.random(10,15)*1000)
                        vRPclient.notify(driver,{"Ti-am gasit un client!"})
                        vRPclient.notify(player,{"Acum vine soferul, asteapta-l in zona!"})

                        local coords_player = GetEntityCoords(GetPlayerPed(player))
                        TriggerClientEvent("uber:setBlipMission",driver,coords_player.x,coords_player.y,coords_player.z,function(blip)
                            Citizen.CreateThread(function()
                                while true do
                                    Wait(0)
                                    local coords_player = GetEntityCoords(GetPlayerPed(player))
                                    local coords_driver = GetEntityCoords(GetPlayerPed(driver))
                                    if Vdist(coords_player.x,coords_player.y,coords_player.z,coords_driver.x,coords_driver.y,coords_driver.z) < 10 then
                                        vRPclient.notify(driver,{"Asteapta sa ridici clientul!"})
                                        Wait(5000)
                                        TriggerClientEvent("uber:removeBlipMission",driver,blip)
                                        blip = nil
                                        TriggerClientEvent("uber:setBlipMission",driver,x,y,0,function(blip)
                                            Citizen.CreateThread(function()
                                                while true do
                                                    Wait(0)
                                                    local coords_driver = GetEntityCoords(GetPlayerPed(driver))
                                                    if Vdist(x,y,0,coords_driver.x,coords_driver.y,0) < 10 then
                                                        if vRP.tryFullPayment({user_id,price}) then
                                                            TriggerClientEvent("uber:removeBlipMission",driver,blip)
                                                            blip = nil
                                                            vRPclient.notify(player,{"Ai platit ~g~"..price.." EURO~w~!"})
                                                            vRP.giveBankMoney({vRP.getUserId({driver}),price*1.25})

                                                            break
                                                        end
                                                    end
                                                end
                                            end)
                                        end)

                                        break
                                    end
                                end
                            end)
                        end)
                    else
                        Citizen.Wait(math.random(5,10)*1000)
                        vRPclient.notify(driver,{"Nu am putut gasi niciun sofer in apropiere!"})
                    end
                end
            end
        end)
    end
end

vRP.registerMenuBuilder({"Agenda", function(add, data)
    local user_id = vRP.getUserId({data.player})
    local player = data.player

    if user_id ~= nil then
        local choices = {}

        choices["UBER"] = {function(player,data)
            vRP.buildMenu({"uber", {player = player}, function(menu)
                menu.name = "UBER"
                menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
                menu.onclose = function(player) vRP.closeMenu({player}) end

                menu["Call UBER"] = {ch_calluber, "Cheama un UBER!<br><span style='color:rgb(255, 215, 0)'>Pentru a folosi UBER-ul, pune un Waypoint pe harta, pentru a cunoaste destinatia!</span>"}
                menu["Toggle UBER"] = {ch_uber, "Foloseste-ti vehiculul pentru a fi UBER!"}
                
                vRP.openMenu({player,menu})
            end})
        end,"<span style='color:yellow'>Aplicatia UBER!</span>"}

        add(choices)
    end
end})
