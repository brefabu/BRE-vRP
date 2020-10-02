MySQL.createCommand("vRP/create_user","INSERT INTO users(username,password,registered_date) VALUES(@username,@password,SYSDATE()); SELECT LAST_INSERT_ID() AS id")
MySQL.createCommand("vRP/login","SELECT * FROM users WHERE username = @username")
MySQL.createCommand("vRP/get_username","SELECT username FROM users WHERE username = @username")

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
      MySQL.ready(function()
        MySQL.query("vRP/login", {username = username}, function(registered, affected)
          Wait(256)
          if #registered == 0 then
            Wait(256)
            vRPclient.notify(player,{"You registered with success!"})
            MySQL.execute("vRP/create_user",{username = username, password = sha2.sha256(password)})
          else
            vRPclient.notify(player,{"You're already registered!"})
          end
        end)
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
  while not MySQL.isReady() do
    Wait(500)
  end
  while true do
    Wait(128)

    local iterator = 0
    while iterator <= #vRP.requests do
      Wait(128)
      iterator = iterator + 1
      Wait(128)
      if iterator <= #vRP.requests then
        Wait(256)
        if not vRP.requests[iterator].passed then
          Wait(2048)
          vRP.requests[iterator].passed = true
          Wait(256)
          local user = vRP.requests[iterator]
          if user.source ~= nil then
            Wait(256)
            MySQL.query("vRP/login", {username = user.username}, function(rows, affected)
              Wait(256)
              if #rows > 0 then
                Wait(256)
                if sha2.sha256(user.password) == rows[1].password then
                  Wait(256)
                  if not rows[1].banned then
                    Wait(256)
                    if not (config.whitelist and rows[1].whitelisted) or (not config.whitelist) then
                      Wait(256)
                      TriggerClientEvent("vRP:",user.source)
                      Wait(256)
                      vRP.users[user.source] = {id = tonumber(rows[1].id),username = rows[1].username,data = json.decode(rows[1].data)}
                      Wait(256)
                      TriggerEvent("vRPcli:playerLetIn", user.source, tonumber(rows[1].id))
                      Wait(256)
                      Wait(256)
                      vRPclient.notify(user.source,{"Welcome on "..config.server_name.."!"})
                      Wait(256)
                      print("vRP | "..user.username.." ( source = "..user.source.." ) logged in! ( user_id = "..rows[1].id.." )")
                    else
                      Wait(256)
                      vRPclient.notify(user.source,{"You're not on the whitelist!"})
                      Wait(256)
                      vRP.requests[iterator] = nil
                      print("vRP | "..user.username.." ( source = "..user.source.." ) refused! WHITELIST ON ( user_id = "..rows[1].id.." )")
                    end
                  else
                    Wait(256)
                    vRPclient.notify(user.source,{"This account is blocked!"})
                    Wait(256)
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
        MySQL.execute("vRP/set_user_data",{data = json.encode(vRP.users[source].data),id = vRP.users[source].id})
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
