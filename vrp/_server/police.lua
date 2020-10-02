local config = module("config/fines")

local choice_handcuff = {function(player,choice)
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
            vRPclient.toggleHandcuff(nplayer,{})
          else
            vRPclient.notify(player,{"Not online!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

local choice_putinveh = {function(player,choice)
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
            vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
              if handcuffed then
                vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
              else
                vRPclient.notify(player,{"Not handcuffed!"})
              end
            end)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

local choice_getoutveh = {function(player,choice)
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
            vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
              if handcuffed then
                vRPclient.ejectVehicle(nplayer, {})
              else
                vRPclient.notify(player,{"Not handcuffed!"})
              end
            end)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

local choice_askid = {function(player,choice)
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
            vRP.request(nplayer,"Show id?",15,function(nplayer,ok)
              if ok then
                vRP.getUserIdentity(tonumber(nuser_id), function(identity)

                  if identity then
                    vRP.buildMenu("askid", {player = player}, function(menu)
                      menu.name = "askid"
                      menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
            
                      menu["See ID CARD"] = {nil,"Name: "..identity.name.."<br>Firstname: "..identity.firstname.."<br>Age: "..identity.age.."<br>Phone: "..identity.phone}
            
                      vRP.openMenu(player,menu)
                      vRPclient.notify(player,{"You see the id card now!"})
                    end)
                  end
                end)
              end
            end)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

local choice_fine = {function(player, choice)
  vRPclient.getNearestPlayers(player,{5},function(nplayers)
    usrList = ""
    for k,v in pairs(nplayers) do
      usrList = usrList .. "[" .. vRP.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
    end
    if usrList ~= "" then
      vRP.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,nuser_id) 
        if user_id ~= " " and user_id ~= nil and tonumber(nuser_id) > 0 then 
          local nplayer = vRP.getUserSource(tonumber(nuser_id))
          if nplayer ~= nil then
            -- build fine menu
            local menu = {name="Fines",css={top="75px",header_color="rgba(0,125,255,0.75)"}}

            local choose = function(player,choice)
              local amount = config.fines[choice]
              if amount ~= nil then
                if vRP.tryFullPayment(tonumber(nuser_id), amount) then
                  vRPclient.notify(player,{"Fined for "..choice.."!"})
                  vRPclient.notify(nplayer,{"Fined for "..choice.."!"})
                  vRP.insertRecord(tonumber(nuser_id),"Fined for "..choice..".")
                  vRP.closeMenu(player)
                end
              end
            end

            for k,v in pairs(config.fines) do -- add fines in function of money available
              menu[k] = {choose,v}
            end

            -- open menu
            vRP.openMenu(player, menu)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

local choice_check = {function(player,choice)
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
            vRP.request(nplayer,"Accept be checked?",15,function(nplayer,ok)
              if ok then
                local identity = vRP.users[nplayer].data

                if identity then
    
                  vRP.buildMenu("check", {player = player}, function(menu)
                    menu.name = "check"
                    menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
          
                    menu["See id"] = {nil,"Name: "..identity.name.."<br>Firstname: "..identity.firstname.."<br>Age: "..identity.age.."<br>Phone: "..identity.phone}
                    
                    menu["See money"] = {nil,"Wallet: "..vRP.getMoney(tonumber(nuser_id)).."<br>Bank: "..vRP.getBankMoney(tonumber(nuser_id))}
    
                    menu["See inventory"] = {function(player,choice)
                      vRP.openInventoryToPlayer(nplayer,player)
                    end}
                    vRP.openMenu(player,menu)
                  end)
                end
              else
                vRPclient.notify(player,{"He refused!"})
              end
            end)
          else
            vRPclient.notify(player,{"Not online anymore!"})
          end
        end
      end)
    else
      vRPclient.notify(player,{"Nobody here!"})
    end
  end)
end}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if vRP.isPlayerInFaction(user_id,"Police")or vRP.isPlayerInFaction(user_id,"Embassy") then
      -- build police menu
      choices["Police Menu"] = {function(player,choice)
        vRP.buildMenu("police", {player = player}, function(menu)
          menu.name = "Police Menu"
          menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
          
          if vRP.isPlayerInFaction(user_id,"M.A.I.") then
            menu["Cuff"] = choice_handcuff
            menu["Put in vehicle"] = choice_putinveh
            menu["Kick from vehicle"] = choice_getoutveh
            menu["Check"] = choice_check
            menu["Fine"] = choice_fine
          end
          menu["Ask for visa"] = choice_viza

          vRP.openMenu(player,menu)
        end)
      end}
    end

    --if vRP.isInMafia(user_id,"Mafia") then
    --  choices["Mafia menu"] = {function(player,choice)
    --    vRP.buildMenu("mafia", {player = player}, function(menu)
    --      menu.name = "Mafia menu"
    --      menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

    --      menu["Cuff"] = choice_handcuff
    --      menu["Put in vehicle"] = choice_putinveh
    --      menu["Kick from vehicle"] = choice_getoutveh

    --      vRP.openMenu(player,menu)
    --    end)
    --  end}
    --end
    
    add(choices)
  end
end)

-- add player give money to main menu
vRP.registerMenuBuilder("interaction", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    
    if not vRP.isPlayerInFaction(user_id,"Police") then
      choices["Check"] = choice_check
    end

    add(choices)
  end
end)
