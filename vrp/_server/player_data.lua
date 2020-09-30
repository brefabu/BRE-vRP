--TIME PLAYED
function vRP.getUserTimePlayed(id)
    return vRP.users[vRP.getUserSource(id)].data.time or 0
end

function vRP.updateUserTimePlayed(id,minutes)
    vRP.users[vRP.getUserSource(id)].data.time = vRP.getUserTimePlayed(id) + minutes
end

--HEALTH
function vRP.getHealth(id)
    return vRP.users[vRP.getUserSource(id)].data.health
end

function vRP.setHealth(id,value)
    vRP.users[vRP.getUserSource(id)].data.health = value

    TriggerClientEvent("vRP:set_health", vRP.getUserSource(id),value)
end

function vRP.varyHealth(id,value)
    local health

    if vRP.getHealth(id) - value <= 0 then
        health = 0
    elseif vRP.getHealth(id) - value >= 100 then
        health = 100
    else
        health = vRP.getHealth(id) - value
    end

    vRP.setHealth(id,health)
end

RegisterServerEvent("vRP:setHealth")
AddEventHandler("vRP:setHealth",function(value)
    if vRP.users[source] then
        local id = vRP.getUserId(source)

        vRP.setHealth(id,value)
    end
end)

RegisterServerEvent("vRP:resetHealth")
AddEventHandler("vRP:resetHealth",function()
    local id = vRP.getUserId(source)

    vRP.setHealth(id,100)
    vRP.setHunger(id,100)
    vRP.setThirst(id,100)
    TriggerEvent("vRP:playerSpawn",id,source,false)
end)

--HUNGER & THIRST
function vRP.getHunger(id)
    return vRP.users[vRP.getUserSource(id)].data.hunger
end

function vRP.getThirst(id)
    return vRP.users[vRP.getUserSource(id)].data.thirst
end

function vRP.setHunger(id,value)
    vRP.users[vRP.getUserSource(id)].data.hunger = value

    TriggerClientEvent("vRP:updateSurvivalGUI", vRP.getUserSource(id), vRP.getHunger(id), vRP.getThirst(id))
end

function vRP.setThirst(id,value)
    vRP.users[vRP.getUserSource(id)].data.thirst = value

    TriggerClientEvent("vRP:updateSurvivalGUI", vRP.getUserSource(id), vRP.getHunger(id), vRP.getThirst(id))
end

function vRP.varyHunger(id,value)
    local hunger = vRP.getHunger(id)

    if hunger - value < 0 then
        hunger = 0
    elseif hunger - value >= 100 then
        hunger = 100
    else
        hunger = hunger - value
    end

    vRPclient.isInComa(vRP.getUserSource(id),{},function(bool)
        if not bool then
            if hunger < 25 then
                vRP.varyHealth(id, 0.5)
            elseif hunger > 80 then
                vRP.varyHealth(id, -2.5)
            end
        end
    end)

    vRP.setHunger(id,hunger)
end

function vRP.varyThirst(id,value)
    local thirst = vRP.getThirst(id)

    if thirst - value < 0 then
        thirst = 0
    elseif thirst - value >= 100 then
        thirst = 100
    else
        thirst = thirst - value
    end

    vRPclient.isInComa(vRP.getUserSource(id),{},function(bool)
        if not bool then
            if thirst < 25 then
                vRP.varyHealth(id, 0.5)
            elseif thirst > 80 then
                vRP.varyHealth(id, -2.5)
            end
        end
    end)
    
    vRP.setThirst(id,thirst)
end

function task_update()
    for k,v in pairs(vRP.users) do
      vRP.varyHunger(v.id, math.random(1,3))
      vRP.varyThirst(v.id, math.random(1,3))

      
        if vRP.getHealth(v.id) < 15 then
            TriggerClientEvent("vRP:start_migrane", vRP.getUserSource(v.id))
        else
            TriggerClientEvent("vRP:stop_migrane", vRP.getUserSource(v.id))
        end
    end
  
    SetTimeout(60000,task_update)
end
task_update()

--USER DATA
function vRP.getUserData(id)
    return vRP.users[vRP.getUserSource(id)].data
end

function vRP.setUserData(id,data)
    vRP.users[vRP.getUserSource(id)].data = data
end

--POSITION
function vRP.getUserLastKnownPosition(id)
    return vRP.users[vRP.getUserSource(id)].data.position
end

function vRP.setUserPosition(id,x,y,z)
    vRP.users[vRP.getUserSource(id)].data.position = {x = x, y = y, z = z}
end

--CUSTOMIZATION
function vRP.getUserCustomization(id)
    return vRP.users[vRP.getUserSource(id)].data.customization
end

function vRP.setUserCustomization(id,data)
    vRP.users[vRP.getUserSource(id)].data.customization = data
end

--WEAPONS
function vRP.getUserWeapons(id)
    return vRP.users[vRP.getUserSource(id)].data.weapons
end

function vRP.setUserWeapons(id,data)
    vRP.users[vRP.getUserSource(id)].data.weapons = data
end

local config = module("config/player_state")

MySQL.createCommand("vRP/get_user_data","SELECT * FROM users WHERE id = @id")
MySQL.createCommand("vRP/set_user_data","UPDATE users SET data = @data WHERE id = @id")

AddEventHandler("vRP:playerSpawn", user_id, player, first_spawn)
    if first_spawn then
        if vRP.getUserData(user_id) == " " or vRP.getUserData(user_id) == "" or vRP.getUserData(user_id) == nil then
            vRP.setUserData(user_id,
                {
                    firstname = "Firstname",
                    name = "Name",
                    phone = vRP.generateStringNumber("+407DDDDDDDD"),
                    age = "18",
                    health = 100,
                    thirst = 100,
                    hunger = 100,
                    faction = " ",
                    faction_rank = " ",
                    role = "Fondator",
                    money = 2000,
                    bmoney = 700,
                    position = {
                        x = 0.0,
                        y = 0.0,
                        z = 0.0
                    }
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
                }
            )
            vRPclient.teleport(player, {config.spawn_position})
        end

        local position = vRP.users[player].data.position
        vRPclient.teleport(player, {position.x, position.y, position.z})
        TriggerClientEvent("vRP_C:playerSpawned",player,vRP.getUserCustomization(user_id))
        TriggerClientEvent("vRP:updateSurvival", player, vRP.getHunger(user_id), vRP.getThirst(user_id))
        TriggerClientEvent("vRP:loadWeapons", player, vRP.getUserWeapons(user_id))
    end
end)

--SQL REGISTER SAVE ~ Every 1min
AddEventHandler("vRP:save", function()
    for i,v in pairs(vRP.users) do
        vRPclient.getPosition(i, {}, function(x,y,z)
            vRP.setUserPosition(v.id,x,y,z)
            MySQL.execute("vRP/set_user_data",{data = json.encode(v.data),id = v.id})
        end)

        if DoesEntityExist(GetPlayerPed(vRP.getUserSource(v.id))) then
            vRP.updateUserTimePlayed(v.id,1)
        end
    end
end)

RegisterServerEvent("vRP:savePlayerIdentity")
AddEventHandler("vRP:savePlayerIdentity", function(firstname, name, age)
    local id = vRP.getUserId(source)
    local player = vRP.getUserSource(id)

    local data = vRP.getUserData(id)

    data.firstname = firstname
    data.name = name
    data.age = age

    vRP.setUserData(id,data)
end)

function vRP.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
    local abyte = string.byte("A")
    local zbyte = string.byte("0")
  
    local number = ""
    for i=1,#format do
      local char = string.sub(format, i,i)
      if char == "D" then number = number..string.char(zbyte+math.random(0,9))
      elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
      else number = number..char end
    end
  
    return number
end
