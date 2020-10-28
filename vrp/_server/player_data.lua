--TIME PLAYED
function vRP.getUserTimePlayed(id)
    return vRP.users[vRP.getUserSource(id)].data.time
end

function vRP.updateUserTimePlayed(id,minutes)
    vRP.users[vRP.getUserSource(id)].data.time = vRP.getUserTimePlayed(id) + minutes
end

--HEALTH
function vRP.getHealth(id)
    return vRP.users[vRP.getUserSource(id)].data.survival.health
end

function vRP.setHealth(id,value)
    vRP.users[vRP.getUserSource(id)].data.survival.health = value

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
    return vRP.users[vRP.getUserSource(id)].data.survival.hunger
end

function vRP.getThirst(id)
    return vRP.users[vRP.getUserSource(id)].data.survival.thirst
end

function vRP.setHunger(id,value)
    vRP.users[vRP.getUserSource(id)].data.survival.hunger = value

    TriggerClientEvent("vRP:updateSurvival", vRP.getUserSource(id), {hunger = value, thirst = vRP.getThirst(id)})
end

function vRP.setThirst(id,value)
    vRP.users[vRP.getUserSource(id)].data.survival.thirst = value

    TriggerClientEvent("vRP:updateSurvival", vRP.getUserSource(id), {hunger = vRP.getHunger(id), value})
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
      vRP.varyHunger(v.id, 1)
      vRP.varyThirst(v.id, 1)
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

--WEAPONS
function vRP.getUserWeapons(id)
    return vRP.users[vRP.getUserSource(id)].data.weapons
end

function vRP.setUserWeapons(id,data)
    vRP.users[vRP.getUserSource(id)].data.weapons = data
end

--CUSTOMIZATION
function vRP.getUserCustomization(id)
    return vRP.users[vRP.getUserSource(id)].data.customization
end

function vRP.setUserCustomization(id,data)
    vRP.users[vRP.getUserSource(id)].data.customization = data
end

MySQL.createCommand("vRP/get_user_data","SELECT * FROM users WHERE id = @id")
MySQL.createCommand("vRP/set_user_data","UPDATE users SET data = @data WHERE id = @id")

AddEventHandler("vRP:playerSpawn", function(user_id, player, first_spawn)
    if first_spawn then
        local position = vRP.users[player].data.position
        vRPclient.teleport(player, {position.x, position.y, position.z})
        TriggerClientEvent("vRP:updateSurvival", player, {hunger =  vRP.getHunger(user_id), thirst = vRP.getThirst(user_id)})
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

        vRP.updateUserTimePlayed(v.id,1)
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
