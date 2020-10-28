vRP.MySQL.createCommand("create_user","INSERT INTO users(username,password,email,registered_date) VALUES(@username,@password,@email,SYSDATE()); SELECT LAST_INSERT_ID() AS id")
vRP.MySQL.createCommand("login","SELECT * FROM users WHERE username = @username")
vRP.MySQL.createCommand("get_username","SELECT username FROM users WHERE username = @username")

local config = module("config/base")

--Setting the login request qeue
RegisterServerEvent("vRP:Request")
AddEventHandler("vRP:Request",function(action,username,password,email)
  local player = source

  if action == "login" then
    local passed = false

    if #vRP.requests > 0 then
      for i,v in pairs(vRP.requests) do
        if v.source == player and v.username == username and v.password == password then
          passed = true
        end
      end
    end

    if not passed then
      table.insert(vRP.requests,{source = player,username = username,password = password,passed = false})
      Wait(256)
    else
      vRPclient.notify(player,{"Already introduced this account!"})
    end

  elseif action == "register" then
    username = sanitizeString(username, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.:_!#$()[]{}<>'", true)
    Wait(256)
    password = sanitizeString(password, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789,.:_!#$()[]{}<>'", true)
    Wait(256)

    if validemail(email) then
      if username:len() >= 3 then
        Wait(256)
        if password:len() >= 4 then
          Wait(256)
          vRP.MySQL.query("login", {username = username}, function(registered, affected)
            Wait(256)
            if #registered == 0 then
              Wait(256)
              vRP.MySQL.execute("create_user",{username = username, password = sha2.sha256(password), email = email})
              vRPclient.notify(player,{"You're successfully registered!"})
            end
          end)
        end
      else
        vRPclient.notify(player,{"Invalid password!"})
      end
    else
      vRPclient.notify(player,{"Invalid username!"})
    end
  else
    vRPclient.notify(player,{"Inval email!"})
  end
end)

RegisterServerEvent("vRP:playerLoggedIn")


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
            vRP.MySQL.query("login", {username = user.username}, function(rows, affected)
              if #rows > 0 then
                if sha2.sha256(user.password) == rows[1].password then
                  if not rows[1].banned then
                    if not (config.whitelist and rows[1].whitelisted) or (not config.whitelist) then
                      TriggerClientEvent("vRP:playerLetIn",user.source)
                      local data = "[]"
                      if rows[1].data ~= "[]" then
                        data = rows[1].data
                      end
                      vRP.users[user.source] = {id = tonumber(rows[1].id),username = rows[1].username,data = json.decode(data)}
                      vRPclient.logInPlayer(user.source)
                      TriggerEvent("vRP:playerLoggedIn",user.source, tonumber(rows[1].id), json.decode(data))
                      Wait(256)
                      vRPclient.notify(user.source,{"Welcome on "..config.server_name.."!"})
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

local cfg = module("config/player_state")
local slots = 0

AddEventHandler("vRP:playerLoggedIn", function(source, user_id, data)
  if json.encode(data) == "[]" then
    local position = cfg.spawn_position
    vRP.users[source].data = {
      role = "Player",
      time = 0,
      identity = {
        firstname = "Firstname",
        name = "Name",
        phone = vRP.generateStringNumber("+407DDDDDDDD"),
        age = "18"
      },
      survival = {
        health = 100,
        thirst = 100,
        hunger = 100
      },
      faction = {
        name = " ",
        rank = " "
      },
      money = {
        wallet = 2000,
        bank = 700
      },
      position = {
        x = position[1],
        y = position[2],
        z = position[3]
      },
      licenses = {
        driveLicenses = {a = false,b = false, c = false, d = false},
        visa = false,
      },
      weapons = {},
      customization = {}
    }
  end
  
  slots = slots + 1
  TriggerClientEvent("vRP:updateSlots", -1, slots)
  TriggerEvent("vRP:playerSpawn",user_id,source,true)
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
  
    if source ~= nil and vRP.users[source] ~= nil then
        TriggerEvent("vRP:playerLeave", vRP.users[source].id, source)
        vRP.MySQL.execute("vRP/set_user_data",{data = json.encode(vRP.users[source].data),id = vRP.users[source].id})
        print("[vRP] "..vRP.getPlayerEndpoint(source).." disconnected ( user_id = "..vRP.users[source].id.." )")
        vRP.users[source] = nil
        slots = slots - 1
        TriggerClientEvent("vRP:updateSlots", -1, slots)
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
