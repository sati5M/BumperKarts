cfg = {}

cfg.minPlayers = 1
cfg.maxPlayers = 5

cfg.ticketMaster = {
    ped = `a_m_m_fatlatin_01`,
    location = vector3(-1721.669921875,-1125.4945068359,13.114929199219),
    markerLocation = vector3(-1722.4866943359,-1124.8459472656,13.134929199219)
}

cfg.bumperKarts = {
    vehicleModel = `skart`,
    locations = { -- All locations are based on this map: https://www.gta5-mods.com/maps/car-bumper-funny-mapping, all credits to Patoche for the map.
        vector3(-1716.4959716797,-1148.2423095703,12.998774528503),
        vector3(-1708.3111572266,-1158.0,12.99879360199),
        vector3(-1711.5904541016,-1171.166015625,12.998950004578),
        vector3(-1721.5659179688,-1174.2330322266,12.999541282654),
        vector3(-1736.6031494141,-1172.1981201172,12.999130249023)
    }
}

cfg.gameSettings = {
    queueTimer = 10, -- SECONDS
    timeToPlayGame = 60, -- SECONDS
    spawnLocAfterGame = vector3(-1732.5638427734,-1116.8132324219,13.017228126526)

}

