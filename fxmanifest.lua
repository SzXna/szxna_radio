fx_version 'cerulean'
game 'gta5'
description 'radio'
author 'SzXna - https://www.github.com/SzXna'
version '0.0.2'
lua54 'yes'

client_script 'client/*.lua'

server_scripts {
	'server/*.lua'
}

shared_scripts {
	'@ox_lib/init.lua',
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
    'locales/*.lua'
}

dependency {
	'es_extended',
	'ox_lib',
	'pma-voice'
}