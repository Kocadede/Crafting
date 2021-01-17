ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('kcdd-crafting:craft')
AddEventHandler('kcdd-crafting:craft', function(z, a, craftedItem, craftedItemcount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if z == 1 then
        if xPlayer.getInventoryItem(a[1].reqitem).count >= a[1].count then
            xPlayer.removeInventoryItem(a[1].reqitem, a[1].count)
            xPlayer.addInventoryItem(craftedItem, craftedItemcount)
            dclog(xPlayer,' '..craftedItemcount.. ' tane '..craftedItem..' craftladı.')
            xPlayer.showNotification("Eşyayı başarıyla craftladın")
        else
            xPlayer.showNotification("Yeterli malzeme yok")
        end
    elseif z == 2 then
        if xPlayer.getInventoryItem(a[1].reqitem).count >= a[1].count and xPlayer.getInventoryItem(a[2].reqitem).count >= a[2].count then
            xPlayer.removeInventoryItem(a[1].reqitem, a[1].count)
            xPlayer.removeInventoryItem(a[2].reqitem, a[2].count)
            xPlayer.addInventoryItem(craftedItem, craftedItemcount)
            dclog(xPlayer,' '..craftedItemcount.. ' tane '..craftedItem..' craftladı.')
            xPlayer.showNotification("Eşyayı başarıyla craftladın")
        else
            xPlayer.showNotification("Yeterli malzeme yok")
        end
    elseif z == 3 then
        if xPlayer.getInventoryItem(a[1].reqitem).count >= a[1].count and xPlayer.getInventoryItem(a[2].reqitem).count >= a[2].count and xPlayer.getInventoryItem(a[3].reqitem).count >= a[3].count then
            xPlayer.removeInventoryItem(a[1].reqitem, a[1].count)
            xPlayer.removeInventoryItem(a[2].reqitem, a[2].count)
            xPlayer.removeInventoryItem(a[3].reqitem, a[3].count)
            xPlayer.addInventoryItem(craftedItem, craftedItemcount)
            dclog(xPlayer,' '..craftedItemcount.. ' tane '..craftedItem..' craftladı.')
            xPlayer.showNotification("Eşyayı başarıyla craftladın")
        else
            xPlayer.showNotification("Yeterli malzeme yok")
        end
    elseif z == 4 then
        if xPlayer.getInventoryItem(a[1].reqitem).count >= a[1].count and xPlayer.getInventoryItem(a[2].reqitem).count >= a[2].count and xPlayer.getInventoryItem(a[3].reqitem).count >= a[3].count and xPlayer.getInventoryItem(a[4].reqitem).count >= a[4].count then
            xPlayer.removeInventoryItem(a[1].reqitem, a[1].count)
            xPlayer.removeInventoryItem(a[2].reqitem, a[2].count)
            xPlayer.removeInventoryItem(a[3].reqitem, a[3].count)
            xPlayer.removeInventoryItem(a[4].reqitem, a[4].count)
            xPlayer.addInventoryItem(craftedItem, craftedItemcount)
            dclog(xPlayer,' '..craftedItemcount.. ' tane '..craftedItem..' craftladı.')
            xPlayer.showNotification("Eşyayı başarıyla craftladın")
        else
            xPlayer.showNotification("Yeterli malzeme yok")
        end
    elseif z == 5 then
        if xPlayer.getInventoryItem(a[1].reqitem).count >= a[1].count and xPlayer.getInventoryItem(a[2].reqitem).count >= a[2].count and xPlayer.getInventoryItem(a[3].reqitem).count >= a[3].count and xPlayer.getInventoryItem(a[4].reqitem).count >= a[4].count and xPlayer.getInventoryItem(a[5].reqitem).count >= a[5].count then
            xPlayer.removeInventoryItem(a[1].reqitem, a[1].count)
            xPlayer.removeInventoryItem(a[2].reqitem, a[2].count)
            xPlayer.removeInventoryItem(a[3].reqitem, a[3].count)
            xPlayer.removeInventoryItem(a[4].reqitem, a[4].count)
            xPlayer.removeInventoryItem(a[5].reqitem, a[5].count)
            xPlayer.addInventoryItem(craftedItem, craftedItemcount)
            dclog(xPlayer,' '..craftedItemcount.. ' tane '..craftedItem..' craftladı.')
            xPlayer.showNotification("Eşyayı başarıyla craftladın")
        else
            xPlayer.showNotification("Yeterli malzeme yok")
        end
    end
end)

ESX.RegisterServerCallback("kcdd_craft:checkItem", function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]

    if item >= 15 then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('kcdd_craft:body')
AddEventHandler('kcdd_craft:body', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('gunbody', 1)
    sourcePlayer.removeInventoryItem('steel', 15)
end)

RegisterNetEvent('kcdd_craft:gunbarrel')
AddEventHandler('kcdd_craft:gunbarrel', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('gunbarrel', 1)
    sourcePlayer.removeInventoryItem('aluminium', 15)
end)

RegisterNetEvent('kcdd_craft:yay')
AddEventHandler('kcdd_craft:yay', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('yay', 1)
    sourcePlayer.removeInventoryItem('cevher', 15)
end)

RegisterNetEvent('kcdd_craft:kabza')
AddEventHandler('kcdd_craft:kabza', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('gunkabza', 1)
    sourcePlayer.removeInventoryItem('copper', 15)
end)

RegisterNetEvent('kcdd_craft:sarjor')
AddEventHandler('kcdd_craft:sarjor', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('gunmagazine', 1)
    sourcePlayer.removeInventoryItem('rubber', 15)
end)

RegisterNetEvent('kcdd_craft:kovan')
AddEventHandler('kcdd_craft:kovan', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('kovan', 1)
    sourcePlayer.removeInventoryItem('scrapmetal', 15)
end)

RegisterNetEvent('kcdd_craft:kevlar')
AddEventHandler('kcdd_craft:kevlar', function()
    local sourcePlayer = ESX.GetPlayerFromId(source)
    sourcePlayer.addInventoryItem('kevlar', 1)
    sourcePlayer.removeInventoryItem('plastic', 15)
end)


function dclog(xPlayer, text)
	local playerName = Sanitize(xPlayer.getName())
	
	local discord_webhook = GetConvar('discord_webhook', "Webhook girin")
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
	  ["username"] = "Ana Craft Log",
	  ["avatar_url"] = "https://i.hizliresim.com/0r2EZV.jpg",
	  ["embeds"] = {{
		["author"] = {
		  ["name"] = playerName .. ' - ' .. xPlayer.identifier
		},
		["color"] = 1942002,
		["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
	  }}
	}
	data['embeds'][1]['description'] = text
	PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end


function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end
