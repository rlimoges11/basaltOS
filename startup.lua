local modem = peripheral.find("modem") or nil
if pocket then 
    shell.run("main")
else
    if settings.get("Autorun") ~= nil then
        if settings.get("GPScoordinates") and modem ~= nil then
            local GPSH =  require ("lib/GPSHelpers")
        end
        local mainApp = shell.openTab(settings.get("Autorun"))
        multishell.setTitle(mainApp, "main")
        multishell.setFocus(mainApp)

    else
        if settings.get("GPScoordinates") and modem ~= nil then
            local GPSH =  require ("lib/GPSHelpers")
            local mainApp = shell.openTab("main")
            multishell.setTitle(mainApp, "main")
            multishell.setFocus(mainApp)
        else
            shell.run("main")
        end
    end
end