fx_version 'cerulean'
game 'gta5'

author 'TrainorDevelopments'

server_script 'server/sv_banmanager.lua'

dependencies {
    'oxmysql'
}

server_export 'jf_isPlayerBanned'
server_export 'jf_getBanReason'
server_export 'jf_getBanExpire'
server_export 'jf_getBanId'