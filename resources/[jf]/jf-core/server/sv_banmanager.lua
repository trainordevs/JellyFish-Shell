function SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function print_table(node)
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

function checkBan(source, setKickReason)
	local src = source
	updateIdentifiers(src)
	
	for k, v in pairs(GetPlayerIdentifiers(src)) do
		exports.oxmysql:execute('SELECT * FROM bans WHERE ban_identifier = ?', { v }, function(result)
            if result[1] then
                if result[1].ban_expire >= os.time() or result[1].ban_expire == -1 then
                    local reason = 'your ban is weirdly formatted, ask jamessc0tt'
                    if result[1]['ban_expire'] == -1 then
                        print(':jf-core: (sv_banmanager.lua) - Player(' .. src .. ') is PERMA banned; Identifier(' .. v .. ') - dropping the player.')
                        reason = ':JFC: You are banned from this server. \n\nBanID: '..result[1]['ban_id']..'\nReason: '..result[1]['ban_reason']..'\nExpires: Never\n\n'
                    else
                        print(':jf-core: (sv_banmanager.lua) - Player(' .. src .. ') is banned until '..result[1]['ban_expire']..'; Identifier(' .. v .. ') - dropping the player.')
                        reason = ':JFC: You are banned from this server. \n\nBanID: '..result[1]['ban_id']..'\nReason: '..result[1]['ban_reason']..'\nExpires: '..result[1]['ban_expire']..'\n\n'
                    end
                    DropPlayer(src, reason)
                    if setKickReason then
                        setKickReason(reason)
                    end
                    CancelEvent()
                end
            end
        end)
	end
end

function updateIdentifiers(src)
	local steamid = GetPlayerIdentifiers(src)[1]
	if not steamid then
        print(':jf-core: (sv_banmanager.lua) - Attempting to update the identifiers for player(' .. src .. ') has failed.')
        return
    else
        print(':jf-core: (sv_banmanager.lua) -  Updating identifiers for Player(' .. src .. ') with SteamID(' .. steamid .. ').')
    end

    exports.oxmysql:execute('SELECT * FROM users WHERE steamid = ?', { steamid }, function(result)
            if result[1] then
                local myIdentifiers = result[1]['identifiers']
                if myIdentifiers then
                    myIdentifiers = json.decode(myIdentifiers)
                else
                    myIdentifiers = {}
                end
                for k, v in pairs(GetPlayerIdentifiers(src)) do
                    local split = SplitString(v, ':')
                    local iType = split[1]
                    if not myIdentifiers[iType] then
                        myIdentifiers[iType] = {}
                    end
                    local exists = false
                    for key, value in pairs(myIdentifiers[iType]) do
                        if value == v then
                            exists = true
                        end
                    end
                    if not exists then
                        table.insert(myIdentifiers[iType], #myIdentifiers[iType]+1, v)
                    end
                end
                local update = json.encode(myIdentifiers)

                exports.oxmysql:update('UPDATE users SET identifiers = ? WHERE user_id = ? ', {update, sql[1]['user_id']}, function(affectedRows) end)
            end
        end)
end