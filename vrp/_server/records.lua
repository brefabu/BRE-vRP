function vRP.getRecords(user_id)
  return vRP.users[user_id].data.records
end

function vRP.insertRecord(user_id,reason)
  vRP.users[user_id].data.records = vRP.getRecords(user_id).."<br>"..reason
end

function vRP.removeRecord(user_id)
  vRP.users[user_id].data.records = vRP.getRecords(user_id):sub(vRP.getRecords(user_id):find("<br>")+4,vRP.getRecords(user_id):len())
end

vRP.registerMenuBuilder("police", function(add, data)
    local player = data.player
  
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
        local choices = {}

        choices["Check record"] = {function(player,choice)
            vRPclient.getNearestPlayers(player,{5},function(nplayers)
                usrList = ""
                for k,v in pairs(nplayers) do
                  usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                end
                if usrList ~= "" then
                  vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
                    if nuser_id ~= nil and nuser_id ~= "" then 
                      local nplayer = vRP.getUserSource(tonumber(nuser_id))
                        if nplayer ~= nil then
                            vRP.buildMenu("record", {player = player}, function(menu)
                              menu.name = "record"
                              menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

                              nuser_id = tonumber(nuser_id)
                              local identity = vRP.users[nplayer].data
                              menu["Record"] = {nil,"Name: "..identity.name.."<br>Firstname: "..identity.firstname.."<br>"..vRP.getRecords(nuser_id)}
                              
                              vRP.openMenu(player,menu)
                            end)
                        else
                          vRPclient.notify(player,{"Not online anymore!"})
                        end
                    end
                  end)
                else
                  vRPclient.notify(player,{"Not online!"})
                end
              end)
        end}
        add(choices)
    end
end)