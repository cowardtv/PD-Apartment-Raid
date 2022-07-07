fx_version 'cerulean'

games { 'gta5' }

author 'CowardTV'


client_scripts {
    'client/pdraid_c.lua'
}


server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'server/pdraid_s.lua'
}
