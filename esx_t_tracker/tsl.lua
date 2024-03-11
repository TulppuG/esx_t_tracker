ESX = exports["es_extended"]:getSharedObject()
local Trackers = {}

RegisterNetEvent('esx_t_tracker:Server:StartTracking')
AddEventHandler('esx_t_tracker:Server:StartTracking', function(callsign)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if C.Jobs[xPlayer.job.name] then 
        Trackers[src] = {CallSign = callsign, Name = xPlayer.name, Color = C.Jobs[xPlayer.job.name].color}
    end
end)

AddEventHandler('esx:playerDropped', function(src)
    Trackers[src] = nil
end)

AddEventHandler('esx:setJob', function(playerId, job, lastJob)
    if C.Jobs[lastJob.name] then
        Trackers[playerId] = nil
    end
end)

CreateThread(function()
    while true do 
        Wait(C.BlipUpdate)
        for k in pairs(Trackers) do
            Trackers[k].coords = GetEntityCoords(GetPlayerPed(k))
        end
        TriggerClientEvent('esx_t_tracker:Client:StartTracking', -1, Trackers)
    end
end)

RegisterCommand(C.TrackerOffCommand, function(src)
    Trackers[src] = nil
end)