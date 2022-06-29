ESX               = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetPlayerNeededIdentifiers(source)
	local ids = GetPlayerIdentifiers(source)
	for i,theIdentifier in ipairs(ids) do
		 if string.find(theIdentifier,"license:") or -1 > -1 then
			  license = theIdentifier
		 elseif string.find(theIdentifier,"steam:") or -1 > -1 then
			  steam = theIdentifier
		 elseif string.find(theIdentifier,"discord:") or -1 > -1 then
			  discord2 = theIdentifier
		 end
	end
	if not steam then
		 steam = "Not found"
	end
	if not discord2 then
		 discord2 = "Not found"
	end
	return license, steam, discord2
end

function sendToDiscord(message, text)
    PerformHttpRequest(Config.Webhook, function(err, text, headers)

        end, 'POST', json.encode({
            embeds = {
                {
                    ["description"] = message,
                    ["color"] = 2847426,
                    ["author"] = {
                        ["name"] = Config.WebhookName,
                        ["icon_url"] = Config.IconURL
                    },
                    ["footer"] = {
                        ["text"] = "Made by @nakesh",
                    },
                    ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S')
                }
            }
        }), {
            ['Content-Type'] = 'application/json'
        }
    )
end

RegisterServerEvent('nakesh:send')
AddEventHandler('nakesh:send', function(datatext)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local license, steam, discord2 = GetPlayerNeededIdentifiers(source)
    local job = xPlayer.getJob()
        if xPlayer ~= nil then
                if string.find(datatext, "https://docs.google.com/") then
                    TriggerClientEvent('notify', source, 1, "LSPD", "Hallo "..xPlayer.getName().. ", deine Bewerbung wurde erfolgreich abgeschickt!", 4000)
                    sendToDiscord("**Player:** ".. GetPlayerName(source) .." \n **ID:** ".. source .."\n **Bewerbung:** " .. datatext  .. "\n**Steam:** ".. steam:gsub('steam:', '') .."\n**GameLicense:** ".. license:gsub('license:', '') .."\n**Discord ID:** ".. discord2:gsub('discord:', '') .."\n**Discord Tag:** <@!"..  discord2:gsub('discord:', '') .. ">")
                else
                    TriggerClientEvent('notify', source, 4, "LSPD", "Du musst deine Bewerbung mit https://docs.google.com/ einsenden!", 4000)
        end          
    end
end)