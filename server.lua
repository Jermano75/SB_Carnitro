ESX                = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('SB:nitroon1', function(source, cb)

    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.getInventoryItem('nitro')
		local hasitem = xPlayer.getInventoryItem('nitro').count

    cb({
      items = items
    })

if hasitem >= 1 then
xPlayer.removeInventoryItem('nitro', 1)
end

end)