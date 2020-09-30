local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_uber")
vRP = Proxy.getInterface("vRP")

function Vdist(x1,y1,z1,x2,y2,z2)
    return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
  end

uber_drivers = {}

AddEventHandler("vRP:playerLeave",function(user_id,player)
    uber_drivers[user_id] = nil
end)

ch_uber = function(player,choice)
    local user_id = vRP.getUserId({player})

    if user_id then
        if uber_drivers[user_id] == nil then
            uber_drivers[user_id] = true
            vRPclient.notify(player,{"Opened UBER!"})
        else
            uber_drivers[user_id] = nil
            vRPclient.notify(player,{"Closed UBER!"})
        end
    end
end

ch_calluber = function(player,choice)
    local user_id = vRP.getUserId({player})

    if user_id then
        vRPclient.getWaypointCoords(player,{},function(x,y)
            local finish = {x,y,0}
            if x ~= 0 and y ~= 0 then
                vRPclient.getPosition(player,{},function(x,y,z)
                    local coords = {x,y,0}
                    local price = math.floor(Vdist(finish[1],finish[2],finish[3],coords[1],coords[2],coords[3])/10*0.75+10)
                    local driver = 0

                    if vRP.getMoney({user_id}) >= price then
                        if (x + y ~= 0) then
                            vRPclient.notify(player,{"Search for an UBER!"})
                            local uber = false

                            for i,v in pairs(uber_drivers) do
                                if uber_drivers[user_id] then
                                    driver = vRP.getUserSource({i})
                                    
                                    uber = true
                                    uber_drivers[user_id] = false
                                    
                                    break
                                end
                            end

                            if uber then
                                Citizen.Wait(math.random(10,15)*1000)
                                
                                if vRP.tryFullPayment({user_id,price}) then
                                    vRPclient.notify(driver,{"Found one!"})
                                    vRPclient.notify(player,{"He's coming now, wait!"})

                                    TriggerClientEvent("uber:setUberPassanger", driver, coords, finish, price)
                                    
                                    vRPclient.notify(player,{"Paid ~g~"..price.." EURO~w~!"})
                                else
                                    vRPclient.notify(player,{"Wtf, you're poor!"})
                                end
                            else
                                vRPclient.notify(player,{"Nobody found..."})
                            end
                        end
                    end
                end)
            else
                vRPclient.notify(player,{"Set the waypoint, first..."})
            end
        end)
    end
end

RegisterServerEvent("vRP:uberPay")
AddEventHandler("vRP:uberPay",function(price)
    local user_id = vRP.getUserId({source})

    vRP.giveMoney({user_id, price})
    vRPclient.notify(player,{"Paid with ~g~"..price.." EURO~w~!"})
end)

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    local player = data.player

    if user_id ~= nil then
        local choices = {}

        choices["UBER"] = {function(player,data)
            vRP.buildMenu({"uber", {player = player}, function(menu)
                menu.name = "UBER"
                menu.css={top="75px",header_color="rgba(0,200,0,0.75)"}
                menu.onclose = function(player) vRP.closeMenu({player}) end

                menu["Call UBER"] = {ch_calluber}
                menu["Toggle UBER"] = {ch_uber}
                
                vRP.openMenu({player,menu})
            end})
        end,"<span style='color:yellow'>App UBER!</span>"}

        add(choices)
    end
end})
