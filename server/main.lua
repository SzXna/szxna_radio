ESX.RegisterUsableItem(Config.radio_item_name, function(source)
	TriggerClientEvent('szxna_radio:use', source)
end)

AddEventHandler('onResourceStart', function()
    if Config.restricted_frequencies then
        if Config.maximum_frequency < Config.restricted_channels then
            print('[ERROR] The frequency range must be set higher than the restricted channels range') 
        end
    end
    if Config.radio_default_volume < 1 then
        print('[ERROR] The default volume must be greater than zero') 
    end
end)