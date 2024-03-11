local blipit, PlayerData = {}

CreateThread(function()
    ESX = exports["es_extended"]:getSharedObject()
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterCommand(C.TrackerOnCommand, function(source, args)
    TriggerServerEvent('esx_t_tracker:Server:StartTracking', args[1] or C.DefaultCallSign)
end)


RegisterNetEvent('esx_t_tracker:Client:StartTracking')
AddEventHandler('esx_t_tracker:Client:StartTracking', function(table)
    for i,v in pairs(blipit) do
        RemoveBlip(v)
    end
    if C.Jobs[PlayerData?.job?.name] then
        for k,v in pairs(table) do
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, C.BlipSprite)
            SetBlipColour(blip, v.Color)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.CallSign.. " - " ..v.Name)
            EndTextCommandSetBlipName(blip)
            blipit[k] = blip
        end
    end
end)

CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/'..C.TrackerOnCommand, "Put tracker on.", {{name = "CALLSIGN", help = "Your callsign"}})
    TriggerEvent('chat:addSuggestion', '/'..C.TrackerOffCommand, "Put tracker off.")
end)