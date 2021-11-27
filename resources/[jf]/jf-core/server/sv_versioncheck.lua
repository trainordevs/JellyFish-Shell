AddEventHandler("onResourceStart", function(resource)
    updatePath = "/trainordevelopments/Jellyfish-Core"

    if resource == GetCurrentResourceName() then
        PerformHttpRequest("https://raw.githubusercontent.com" .. updatePath .. "/master/version", checkVersion, "GET")
    end
end)

function checkVersion(err, responseText, headers)
	curVersion = LoadResourceFile(GetCurrentResourceName(), "version")

	if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
		print('^1----------------- ATTENTION ------------------')
		print("^0------ Jellyfish-Core Update Available. ------")
        print("^0------------ Current Version: " .. responseText .. " ------------")
        print("^0-------------- Your Version: " .. curVersion .. " -------------")
		print('^1----------------------------------------------')
	elseif tonumber(curVersion) > tonumber(responseText) then
		print('^1----------------- ATTENTION ------------------')
		print("^0------ Jellyfish-Core Update Available. ------")
        print("^0------------ Current Version: " .. responseText .. " ------------")
        print("^0-------------- Your Version: " .. curVersion .. " -------------")
		print('^1----------------------------------------------')
    end
end