local timeLeft = 30
local tenCountdown = 30
local pedCreated = false

function alert(msg) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

function clientSetPedInvis(pedId)
    local ped = pedId
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
end
function DrawAdvancedNativeText(x,y,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(254, 254, 254, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

Citizen.CreateThread(function()
    while not HasModelLoaded(cfg.ticketMaster.ped) do
        RequestModel(cfg.ticketMaster.ped)
        Wait(0)
    end
    if not pedCreated then
        local ped = CreatePed(1, cfg.ticketMaster.ped, cfg.ticketMaster.location, 45.0, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        clientSetPedInvis(ped)
        pedCreated = true
    end 
end)

Citizen.CreateThread(function()   
    local sleep = 1000

    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        if #(pedCoords - cfg.ticketMaster.markerLocation) < 10 then
            sleep = 0
            DrawMarker(27, cfg.ticketMaster.markerLocation, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 251, 0, 1.0, false, true, 2, false, nil, nil, false)
            if #(pedCoords - cfg.ticketMaster.markerLocation) < 2 then
                alert("Press ~INPUT_CONTEXT~ to join Bumper Karts!")
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("bumperkart:updateTable")
                end
            end
        else
            sleep = 1000
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("bumperkart:tensecondcountdown")
AddEventHandler("bumperkart:tensecondcountdown", function()
    tenCountdown = cfg.gameSettings.timeToPlayGame
    while true do
        if tenCountdown <= cfg.gameSettings.timeToPlayGame and tenCountdown >= 10 then
            DrawRect(0.944, 0.886, 0.17, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.0, 0.892, 0.005, 0.0028, 0.29, "TIME REMAINING:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.06, 0.885, 0.005, 0.0028, 0.464, "00:" .. tostring(tenCountdown), 255, 255, 255, 255, 0, 0)
        end
        if tenCountdown <= cfg.gameSettings.timeToPlayGame and tenCountdown < 10 then
            DrawRect(0.944, 0.886, 0.17, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.0, 0.892, 0.005, 0.0028, 0.29, "TIME REMAINING:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.06, 0.885, 0.005, 0.0028, 0.464, "00:0" .. tostring(tenCountdown), 255, 255, 255, 255, 0, 0)
        end

        if tenCountdown == 0 then
            break
        end
        Wait(0)
       
    end
end)

Citizen.CreateThread(function()
    timeLeft = 0
    while true do
        while timeLeft > 0 do
            timeLeft = timeLeft - 1
            Citizen.Wait(1000)
        end
        Wait(1000)
    end
    
end)

Citizen.CreateThread(function()
    tenCountdown = 0
    while true do
        while tenCountdown > 0 do
            tenCountdown = tenCountdown - 1
            Wait(1000)
        end
        Wait(1000)
    end
end)

RegisterNetEvent("bumperkart:SlotsFilled")
AddEventHandler("bumperkart:SlotsFilled", function()
    notify("~r~No space available")
end)

RegisterNetEvent("bumperkart:alreadyInQueue")
AddEventHandler("bumperkart:alreadyInQueue", function()
    notify("~r~You are already in the queue.")
end)

RegisterNetEvent("bumperkart:GameOngoing")
AddEventHandler("bumperkart:GameOngoing", function()
    notify("~r~There is currently a game ongoing.")
end)

RegisterNetEvent("bumperkart:NotEnoughPlayers")
AddEventHandler("bumperkart:NotEnoughPlayers", function()
    notify("~r~Not enough players to start the game.")
end)

RegisterNetEvent("bumperkart:gameover")
AddEventHandler("bumperkart:gameover", function()
    notify("~g~Your game has now finished.")
end)

RegisterNetEvent("bumperkart:JoinedQueue")
AddEventHandler("bumperkart:JoinedQueue", function(timer)
    notify("~g~You have joined the queue.")
    timeLeft = timer
    while true do
        if timeLeft > 9 then 
            DrawRect(0.944, 0.886, 0.081, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.013, 0.892, 0.005, 0.0028, 0.29, "TIME:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.05, 0.885, 0.005, 0.0028, 0.464, "00:" .. tostring(timeLeft), 255, 255, 255, 255, 0, 0)
        elseif timeLeft < 10 then
            DrawRect(0.944, 0.886, 0.081, 0.032, 0, 0, 0, 150)
            DrawAdvancedNativeText(1.013, 0.892, 0.005, 0.0028, 0.29, "TIME:", 255, 255, 255, 255, 0, 0)
            DrawAdvancedNativeText(1.05, 0.885, 0.005, 0.0028, 0.464, "00:0" .. tostring(timeLeft), 255, 255, 255, 255, 0, 0)
        end
        if timeLeft == 0 then
            break
        end
    Wait(0)
    end
end)



RegisterNetEvent("bumperkart:BumperKartStarted")
AddEventHandler("bumperkart:BumperKartStarted", function()
    notify("~g~Game starting in 3")
    Citizen.Wait(1000)
    notify("~g~Game starting in 2")
    Citizen.Wait(1000)
    notify("~g~Game starting in 1")
    Citizen.Wait(1000)
    TriggerServerEvent("bumperkart:BumperKartStart")
    while not HasModelLoaded(cfg.bumperKarts.vehicleModel) do 
        RequestModel(cfg.bumperKarts.vehicleModel)
        Wait(0) 
    end
    notify("~g~Game started!")

    
end)