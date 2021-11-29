-- List resources here to load on server startup. 
local resources = {

}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(resources) do
            ExecuteCommand('start ' .. v)
        end
        break
    end
end)