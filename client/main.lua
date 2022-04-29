-- VAG.GG // Zan#1456
Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(30)-- Seconds Hold
  end
end)


-- Code

RegisterNetEvent('drill-printer:client:UseDocument')
AddEventHandler('drill-printer:client:UseDocument', function(ItemData)
    local ped = GetPlayerPed(-1)
    local DocumentUrl = ItemData.info.url ~= nil and ItemData.info.url or false
    SendNUIMessage({
        action = "open",
        url = DocumentUrl
    })
    SetNuiFocus(true, false)
end)

RegisterNetEvent('drill-printer:client:SpawnPrinter')
AddEventHandler('drill-printer:client:SpawnPrinter', function(ItemData)
    local playerPed = GetPlayerPed(-1)
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 1.0)

    local model = GetHashKey('prop_printer_02')
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    obj = CreateObject(model, x, y, z, true, false, true)
    PlaceObjectOnGroundProperly(obj)
    SetModelAsNoLongerNeeded(model)
    SetEntityAsMissionEntity(obj)
end)

RegisterNUICallback('SaveDocument', function(data)
    print("way")
    if data.url ~= nil then
        TriggerServerEvent('drill-printer:server:SaveDocument', data.url)
    end
end)

RegisterNUICallback('CloseDocument', function()
    SetNuiFocus(false, false)
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.65, 0.65)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        local PrinterObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, GetHashKey('prop_printer_02'), false, false, false)

        if PrinterObject ~= 0 then
            local PrinterCoords = GetEntityCoords(PrinterObject)
            DrawText3Ds(PrinterCoords.x, PrinterCoords.y, PrinterCoords.z, '~g~E~w~ - Printer')
            if IsControlJustPressed(0, Keys["E"]) then
                SendNUIMessage({
                    action = "start"
                })
                SetNuiFocus(true, true)
            end
        else
            Citizen.Wait(1000)
        end

        Citizen.Wait(3)
    end
end)