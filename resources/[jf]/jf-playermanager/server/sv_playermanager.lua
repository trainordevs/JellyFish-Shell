AddEventHandler('playerConnecting', function(playername)
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

    exports.oxmysql:execute('SELECT * FROM users WHERE license = ?', { rsLicense }, function(result)
        if not result[1] then
            playername = playername:gsub('%W', '')
            exports.oxmysql:insert('INSERT INTO users (name, license, banned) VALUES (?, ?, ?, ?) ', {playername, rsLicense, '0'}, function(id) end)
        end
    end)
end)