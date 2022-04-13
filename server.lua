local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('bomb', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.Functions.GetItemByName('bomb') ~= nil then
        TriggerClientEvent('bomb:check', source)
    end
end)

RegisterServerEvent('bomb:remove')
AddEventHandler('bomb:remove', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer.Functions.GetItemByName('bomb') ~= nil then
        xPlayer.Functions.RemoveItem('bomb', 1)
    end
end)
