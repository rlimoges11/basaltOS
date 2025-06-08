if settings.get("Autorun") ~= nil then
    shell.run(settings.get("Autorun"))
else
    local modem = peripheral.find("modem") or nil
    if settings.get("GPScoordinates") and modem ~= nil and not pocket then
        local GPSH =  require ("lib/GPSHelpers")
    end

    local mainApp = shell.openTab("main")
    multishell.setTitle(mainApp, "main")
    multishell.setFocus(mainApp)
end