local debugData = {}

local function HandleHeadshot(victim, bone, weaponHash)
    if not victim or not DoesEntityExist(victim) then return end

    local isHeadshot = false
    for _, headBone in ipairs(Config.HeadshotBones) do
        if bone == headBone then
            isHeadshot = true
            break
        end
    end

    if isHeadshot then
        local playerPos = GetEntityCoords(PlayerPedId())
        local victimPos = GetEntityCoords(victim)

        if IsPedInAnyVehicle(victim, false) then
            victimPos = GetEntityCoords(GetVehiclePedIsIn(victim, false))
        end

        TriggerServerEvent('silence_sync:registerHeadshot', {
            victim = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victim)),
            weapon = weaponHash,
            distance = #(playerPos - victimPos),
            bone = bone,
            shotTime = GetGameTimer(),
            shooterPos = playerPos
        })

        if Config.Debug.enabled then
            debugData[victim] = {
                pos = victimPos,
                time = GetGameTimer()
            }
        end
    end
end

CreateThread(function()
    while true do
        Wait(0)
        if Config.Debug.enabled and Config.Debug.drawHeadshotMarkers then
            local currentTime = GetGameTimer()
            for entity, data in pairs(debugData) do
                if currentTime - data.time < 5000 then
                    DrawMarker(28, data.pos.x, data.pos.y, data.pos.z + 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.1, 255, 0, 0, 255, false, false, 2, nil, nil, false)
                else
                    debugData[entity] = nil
                end
            end
        end
    end
end)

RegisterNetEvent('silence_sync:debugInfo')
AddEventHandler('silence_sync:debugInfo', function(data)
    if Config.Debug.enabled then
        local text = string.format("Headshot: %s -> %s\nDistance: %.1f\nBone: %s", 
            data.shooter, data.victim, data.distance, data.bone)
        
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(true, true)
    end
end)

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local victim = args[1]
        local attacker = args[2]
        local isDead = args[4]
        local weaponHash = args[7]
        local isMelee = args[11]
        local hitBone = args[9]

        if attacker == PlayerPedId() and not isMelee then
            HandleHeadshot(victim, hitBone, weaponHash)
        end
    end
end)