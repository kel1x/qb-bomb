local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('bomba', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer.Functions.GetItemByName('bomba') ~= nil then
        TriggerClientEvent('bomba:provera', source)
    end
end)

RegisterServerEvent('bomba:ukloni')
AddEventHandler('bomba:ukloni', function()
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer.Functions.GetItemByName('bomba') ~= nil then
        xPlayer.Functions.RemoveItem('bomba', 1)
    end
end)

-- DISCORD LOGS --

PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
    ['username'] = Config.WebhookName,
    ['avatar_url'] = Config.WebhookAvatarUrl,
    ['embeds'] = {{
        ['author'] = {
            ['name'] = 'Detonacija System',
            ['icon_url'] = ''
        },
        ['footer'] = {
            ['text'] = 'Uspesno pokrenut! ✅'
        },
        ['color'] = 12914,
        ['description'] = Config.ImeServera,
        ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
    }}
}), {['Content-Type'] = 'application/json' })

RegisterServerEvent('kalas:log')
AddEventHandler('kalas:log', function(text)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    discordlog(xPlayer, text)
end)

function discordlog(xPlayer, text)
    local playerName = Sanitize(GetPlayerName())
    
    for k, v in ipairs(GetPlayerIdentifiers(xPlayer.source)) do
        if string.match(v, 'discord:') then
            identifierDiscord = v
        end
    end
	
	local discord_webhook = GetConvar('discord_webhook', Config.DiscordWebhook)
	if discord_webhook == '' then
	  return
	end
	local headers = {
	  ['Content-Type'] = 'application/json'
	}
	local data = {
        ['username'] = Config.WebhookName,
        ['avatar_url'] = Config.WebhookAvatarUrl,
        ['embeds'] = {{
            ['author'] = {
                ['name'] = 'Detonacija System',
                ['icon_url'] = ''
            },
            ['footer'] = {
                ['text'] = 'Uspesno pokrenut! ✅'
            },
            ['color'] = 12914,
            ['description'] = Config.ImeServera,
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }}
      }
    text = '🆔 **ID**: '..tonumber(xPlayer.source)..'\n'..text..''
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