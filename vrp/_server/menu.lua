vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player
  
    local user_id = vRP.getUserId(player)
    
    if user_id ~= nil then
        local choices = {}
        local p_data = vRP.getUserData(user_id)    

        choices["Inventory"] = {function(player,choice)
            TriggerClientEvent("vRP:openInventoryGui", player)
        end}

        choices["Bank"] = {function(player,choice)
        end,"Money: "..vRP.getBankMoney(user_id)}

        choices["Legitimations"] = {function(player,choice)
            vRP.buildMenu("info_player", {user_id = user_id, player = player}, function(menu)
                menu.name="Legitimatii"
                menu.css={top="75px",header_color="rgba(25525,0,0.75)"}

                menu["ID Card"] = {nil, "Name: "..p_data.name.."<br>Firstname: "..p_data.firstname.."<br>Phone: "..p_data.phone.."<br>Age: "..p_data.age}
                if p_data.faction ~= " " then
                    menu["Work Card"] = {nil, "Name: "..p_data.name.."<br>Firstname: "..p_data.firstname.."<br>Faction: "..p_data.faction.."<br>Role: "..p_data.faction_rank}
                end
                if p_data.license_A then
                    menu["AUTO License ( A )"] = {nil}
                end
                if p_data.license_B then
                    menu["AUTO License ( B )"] = {nil}
                end
                if p_data.license_C then
                    menu["AUTO License ( C )"] = {nil}
                end
                if p_data.license_D then
                    menu["AUTO License ( D )"] = {nil}
                end
                if vRP.hasVisa(user_id) then
                    menu["Visa"] = {nil}
                end

                vRP.openMenu(player,menu)
            end)
        end,"See ur legitimations!"}

        choices["Interaction"] = {function(player,choice)
            vRP.buildMenu("interaction", {user_id = user_id, player = player}, function(menu)
                menu.name="Interaction"
                menu.css={top="75px",header_color="rgba(25525,0,0.75)"}

                menu["Give money"] = {function(player,choice)
                    vRPclient.getNearestPlayers(player,{5},function(nplayers)
                        usrList = ""
                        for k,v in pairs(nplayers) do
                          usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. vRP.getUserName(k) .. " | "
                        end
                        if usrList ~= "" then
                            vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                                if nuser_id ~= nil and nuser_id ~= "" then 
                                    nuser_id = tonumber(nuser_id)
                                    local nplayer = vRP.getUserSource(tonumber(nuser_id))
                                    if nplayer ~= nil then
                                        vRP.prompt(player,"Value ","",function(player,amount) 
                                            local amount = parseInt(amount)
                                            print(amount)
                                            if amount > 0 and vRP.tryPayment(user_id,amount) then
                                                vRP.giveMoney(nuser_id,amount)
                                                vRPclient.notify(player,{"You gived "..amount.." EURO!"})
                                            end
                                        end)
                                    end
                                end
                            end)
                        end
                    end)
                end}

                menu["Ask for ID"] = {function(player,choice)
                    vRPclient.getNearestPlayers(player,{5},function(nplayers)
                        usrList = ""
                        for k,v in pairs(nplayers) do
                          usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                        end
                        if usrList ~= "" then
                            vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                                if nuser_id ~= nil and nuser_id ~= "" then 
                                    nuser_id = tonumber(nuser_id)
                                    local nplayer = vRP.getUserSource(tonumber(nuser_id))
                                    if nplayer ~= nil then
                                        vRP.buildMenu("legitimation", {user_id = nuser_id, player = nplayer}, function(info)
                                            info.name="Ask Legitimation"
                                            info.css={top="75px",header_color="rgba(25525,0,0.75)"}
                                            
                                            local p_data = vRP.getUserData(nuser_id)  

                                            info["ID card"] = {nil, "Name: "..p_data.name.."<br>Firstname: "..p_data.firstname.."<br>Phone: "..p_data.phone.."<br>Age: "..p_data.age}

                                            vRP.openMenu(player,info)
                                        end)
                                    end
                                end
                            end)
                        end
                    end)
                end}

                menu["Ask for AUTO license"] = {function(player,choice)
                    vRPclient.getNearestPlayers(player,{5},function(nplayers)
                        usrList = ""
                        for k,v in pairs(nplayers) do
                          usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                        end
                        if usrList ~= "" then
                            vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                                if nuser_id ~= nil and nuser_id ~= "" then 
                                    nuser_id = tonumber(nuser_id)
                                    local nplayer = vRP.getUserSource(tonumber(nuser_id))
                                    if nplayer ~= nil then
                                        vRP.buildMenu("legitimation", {user_id = nuser_id, player = nplayer}, function(info)
                                            info.name="Ask Legitimation"
                                            info.css={top="75px",header_color="rgba(25525,0,0.75)"}
                                            
                                            local p_data = vRP.getUserData(nuser_id)  

                                            if p_data.license_A then
                                                info["AUTO License ( A )"] = {nil}
                                            end
                                            if p_data.license_B then
                                                info["AUTO License ( B )"] = {nil}
                                            end
                                            if p_data.license_C then
                                                info["AUTO License ( C )"] = {nil}
                                            end
                                            
                                            if p_data.license_A or p_data.license_B or p_data.license_C then
                                                info["Missing"] = {nil}
                                            end

                                            vRP.openMenu(player,info)
                                        end)
                                    end
                                end
                            end)
                        end
                    end)
                end}

                menu["Ask for visa"] = {function(player,choice)
                    vRPclient.getNearestPlayers(player,{5},function(nplayers)
                        usrList = ""
                        for k,v in pairs(nplayers) do
                          usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                        end
                        if usrList ~= "" then
                            vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                                if nuser_id ~= nil and nuser_id ~= "" then 
                                    nuser_id = tonumber(nuser_id)
                                    local nplayer = vRP.getUserSource(tonumber(nuser_id))
                                    if nplayer ~= nil then
                                        vRP.buildMenu("legitimation", {user_id = nuser_id, player = nplayer}, function(info)
                                            info.name="Ask Legitimation"
                                            info.css={top="75px",header_color="rgba(25525,0,0.75)"}
                                            
                                            local p_data = vRP.getUserData(nuser_id)  

                                            if vRP.hasVisa(user_id) then
                                                info["Visa"] = {nil}
                                            else
                                                info["Missing"] = {nil}
                                            end

                                            vRP.openMenu(player,info)
                                        end)
                                    end
                                end
                            end)
                        end
                    end)
                end}

                menu["Ask for work card"] = {function(player,choice)
                    vRPclient.getNearestPlayers(player,{5},function(nplayers)
                        usrList = ""
                        for k,v in pairs(nplayers) do
                          usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                        end
                        if usrList ~= "" then
                            vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                                if nuser_id ~= nil and nuser_id ~= "" then 
                                    nuser_id = tonumber(nuser_id)
                                    local nplayer = vRP.getUserSource(tonumber(nuser_id))
                                    if nplayer ~= nil then
                                        vRP.buildMenu("legitimation", {user_id = nuser_id, player = nplayer}, function(info)
                                            info.name="ask legitimation"
                                            info.css={top="75px",header_color="rgba(25525,0,0.75)"}
                                            
                                            local p_data = vRP.getUserData(nuser_id)  

                                            
                                            if p_data.faction ~= " " then
                                                info["Work Card"] = {nil, "Name: "..p_data.name.."<br>Firstname: "..p_data.firstname.."<br>Faction: "..p_data.faction.."<br>Role: "..p_data.faction_rank}
                                            else
                                                info["Missing"] = {nil}
                                            end

                                            vRP.openMenu(player,info)
                                        end)
                                    end
                                end
                            end)
                        end
                    end)
                end}

                vRP.openMenu(player,menu)
            end)
        end}


        add(choices)
    end
end)

vRP.registerMenuBuilder("Agenda", function(add, data)
    local user_id = vRP.getUserId(data.player)
    if user_id ~= nil then
        local choices = {}
        
        choices["Announce"] = {function(player,data)
            if vRP.tryFullPayment(user_id,500) then
                vRP.prompt(player,"Announce: ","",function(player,text) 
                    if text ~= nil and text ~= "" then
                        vRPclient.notify(player,{"It taken taxes!"})
                        TriggerClientEvent('chat:addMessage', -1, {template = '<div style="text-align:left;padding: 0.4vw; margin: 0.25vw; background-image: linear-gradient(to right, rgba(250, 0, 0,0.5) 3%, rgba(36, 211, 242,0) 95%); border-radius: 15px;color: white;border-left: solid 2px red;"><i class="fab fa-twitter"></i> [ ANUNT COMERCIAL ] ( {0} ) {1}: {2}</div>',args = { user_id, vRP.getUserName(user_id), text }})
                    end
                end)
            else
                vRPclient.notify(player,{"~r~Not enough money!"})
            end
        end}

        choices["Alerts"] = {function(player,data)
            vRP.buildMenu("alerts", {player = player}, function(menu)
                menu.name = "Alerts"
                menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

                menu["Ambulance"] = {function(player,choice)
                    vRP.prompt(player,"Problem: ","",function(player,text) 
                        local answered = false
                        if text ~= nil and text ~= "" then
                            for j,k in pairs(vRP.users) do
                                local user_id = k.id
                                local nplayer = j
                                if vRP.isPlayerInFaction(user_id,"EMS") then
                                    vRP.request(nplayer,"[ALERT]: "..text, 30, function(nplayer,ok)
                                        if ok then -- take the call
                                            if not answered then
                                                -- answer the call
                                                vRPclient.notify(player,{"~b~Someone comes."})
                                                vRPclient.getPosition(player,{},function(x,y,z)
                                                    vRPclient.setGPS(nplayer,{x,y})
                                                end)
                                                answered = true
                                            else
                                                vRPclient.notify(nplayer,{"It was already taken!"})
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end)
                end}

                menu["Police"] = {function(player,choice)
                    vRP.prompt(player,"Problem: ","",function(player,text) 
                        local answered = false
                        if text ~= nil and text ~= "" then
                            for j,k in pairs(vRP.users) do
                                local user_id = k.id
                                local nplayer = j
                                if vRP.isPlayerInFaction(user_id,"Police") then
                                    vRP.request(nplayer,"[ALERT]: "..text, 30, function(nplayer,ok)
                                        if ok then -- take the call
                                            if not answered then
                                                -- answer the call
                                                vRPclient.notify(player,{"~b~Someone comes."})
                                                vRPclient.getPosition(player,{},function(x,y,z)
                                                    vRPclient.setGPS(nplayer,{x,y})
                                                end)
                                                answered = true
                                            else
                                                vRPclient.notify(nplayer,{"It was already taken!"})
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    end)
                end}

                vRP.openMenu(player,menu)
            end)
        end}

        add(choices)
    end
end)
