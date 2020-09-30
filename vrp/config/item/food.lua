-- define some basic inventory items

local items = {}

local function play_eat(player)
  local seq = {
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function gen(player, vary_hunger, vary_thirst)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
    if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end
  end
end

items["donut"] = {"Donut","", function(user_id)
  gen(vRP.getUserSource(user_id),-5.0,0) 
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Eat."})
  play_eat(vRP.getUserSource(user_id))
end,0.1}

items["chocolate"] = {"Chocolate","", function(user_id)
  gen(vRP.getUserSource(user_id),-15.0,0)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Eat."})
  play_eat(vRP.getUserSource(user_id))
end,0.1}

items["apple"] = {"Apple","", function(user_id)
  gen(vRP.getUserSource(user_id),-5.0,0)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Eat."})
  play_eat(vRP.getUserSource(user_id))
end,0.1}

items["bread"] = {"Bread","", function(user_id)
  gen(vRP.getUserSource(user_id),-5.0,0)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Eat."})
  play_eat(vRP.getUserSource(user_id))
end,0.5}

items["water"] = {"Water","", function(user_id)
  gen(vRP.getUserSource(user_id),0,-25.0)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Drink."})
  play_drink(vRP.getUserSource(user_id))
end,0.5}
items["cola"] = {"Coca Cola","", function(user_id)
  gen(vRP.getUserSource(user_id),0,-12.5)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Drink."})
  play_drink(vRP.getUserSource(user_id))
end,0.33}

items["beer"] = {"Heineken","", function(user_id)
  gen(vRP.getUserSource(user_id),0,-15)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Drink."})
  play_drink(vRP.getUserSource(user_id))
end,0.33}
items["whiskey"] = {"Whiskey","", function(user_id)
  gen(vRP.getUserSource(user_id),0,-50)
  vRPclient.notify(vRP.getUserSource(user_id),{"~o~ Drink."})
  play_drink(vRP.getUserSource(user_id))
end,1}

return items
