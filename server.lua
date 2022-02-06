local pedCreated
local countdownOnGoing
local gameOnGoing
local playerQueue = {}
local existingKarts = {}
local timer = cfg.gameSettings.queueTimer
local index = 1
local players = 1

RegisterNetEvent("bumperkart:updateTable")
AddEventHandler("bumperkart:updateTable", function()
    local source = source
    local playersQueued = tablelength(playerQueue)

    if gameOnGoing then
        TriggerClientEvent("bumperkart:GameOngoing", source)
        return
    end
    
    if playersQueued > 0 then
        for k, v in pairs(playerQueue) do
            if v.tempid == source then
                TriggerClientEvent("bumperkart:alreadyInQueue", source)
                return false
            end
        end

        if playersQueued >= cfg.maxPlayers then
            TriggerClientEvent("bumperkart:SlotsFilled", source)
            return false
        else
            
        TriggerClientEvent("bumperkart:JoinedQueue", source, timer)
        playerQueue[index] = {tempid = source}
        index = index + 1
        if not countdownOnGoing then
            countdownOnGoing = true
            Wait(timer / 1000)
            startCountdown()
            countdownOnGoing = false
            
        end
        end
    else
        TriggerClientEvent("bumperkart:JoinedQueue", source, timer)
        playerQueue[index] = {tempid = source}
        index = index + 1
        if not countdownOnGoing then
            countdownOnGoing = true
            Wait(timer / 1000)
            startCountdown()
            countdownOnGoing = false
        end
        return
        
    end
end)

RegisterNetEvent("bumperkart:BumperKartStart")
AddEventHandler("bumperkart:BumperKartStart", function()
    local source = source
    if not gameOnGoing then
        gameOnGoing = true
        startGame()
        TriggerClientEvent("bumperkart:tensecondcountdown", source)
        Citizen.Wait(cfg.gameSettings.timeToPlayGame * 1000)
        endGame()
    end
end)

function startGame()
        for k, v in pairs(playerQueue) do 
            if tablelength(existingKarts) == tablelength(playerQueue) then
                break
            else
                if k > tablelength(playerQueue) then
                    
                else
                    
                local bumperKart = Citizen.InvokeNative(`CREATE_AUTOMOBILE` & 0xFFFFFFFF, cfg.bumperKarts.vehicleModel, cfg.bumperKarts.locations[k], 360.0)
                Citizen.Wait(200)
                local netId = NetworkGetNetworkIdFromEntity(bumperKart)
                existingKarts[k] = {netId = netId, tempid = v.tempid}
                SetPedIntoVehicle(GetPlayerPed(v.tempid), bumperKart, -1)
                end
                
            end
        end
    playerQueue = {}
end

function endGame()
    if gameOnGoing then
        for k, v in pairs(existingKarts) do
            if DoesEntityExist(NetworkGetEntityFromNetworkId(v.netId)) then
                DeleteEntity(NetworkGetEntityFromNetworkId(v.netId))
                SetEntityCoords(GetPlayerPed(v.tempid), cfg.gameSettings.spawnLocAfterGame, false, false, true, true)
                TriggerClientEvent("bumperkart:gameover", v.tempid)
            end
        end
    end
    gameOnGoing = false
    countdownOnGoing = false
    existingKarts = {}
    playerQueue = {}
    timer = cfg.gameSettings.queueTimer
    index = 1
    players = 1
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end
    
function startCountdown()
    while timer > 0 do
        timer = timer - 1
        Wait(1000)
    end
    local playersQueued = tablelength(playerQueue)
    if playersQueued >= cfg.minPlayers then
        for i = 1, #playerQueue do
            if players > i then
                players = 1
                break
            else
                players = players + 1
                TriggerClientEvent("bumperkart:BumperKartStarted", playerQueue[i].tempid)
            end
        end        
    else
        while timer > 0 do
            timer = timer - 1
            Wait(500)
        end
        for k, v in pairs(playerQueue) do
            TriggerClientEvent("bumperkart:NotEnoughPlayers", playerQueue[k].tempid)
            timer = 5
            end
        end
end
