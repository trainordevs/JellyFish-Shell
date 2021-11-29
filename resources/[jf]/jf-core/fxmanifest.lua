fx_version 'cerulean'
game 'gta5'

author 'An awesome dude'
description 'An awesome, but short, description'
version '1.0.0'
client_scripts {
    'utils/cl_utils.lua',
    'misc/cl_jumping.lua'
}

server_scripts {
    'utils/sv_utils.lua',
    'misc/sv_resources.lua',
    'misc/sv_versioncheck.lua',
    'banmanager/sv_banmanager.lua',
    'playermanager/sv_playermanager.lua'
}

dependencies {
    'oxmysql'
}

exports {

}

server_exports {

}