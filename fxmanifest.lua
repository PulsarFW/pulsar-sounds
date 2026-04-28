fx_version("cerulean")
game("gta5")
lua54("yes")
client_script("@pulsar-core/exports/cl_error.lua")
client_script("@pulsar-pwnzor/client/check.lua")

ui_page("ui/index.html")

client_scripts({
	"client/*.lua",
})

server_scripts({
	"server/*.lua",
})

files({
	"ui/**/*.*",
})
