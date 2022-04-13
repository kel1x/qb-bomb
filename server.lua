local QBCore = exports['galaxy-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('bomba', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.Functions.GetItemByName('bomba') ~= nil then
        TriggerClientEvent('bomba:provera', source)
    end
end)

RegisterServerEvent('bomba:ukloni')
AddEventHandler('bomba:ukloni', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer.Functions.GetItemByName('bomba') ~= nil then
        xPlayer.Functions.RemoveItem('bomba', 1)
    end
end)