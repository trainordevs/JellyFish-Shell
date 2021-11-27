local sql = [[
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO"
SET time_zone = "+00:00";
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE IF NOT EXISTS `bans` (
  `ban_identifier` varchar(255) NOT NULL,
  `ban_reason` text NOT NULL,
  `ban_id` int(11) NOT NULL,
  `ban_expire` int(11) NOT NULL,
  `ban_date` int(11) NOT NULL,
  `ban_admin` int(11) NOT NULL,
  PRIMARY KEY (`ban_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `steamid` text NOT NULL,
  `identifiers` text DEFAULT NULL,
  `location` text DEFAULT NULL,
  `admin_lvl` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL DEFAULT 0,
  `connections` int(11) NOT NULL,
  `banned` int(99) NOT NULL,
  `banned_r` text NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id` (`user_id`),
  KEY `user_id_2` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
]]

local timeout = 10
local done = false
local start = 0

CreateThread(function()
    local result = exports.oxmysql:executeSync(sql)
    if result then
        done = true
    end
end)

-- List resources here to load on server startup. 
local resources = {

}

Citizen.CreateThread(function()
    start = os.time()
    while true do
        Citizen.Wait(0)
        if not done then
            if start + timeout < os.time() then
                print('^1JF-CORE DATABASE ERROR')
                print('^1ERROR - MYSQL SERVER DID NOT RESPOND IN TIME.')
                print('^1PLEASE ENSURE oxmysql IS INSTALLED AND CONFIGURED PROPERLY.')
                print('^1YOU MAY INCREASE THE TIMEOUT IN sv_db.lua IF IT STILL ISN\'T CONNECTING.')
                print('^1END OF ERROR')
            end
        else
            for k, v in pairs(resources) do
                ExecuteCommand('start ' .. v)
            end
            break
        end
    end
end)