function vRP.getMoney(id)
  return vRP.users[vRP.getUserSource(id)].data.money.wallet
end

function vRP.getBankMoney(id)
  return vRP.users[vRP.getUserSource(id)].data.money.bank
end

function vRP.setMoney(id,amount)
  vRP.users[vRP.getUserSource(id)].data.money.wallet = amount

  TriggerClientEvent("vRP:updateMoney", vRP.getUserSource(id),vRP.getMoney(id))
end

function vRP.setBankMoney(id,amount)
  vRP.users[vRP.getUserSource(id)].data.money.bank = amount
end

function vRP.giveMoney(id,amount)
  vRP.setMoney(id,vRP.getMoney(id) + amount)
end

function vRP.giveBankMoney(id,amount)
  vRP.setBankMoney(id,vRP.getBankMoney(id) + amount)
end

function vRP.tryPayment(id,amount)
  if vRP.getMoney(id) > amount then
      vRP.setMoney(id,vRP.getMoney(id) - amount)
      return true
  end

  return false
end

function vRP.tryBankPayment(id,amount)
  if vRP.getBankMoney(id) > amount then
      vRP.setMoney(id,vRP.getBankMoney(id) - amount)
      return true
  end

  return false
end

function vRP.tryFullPayment(id,amount)
  local money = vRP.getMoney(id)
  print(id,money)

  if money >= amount then
    return vRP.tryPayment(id, amount)
  else
    if vRP.tryBankPayment(id,amount - money) then
      return vRP.tryPayment(id, amount)
    end
  end

  return false
end

AddEventHandler("vRP:playerSpawn", function(user_id, player, first_spawn)
  if first_spawn then
      TriggerClientEvent("vRP:updateMoney", player, vRP.getMoney(user_id))
  end
end)