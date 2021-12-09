function JellyFish.Utils.GetPlayerFromId (playerId)
	for i = 1, #current_players do
		if current_players[i].ply_id == playerId then
			return current_players[i]
		end
	end

	return nil
end

function JellyFish.Utils.SplitString(inputstr, sep)
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

function JellyFish.Utils.MakeString(length)
	if length < 1 then return nil end
	local string = ""
	for i = 1, length do
		string = string .. math.random(32, 126)
	end
	return string
end