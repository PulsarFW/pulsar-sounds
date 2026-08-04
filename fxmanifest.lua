fx_version 'cerulean'
game 'gta5'

name 'Pulsar Sounds'
description 'Shared sound playback for world/ambient and UI sound effects'
author 'Artmines - maintained for Pulsar Framework'
url 'https://pulsarframe.work'
version 'v1.0.0'

version_check 'yes'
github 'https://github.com/PulsarFW/pulsar_sounds'

client_script '@pulsar_core/components/cl_error.lua'
shared_script '@pulsar_core/core/sh_pulsar.lua'
client_script '@pulsar_pwnzor/client/check.lua'

client_scripts({
	'client/*.lua',
})

server_scripts({
	'server/*.lua',
})

files({
	'ui/**/*.*',
})

ui_page 'ui/index.html'
lua54 'yes'