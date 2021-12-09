local JellyFish = exports['jf-core']:GetObject()

function JellyFish.Players.GetRockstarLicense()
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local rsLicense

    for k,v in pairs(identifiers) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            rsLicense = v
        end
    end

    if not rsLicense then
        return false
    end

    return rsLicense
end

function JellyFish.Players.CheckBanStatus(rsLicense)
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

function JellyFish.Players.getBanReason(rsLicense)
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

function JellyFish.Players.getBanExpire(rsLicense)
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

function JellyFish.Players.getBanId(rsLicense)
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

AddEventHandler('playerConnecting', function(playername)
    local rsLicense = JellyFish.Players.GetRockstarLicense(src)

    if not rsLicense then
        DropPlayer("We were unable to fetch your Rockstar License.")
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM users WHERE license = ?', { rsLicense }, function(result)
        if not result[1] then
            playername = playername:gsub('%W', '')
            exports.oxmysql:insert('INSERT INTO users (name, license, banned) VALUES (?, ?, ?, ?) ', {playername, rsLicense, '0'}, function(id) end)
        end
    end)
end)