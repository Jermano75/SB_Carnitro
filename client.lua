local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local playerData = {}	
local nitroon = false

Citizen.CreateThread(function()
    while ESX == nil do													
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
  
    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("sb_activarnitro")
AddEventHandler('sb_activarnitro', function()
local ped = GetPlayerPed(-1)
local inside = IsPedInAnyVehicle(ped, true)
    if inside then
        TriggerEvent("SB:nitroon")
    else
        print("estas fora do carro")
        exports['mythic_notify']:DoLongHudText ('error', 'Estas fora do carro')
    end
end)

-- Comand Register - comando -> nitro
RegisterCommand("nitro", function(source, args, raw)
    TriggerEvent("sb_activarnitro")
    activarNitro()
end, false) -- falso para qualquer pessoa

RegisterNetEvent('SB:nitroon')
AddEventHandler('SB:nitroon', function()
    ESX.TriggerServerCallback('SB:nitroon1', function(inventory)
        local item = inventory.items
        if item.count >= 1 then
            local ped = GetPlayerPed(-1)
            local carro = GetVehiclePedIsIn(ped, false)
            local force = 100.0                                              ---// trocar a força do nitro
            exports['progressBars']:startUI(8000, "A instalar o nitro")
            Citizen.Wait(8000)
            while true do
            Citizen.Wait(0)
                if IsControlJustPressed(0,51) and nitroon then   ------ trocar a tecla 51 por outra qualquer
                    local stop = IsVehicleStopped(carro)                     
                    if stop then   
                        exports['mythic_notify']:DoLongHudText ('error', 'Tens de estar em movimento')
                    else
                        exports['mythic_notify']:DoLongHudText ('success', 'Activaste o nitro')
                        Citizen.Wait(2500)
                        SetVehicleBoostActive(carro, 1, 0)
                        SetVehicleForwardSpeed(carro, force)
                        StartScreenEffect("RaceTurbo", 0, 0)
                        Citizen.Wait(2500)                      ---- aumentar o tempo que nitro ira durar
                        SetVehicleBoostActive(carro, 0, 0)
                        nitroActivado = false
                        exports['mythic_notify']:DoLongHudText ('inform', 'Acabaste com o nitro')
                        return true   
                    end              
                end
            end
        else
            exports['mythic_notify']:DoLongHudText ('error', 'Não tens botija de nitro contigo')
        end
    end)
end)

function activarNitro()
    nitroon = true
end