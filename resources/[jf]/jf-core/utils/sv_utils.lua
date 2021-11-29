--[[
    Pulled from JamesSc0tt/FiveM-FSN-Framework
]]

JFC 					= {}
local current_players 	= {}
local moneystore		= {}

AddEventHandler('jfc:getObject', function(cb)
	cb(JFC)
end)

AddEventHandler('jf-core:updateCharacters', function(charTbl)
	current_players = charTbl
end)

AddEventHandler('jf-core:updateMoneyStore', function(moneyTbl)
	moneystore = moneyTbl
end)

AddEventHandler('playerDropped', function()
	local playerId = source

	for j = 1, #current_players do
		if current_players[j].ply_id == playerId then
			current_players[j] = nil
		end
	end
end)

JFC.GetPlayerFromId = function(playerId)
	for i = 1, #current_players do
		if current_players[i].ply_id == playerId then
			return current_players[i]
		end
	end

	return nil
end

Util = {}

function Util.SplitString(inputstr, sep)
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

function Util.GetSteamID(src)
	if not string.find(GetPlayerIdentifiers(src)[1], 'steam') then
		DropPlayer(src, 'JellyfishCore: Please ensure Steam is running. We were unable to get your steamid.')
	end
	return GetPlayerIdentifiers(src)[1]
end

function Util.MakeString(length)
	if length < 1 then return nil end
	local string = ""
	for i = 1, length do
		string = string .. math.random(32, 126)
	end
	return string
end