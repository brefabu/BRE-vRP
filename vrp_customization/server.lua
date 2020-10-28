local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

vRPclient = Tunnel.getInterface("vRP","vRP_Clothing")

RegisterServerEvent("updateSkin")
AddEventHandler("updateSkin", function(dad,mum,dadmumpercent,skin,eyecolor,acne,skinproblem,freckle,wrinkle,wrinkleopacity,hair,haircolor,eyebrow,eyebrowopacity,beard,beardopacity,beardcolor,torso,torsotext,leg,legtext,shoes,shoestext,accessory,accessorytext,undershirt,undershirttext,torso2,torso2text,prop_hat,prop_hat_text,prop_glasses,prop_glasses_text,prop_earrings,prop_earrings_text,prop_watches,prop_watches_text)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})

	if dad == nil then
		dad = 0
	end
	
	if mum == nil then
		mum = 0
	end

	vRP.setUserCustomization({user_id,{dad = dad,mum = mum,dadmumpercent = dadmumpercent,skin = skin,eyecolor = eyecolor,acne = acne,skinproblem = skinproblem,freckle = freckle,wrinkle = wrinkle,wrinkleopacity = wrinkleopacity,hair = hair,haircolor = haircolor,eyebrow = eyebrow,eyebrowopacity = eyebrowopacity,beard = beard,beardopacity = beardopacity,beardcolor = beardcolor,torso = torso,torsotext = torsotext,leg = leg,legtext = legtext,shoes = shoes,shoestext = shoestext,accessory = accessory,accessorytext = accessorytext,undershirt = undershirt,undershirttext = undershirttext,torso2 = torso2,torso2text = torso2text,prop_hat = prop_hat,prop_hat_text = prop_hat_text,prop_glasses = prop_glasses,prop_glasses_text = prop_glasses_text,prop_earrings = prop_earrings,prop_earrings_text = prop_earrings_text,prop_watches = prop_watches,prop_watches_text = prop_watches_text}})
end)
