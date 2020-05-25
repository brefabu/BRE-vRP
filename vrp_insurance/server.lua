local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")

vRPclient = Tunnel.getInterface("vRP","vrp_asigurare")
vRP = Proxy.getInterface("vRP")

MySQL.createCommand("vRP/iamasinilejucatorului","SELECT * FROM vehicles WHERE owner_id = @user_id")

function build_asigurare_menu(player)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		menu = {name="ASIGURARI AUTO",css={top="75px",header_color="rgba(0,200,0,0.75)"}}
		MySQL.query("vRP/iamasinilejucatorului", {user_id = user_id}, function(result, affected)
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
								vRPclient.notify(player,{"[ASIGURARE] Felicitari , ai cumparat asigurare cu : "..price_insurance.." RON pentru masina : "..vRP.getVehName({v.vehicle}).."!"})
								vRP.addInsurance({vehicle_plate})
							else
								vRPclient.notify(player,{"[ASIGURARE] Nu ai suficienti bani pentru a plati asigurarea !"})
							end
							vRP.closeMenu({player})
						end, "Numar inmatriculare : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..v.vehicle_plate.."</span><br>Pret masina : <span style = 'color: rgb(0,215,255);font-weight:bold;font-weight:bold;'>"..price.." Euro</span><br>Pret : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..tostring(price_insurance).." Euro</span>"}
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

	vRP.setArea({source,"vRP:Asigurari",x,y,z,2,1.5,menu_enter,menu_leave})
end

AddEventHandler("vRP:playerLoggedIn", function(player, user_id, data)
	build_menu(player)
end)

vRP.registerMenuBuilder({"police", function(add, data)
	local user_id = vRP.getUserId({data.player})
	if user_id ~= nil then
		local choices = {}
		
		choices["Verifica asigurare"] = {function(player, choice)
			vRP.prompt({player, "USER ID : ", "", function(player, nuser_id)
				if nuser_id ~= nil then
					MySQL.query("vRP/iamasinilejucatorului", {user_id = nuser_id}, function(rows, affected)
						if #rows > 0 then
							vRP.buildMenu({"asigurare", {player = player}, function(menu)
								menu.name = "Asigurare AUTO"
								menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

								for i, v in pairs(rows) do
									local masina = v.vehicle
									local placuta = v.vehicle_plate
									local statusasigasd
									if vRP.hasInsurance({v.vehicle_plate}) then
										statusasigasd = "Da"
									else
										statusasigasd = "Nu"
									end
									menu[vRP.getVehName({masina})] = {nil, "Numar inmatriculare : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..placuta.."</span><br> Are asigurare : <span style = 'color: rgb(0,215,255);font-weight:bold;'>"..statusasigasd}
								end

								vRP.openMenu({player,menu})
							end})
						end
					end)
				end
			end})
		end, "Verifica asigurarile unui jucator!"}

	    add(choices)
    end
end})
