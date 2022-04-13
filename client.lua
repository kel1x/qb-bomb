local QBCore = exports['galaxy-core']:GetCoreObject()

local timer = 0
local targetVehicle

RegisterNetEvent('bomba:provera')
AddEventHandler('bomba:provera', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
    local vCoords = GetEntityCoords(veh)
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, vCoords.x, vCoords.y, vCoords.z, false)

    -- DISCORD LOG

    local name = GetPlayerName(PlayerId())
    local plates = GetVehicleNumberPlateText(veh)
    local var = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local hash = GetStreetNameFromHashKey(var);
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)

    if not IsPedInAnyVehicle(ped, false) then
        if veh and (dist < 3.0) then
            exports['progressbar']:Progress({
                name = "postavljanje_bombe",
                duration = 5000,
                label = "Postavljate bombu...",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                    anim = "weed_spraybottle_crouch_base_inspector",
                    flags = 49,
                }
            })    
            Citizen.Wait(5000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('bomba:ukloni')
            TriggerServerEvent("qb-log:server:CreateLog", "default", "💣 **Postavio bombu:** " ..name.. "\n🚗 **Tablice Vozila:** " ..plates.. "\n📍 **Lokacija:** " ..hash..", " ..zone.."")
            QBCore.Functions.Notify("Postavili ste bombu,kada budete hteli da je detonirate pritisnite tipku G", "success")
            targetVehicle = veh
            
            while targetVehicle do
                Citizen.Wait(0)
                if targetVehicle then
                    if IsControlJustReleased(0, 47) then
                        DetonateVehicle(targetVehicle)
                    end             
                end    
            end
        else
            QBCore.Functions.Notify("Nema vozila u blizini!", "error")
        end 
    else
        QBCore.Functions.Notify("Morate biti van vozila!", "error")
    end
end)


function DetonateVehicle(veh)
    local vCoords = GetEntityCoords(veh)
    if DoesEntityExist(veh) then
        targetVehicle = nil
        AddExplosion(vCoords.x, vCoords.y, vCoords.z, 5, 50.0, true, false, true)
    end
end