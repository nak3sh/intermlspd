local PlayerData                = {}
ESX                             = nil
local display = false
local firstspawn = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)


RegisterNUICallback("exit", function(data)
    TriggerEvent('notify', 1, "LSPD", "Wir sehen uns!", 4000)
    SetDisplay(false)
end)

RegisterNUICallback("main", function(data)
    TriggerServerEvent("nakesh:send", data.text)
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end



Citizen.CreateThread(function()
    while true do
	local ped = PlayerPedId()
        Citizen.Wait(1)
            if GetDistanceBetweenCoords(GetEntityCoords(ped),  Config.StandX ,Config.StandY ,Config.StandZ, true) < 2 and ESX.PlayerData.job and ESX.PlayerData.job.name == 'unemployed' then-- PED Position
                    if IsControlJustReleased(1, 51) then
                        SetDisplay(not display)
                    end
        end
    end
 end)
    


 Citizen.CreateThread(function()
    local hash = GetHashKey(Config.Ped)

    if not HasModelLoaded(hash) then
        RequestModel(hash)
        Citizen.Wait(100)
    end

    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    if firstspawn == false then
        local npc = CreatePed(6, hash,  Config.StandX ,Config.StandY ,Config.StandZ-1, Config.Heading, false, false) -- PED Position
        SetEntityInvincible(npc, true)
        FreezeEntityPosition(npc, true)
        SetPedDiesWhenInjured(npc, false)
        SetPedCanRagdollFromPlayerImpact(npc, false)
        SetPedCanRagdoll(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetEntityDynamic(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
    end
end)
