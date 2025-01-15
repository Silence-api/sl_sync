RegisterNetEvent('silence_sync:registerHeadshot')
AddEventHandler('silence_sync:registerHeadshot', function(data)
    local source = source
    local victim = data.victim
    
    if not victim then return end
    if source == victim then return end

    local distance = data.distance
    if distance > Config.MaxHeadshotDistance then return end

    local currentTime = os.time() * 1000
    if math.abs(currentTime - data.shotTime) > Config.SyncValidation.maxTimeDifference then return end

    TriggerClientEvent('silence_sync:applyDamage', victim, Config.HeadshotDamageMultiplier)
    TriggerClientEvent('silence_sync:headshotFeedback', source, true)

    if Config.Debug.enabled then
        TriggerClientEvent('silence_sync:debugInfo', -1, {
            shooter = GetPlayerName(source),
            victim = GetPlayerName(victim),
            distance = distance,
            bone = data.bone
        })
    end
end)