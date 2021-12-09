local JellyFish = exports['jf-core']:GetObject()

AddEventHandler('playerConnecting', function()
    local rsLicense = JellyFish.Players.GetRockstarLicense(src)

    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM bans WHERE license = ?', { rsLicense }, function(result)
        if result[1] then
            local ban_expire
            local ban_id
            local ban_reason

            for _, v in pairs(result) do
                ban_expire = v.ban_expire
                ban_id = v.ban_id
                ban_reason = v.ban_reason
            end
            
            if ban_expire >= os.time() or ban_expire == -1 then
                if ban_expire == -1 then
                    print(':jf-banmanager: (sv_banmanager.lua) - License (' .. rsLicense .. ') is PERMA banned; Dropping the player.')
                    reason = ':JFC: You are banned from this server. \n\nBanID: ' .. ban_id .. '\nReason: ' .. ban_reason .. '\nExpires: Permanent.\n\n'
                else
                    print(':jf-banmanager: (sv_banmanager.lua) - License (' .. rsLicense .. ') is banned until '.. ban_expire .. '; Dropping the player.')
                    reason = ':JFC: You are banned from this server. \n\nBanID: ' .. ban_id .. '\nReason: ' .. ban_reason .. '\nExpires: ' .. ban_expire .. '.\n\n'
                end
                DropPlayer(player, reason)
                CancelEvent()
            end
        end
    end)
end)