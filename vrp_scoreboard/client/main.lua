local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local idVisable = true

RegisterNetEvent('vrp_scoreboard:updateConnectedPlayers')
AddEventHandler('vrp_scoreboard:updateConnectedPlayers', function(connectedPlayers,slots)
	UpdatePlayerTable(connectedPlayers,slots)
end)

RegisterNetEvent('vrp_scoreboard:updatePing')
AddEventHandler('vrp_scoreboard:updatePing', function(connectedPlayers,slots)
	UpdatePlayerTable(connectedPlayers,slots)
end)

RegisterNetEvent('vrp_scoreboard:toggleID')
AddEventHandler('vrp_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({action = 'toggleID',state = idVisable})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({action = 'updateServerInfo',uptime = uptime})
end)

function UpdatePlayerTable(connectedPlayers,slots)
	local formattedPlayerList, num = {}, 1

	for k,v in pairs(connectedPlayers) do

		local color = 'green';
		if v.ping > 50 and v.ping < 80 then
			color = 'orange';
		elseif v.ping >= 80 then
			color = 'red';
		end

		local ping = '<td style="color:'..color..'">'..v.ping.." <span style='color:white;'>ms</span></td>"
		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td>'..ping):format(v.id, v.name, v.job, v.hours, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td><td>%s</td>'..ping..'</tr>'):format(v.id, v.name, v.job, v.hours, v.ping))
			num = 1
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})
	SendNUIMessage({player_count = slots})
end

function drawTxt2(width,height,scale, text, r,g,b,a, outline)
	SetTextFont(7)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	if(outline)then
	  SetTextOutline()
	end
	SetTextEntry("STRING")
	AddTextComponentString(text)
	SetTextWrap(0.0,1.0)
	SetTextCentre(true)
	DrawText(1.0 - width/2, 0.04)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustReleased(0, Keys['Z']) or IsControlJustReleased(0, 48) then
			SendNUIMessage({action = 'toggle'})
			Citizen.Wait(200)
		end
	end
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({action  = 'close'})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end
