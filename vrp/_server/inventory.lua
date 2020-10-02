MySQL.createCommand("vRP/add_inventory","INSERT INTO inventories(id, data) VALUES(@id,@data)")
MySQL.createCommand("vRP/get_inventory_data","SELECT * FROM inventories WHERE id = @id")
MySQL.createCommand("vRP/set_inventory_data","UPDATE inventories SET data = @data WHERE id = @id")
MySQL.createCommand("vRP/get_inventories","SELECT * FROM inventories")

vRP.inventories = {}

MySQL.ready(function()
    MySQL.query("vRP/get_inventories", {}, function(result, data)
        if #result > 0 then
            for i,v in pairs(result) do
                vRP.inventories[v.id] = json.decode(v.data)
            end
        end
    end)
end)

function vRP.addInventory(id,weight)
    vRP.inventories[id] = { items = {}, weight = weight}

    MySQL.execute("vRP/add_inventory", {id = id,data = json.encode(vRP.inventories[id])})
end

function vRP.getInventory(identificator)
    return vRP.inventories[identificator] or false
end

function vRP.checkInventory(identificator)
    if vRP.inventories[identificator] then
        return true
    else
        return false
    end
end

function vRP.setInventory(identificator,data)
  vRP.inventories[identificator] = data
end

function vRP.giveInventoryItem(identificator, item, amount)
    local inventory = vRP.getInventory(identificator)

    if inventory.items[item] ~= nil then
        inventory.items[item] = inventory.items[item] + amount
    else
        inventory.items[item] = amount
    end

    vRP.setInventory(identificator,inventory)
end

function vRP.tryGetInventoryItem(identificator, item, amount)
    local inventory = vRP.getInventory(identificator)

    if inventory.items[item] and inventory.items[item] >= amount then
        inventory.items[item] = inventory.items[item] - amount

        vRP.setInventory(identificator,inventory)
        return true
    end

    return false
end

function vRP.getInventoryWeight(identificator)
    local inventory = vRP.getInventory(identificator)
    local weight = 0
    
    if #inventory.items then
        for i,v in pairs(inventory.items) do
            weight = weight + v * vRP.getItemWeight(i)
        end
    end

    return weight
end

function vRP.getInventoryMaxWeight(identificator)
    local inventory = vRP.getInventory(identificator)
    
    return inventory.weight
end

AddEventHandler("vRP:playerLoggedIn", function(source, id, data)
    if source ~= nil and id ~= nil then 
        if not vRP.checkInventory("player:"..id) then
            print("generated inventory for player with id: "..id)
            vRP.addInventory("player:"..id,30)
        end
    end
end)

function vRP.gainStrenght(strenght)
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)

    vRP.inventories["player:"..user_id].weight = vRP.inventories["player:"..user_id].weight + strenght
end

--SQL REGISTER SAVE ~ Every 1min
AddEventHandler("vRP:save", function()
    for i,v in pairs(vRP.inventories) do
        MySQL.execute("vRP/set_inventory_data",{data = json.encode(v),id = i})
    end
end)

