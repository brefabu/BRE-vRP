vRP.MySQL.createCommand("vRP/create_user","INSERT INTO users(username,password,data,registered_date) VALUES(@username,@password,@data,SYSDATE()); SELECT LAST_INSERT_ID() AS id")
vRP.MySQL.createCommand("vRP/login","SELECT * FROM users WHERE username = @username")
vRP.MySQL.createCommand("vRP/get_username","SELECT username FROM users WHERE username = @username")

local config = module("config/base")

--Setting the login request qeue
RegisterServerEvent("vRP:checkLogin")
AddEventHandler("vRP:checkLogin",function(username,password)
  local passed = false
  if #vRP.requests > 0 then
    for i,v in pairs(vRP.requests) do
      if v.source == source and v.username == username and v.password == password then
        passed = true
      end
    end
  end

  if not passed then
    table.insert(vRP.requests,{source = source,username = username,password = password,passed = false})
    vRPclient.notify(source,{"Wait to check your account!"})
    Wait(256)
  else
    vRPclient.notify(source,{"You already introduced this account!"})
  end
end)

RegisterServerEvent("vRP:checkRegister")
AddEventHandler("vRP:checkRegister",function(username,password)
  local player = source
  
  username = sanitizeString(username, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.:_!#$()[]{}<>'", true)
  Wait(256)
  password = sanitizeString(password, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.:_!#$()[]{}<>'", true)
  Wait(256)

  if username:len() >= 3 then
    Wait(256)
    if password:len() >= 4 then
      Wait(256)
      vRP.MySQL.query("vRP/login", {username = username}, function(registered, affected)
        Wait(256)
        if #registered == 0 then
          Wait(256)
          vRPclient.notify(player,{"You registered with success!"})
          vRP.MySQL.execute("vRP/create_user",{username = username, password = sha2.sha256(password), data = json.encode({
                  firstname = "Firstname",
                  name = "Name",
                  phone = vRP.generateStringNumber("+407DDDDDDDD"),
                  age = "18",
                  health = 100,
                  thirst = 100,
                  hunger = 100,
                  faction = " ",
                  faction_rank = " ",
                  role = "Player",
                  money = 2000,
                  bmoney = 700,
                  position = {
                      x = 0.0,
                      y = 0.0,
                      z = 0.0
                  },
                  license_A = false,
                  license_B = false,
                  license_C = false,
                  visa = false,
                  weapons = {},
                  customization = {
                      prop_glasses_text = 0,
                      beard = 0,
                      torso = 0,
                      prop_glasses = 0,
                      prop_earrings = 0,
                      wrinkleopacity = 0,
                      leg = 0,
                      eyebrowopacity = 0,
                      dadmumpercent = 5,
                      undershirttext = 0,
                      torsotext = 0,
                      legtext = 0,
                      shoestext = 0,
                      eyebrow = 0,
                      freckle = 0,
                      skinproblem = 0,
                      prop_hat_text = 0,
                      shoes = 0,
                      beardcolor = 0,
                      prop_hat = 0,
                      prop_watches_text = 0,
                      beardopacity = 0,
                      torso2text = 0
                      ,acne = 0,
                      mum = 0,
                      wrinkle = 0,
                      accessory = 0,
                      hair = 0,
                      eyecolor = 0,
                      accessorytext = 0,
                      prop_earrings_text = 0,
                      dad = 0,
                      skin = 0,
                      prop_watches = 0,
                      undershirt = 0,
                      torso2 = 0,
                      haircolor = 0
                  }
              })})
        else
          vRPclient.notify(player,{"You're already registered!"})
        end
      end)
    else
      vRPclient.notify(player,{"Password is too short!"})
    end
  else
    vRPclient.notify(player,{"User name is too short!"})
  end
end)

RegisterServerEvent("vRP:playerLoggedIn")

Citizen.CreateThread(function()
  while true do
    Wait(128)
    local iterator = 0
    while iterator <= #vRP.requests do
      iterator = iterator + 1
      if iterator <= #vRP.requests then
        if not vRP.requests[iterator].passed then
          vRP.requests[iterator].passed = true
          local user = vRP.requests[iterator]
          if user.source ~= nil then
            vRP.MySQL.query("vRP/login", {username = user.username}, function(rows, affected)
              if #rows > 0 then
                if sha2.sha256(user.password) == rows[1].password then
                  Wait(256)
                  if not rows[1].banned then
                    Wait(256)
                    if not (config.whitelist and rows[1].whitelisted) or (not config.whitelist) then
                      TriggerClientEvent("vRP:playerLetIn",user.source)
                      vRP.users[user.source] = {id = tonumber(rows[1].id),username = rows[1].username,data = json.decode(rows[1].data)}
                      TriggerEvent("vRP:playerSpawn",tonumber(rows[1].id),user.source,true)
                      TriggerClientEvent("vRPcli:playerLetIn",user.source)
                      TriggerEvent("vRP:playerLoggedIn",user.source, tonumber(rows[1].id), rows[1].data)
                      vRPclient.notify(user.source,{"Welcome on "..config.server_name.."!"})
                      Wait(256)
                      print("vRP | "..user.username.." ( source = "..user.source.." ) logged in! ( user_id = "..rows[1].id.." )")
                    else
                      vRPclient.notify(user.source,{"You're not on the whitelist!"})
                      vRP.requests[iterator] = nil
                      print("vRP | "..user.username.." ( source = "..user.source.." ) refused! WHITELIST ON ( user_id = "..rows[1].id.." )")
                    end
                  else
                    vRPclient.notify(user.source,{"This account is blocked!"})
                    vRP.requests[iterator] = nil
                    print("vRP | "..user.username.." ( source = "..user.source.." ) refused! BANNED ( user_id = "..rows[1].id.." )")
                  end
                else
                  vRPclient.notify(user.source,{"Credentials are wrong!"})
                  vRP.requests[iterator] = nil
                end
              else
                vRPclient.notify(user.source,{"Credentials are wrong!"})
                vRP.requests[iterator] = nil
              end
            end)
          end
        end
      end
    end
  end
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
  
    if source ~= nil and vRP.users[source] ~= nil then
        TriggerEvent("vRP:playerLeave", vRP.users[source].id, source)
        vRP.MySQL.execute("vRP/set_user_data",{data = json.encode(vRP.users[source].data),id = vRP.users[source].id})
        print("[vRP] "..vRP.getPlayerEndpoint(source).." disconnected ( user_id = "..vRP.users[source].id.." )")
        vRP.users[source] = nil
    end
end)
  
RegisterServerEvent("vRP:playerSpawn")
RegisterServerEvent("vRPcli:playerDied")
  
RegisterServerEvent("vRPcli:playerSpawn")
AddEventHandler("vRPcli:playerSpawn", function()
    local user_id = vRP.getUserId(source)
    local player = source
    
    SetTimeout(2000, function()
        TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)
    end)
end)
  
AddEventHandler("vRPcli:playerDied", function()
    local user_id = vRP.getUserId(source)
    local player = source
    
    SetTimeout(2000, function()
        TriggerEvent("vRP:playerDied",user_id,player)
    end)
end)
