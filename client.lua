local ticketMasterNetId = nil
local timeLeft = 30
local number = 0
local alerted = false

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

function clientSetPedInvis(netId)
    local ped = NetworkGetEntityFromNetworkId(netId)
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
    local sleep = 1000
    local ped = PlayerPedId()
    
    while true do
        local pedCoords = GetEntityCoords(ped)
        if #(pedCoords - cfg.ticketMaster.markerLocation) < 10 then
            sleep = 0
            DrawMarker(27, cfg.ticketMaster.markerLocation, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 251, 0, 1.0, false, true, 2, false, nil, nil, false)
            if #(pedCoords - cfg.ticketMaster.markerLocation) < 2 then
                alert("Press ~INPUT_CONTEXT~ to join Bumper Karts!")
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("Server:updateTable")
                end
            end
        else
            sleep = 1000
        end
        
        Wait(sleep)
    end
   
end)

Citizen.CreateThread(function()
    timeLeft = 0
    while true do
        while timeLeft > number do
            timeLeft = timeLeft - 1
            Citizen.Wait(1000)
        end
        Wait(1000)
    end
    
end)

RegisterNetEvent("Client:createPed")
AddEventHandler("Client:createPed", function(netId)
    ticketMasterNetId = netId
    clientSetPedInvis(netId)
end)

RegisterNetEvent("onResourceStop")
AddEventHandler("onResourceStop", function(resourcename)
    if GetCurrentResourceName() == resourcename then
        if ticketMasterNetId ~= nil then
            DeletePed(NetworkGetEntityFromNetworkId(ticketMasterNetId))
        end
    end
end)

RegisterNetEvent("Client:SlotsFilled")
AddEventHandler("Client:SlotsFilled", function()
    notify("~r~No space available")
end)

RegisterNetEvent("Client:alreadyInQueue")
AddEventHandler("Client:alreadyInQueue", function()
    notify("~r~You are already in the queue.")
end)

RegisterNetEvent("Client:GameOngoing")
AddEventHandler("Client:GameOngoing", function()
    notify("~r~There is currently a game ongoing.")
end)

RegisterNetEvent("Client:NotEnoughPlayers")
AddEventHandler("Client:NotEnoughPlayers", function()
    notify("~r~Not enough players to start the game.")
end)

RegisterNetEvent("Client:JoinedQueue")
AddEventHandler("Client:JoinedQueue", function(timer)
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



RegisterNetEvent("Client:BumperKartStarted")
AddEventHandler("Client:BumperKartStarted", function()
    notify("~g~Game starting in 3")
    Citizen.Wait(1000)
    notify("~g~Game starting in 2")
    Citizen.Wait(1000)
    notify("~g~Game starting in 1")
    Citizen.Wait(1000)
    TriggerServerEvent("Server:BumperKartStart")
    while not HasModelLoaded(cfg.bumperKarts.vehicleModel) do 
        RequestModel(cfg.bumperKarts.vehicleModel)
        Wait(0) 
    end
    notify("~g~Game started!")

    
end)