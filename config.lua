Config = {}

-- Maximale Entfernung für Headshots
Config.MaxHeadshotDistance = 10009.0  

-- Schadensmultiplikator für Headshots
Config.HeadshotDamageMultiplier = 100.0  

-- Knochen-IDs für Headshots
Config.HeadshotBones = {31086, 39317, 47495}  

-- Validierungseinstellungen für die Synchronisation
Config.SyncValidation = {
    maxTimeDifference = 500  -- Maximale Zeitdifferenz in Millisekunden
}

-- Debug-Einstellungen
Config.Debug = {
    enabled = true,  -- Debugging aktivieren
    drawHeadshotMarkers = true,  -- Headshot-Markierungen zeichnen
    logHeadshots = true  -- Headshots protokollieren
}
