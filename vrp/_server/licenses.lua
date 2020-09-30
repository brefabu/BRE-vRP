--setters
function vRP.giveDriveLicenseTypeA(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.permis_A = true
end

function vRP.giveDriveLicenseTypeB(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.permis_B = true
end

function vRP.giveDriveLicenseTypeC(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.permis_C = true
end

function vRP.giveDriveLicenseTypeD(user_id)
    vRP.users[vRP.getUserSource(user_id)].data.permis_D = true
end

--checkers
function vRP.hasDriveLicenseTypeA(user_id)
    return vRP.users[vRP.getUserSource(user_id)].data.permis_A
end

function vRP.hasDriveLicenseTypeB(user_id)
    return vRP.users[vRP.getUserSource(user_id)].data.permis_B
end

function vRP.hasDriveLicenseTypeC(user_id)
    return vRP.users[vRP.getUserSource(user_id)].data.permis_C
end

function vRP.hasDriveLicenseTypeD(user_id)
    return vRP.users[vRP.getUserSource(user_id)].data.permis_D
end
