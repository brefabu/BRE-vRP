local items = {}

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function play_smoke(player)
  local seq2 = {
    {"mp_player_int_uppersmoke","mp_player_int_smoke_enter",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke",1},
    {"mp_player_int_uppersmoke","mp_player_int_smoke_exit",1}
  }

  vRPclient.playAnim(player,{true,seq2,false})
end

local function play_smell(player)
  local seq3 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq3,false})
end

local function play_lsd(player)
  local seq4 = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq4,false})
end

items["pills"] = {
  "Pastila","O simpla medicamentatie.",
  function(user_id)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)    
          if not in_coma then
            if vRP.tryGetInventoryItem(user_id,"pills",1) then
              vRPclient.varyHealth(player,{25})
              vRPclient.notify(player,{"~g~Ai luat pastile."})
              play_drink(player)
            end
          end    
      end)
    end
  end,0.1
}

items["lsd"] = {
  "LSD","LSD :*.",
  function(user_id)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)    
          if not in_coma then
            if vRP.tryGetInventoryItem(user_id,"lsd",1) then
              vRPclient.varyHealth(player,{25})
              vRPclient.notify(player,{"~g~You took LSD."})
              play_lsd(player)
            end
          end    
      end)
    end
  end,0.1
}

items["cocaine"] = {
  "Cocaine","Some cocaine :*",
  function(user_id) 
    if vRP.tryGetInventoryItem(user_id,"cocaine",1) then 
      vRP.varyThirst(user_id,(20)) 
      vRPclient.notify(player,{"~g~You took drouuugs maaan."}) 
      play_smell(player) 
    end
  end,0.5
}

items["canabis"] = {
  "Canabis","Herbs :))",
  function(user_id)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)    
          if not in_coma then
            if vRP.tryGetInventoryItem(user_id,"canabis",1) then
              vRPclient.varyHealth(player,{25})
              vRPclient.notify(player,{"~g~You took some green."})
              play_smell(player)
            end
          end    
      end)
    end
  end,0.1
}

items["heroine"] = {
  "Heroine","Dust ^^",
  function(user_id)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)    
          if not in_coma then
            if vRP.tryGetInventoryItem(user_id,"heroine",1) then
              vRPclient.varyHealth(player,{25})
              vRPclient.notify(player,{"~g~You're messy now."})
              play_smell(player)
            end
          end    
      end)
    end
  end,0.1
}

items["extasy"] = {
  "Extasy","Fuckening FUK :*.",
  function(user_id)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)    
          if not in_coma then
            if vRP.tryGetInventoryItem(user_id,"extasy",1) then
              vRPclient.varyHealth(player,{25})
              vRPclient.notify(player,{"~g~WOAAAAAAh, that's good as hell."})
              play_smell(player)
            end
          end    
      end)
    end
  end,0.1
}

return items
