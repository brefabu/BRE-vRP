AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        Citizen.CreateThread(function()
            while true do
                Wait(3600000)
                if vRP.getUserSource(user_id) ~= nil then
                    if vRP.isPlayerInAnyFaction(user_id) then
                        local salary = vRP.getSalaryFaction(user_id)
                        if salary > 0 then
                            vRPclient.notifyPicture(source, {"CHAR_BANK_MAZE", 9, "Bank | ~g~Salary", false, "~w~Wow, salary is here braaah. ( ~g~"..salary.." Euro~w~ )"})
                            vRP.giveBankMoney(user_id,salary)
                        end
                    end
                    vRP.giveGifts(user_id,math.random(1,3))
                else
                    break
                end
            end
        end)
    end
end)