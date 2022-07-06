local QBCore = exports['qb-core']:GetCoreObject()






local targetlocations = {
        vector3(-667.372,-1106.034,14.629),
        vector3(-1288.61, -430.71, 34.77),
	vector3(269.89, -640.89, 42.01),
	vector3(-621.016,46.677,43.591),
	vector3(291.517,-1078.674,29.405),
}

function ApartmentCheck()
    local pos = GetEntityCoords(PlayerPedId())
    local apt1 = #(pos - vector3(-667.372,-1106.034,14.629))
    local apt2 = #(pos - vector3(-1288.046,-430.126,35.077))
	local apt3 = #(pos - vector3(269.075,-640.672,42.02))
	local apt4 = #(pos - vector3(-621.016,46.677,43.591))
	local apt5 = #(pos - vector3(291.517,-1078.674,29.405))
    if apt1 < 3 then
        return "apartment1"
    elseif apt2 < 3 then
        return "apartment2"
	elseif apt3 < 3 then
        return "apartment3"
	elseif apt4 < 3 then
        return "apartment4"
	elseif apt5 < 3 then
        return "apartment5"
    end
end
Citizen.CreateThread(function()

    for k,v in pairs(targetlocations) do
        exports['qb-target']:AddBoxZone(k, v, 1.0, 1.0, {
            name = k,
            heading = 35.0,
            debugPoly = false,
        }, {
            options = {
                {
                    event = "qb-apartments:choose",
                    icon = "far fa-clipboard",
                    label = "Raid apartment",
                    job = 'police'
                },
            },
            distance = 1.5
        })
    end
end)



local raidEnabled = false
RegisterNetEvent('apartments:client:pdraid')
AddEventHandler('apartments:client:pdraid', function(bool)
	raidEnabled = bool
end)

RegisterCommand('pdraid', function()
	if not raidEnabled then
		PlayerJob = QBCore.Functions.GetPlayerData().job
		if PlayerJob.grade.level > 12 and PlayerJob.name == 'police' then
			local timer = math.random(5,10)
			local circles = math.random(3, 4)
			local LockPick = exports['qb-lock']:StartLockPickCircle(circles, timer)
			if LockPick then
			TriggerServerEvent('apartments:server:pdraid', true)
			QBCore.Functions.Notify("Raid is now ON", "success")
			else
			TriggerServerEvent('apartments:server:pdraid', false)
			QBCore.Functions.Notify("Failed", "error")
			end
		else
		QBCore.Functions.Notify("Not an Officer/ Correct Rank", "error")
		end
	else
	QBCore.Functions.Notify("Raid is now Off", "error")
	TriggerServerEvent('apartments:server:pdraid', false)
	end
									
end)

RegisterNetEvent('qb-apartments:choose')
AddEventHandler('qb-apartments:choose',function()
    if raidEnabled then
			 TriggerServerEvent('apartments:server:pdraid', true)
	local PlayerData = QBCore.Functions.GetPlayerData()
	local dialog = exports['qb-input']:ShowInput({
    header = "Enter the CID of the persons apartment",
    submitText = "Enter",
    inputs = {
        {
            text = "Citizen ID (#)",
            name = "citizenid",
            type = "text",
            isRequired = true 
        },
    },
})

		if dialog then
			QBCore.Functions.TriggerCallback('apartments:PoliceApartment', function(result)
					if ApartmentCheck() == result.type then
				if result then
                
                    altaapartment = result.type
                    EnterApartment(altaapartment, result.name)
				end
					else
						QBCore.Functions.Notify("This is not his House", "error")
                	end
			end, dialog.citizenid)
		end
	
	else
     QBCore.Functions.Notify("Raid is not enabled", "error")
    end
end)
