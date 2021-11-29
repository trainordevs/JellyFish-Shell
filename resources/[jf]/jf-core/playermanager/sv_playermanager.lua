players = {}

AddEventHandler('playerConnecting', function(playername, setKickReason)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)
    local rsLicense

    for k,v in pairs(identifiers) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            rsLicense = v
        end
    end

    if not rsLicense then
        local kickReason = "We were unable to fetch your Rockstar License."
        DropPlayer(kickReason)
        CancelEvent()
    end

    exports.oxmysql:execute('SELECT * FROM users WHERE license = ?', { rsLicense }, function(result)
        if not result[1] then
            playername = playername:gsub('%W', '')
            exports.oxmysql:insert('INSERT INTO users (name, license, connections) VALUES (?, ?, ?) ', {playername, rsLicense, '1'}, function(id)
                -- table.insert(players, { id=#players+1, name=playername, license=rsLicense, adminlvl= })
            end)
        end
    end)
end)

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end