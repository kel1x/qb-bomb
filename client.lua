local QBCore = exports['qb-core']:GetCoreObject()

local timer = 0
local targetvozilo
local ped = GetPlayerPed(-1)

RegisterNetEvent('bomba:provera')
AddEventHandler('bomba:provera', function()
    local ped = GetPlayerPed(-1)
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 3.000, 0, 70)
    local vCoords = GetEntityCoords(veh)
    local dist = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, vCoords.x, vCoords.y, vCoords.z, false)
    local animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@"
    local anim = "weed_spraybottle_crouch_base_inspector"

    -- DISCORD --

    local name = GetPlayerName(PlayerId())
    local tablice = GetVehicleNumberPlateText(veh)
    local var = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    hash = GetStreetNameFromHashKey(var);
    local zona = GetNameOfZone(coords.x, coords.y, coords.z)

    if not IsPedInAnyVehicle(ped, false) then
        if veh and (dist < 3.0) then
            loadAnimDict(animDict)
            Citizen.Wait(1000)
            TaskPlayAnim(ped, animDict, anim, 3.0, 1.0, -1, 0, 1, 0, 0, 0)
            exports['progressBars']:startUI(Config.VremePostavljanja * 1000, "Postavljate bombu...")
            Citizen.Wait(Config.VremePostavljanja * 1000)
            ClearPedTasksImmediately(ped)
            TriggerServerEvent('bomba:ukloni')
            TriggerServerEvent('bomba:log', "💣 **Postavio bombu:** " ..name.. "\n🚗 **Tablice Vozila:** " ..tablice.. "\n📍 **Lokacija:** " ..hash..", " ..zona.."")
            QBCore.Functions.Notify("Postavili ste bombu,kada budete hteli da je detonirate pritisnite tipku G", "success")
            targetvozilo = veh
            
            while targetvozilo do
                Citizen.Wait(0)
                if targetvozilo then
                    if IsControlJustReleased(0, Config.TriggerKey) then
                        DetonirajVozilo(targetvozilo)
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


function DetonirajVozilo(veh)
    local vCoords = GetEntityCoords(veh)
    if DoesEntityExist(veh) then
        targetvozilo = nil
        AddExplosion(vCoords.x, vCoords.y, vCoords.z, 5, 50.0, true, false, true)
    end
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(20)
    end
end