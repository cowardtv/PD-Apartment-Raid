local QBCore = exports['qb-core']:GetCoreObject()


RegisterServerEvent('apartments:server:pdraid')
AddEventHandler('apartments:server:pdraid', function(bool)
	TriggerClientEvent("apartments:client:pdraid", -1, bool)
end)

QBCore.Functions.CreateCallback('apartments:PoliceApartment', function(source, cb, citizenid)
    local result = MySQL.query.await('SELECT * FROM apartments WHERE citizenid = ?', { citizenid })
	return cb(result[1])
end
