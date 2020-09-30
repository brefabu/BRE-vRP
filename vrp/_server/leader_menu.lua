local config = module("config/factions")
local factions = config

vRP.registerMenuBuilder("main", function(add, data)
    local player = data.player
  
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local choices = {}
        
        if vRP.isPlayerInAnyFaction(user_id) and vRP.isPlayerLeaderOfAnyFaction(user_id) then
            choices["Faction menu"] = {function(player,data)
                local i = vRP.getPlayerFaction(user_id)
                vRP.buildMenu("leader", {user_id = user_id, player = player}, function(faction)
                    faction.name= i
                    faction.css={top="75px",header_color="rgba(25525,0,0.75)"}
            
                    faction["Add member"] = {function(player,data)
                        vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                            nuser_id = tonumber(nuser_id)
                            local target = vRP.getUserSource(nuser_id)
                            if target then
                                vRP.addPlayerToFaction(nuser_id,i)
                                vRPclient.notify(player,{"ID: "..nuser_id.." is added!"})
                                vRPclient.notify(target,{"You're added "..i.."!"})
                            else
                                vRPclient.notify(player,{"Is offline!"})
                            end
                        end)
                    end}
            
                    faction["Kick member"] = {function(player,data)
                        vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                            nuser_id = tonumber(nuser_id)
                            local target = vRP.getUserSource(nuser_id)
                            if target and vRP.isPlayerInFaction(nuser_id,i) then
                                vRP.removePlayerFromFaction(nuser_id)
                                vRPclient.notify(player,{"ID: "..nuser_id.." is kicked!"})
                                vRPclient.notify(target,{"You're kicked "..i.."!"})
                            else
                                vRPclient.notify(player,{"Is offline!"})
                            end
                        end)
                    end}

                    faction["Set rank"] = {function(player,data)
                        vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                            nuser_id = tonumber(nuser_id)
                            local target = vRP.getUserSource(nuser_id)
                            if target and vRP.isPlayerInFaction(nuser_id,i) then
                                vRP.buildMenu("ranks", {user_id = user_id, player = player}, function(ranks)
                                    ranks.name="Seteaza Rank"
                                    ranks.css={top="75px",header_color="rgba(25525,0,0.75)"}
                                    
                                    for r,rank in pairs(factions[i]._ranks) do
                                        ranks[r..". "..rank]= {function(player,data)
                                            vRP.setPlayerRankFaction(nuser_id,rank)
                                            vRPclient.notify(player,{"ID: "..nuser_id.." is "..rank.."!"})
                                            vRPclient.notify(target,{"You're "..rank.." ("..i..")!"})
                                        end}
                                    end

                                    vRP.openMenu(player,ranks)
                                end)
                            else
                                vRPclient.notify(player,{"Not in faction or offline!"})
                            end
                        end)
                    end}
            
                    vRP.openMenu(player,faction)
                end)
            end}
        end

        add(choices)
    end
end)