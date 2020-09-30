--[[
========================================================
=============== PROJECT: vRP Gym =======================
=============== SCRIPTER: DGVaniX ======================
=============== DATE: 03/11/2018 =======================
========================================================
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_gym")
vRPCgym = Tunnel.getInterface("vRP_gym","vRP_gym")

vRPgym = {}
Tunnel.bindInterface("vRP_gym",vRPgym)
Proxy.addInterface("vRP_gym",vRPgym)

members = {}

gymTable = {
	["biceps1"] = {-1198.9050, -1564.1252, 4.1115, "Z-Bar (Biceps)"},
	["biceps2"] = {-1210.0610, -1560.6418, 4.1115, "Z-Bar (Biceps)"},
	["biceps3"] = {2010.5832519531,3730.6577148438,31.816825866699, "Z-Bar (Biceps)"},
	["biceps4"] = {2008.9549560547,3733.4360351563,31.927688598633, "Z-Bar (Biceps)"},
	["abd1o"] = {-1197.7672, -1571.3300, 4.1115, "Crunches"},
	["abdo2"] = {2019.7344970703,3737.7453613281,32.171237945557, "Crunches"},
	["yoga1"] = {-1204.2547, -1556.8259, 4.1115, "Yoga"},
	["yoga2"] = {2016.0812988281,3740.958984375,32.109794616699, "Yoga"},
	["yoga3"] = {2014.6358642578,3739.8918457031,32.084732055664, "Yoga"},
	["tractiuni1"] = {-1200.1284, -1570.9903, 4.1115, "Pull-Ups"},
	["tractiuni2"] = {-1204.7150, -1564.3831, 4.1115, "Pull-Ups"},
	["flotari1"] = {-1194.1945, -1570.1912, 4.1115, "Push-Ups"},
	["flotari2"] = {2016.4188232422,3736.0473632813,31.954528808594, "Push-Ups"},
	["flotari3"] = {2018.0377197266,3737.0197753906,31.969802856445, "Push-Ups"},
	["bench1"] = {-1197.1033, -1567.5870, 4.1115, "Bench"},
	["bench2"] = {-1200.6325, -1575.8344, 4.1115, "Bench"},
	["bench3"] = {-1206.4871, -1561.5948, 4.1115, "Bench"},
	["bench4"] = {-1201.4362, -1562.7670, 4.1115, "Bench"},
	["bench5"] = {2025.8247070313,3737.7907714844,31.970390319824, "Bench"},
	["bench6"] = {2022.6127929688,3735.5290527344,31.939460754395, "Bench"},
	["bench7"] = {2019.3862304688,3733.6791992188,31.907228469849, "Bench"}
}

theGym = {-1195.4376, -1577.6749, 4.1115}

workouts = {
	["PROP_HUMAN_MUSCLE_CHIN_UPS"] = {"tractiuni1", "tractiuni2"},
	["WORLD_HUMAN_MUSCLE_FREE_WEIGHTS"] = {"biceps1", "biceps2", "biceps3", "biceps4"},
	["WORLD_HUMAN_SIT_UPS"] = {"abdo1","abdo2"},
	["WORLD_HUMAN_YOGA"] = {"yoga1","yoga2","yoga3"},
	["WORLD_HUMAN_PUSH_UPS"] = {"flotari1","flotari2","flotari3"},
	["PROP_HUMAN_SEAT_MUSCLE_BENCH_PRESS"] = {"bench1", "bench2", "bench3", "bench4","bench5","bench6","bench7"}
}

gym_menu = {name="Gym Shop",css={top="75px", header_color="rgba(0,125,255,0.75)"}}

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then
		thePlayer = vRP.getUserSource({user_id})
		vRPCgym.populateGymTable(thePlayer, {gymTable, theGym})
	end
end)

function vRPgym.initWorkout(workout)
	thePlayer = source
	for i, v in pairs(workouts) do
		workTable = v
		for k, vl in pairs(workTable) do
			if(vl == workout)then
				vRPCgym.startWorkout(thePlayer, {i})
				break
			end
		end
	end
end

-- function vRPgym.gainStrenght(strenght)
-- 	user_id = vRP.getUserId({source})
	
-- 	local parts = splitString("physical.strength",".")
--     if #parts == 2 then
--         vRP.varyExp({user_id,parts[1],parts[2],tonumber(strenght)})
--     end
-- end

function vRPgym.hasMembership()
	thePlayer = source
	user_id = vRP.getUserId({thePlayer})
	if(user_id ~= nil)then
		if(members[user_id] == true)then
			return true
		else
			return false
		end
	end
end

function buyMembership(player, choice)
	user_id = vRP.getUserId({player})
	if(members[user_id] ~= true)then
		if(vRP.tryPayment({user_id, 500}))then
			members[user_id] = true
			vRPclient.notify(player, {"~w~[GYM] ~g~Ai platit $500 pentru un abonament de o zi(pana la restart)! Acum poti folosi sala!"})
		else
			vRPclient.notify(player, {"~w~[GYM] ~r~Nu ai destui bani pentru a-ti cumpara abonament la sala!"})
		end
	else
		vRPclient.notify(player, {"~w~[GYM] ~r~Deja ai un abonament la sala!"})
	end
	vRP.closeMenu({player})
end

function cancelMembership(player, choice)
	user_id = vRP.getUserId({player})
	if(members[user_id] == true)then
		members[user_id] = false
		vRPclient.notify(player, {"~w~[GYM] ~g~Ai anulat abonamentul de la sala!"})
	else
		vRPclient.notify(player, {"~w~[GYM] ~r~Nu ai abonament la sala!"})
	end
	vRP.closeMenu({player})
end



RegisterServerEvent("showGymMenu")
AddEventHandler("showGymMenu", function()
	thePlayer = source
	if(members[user_id] ~= true)then
		gym_menu["Open Membership"] = {buyMembership, "Cumpara abonament pentru o zi la sala(pana la restart)<br>Pret: <font color='red'>$500</font>"}
		gym_menu["Cancel Membership"] = nil
	else
		gym_menu["Cancel Membership"] = {cancelMembership, "Anuleaza abonament"}
		gym_menu["Open Membership"] = nil
	end
	vRP.openMenu({thePlayer,gym_menu})
end)
