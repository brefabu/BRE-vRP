function vRP.hasVisa(user_id)
    return vRP.users[vRP.getUserSource(user_id)].data.visa
end

function vRP.acceptVisa(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.visa = true
end

function vRP.refuseVisa(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.visa = false
end
