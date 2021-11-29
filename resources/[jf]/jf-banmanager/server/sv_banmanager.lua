AddEventHandler('playerConnecting', function()
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local rsLicense

    for k,v in pairs(identifiers) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            rsLicense = v
        end
    end

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

function jf_isPlayerBanned(license)
    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM bans WHERE license = ?', { rsLicense }, function(result)
        if result[1] then
            return true
        end
    end)

    return false
end

function jf_getBanReason(license)
    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM bans WHERE license = ?', { rsLicense }, function(result)
        if result[1] then
            local ban_reason

            for _, v in pairs(result) do
                ban_reason = v.ban_reason
            end

            return ban_reason
        end
    end)
end

function jf_getBanExpire(license)
    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM bans WHERE license = ?', { rsLicense }, function(result)
        if result[1] then
            local ban_expire

            for _, v in pairs(result) do
                ban_expire = v.ban_expire
            end

            return ban_expire
        end
    end)
end

function jf_getBanId(license)
    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM bans WHERE license = ?', { rsLicense }, function(result)
        if result[1] then
            local ban_id

            for _, v in pairs(result) do
                ban_id = v.ban_id
            end

            return ban_id
        end
    end)
end