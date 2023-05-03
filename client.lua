local isHandUp = true

function GetClosestPlayer()
    local players, closestDistance, closestPlayer = GetActivePlayers(), -1, -1
    local playerPed, playerId = PlayerPedId(), PlayerId()
    local coords, usePlayerPed = coords, false
    
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        usePlayerPed = true
        coords = GetEntityCoords(playerPed)
    end
    
    for i=1, #players, 1 do
        local tgt = GetPlayerPed(players[i])

        if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then

            local targetCoords = GetEntityCoords(tgt)
            local distance = #(coords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- https://github.com/mja00/redm-shit/blob/master/nuiweaponspawner/config.lua
        -- L
        if IsControlJustPressed(0,0x9959A6F0) and IsInputDisabled(0)  then

            local closestPlayer, closestDistance = GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 1.0 then
                TriggerServerEvent("nolosha:lookup_player", GetPlayerServerId(closestPlayer))
            else
                TriggerEvent('vorp:TipRight', 'Personne ne lève les mains pour être fouillé', 3000)
            end
        end
        if (IsControlJustPressed(0,0x8CC9CD42)) and IsInputDisabled(0)  then
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                RequestAnimDict("script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs")    
                while not HasAnimDictLoaded("script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs") do 
                    Citizen.Wait(100)
                end
                if IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                    DisablePlayerFiring(ped, true)
                    ClearPedSecondaryTask(ped)
                    TriggerServerEvent("nolosha:handsdown", GetPlayerServerId(ped))
                    print('down')
                else
                    SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
                    DisablePlayerFiring(ped, true)
                    TaskPlayAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 2.0, -1.0, 120000, 31, 0, true, 0, false, 0, false)
                    TriggerServerEvent("nolosha:handsup", GetPlayerServerId(ped))
                    print('up')
                end
            end
        end
    end
end)


--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        if isHandUp then
            RequestAnimDict("script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs")    
            while not HasAnimDictLoaded("script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs") do 
                Citizen.Wait(100)
            end
            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then 
                if not IsEntityPlayingAnim(ped, "script_proc@robberies@shop@rhodes@gunsmith@inside_upstairs", "handsup_register_owner", 3) then
                    TriggerServerEvent("nolosha:handsdown", GetPlayerServerId(ped))
                end
            end
        end
    end
end)
--]]

RegisterNetEvent('nolosha:ackhands')
AddEventHandler('nolosha:ackhands', function(val)
    print('hands')
    print(val)
    isHandUp = val
end)