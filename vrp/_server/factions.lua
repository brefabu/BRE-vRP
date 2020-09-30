factions = module("config/factions")

RegisterServerEvent("vRP:playerJoinFaction")
RegisterServerEvent("vRP:playerLeaveFaction")

function vRP.getPlayerFaction(user_id)
    local source = vRP.getUserSource(user_id)
    return vRP.users[source].data.faction or " "
end

function vRP.addPlayerToFaction(user_id, faction)
    TriggerEvent("vRP:playerJoinFaction",user_id,vRP.getUserSource(user_id),faction)
    local source = vRP.getUserSource(user_id)
    vRP.users[source].data.faction = faction
    vRP.users[source].data.faction_rank = factions[faction]._ranks[1]
end

function vRP.removePlayerFromFaction(user_id)
    TriggerEvent("vRP:playerLeaveFaction",user_id,vRP.getUserSource(user_id))
    local source = vRP.getUserSource(user_id)
    vRP.users[source].data.faction = " "
    vRP.users[source].data.faction_rank = " "
end

function vRP.isPlayerInFaction(user_id, faction)
    local source = vRP.getUserSource(user_id)
    return (vRP.users[source].data.faction == faction)
end

function vRP.isPlayerInAnyFaction(user_id)
    local source = vRP.getUserSource(user_id)
    if not vRP.users[source].data.faction == " " then
        return true
    end

    return false
end

function vRP.setPlayerRankFaction(user_id, rank)
    local source = vRP.getUserSource(user_id)
    local faction = vRP.getUserFaction(user_id)

    if faction then
        if #factions[faction]._ranks then
            for i,v in pairs(factions[faction]._ranks) do
                if v == rank then
                    vRP.users[source].data.faction_rank = rank
                end
            end
        end
    end
end

function vRP.getPlayerRankFaction(user_id)
    local source = vRP.getUserSource(user_id)
    return vRP.users[source].data.faction_rank
end

function vRP.setLeader(user_id)
    local source = vRP.getUserSource(user_id)
    local faction = vRP.getPlayerFaction(user_id)

    vRP.users[source].faction_rank = factions[faction]._leader
end

function vRP.removeLeader(user_id)
    local source = vRP.getUserSource(user_id)
    local faction = vRP.getFaction(user_id)

    vRP.users[source].faction_rank = factions[faction]._ranks[1]
end

function vRP.isLeader(user_id,faction)
    local source = vRP.getUserSource(user_id)
    if vRP.users[source].data.faction == factions[faction]._leader then
        return true
    else
        return false
    end
end

function vRP.getPlayerRankFactionPriority(user_id)
    local source = vRP.getUserSource(user_id)
    local faction = vRP.getUserFaction(user_id)

    if faction ~= " " then
        if vRP.isLeader(user_id,faction) then
            return 10
        end
        for i,v in pairs(factions[faction]._ranks) do
            if v == vRP.users[source].data.faction_rank then
                return i
            end
        end
    end
    return 0
end

function vRP.getUserFactionByType(user_id,type)
    for i,v in pairs(factions) do
        if v._type == type and vRP.isPlayerInFaction(user_id, i) then
            return true
        end
    end
    return false
end

function vRP.isPlayerLeaderOfAnyFaction(user_id)
    local source = vRP.getUserSource(user_id)
    for i,v in pairs(factions) do
        if vRP.users[source].data.faction_rank == v._leader then
            return true
        end
    end
    return false
end

function vRP.getUsersFaction(faction)
    local users = {}

    for k,v in pairs(vRP.users) do
        if vRP.isPlayerInFaction(vRP.getUserId(k),faction) then
            table.insert(users,vRP.getUserId(k))
        end
    end
    return users
end

function vRP.getChatFaction(faction)
    if faction ~= " " then
        return factions[faction]._chat
    end
    
    return "None"
end

function vRP.getSalaryFaction(user_id)
    local source = vRP.getUserSource(user_id)
    local faction = vRP.getPlayerFaction(user_id)
    local rank = vRP.getPlayerRankFaction(user_id)

    return factions[faction]._salary[rank] or 0
end

AddEventHandler("vRP:playerLoggedIn",function(source,user_id)
    if source ~= nil then
        for i,v in pairs(factions) do
            for a,b in pairs(v._coords) do
                local x,y,z = table.unpack(b)
                vRPclient.addBlip(source,{x,y,z,v._blip_id,v._blip_color,i})
            end
        end
    end
end)


local function build_client_lidermenu(source)
    local user_id = vRP.getUserId(source)
    
    if user_id ~= nil then
        for i,v in pairs(factions) do
            for j,k in pairs(v._coords) do
                local x,y,z = table.unpack(k)
                if vRP.hasUserRole(user_id,"Fondator") or vRP.isLeader(user_id,i) then
                    local lidermenu_enter = function(player,area)
                        if user_id ~= nil then
                            vRP.buildMenu("faction", {user_id = user_id, player = player}, function(faction)
                                faction.name= i
                                faction.css={top="75px",header_color="rgba(25525,0,0.75)"}
                        
                                faction["Add member"] = {function(player,data)
                                    vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                                        nuser_id = tonumber(nuser_id)
                                        local target = vRP.getUserSource(nuser_id)
                                        if target then
                                            vRP.addPlayerToFaction(nuser_id,i)
                                            vRPclient.notify(player,{"ID: "..nuser_id.." was added!"})
                                            vRPclient.notify(target,{"You're added in "..i.."!"})
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
                                            vRPclient.notify(player,{"ID: "..nuser_id.." was kicked!"})
                                            vRPclient.notify(target,{"You're kicked in "..i.."!"})
                                        else
                                            vRPclient.notify(player,{"Not in faction or offline!"})
                                        end
                                    end)
                                end}

                                faction["Set leader"] = {function(player,data)
                                    vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                                        nuser_id = tonumber(nuser_id)
                                        local target = vRP.getUserSource(nuser_id)
                                        if target and vRP.isPlayerInFaction(nuser_id,i) then
                                            vRP.setLeader(nuser_id)
                                            vRPclient.notify(player,{"ID: "..nuser_id.." is leader!"})
                                            vRPclient.notify(target,{"You're leader ("..i..")!"})
                                        else
                                            vRPclient.notify(player,{"Not in faction or offline!"})
                                        end
                                    end)
                                end}
                                
                                faction["Set rank"] = {function(player,data)
                                    vRP.prompt(player, "User ID:", "", function(player, nuser_id)
                                        nuser_id = tonumber(nuser_id)
                                        local target = vRP.getUserSource(nuser_id)
                                        if target and vRP.isPlayerInFaction(nuser_id,i) then
                                            vRP.buildMenu("ranks", {user_id = user_id, player = player}, function(ranks)
                                                ranks.name="Set Rank"
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
                        end
                    end
                    local lidermenu_leave = function(player,area)
                        vRP.closeMenu(player)
                    end
    
                    vRPclient.addMarker(source,{x,y,z-0.75,2.0,2.0,0.5, 200, 0, 45, 125, 100})
                    vRP.setArea(source,"vRP:faction"..i..j,x,y,z,1,1.5,lidermenu_enter,lidermenu_leave)
                end
            end
        end
    end
end

AddEventHandler("vRP:playerLoggedIn",function(source,user_id)
    if source ~= nil then
        build_client_lidermenu(source)
    end
end)

