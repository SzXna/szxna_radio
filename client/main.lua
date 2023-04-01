local RadioOpen = false
local RadioChannel = '0 (OFF)'
local RadioVolume = Config.radio_default_volume

function toggleRadioAnimation(state)
    lib.requestAnimDict('cellphone@')
	if state then
		TriggerEvent("attachItemRadio","radio01")
		TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
		radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, 1, 1, 0)
		AttachEntityToEntity(radioProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, 1, 0, 0, 0, 2, 1)
	else
		StopAnimTask(PlayerPedId(), "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(PlayerPedId())
		DeleteObject(radioProp)
		radioProp = 0
	end
end

RegisterNetEvent('szxna_radio:set_vol')
AddEventHandler('szxna_radio:set_vol', function()
	local input = lib.inputDialog(TranslateCap('menu_dialog_volume'), {'0 - 100 %'})

	if not input then toggleRadio() end
	RadioVolume = tonumber(input[1])
	if RadioVolume == nil or RadioVolume < 0 or RadioVolume > 100 then
		RadioVolume = Config.radio_default_volume
		toggleRadio()
	else
		toggleRadio()
		exports['pma-voice']:setRadioVolume(RadioVolume)
		if Config.ox_notification then
            lib.notify({
                description = TranslateCap('volume_is_set', RadioVolume) .. '%',
            })
        else
            ESX.ShowNotification(TranslateCap('volume_is_set', RadioVolume) .. '%')
        end
	end
end)

RegisterNetEvent('szxna_radio:set_freq')
AddEventHandler('szxna_radio:set_freq', function()
    local input = lib.inputDialog(TranslateCap('menu_dialog_frequency'), {'1 - ' .. Config.maximum_frequency})
    RadioChannel = tonumber(input[1])
	if RadioChannel == nil or RadioChannel < 1 or RadioChannel > Config.maximum_frequency then
		RadioChannel = '0 (OFF)'
		toggleRadio()
		RadioOpen = false
	else
		if RadioChannel == nil or RadioChannel < 1 or RadioChannel < Config.restricted_channels + 1 then
            for i=1, #Config.restricted_channels_jobs_allowed, 1 do
                if ESX.PlayerData.job.name == Config.restricted_channels_jobs_allowed[1] or ESX.PlayerData.job.name == Config.restricted_channels_jobs_allowed[2] or ESX.PlayerData.job.name == Config.restricted_channels_jobs_allowed[3] or ESX.PlayerData.job.name == Config.restricted_channels_jobs_allowed[4] or ESX.PlayerData.job.name == Config.restricted_channels_jobs_allowed[5] then
                    toggleRadio()
                    exports['pma-voice']:setVoiceProperty('radioEnabled', true)
                    exports['pma-voice']:setVoiceProperty('micClicks', true)
                    exports['pma-voice']:setRadioChannel(RadioChannel)
					if Config.ox_notification then
						lib.notify({
							description = TranslateCap('frequency_is_set', RadioChannel),
						})
					else
						ESX.ShowNotification(TranslateCap('frequency_is_set', RadioChannel))
					end
                    RadioOpen = true
                else
                    RadioChannel = '0 (OFF)'
                    toggleRadio()
                    RadioOpen = false
                end
            end
		else
			toggleRadio()
			exports['pma-voice']:setVoiceProperty('radioEnabled', true)
			exports['pma-voice']:setVoiceProperty('micClicks', true)
			exports['pma-voice']:setRadioChannel(RadioChannel)
			if Config.ox_notification then
				lib.notify({
					description = TranslateCap('frequency_is_set', RadioChannel),
				})
			else
				ESX.ShowNotification(TranslateCap('frequency_is_set', RadioChannel))
			end
			RadioOpen = true
		end
	end
end)

RegisterNetEvent('szxna_radio:use')
AddEventHandler('szxna_radio:use', function()
    toggleRadio()
end)

RegisterNetEvent('szxna_radio:leave')
AddEventHandler('szxna_radio:leave', function()
	exports['pma-voice']:setVoiceProperty('radioEnabled', false)
	exports['pma-voice']:setVoiceProperty('micClicks', false)
	exports["pma-voice"]:SetRadioChannel(0)
	exports["pma-voice"]:removePlayerFromRadio()
	toggleRadioAnimation(false)
	RadioChannel = '0 (OFF)'
	RadioOpen = false
end)

function toggleRadio()
	toggleRadioAnimation(false)
    toggleRadioAnimation(true)
	lib.registerContext({
		id = 'radio_menu',
		title = TranslateCap('menu_title'),
		onExit = function()
			toggleRadioAnimation(false)
		end,
		options = {
			{
				title = TranslateCap('menu_frequency') .. ' ' .. RadioChannel,
				arrow = true,
				event = 'szxna_radio:set_freq',
                icon = 'fa-solid fa-walkie-talkie',
			},
            {
				title = TranslateCap('menu_volume') .. ' ' .. RadioVolume .. ' % ',
				arrow = true,
				event = 'szxna_radio:set_vol',
                icon = 'fa-solid fa-volume-high',
			},
		    {
				title = TranslateCap('menu_disconnect_channel'),
				arrow = false,
				event = 'szxna_radio:leave',
                icon = 'fa-solid fa-right-from-bracket'
			}
		}
	})
	lib.showContext('radio_menu')
end

if Config.radio_item == false then
    RegisterCommand('toggleRadio', function()
        toggleRadio()
    end, false)

    RegisterKeyMapping('toggleRadio', TranslateCap('controls_toggle_radio'), 'keyboard', 'F10')
end