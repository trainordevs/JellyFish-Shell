fx_version 'cerulean'
game 'gta5'

author 'Trainor Devs'

client_scripts {
    'utils/cl_utils.lua',
    'misc/cl_jumping.lua'
}

server_scripts {
    'server/main.lua'
    'utils/sv_utils.lua',
    'misc/sv_resources.lua',
    'misc/sv_versioncheck.lua',
    'playermanager/sv_playermanager.lua'
}

dependencies {
    'oxmysql'
}