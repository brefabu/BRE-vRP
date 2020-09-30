function vRP.addInsurance(plate)
    vRP.vehicles[plate].insurance = true
end
  
function vRP.expireInsurance(plate)
    vRP.vehicles[plate].insurance = false
end
  
function vRP.hasInsurance(plate)
    return vRP.vehicles[plate].insurance
end
  