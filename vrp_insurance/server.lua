local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP","vrp_insurance")
vRP = Proxy.getInterface("vRP")

vRP.MySQL = {}
vRP.MySQL = module("vrp", "lib/MySQL")

vRP.MySQL.createCommand("vRP/get_user_vehicles","SELECT * FROM vehicles WHERE owner_id = @user_id")

function build_asigurare_menu(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		menu = {name="AUTO Insurance",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
		vRP.MySQL.query("vRP/get_user_vehicles", {user_id = user_id}, function(result, affected)
			if #result > 0 then
				for i, v in pairs(result) do
					if vRP.hasInsurance({v.vehicle_plate}) then
						local price = vRP.getVehPrice({v.vehicle})
						
						if price == nil then
							price = 10000
						end

						local price_insurance = price / 20

						menu[vRP.getVehName({v.vehicle})] = {function(player, choice)
							if vRP.tryPayment({user_id,price_insurance}) then
								vRPclient.notify(player,{"[Insurance] Greetings , you bought insurance at price: "..price_insurance.." Euro for : "..vRP.getVehName({v.vehicle}).."!"})
								vRP.addInsurance({vehicle_plate})
							else
								vRPclient.notify(player,{"[Insurance] Not enought money!"})
							end
							vRP.closeMenu({player})
						end, "Plate Number : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..v.vehicle_plate.."</span><br>Vehicle Price : <span style = 'color: rgb(0,215,255);font-weight:bold;font-weight:bold;'>"..price.." Euro</span><br>Insurance Price : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..tostring(price_insurance).." Euro</span>"}
					end
				end
				vRP.openMenu({player,menu})
			end
		end)
	end
end

local function build_menu(source)
	local x, y, z = -436.25064086914,6005.9116210938,31.716279983521
	local function menu_enter(source,area)
		build_asigurare_menu(source)
	end
	local function menu_leave(source,area)
		vRP.closeMenu({source})
	end

	vRP.setArea({source,"vRP:Insurances",x,y,z,2,1.5,menu_enter,menu_leave})
end

AddEventHandler("vRP:playerLoggedIn", function(player, user_id, data)
	build_menu(player)
end)

vRP.registerMenuBuilder({"police", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		
		choices["Check Insurance"] = {function(player, choice)
			vRP.prompt({player, "USER ID : ", "", function(player, nuser_id)
				if nuser_id ~= nil then
					vRP.MySQL.query("vRP/get_user_vehicles", {user_id = nuser_id}, function(rows, affected)
						if #rows > 0 then
							vRP.buildMenu({"insurance", {player = player}, function(menu)
								menu.name = "AUTO Insurance"
								menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

								for i, v in pairs(rows) do
									local masina = v.vehicle
									local placuta = v.vehicle_plate
									local statusasigasd
									if vRP.hasInsurance({v.vehicle_plate}) then
										statusasigasd = "Yes"
									else
										statusasigasd = "No"
									end
									menu[vRP.getVehName({masina})] = {nil, "Plate Number : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..placuta.."</span><br> Has insurance : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..statusasigasd}
								end

								vRP.openMenu({player,menu})
							end})
						end
					end)
				end
			end})
		end, "Check insurances of a player!"}

	    add(choices)
    end
end})
