local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_showroom")
vRP.MySQL = module("vrp", "lib/MySQL")

vRP.MySQL.createCommand("vRP/get_vehicles","SELECT * FROM vehicles WHERE owner = @user_id")
vRP.MySQL.createCommand("vRP/select_plates","SELECT vehicle_plate FROM vehicles")

local prefix = {
	["AB"] = "Alba",
	["AR"] = "Arad",
	["AG"] = "Arges",
	["BC"] = "Bacau",
	["BH"] = "Bihor",
	["BN"] = "Bistrita-Nasaud",
	["BT"] = "Botosani",
	["BR"] = "Braila",
	["BV"] = "Brasov",
	["BZ"] = "Buzau",
	["CL"] = "Calarasi",
	["CS"] = "Caras-Severin",
	["CJ"] = "Cluj",
	["CT"] = "Constanta",
	["CV"] = "Covasna",
	["DB"] = "Dambovita",
	["DJ"] = "Dolj",
	["GL"] = "Galati",
	["GR"] = "Giurgiu",
	["GJ"] = "Gorj",
	["HR"] = "Harghita",
	["HD"] = "Hunedoara",
	["IL"] = "Ialomita",
	["IS"] = "Iasi",
	["IF"] = "Ilfov",
	["MM"] = "Maramures",
	["MH"] = "Mehedinti",
	["MS"] = "Mures",
	["NT"] = "Neamt",
	["OT"] = "Olt",
	["PH"] = "Prahova",
	["SJ"] = "Salaj",
	["SM"] = "Satu Mare",
	["SB"] = "Sibiu",
	["SV"] = "Suceava",
	["TR"] = "Teleorman",
	["TM"] = "Timis",
	["TL"] = "Tulcea",
	["VL"] = "Valcea",
	["VS"] = "Vaslui",
	["VN"] = "Vrancea",
	["B"] = "Bucuresti"
}

RegisterServerEvent('showroom:get_vehicles')
AddEventHandler('showroom:get_vehicles', function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	local vehicles = vRP.getVehicles({})

	TriggerClientEvent("showroom:get_vehicles",player,vehicles)
end)

RegisterServerEvent('showroom:buy')
AddEventHandler('showroom:buy', function(vehicle, price)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	
	vRP.MySQL.ready(function()
		vRP.MySQL.query("vRP/get_vehicles",{user_id = user_id},function(vehicles,affected)
			if #vehicles <= 10 then
				vRP.prompt({player,"Litere [ Ultimele 3 litere, ex: B111<span style='color: red;'>ABC</span> ]:","",function(player,litere)
					litere = string.upper(litere)
					if litere ~= "" and litere ~= nil and string.len(litere) == 3 then
						local numere = math.random(1,999)
						vRP.buildMenu({"prefix", {user_id = user_id, player = player,vname = vname}, function(menu)
							menu.name="Judete"
							menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}
							local plate = ""
							
							for prefix,val in pairs(prefix) do
								menu[val] = {function(player,choice)
									if prefix == "B" then
										prefix = prefix.." "
									end
									
									vRP.MySQL.query("vRP/select_plates",{},function(plates,affected)
										if string.len(plate) < 8 and numere < 10 then
											plate = prefix.."0"..numere.." "..litere--B 10 BRE
										elseif string.len(plate) < 8 and numere > 10 and numere < 100 then
											plate = prefix..numere.." "..litere--CT10 BUN
										elseif string.len(plate) < 8 and numere > 100 then
											plate = prefix..numere..litere--CT100BUN
										end
										if #plates > 0 then
											for i,v in pairs(plates) do
												if string.len(plate) < 8 and numere < 10 then
													plate = prefix.."0"..numere.." "..litere--B 10 BRE
												elseif string.len(plate) < 8 and numere > 10 and numere < 100 then
													plate = prefix..numere.." "..litere--CT10 BUN
												elseif string.len(plate) < 8 and numere > 100 then
													plate = prefix..numere..litere--CT100BUN
												end
												if v.vehicle_plate == plate then
													numere = numere-1
													i = 1
												end
											end
										end
			
										if string.len(plate) == 8 then
											if vRP.tryPayment({user_id,tonumber(price)}) then
												vRP.buyVehicle({vehicle, plate, user_id})
												vRPclient.getPosition(player,{},function(x,y,z)
													local showrooms = {{140.86053466797,6441.6879882813,31.478973388672},{1732.9184570313,3729.267578125,33.952640533447},{-30.282169342041,-1089.5447998047,26.422134399414}}

													local closest = showrooms[1]

													for i,v in pairs(showrooms) do
														if vRP.Vdist({x,y,z,v[1],v[2],v[3]}) < vRP.Vdist({x,y,z,closest[1],closest[2],closest[3]}) then
															closest = v
														end
													end

													vRPclient.notifyPicture(player, {"CHAR_CARSITE3", 9, "Showroom", false, "Ti-ai cumparat noul ~r~"..vRP.getVehName({vehicle}).."~w~ cu succes.\nAi platit ~g~"..price.." Euro~w~."})
													vRPclient.spawnBuyedVehicle(player,{vehicle,plate,closest},function(vehicle)
														vRP.registerVehicle({plate,vehicle})
													end)
												end)								
											else
												vRPclient.notify(player,{"~r~Fonduri insuficiente."})
											end
											vRP.closeMenu({player})
										else
											vRPclient.notify(player,{"Valoare incorecta! Obligatoriu 8 caractere!"})
										end
									end)
									vRP.closeMenu({player})
								end}
							end
							vRP.openMenu({player,menu})
						end})
					else
						vRPclient.notify(player,{"Valoare incorecta!"})
						vRP.closeMenu({player})
					end
				end})
			end	
		end)
	end)
end)